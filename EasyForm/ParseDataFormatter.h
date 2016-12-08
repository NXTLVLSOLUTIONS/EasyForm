//
//  ParseDataFormatter.h
//  Viaggio
//
//  Created by Rahiem Klugh on 3/2/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "UserModel.h"

@interface ParseDataFormatter : NSObject

@property(nonatomic, strong) NSMutableArray *providerFormsArray;
@property(nonatomic, strong) NSMutableArray *providersArray;
@property(nonatomic, strong) NSMutableArray *allProvidersArray;
@property(nonatomic, strong) NSMutableArray *insuranceArray;
@property(nonatomic, strong) NSMutableArray *paymentsArray;
@property(nonatomic) ImageSelectionType idType;
+(ParseDataFormatter*) sharedInstance;
-(void)queryAllProviders;
-(void)queryProviderType: (NSString*) type;
-(void)getProviderForms: (NSString*) providerId;
-(void)queryInsurance;
-(void)queryPayments;
-(void)getProfileImage;
-(void)getSignatureImage;
-(void)getIdCards;
-(void)saveProfileImage: (UIImage*)image;
-(void)saveSignatureImage: (UIImage*)image;
-(void)saveIdImage: (UIImage*)image idType: (ImageSelectionType) selectionType;
-(void)deleteCard;
-(void)saveNewStripeUserWithCard: (NSString*)customerID cardId: (NSString*) cardToken;
-(void)addCard: (NSString*) cardType lastFour: (NSString*) lastFourDigits;
-(void)updateUserProfile:(UserModel*)userModel;
-(void)deleteCreditCard: (NSString*) cardObjectId;

//Car booking
@property (strong, nonatomic) NSString *pickUpDate;
@property (strong, nonatomic) NSString *pickUpTime;
@property (strong, nonatomic) NSString *dropOffDate;
@property (strong, nonatomic) NSString *dropOffTime;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *cityState;
@property (strong, nonatomic) NSString *customerToken;
@property (strong, nonatomic) PFObject *carParseObject;
@property (strong, nonatomic) UIImage  *userProfileImage;
@property (strong, nonatomic) UIImage  *userSignatureImage;
@property (strong, nonatomic) UIImage  *userLicenseImage;
@property (strong, nonatomic) UIImage  *userIdImage;
@property (strong, nonatomic) UIImage  *userDiscountImage;
@property (strong, nonatomic) UIImage  *userInsuranceImage;
@property (nonatomic) BOOL userUpdatedProfileImage;
@property (nonatomic) NSNumber *segmentNumber;
@property (nonatomic) BOOL isLaunchedFromPhoneCall;
@property (nonatomic) BOOL isIphone6;
@property (nonatomic) BOOL isSelectionMade;
@property(nonatomic) ProviderType providerType;
@end
