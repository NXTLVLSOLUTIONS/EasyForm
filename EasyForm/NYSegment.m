//
//  NYSegment.m
//  NYSegmentedControl
//
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegment.h"
#import "NYSegmentLabel.h"

static CGFloat const kMinimumSegmentWidth = 68.0f;

@implementation NYSegment

- (instancetype)initWithTitle:(NSString *)imageName {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [self resizeImage:[UIImage imageNamed:imageName]];
        CGFloat offsetY = -5.0;
        attachment.bounds = CGRectMake(-15, offsetY, attachment.image.size.width-10, attachment.image.size.height-10);
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        self.titleLabel.attributedText = attachmentString;
        //self.titleLabel.text = title;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.titleLabel = [[NYSegmentLabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
       // [self.titleLabel sizeToFit];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [self.titleLabel sizeThatFits:size];
    return CGSizeMake(MAX(sizeThatFits.width * 1.4f, kMinimumSegmentWidth), sizeThatFits.height);
}

-(UIImage *) resizeImage: (UIImage*) inputImage
{
    UIImage * image = inputImage;
    CGSize sacleSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
