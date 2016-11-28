//
//  PDFRenderer.m
//  PDFRenderer
//
//  Created by Steve Baker on 3/20/14.
//  Copyright (c) 2014 Beepscore LLC. All rights reserved.
//

#import "PDFRenderer.h"
#import <objc/runtime.h>
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "ZXBitMatrix.h"
@import UIKit;


#define HELVETICA @"Helvetica"
#define HELVETICA_LIGHT @"Helvetica-light"
#define HELVETICA_BOLD @"Helvetica-bold"
#define EASY_BLUE [UIColor colorWithRed:0.0/255 green:122.0/255 blue:255.0/255 alpha:1]

@implementation PDFRenderer

+(PDFRenderer*) sharedInstance
{
    static PDFRenderer * sharedData = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[PDFRenderer alloc ]init];
    });
    
    return sharedData;
}

- (void)drawPDF:(NSString*)fileName {
      NSLog(@"First name data: %@", _name);
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    // if drawImage is after drawText, logo isn't visible  IconPlusText
    UIImage *logo = [UIImage imageNamed:@"EasyFont"];
    CGRect frame = CGRectMake(20, 20, 100, 12.9);
    [self drawImage:logo inRect:frame];
    [self drawLineFromPoint:CGPointMake(20, 40) toPoint:CGPointMake(120, 40)lineSize:1.5];
    [self generateQRcode];
    
    [self drawText];
    
    //Box Frame
    [self drawLineFromPoint:CGPointMake(0, -10) toPoint:CGPointMake(575, -10)lineSize:1.5];
    [self drawLineFromPoint:CGPointMake(0, -10) toPoint:CGPointMake(0, -650)lineSize:1.5];
    [self drawLineFromPoint:CGPointMake(575, -10) toPoint:CGPointMake(575, -650)lineSize:1.5];
    [self drawLineFromPoint:CGPointMake(0, -650) toPoint:CGPointMake(575, -650)lineSize:1.5];
    
    //Personal
    [self drawLineFromPoint:CGPointMake(180, -10) toPoint:CGPointMake(180, -220)lineSize:0.5];
    
    //Medical
     [self drawLineFromPoint:CGPointMake(180, -260) toPoint:CGPointMake(180, -410)lineSize:0.5];
    
    //Medical 2
    [self drawLineFromPoint:CGPointMake(180, -410) toPoint:CGPointMake(180, -580)lineSize:0.5];
    
    [self drawPersonalLines];
    [self drawMedicalLines];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


-(void) generateQRcode
{
    
    NSString *data = @"123456";
    if (data == 0) return;
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:data
                                  format:kBarcodeFormatQRCode
                                   width:400
                                  height:400
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        
        CGRect frame = CGRectMake(540, 10, 60, 60);
        [self drawImage: [UIImage imageWithCGImage:image.cgimage] inRect:frame];
    } else {
        // self.imageView.image = nil;
    }
}

-(void) drawPersonalLines{
    
    int origin = 40;
    int spacing = 30;
    int numberOfRows = 7;
    
    for (int j = 0; j < numberOfRows; j++)
    {
        
        [self drawLineFromPoint: CGPointMake(0, -origin) toPoint:CGPointMake(575, -origin) lineSize:0.5];
        origin = origin+spacing;
    }
}

-(void) drawMedicalLines{
    
    int origin = 260;
    int spacing = 30;
    int numberOfRows = 6;
    
    //Header
    [self drawLineFromPoint: CGPointMake(0, -260) toPoint:CGPointMake(575, -260) lineSize:1.5];
    
    //Footer
    [self drawLineFromPoint:CGPointMake(0, -580) toPoint:CGPointMake(575, -580)lineSize:1.5];
    
    for (int j = 0; j < numberOfRows; j++)
    {
        if (j != 4) {
            [self drawLineFromPoint: CGPointMake(0, -origin) toPoint:CGPointMake(575, -origin) lineSize:0.5];
           
        }
         origin = origin+spacing;
  
    }
}

- (void)drawText {
    
    NSString* textToDraw = @"";
    CTFramesetterRef framesetter = [self createFramesetterFromString:textToDraw fontSize:11.5 fontColor:[UIColor lightGrayColor]];
    
    [self addText:@"PATIENT INFORMATION FORM" withFrame:CGRectMake(200, 75, 200, 50) fontSize:16.0 fontColor:[UIColor grayColor] fontName:HELVETICA];
    [self addText:@"Date Submitted: 06-08-2016 04:35 PM" withFrame:CGRectMake(25, 690, 200, 50) fontSize:12.0 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:[NSString stringWithFormat:@"Submitted by: %@", _email] withFrame:CGRectMake(25, 705, 200, 50) fontSize:12.0 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Life Just Got Easier" withFrame:CGRectMake(20, 45, 100, 50) fontSize:11.5 fontColor:[UIColor lightGrayColor] fontName:HELVETICA];
    [self addText:@"Easy Code" withFrame:CGRectMake(550, 62, 100, 50) fontSize:8.0 fontColor:[UIColor blackColor] fontName:HELVETICA_LIGHT];
    
    [self drawPersonal];
    
    CTFrameRef frameRef = [self createFrameRef:framesetter];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 20, 85);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CFRelease(frameRef);
    CFRelease(framesetter);
}

// CoreFoundation naming convention for functions
// Function name with copy or create means caller is responsible for releasing returned object
// http://stackoverflow.com/questions/14064336/arc-and-cfrelease

- (CTFramesetterRef)createFramesetterFromString:(NSString *)string fontSize:(CGFloat)size fontColor:(UIColor*)color {
    CFStringRef stringRef = (__bridge CFStringRef)string;
    
    CGColorSpaceCreateWithName(stringRef);
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]
                                          initWithString:string];
    
    CTFontRef helveticaBold;
    helveticaBold = CTFontCreateWithName(CFSTR("Helvetica"), size, NULL);
    [string1 addAttribute:(id)kCTFontAttributeName
                    value:(__bridge id)helveticaBold
                    range:NSMakeRange(0, [string length])];
    [string1 addAttribute:(id)kCTForegroundColorAttributeName
                    value:(id)color.CGColor
                    range:NSMakeRange(0, [string length])];
    
    CTFramesetterRef framesetter =    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string1);
    
    // CGMutablePathRef framePath = CGPathCreateMutable();
    
    
    
    
    // Prepare the text using a Core Text Framesetter.
    //    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    //    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    //    // I think at this point it's safe to release currentText to avoid leak
    //    CFRelease(currentText);
    return framesetter;
}

- (CTFrameRef)createFrameRef:(CTFramesetterRef)framesetter {
    CGRect frameRect = CGRectMake(0, 0, 300, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    return frameRef;
}


- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize fontColor:(UIColor*)color fontName:(NSString*)fontName {
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    CGSize _pageSize = CGSizeMake(612, 792);
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary * attributes = @{NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName: color};
    
    CGSize stringSize = [text boundingRectWithSize:CGSizeMake(_pageSize.width - 2*20-2*20, _pageSize.height - 2*20 - 2*20)
                                           options:NSStringDrawingUsesFontLeading
                         |NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil].size;
    
    
    float textWidth = frame.size.width;
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    //    /// Make a copy of the default paragraph style
    //    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //    /// Set line break mode
    //    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    //    /// Set text alignment
    //    paragraphStyle.alignment = NSTextAlignmentLeft;
    //
    //    NSDictionary *attributes = @{ NSFontAttributeName: font,
    //                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    [text drawInRect:renderingRect withAttributes:attributes];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
    
}

- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to lineSize:(CGFloat)size {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, size);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

- (void)drawImage:(UIImage*)image inRect:(CGRect)rect {
    [image drawInRect:rect];
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)image;
{
//    CGSize size = [source size];
//    UIGraphicsBeginImageContext(size);
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
//    CGContextStrokeRect(context, rect);
//    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return testImg;
    CGImageRef bgimage = [image CGImage];
    float width = CGImageGetWidth(bgimage);
    float height = CGImageGetHeight(bgimage);
    
    // Create a temporary texture data buffer
    void *data = malloc(width * height * 4);
    
    // Draw image to buffer
    CGContextRef ctx = CGBitmapContextCreate(data,
                                             width,
                                             height,
                                             8,
                                             width * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), bgimage);
    
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    
    //Set the width of the pen mark
    CGFloat borderWidth = (float)width*0.02;
    CGContextSetLineWidth(ctx, borderWidth);
    
    //Start at 0,0 and draw a square
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, height);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, width, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
    //Draw it
    CGContextStrokePath(ctx);
    
    // write it to a new image
    CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CFRelease(cgimage);
    CGContextRelease(ctx);
    
    // auto-released
    return newImage;
}



-(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
{
    int padding = 10;
    
    NSArray* headers = [NSArray arrayWithObjects:@"Quantity", @"Description", @"Unit price", @"Total", nil];
    NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    NSArray* invoiceInfo2 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    NSArray* invoiceInfo3 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    NSArray* invoiceInfo4 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    
    NSArray* allInfo = [NSArray arrayWithObjects:headers, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4, nil];
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        NSArray* infoToDraw = [allInfo objectAtIndex:i];
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i+1)*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            
            
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
        }
        
    }
    
}


-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}



- (void) drawPersonal{
    
    
    [self addText:@"Full Name" withFrame:CGRectMake(30, 105, 80, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Phone Number" withFrame:CGRectMake(30, 135, 105, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Email Address" withFrame:CGRectMake(30, 165, 102, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Social Security Number" withFrame:CGRectMake(30, 195, 150, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Sex" withFrame:CGRectMake(30, 225, 50, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Home Address" withFrame:CGRectMake(30, 255, 105, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"City, State, Zip" withFrame:CGRectMake(30, 285, 105, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    
    //MEDICAL
    [self addText:@"MEDICAL" withFrame:CGRectMake(30, 325, 80, 50) fontSize:11.5 fontColor:EASY_BLUE fontName:HELVETICA_BOLD];
    [self addText:@"Insurance Provider" withFrame:CGRectMake(30, 355, 125, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Health Rating (1-10)" withFrame:CGRectMake(30, 385, 132, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Are you pregnant?" withFrame:CGRectMake(30, 415, 125, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Condition Description" withFrame:CGRectMake(30, 445, 140, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
    [self addText:@"Insurance Card" withFrame:CGRectMake(30, 500, 110, 50) fontSize:11.5 fontColor:EASY_BLUE fontName:HELVETICA_BOLD];
    
    [self addText:@"Injury Photos" withFrame:CGRectMake(220, 500, 115, 50) fontSize:11.5 fontColor:EASY_BLUE fontName:HELVETICA_BOLD];
    
    [self writePersonal];
    [self writeMedical];
    [self writeImages];
}

- (void) writePersonal{
    
    NSArray *fields = @[_name, _phoneNumber,_email, _ssn,_sex, _address, _cityStateZip];
    int numberOfRows = (int)[fields count];
    int yOrigin = 105;
    int spacing = 30;
    
    for (int j = 0; j < numberOfRows; j++)
    {
        
        [self addText: [fields objectAtIndex:j] withFrame:CGRectMake(220, yOrigin, 100, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
        yOrigin = yOrigin+spacing;
    }
}

- (void) writeMedical{
    NSArray *fields = @[_insurance, _healthRating,_pregnacyStatus, _conditionDescription];
    int numberOfRows = (int)[fields count];
    int yOrigin = 355;
    int spacing = 30;
    
    for (int j = 0; j < numberOfRows; j++)
    {
        
        [self addText: [fields objectAtIndex:j] withFrame:CGRectMake(220, yOrigin, 100, 50) fontSize:11.5 fontColor:[UIColor blackColor] fontName:HELVETICA];
        yOrigin = yOrigin+spacing;
    }
}

-(void)writeImages
{
    if (_cardImage != nil) {
        CGRect frame = CGRectMake(35, 540, 140, 81.70);
        [self drawImage:_cardImage inRect:frame];
    }
    
    if (_injuryImage != nil) {
        CGRect frame = CGRectMake(220, 520, 100, 133.3);
        [self drawImage: _injuryImage inRect:frame];
    }
    
    if (_signatureImage != nil) {
        CGRect frame = CGRectMake(300, 675, 120, 40.70);
        [self drawImage: _signatureImage inRect:frame];
    }
}



@end
