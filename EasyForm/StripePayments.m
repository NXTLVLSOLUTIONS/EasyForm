//
//  StripePayments.m
//  Viaggio
//
//  Created by Rahiem Klugh on 3/17/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "StripePayments.h"
#import <Parse/Parse.h>
#import <Stripe/Stripe.h>
#import "ParseDataFormatter.h"
#import "KVNProgress.h"
#import "Constants.h"


@implementation StripePayments

+(StripePayments*) sharedInstance
{
    static StripePayments * sharedData = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[StripePayments alloc ]init];
    });
    
    return sharedData;
}


-(void)createNewStripeCard: (NSString*)number month: (NSUInteger) month year: (NSUInteger) year cvc: (NSString*) cvc
{
    [KVNProgress showWithStatus:@"Verifing Card Information..."];
    if (![Stripe defaultPublishableKey]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Publishable Key"
                                                          message:@"Please specify a Stripe Publishable Key in Constants.m"
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    STPCardParams *card = [[STPCardParams alloc] init];
    card.number = number;
    card.expMonth = month;
    card.expYear = year;
    card.cvc = cvc;
    [[STPAPIClient sharedClient] createTokenWithCard:card completion:^(STPToken *token, NSError *error)
     {
         if (error) {
             [self hasError:error];
         } else {
      
             [self createCustomerFromCard:token.tokenId];
         }
     }];
}


- (void)hasError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)createCustomerFromCard:(NSString *)token
{
    NSString* email = [PFUser currentUser].email;
    NSString* userId = [PFUser currentUser].objectId;
    [PFCloud callFunctionInBackground:@"createCustomer"
                       withParameters:@{
                                        @"cardToken":token,
                                        @"email": email,
                                        @"objectId": userId,
                                        }
                                block:^(id object, NSError *error) {
                                    //Save token in parse
                                    [KVNProgress dismiss];
                                    [[ParseDataFormatter sharedInstance] saveNewStripeUserWithCard:object[@"id"] cardId:object[@"default_source"]];
                                    
                                }];
}

-(void)retrieveCardInfo: (NSString*) customerToken cardId: (NSString*) cardToken
{
    
//    [PFCloud callFunctionInBackground:@"retrieveCard"
//                       withParameters:@{
//                                        @"cardToken":cardToken,
//                                        @"customerId": customerToken,
//                                        }
//                                block:^(id object, NSError *error) {
//                                    //Save token in parse
//                                    [KVNProgress dismiss];
//                                    //[[ParseDataFormatter sharedInstance] saveNewStripeUserWithCard:object cardId:token];
//                                    
//                                }];
    NSString *urlString = [NSString stringWithFormat:@"https://api.stripe.com/v1/customers/%@/sources/%@" , customerToken, cardToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: urlString]];
    NSString *params = [NSString stringWithFormat:@"Bearer %@",STRIPESECRETKEY];
    
   // request.HTTPMethod = @"GET";
    [request setHTTPMethod:@"GET"];
    [request setValue:params forHTTPHeaderField:@"Authorization"];
    //request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
      
         if (error)
         {
             NSLog(@"ERROR: %@",error);
         }
         else
         {
             NSLog(@"%@", response);
             NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding]);
             NSError *errorJson=nil;
             _cardData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
            [KVNProgress dismiss];
           // [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_BOOKING_CONFIRMATION object:nil];
          //  NSLog(@"Dict: %@", responseDict);
             
             
         }
     }];
}

-(void)chargeCustomer:(NSString *)customerId amount:(NSNumber *)amountInCents //completion:(PFIdResultBlock)handler
{
    [PFCloud callFunctionInBackground:@"chargeCustomer"
                       withParameters:@{
                                        @"amount":amountInCents,
                                        @"customerId":customerId
                                        }
                                block:^(id object, NSError *error) {
                                    //Object is an NSDictionary that contains the stripe charge information, you can use this as is or create, an instance of your own charge class.
                                    //handler(object,error);
                                      [KVNProgress showSuccessWithStatus:@"Booking Confirmed"];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkoutComplete" object:nil];
                                    
                                }];
}

@end
