//
//  Constants.h
//  Viaggio
//
//  Created by Rahiem Klugh on 3/1/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef enum {
    ImageTypeLicense,
    ImageTypeInsurance,
    ImageTypeDiscount,
    ImageTypeId,
} ImageSelectionType;

typedef enum {
    CardTypeVisa,
    CardTypeMasterCard,
    CardTypeDiscover,
    CardTypeAmex,
} CardType;

typedef enum {
    ProviderTypeDoctor,
    ProviderTypeDentist,
    ProviderTypeChiropractor,
    ProviderTypeNone,
} ProviderType;

//User Properties
#define BUSINESS @"Business"
#define LAWYER @"Lawyer"
#define DOCTOR @"Doctor"
#define DENTIST @"Dentist"
#define REAL_ESTATE @"Real Estate"
#define CHIROPRACTOR @"Chiropractor"
#define SELECTCATEGORY @"Select Category"

#define STRIPESECRETKEY @"sk_test_hmkbrvDAoMcHQwUTzRVJ2i5X"

//Colors
#define EASY_BLUE [UIColor colorWithRed:0.0/255 green:122.0/255 blue:255.0/255 alpha:1]

#define IS_IPHONE       ((int)(MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)) == 480)
#define IS_IPHONE5      ((int)(MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)) == 568)
#define IS_IPHONE6      ((int)(MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)) == 667)
#define IS_IPHONE6PLUS  ((int)(MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)) == 736)
#define  Width   [UIScreen mainScreen].bounds.size.width

#endif /* Constants_h */
