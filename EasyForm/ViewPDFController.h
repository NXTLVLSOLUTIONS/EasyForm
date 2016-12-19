//
//  ViewPDFController.h
//  EasyForm
//
//  Created by Rahiem Klugh on 9/26/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ILPDFKit/ILPDFDocument.h>
#import <ILPDFKit/ILPDFKit.h>

@interface ViewPDFController : ILPDFViewController
@property (nonatomic, strong) NSData *pdfData;
@property (nonatomic, strong) NSString *providerEmail;

@end
