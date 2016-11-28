//
//  PDFRenderer.h
//  PDFRenderer
//
//  Created by Steve Baker on 3/20/14.
//  Copyright (c) 2014 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreText;
@import UIKit;

@interface PDFRenderer : NSObject
+(PDFRenderer*) sharedInstance;

- (void)drawPDF:(NSString*)fileName;

- (void)drawText;

//+ (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

- (void)drawImage:(UIImage*)image inRect:(CGRect)rect;

//PDF properties
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *phoneNumber;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *ssn;
@property (strong,nonatomic) NSString *sex;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *cityStateZip;
@property (strong,nonatomic) NSString *insurance;
@property (strong,nonatomic) NSString *healthRating;
@property (strong,nonatomic) NSString *pregnacyStatus;
@property (strong,nonatomic) NSString *conditionDescription;
@property (strong,nonatomic) NSString *dateSubmitted;


@property (strong,nonatomic) UIImage *cardImage;
@property (strong,nonatomic) UIImage *injuryImage;
@property (strong,nonatomic) UIImage *signatureImage;

@end
