//
//  RegisterVCNew.m
//  EasyForm
//
//  Created by Rahiem Klugh on 10/12/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "RegisterVCNew.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import "AppDelegate.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"

@interface RegisterVCNew ()
{
    NSString* number;
}

@end

@implementation RegisterVCNew

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _registerButton.layer.cornerRadius = 30;
    _registerButton.layer.masksToBounds = YES;
    _registerButton.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:197.0/255.0 blue:194.0/255.0 alpha:1.0].CGColor;
    _registerButton.layer.borderWidth = 1;
    
    [_registerButton addTarget:self action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    number = nil;
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"youremail@easyform.us" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithWhite:0.9 alpha:0.7] }];
    self.emailTextField.attributedPlaceholder = str;
    
    [self verifyPressed];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerButtonTapped{
    if ([self validateEmail:_emailTextField.text]) {
        
        if (number) {
            [self signUpNewUser:number];
        }
        else{
            [self verifyPressed];
        }
    }
}


-(BOOL)validateEmail:(NSString *)email {
    
    if([email length] == 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Email" message:@"Email field should not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    if (regExMatches == 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Email" message:@"Enter proper email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else {
        return YES;
    }
}

-(void)verifyPressed
{
    Digits *digits = [Digits sharedInstance];
    DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
    configuration.appearance = [[DGTAppearance alloc] init];
    //configuration.appearance.backgroundColor = [UIColor blackColor];
    configuration.appearance.accentColor = EASY_BLUE;
    
    [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *session, NSError *error) {
        // Inspect session/error objects
        if (session != nil){
           [_emailTextField becomeFirstResponder];
           number = session.phoneNumber;
        }
    }];
}
- (void)signUpNewUser: (NSString*) phoneNumber {
    
    [KVNProgress showWithStatus:@"Creating new account..."];
    
    PFUser *user = [PFUser user];
    user.username = phoneNumber;
    user.password = phoneNumber;
    user [@"email"] = _emailTextField.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            // Hooray! Let them use the app now.
            [KVNProgress dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"registered"];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
                [self presentViewController:viewController animated:YES completion:nil];
                //                [self.navigationController setNavigationBarHidden:NO animated:YES];
            });
        }
        else
        {
            [KVNProgress dismiss];
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            if (error.code == 202) {
                
                [self.view endEditing:YES];
                
                UIAlertController *alert= [UIAlertController
                                           alertControllerWithTitle:@"Registration Error"
                                           message:@"User already registered"
                                           preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               NSLog(@"cancel btn");
                                                               
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               [(AppDelegate *)[[UIApplication sharedApplication] delegate] setLoginViewController];
                                                           }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
