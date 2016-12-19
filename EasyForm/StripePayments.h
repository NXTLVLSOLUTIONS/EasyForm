//
//  StripePayments.h
//  Viaggio
//
//  Created by Rahiem Klugh on 3/17/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StripePayments : NSObject
+(StripePayments*) sharedInstance;

@property (nonatomic, strong) NSDictionary *cardData;

-(void)createNewStripeCard: (NSString*)number month: (NSUInteger) month year: (NSUInteger) year cvc: (NSString*) cvc;
-(void)retrieveCardInfo: (NSString*) customerToken cardId: (NSString*) cardToken;
-(void)chargeCustomer:(NSString *)customerId amount:(NSNumber *)amountInCents;
@end
