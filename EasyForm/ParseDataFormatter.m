//
//  ParseDataFormatter.m
//  Viaggio
//
//  Created by Rahiem Klugh on 3/2/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "ParseDataFormatter.h"
#import "KVNProgress.h"
#import "StripePayments.h"
#import "UserModel.h"

@implementation ParseDataFormatter

+(ParseDataFormatter*) sharedInstance
{
    static ParseDataFormatter * sharedData = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[ParseDataFormatter alloc ]init];
    });
    
    return sharedData;
}


-(void)queryAllProviders
{
//    [KVNProgress setConfiguration:[KVNProgressConfiguration defaultConfiguration]];
    //    [KVNProgress show];
    
    _allProvidersArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Providers"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [_allProvidersArray addObject:object];
            }
            
           // [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_allProvidersArray] forKey:@"mySavedArray"];
           // [[NSUserDefaults standardUserDefaults] setObject:_allProvidersArray forKey:@"allProvidersArray"];
            // [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProviders" object:nil];
            //         [KVNProgress dismiss];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(void)getProviderForms: (NSString*) providerId
{
        [KVNProgress setConfiguration:[KVNProgressConfiguration defaultConfiguration]];
        [KVNProgress show];
    
    _providerFormsArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"ProviderForms"];
    [query whereKey:@"providerId" equalTo:providerId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [_providerFormsArray addObject:object];
            }
            
            [KVNProgress dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProviderFormsFetched" object:nil];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)queryProviderType: (NSString*) type
{
    [KVNProgress setConfiguration:[KVNProgressConfiguration defaultConfiguration]];
    [KVNProgress show];
    
    _providersArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Providers"];
    [query whereKey:@"type" equalTo:type];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [_providersArray addObject:object];
            }
            
            if (_providersArray.count == 0) {
                [self queryAllProviders];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProviders" object:nil]; 
            }
        
            [KVNProgress dismiss];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)queryInsurance{
    [KVNProgress setConfiguration:[KVNProgressConfiguration defaultConfiguration]];
    [KVNProgress show];
    
    _insuranceArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"InsuranceCompanies"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [_insuranceArray addObject:object];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadInsurance" object:nil];
            [KVNProgress dismiss];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void)queryPayments{
     _paymentsArray = [[NSMutableArray alloc] init];
    
    [KVNProgress setConfiguration:[KVNProgressConfiguration defaultConfiguration]];
    [KVNProgress show];

    PFQuery *query = [PFQuery queryWithClassName:@"Payment"];
    [query whereKey:@"userObjectId" equalTo:[PFUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [_paymentsArray addObject:object];
            }
            if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"applepay"]) {
                [_paymentsArray addObject:@"APPLEPAY"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPayments" object:nil];
            [KVNProgress dismiss];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)getProfileImage
{
    PFQuery *query = [PFUser query];
    if ([PFUser currentUser].objectId) {
        [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            NSLog(@"Retrieved data");
            
            if (!error) {
                PFFile *file = [object objectForKey:@"profileImage"];
                [file getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:result];
                        _userProfileImage = image;
                        _userUpdatedProfileImage = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"setProfileImage" object:image];
                        
                    }
                }];
            }
        }];
    }
}


-(void)saveProfileImage: (UIImage*)image

{
    
    [KVNProgress showWithStatus:@"Updating Profile Image..."];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    PFFile *imageFile = [PFFile fileWithName:@"ProfileImage.jpg" data:imageData];
    
    [imageFile saveInBackground];
    
    
    
    PFUser *user = [PFUser currentUser];
    
    [user setObject:imageFile forKey:@"profileImage"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            [KVNProgress dismiss];
            _userUpdatedProfileImage = YES;
            _userProfileImage = nil;
             _userProfileImage = image;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setProfileImage" object:image];
        }
        
    }];
    
}


-(void)getSignatureImage
{
    PFQuery *query = [PFUser query];
    if ([PFUser currentUser].objectId) {
        [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            NSLog(@"Retrieved data");
            
            if (!error) {
                PFFile *file = [object objectForKey:@"signatureImage"];
                [file getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:result];
                        _userSignatureImage = image;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"setSignatureImage" object:image];
                        
                    }
                }];
            }
        }];
    }
}


-(void)saveSignatureImage: (UIImage*)image

{
    
    [KVNProgress showWithStatus:@"Updating Signature Image..."];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    PFFile *imageFile = [PFFile fileWithName:@"SignatureImage.jpg" data:imageData];
    
    [imageFile saveInBackground];
    
    
    
    PFUser *user = [PFUser currentUser];
    
    [user setObject:imageFile forKey:@"signatureImage"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            [KVNProgress dismiss];
            _userSignatureImage = nil;
            _userSignatureImage = image;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setSignatureImage" object:image];
        }
        
    }];
    
}


-(void)getIdCards{
    
    PFQuery *query = [PFUser query];
    if ([PFUser currentUser].objectId) {
        [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            NSLog(@"Retrieved data");
            
            if (!error) {
                PFFile *file1 = [object objectForKey:@"licenseImage"];
                PFFile *file2 = [object objectForKey:@"insuranceImage"];
                PFFile *file3 = [object objectForKey:@"discountImage"];
                PFFile *file4 = [object objectForKey:@"idImage"];
                
                [file1 getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:result];
                        _userLicenseImage = image;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCards" object:image];
                    }
                }];
                [file2 getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:result];
                        _userInsuranceImage = image;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCards" object:image];
                    }
                }];
                
                [file3 getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:result];
                        _userDiscountImage = image;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCards" object:image];
                    }
                }];
                
                [file4 getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:result];
                        _userIdImage = image;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCards" object:image];
                    }
                }];
            }
        }];
    }
}


-(void)saveIdImage: (UIImage*)image idType: (ImageSelectionType) selectionType
{
    NSString* name;
    
    if (selectionType == ImageTypeLicense) {
        name = @"licenseImage";
    }
    if (selectionType == ImageTypeInsurance) {
        name = @"insuranceImage";
    }
    if (selectionType == ImageTypeDiscount) {
        name = @"discountImage";
    }
    if (selectionType == ImageTypeId) {
        name = @"idImage";
    }
    
    [KVNProgress showWithStatus:@"Updating..."];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSString* fileName = [NSString stringWithFormat:@"%@.jpg",name];
    PFFile *imageFile = [PFFile fileWithName:fileName data:imageData];
    
    [imageFile saveInBackground];
    
    
    
    PFUser *user = [PFUser currentUser];
    
    [user setObject:imageFile forKey:name];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            [KVNProgress dismiss];
            
            if (selectionType == ImageTypeLicense) {
                _userLicenseImage = nil;
                _userLicenseImage = image;
            }
            if (selectionType == ImageTypeInsurance) {
                _userInsuranceImage = nil;
                _userInsuranceImage = image;
            }
            
            if (selectionType == ImageTypeDiscount) {
                _userDiscountImage = nil;
                _userDiscountImage = image;
            }
            if (selectionType == ImageTypeId) {
                _userIdImage = nil;
                _userIdImage = image;
            }
            
       
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCards" object:image];
        }
        
    }];
    
}


-(void)deleteCard{
    NSString* name;
    
    [KVNProgress showWithStatus:@"Deleting..."];
    
    if (_idType == ImageTypeLicense) {
        name = @"licenseImage";
    }
    if (_idType == ImageTypeInsurance) {
        name = @"insuranceImage";
    }
    if (_idType == ImageTypeDiscount) {
        name = @"discountImage";
    }
    if (_idType == ImageTypeId) {
        name = @"idImage";
    }
    
    PFQuery *query = [PFUser query];
    if ([PFUser currentUser].objectId) {
        [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            NSLog(@"Retrieved data");
            
            if (!error) {
                  object[name] = [NSNull null];
                
                PFUser *user = [PFUser currentUser];
                
                [user setObject:object[name] forKey:name];
                
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if (!error) {
                        
                        if (_idType == ImageTypeLicense) {
                            _userLicenseImage = nil;
                        }
                        if (_idType == ImageTypeInsurance) {
                            _userInsuranceImage = nil;
                        }
                        if (_idType == ImageTypeDiscount) {
                            _userDiscountImage = nil;
                        }
                        if (_idType == ImageTypeId) {
                            _userIdImage = nil;
                        }
                        
                        [KVNProgress dismiss];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCards" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"cardDeleted" object:nil];
                    }
                    
                }];
            }
        }];
    }
}

-(void)saveNewStripeUserWithCard: (NSString*)customerID cardId: (NSString*) cardToken
{
    PFObject *user = [PFObject objectWithClassName:@"StripeTokens"];
    
    user[@"parseUserId"] =  [PFUser currentUser].objectId;
    user[@"customerToken"] =  customerID;
    user[@"cardToken"] =  cardToken;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissCardView" object:nil];
        } else {
            // There was a problem, check error.description
        }
    }];
}

-(void)fetchUserCreditCardTokens
{
    [KVNProgress showWithStatus:@"Gathering Credit Card..."];
    
    PFQuery *query = [PFQuery queryWithClassName:@"StripeTokens"];
    [query whereKey:@"parseUserId" equalTo:[PFUser currentUser].objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        NSLog(@"Retrieved data");
        
        if (!error) {
            _customerToken = object[@"customerToken"];
            [KVNProgress dismiss];
            [[StripePayments sharedInstance] retrieveCardInfo:object[@"customerToken"] cardId:object[@"cardToken"] ];
        }
    }];
}


-(void)addCard: (NSString*) cardType lastFour: (NSString*) lastFourDigits
{
 [KVNProgress showWithStatus:@"Saving Credit Card..."];
  PFObject *card = [PFObject objectWithClassName:@"Payment"];
        card[@"cardType"] = cardType;
        card[@"lastFour"] = lastFourDigits;
        card[@"userObjectId"] = [PFUser currentUser].objectId;
    
        [card saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                [KVNProgress dismiss];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"cardAdded" object:nil];
            } else {
                // There was a problem, check error.description
            }
        }];
}


-(void) updateUserProfile:(UserModel*)userModel
{
    [KVNProgress showWithStatus:@"Saving Profile..."];
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"firstName"] = userModel.firstName;
    currentUser[@"lastName"] = userModel.lastName;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            [KVNProgress dismiss];
            [KVNProgress showSuccessWithStatus:@"Profile Updated!"];
        } else {
            // There was a problem, check error.description
        }
    }];
}


-(void)deleteCreditCard: (NSString*) cardObjectId {

    [KVNProgress showWithStatus:@"Removing..."];
 
    PFQuery *query = [PFQuery queryWithClassName:@"Payment"];
    [query whereKey:@"objectId" equalTo:cardObjectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        NSLog(@"Retrieved data");
        
        if (!error) {
            [object deleteInBackground];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QueryPayments" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cardDeleted" object:nil];
            
            [KVNProgress dismiss];
        }
    }];

}


@end
