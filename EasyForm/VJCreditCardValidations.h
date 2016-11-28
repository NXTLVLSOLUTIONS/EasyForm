//
//  CreditCardValidations.h
//  Swyft
//
//  Created by IPS Brar on 20/10/14.
//  Copyright (c) 2014 NetSet Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VJCreditCardValidations : NSObject
+ (instancetype)cardNumberWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;
- (NSInteger)lengthForCardType;
- (BOOL)isValid;
- (NSString *)cardType;
- (NSString *)formattedStringWithTrail;
- (NSString *)formattedString;
- (BOOL)isValidLuhn;
- (BOOL)isValidLength;
- (BOOL)isPartiallyValid;
@end
