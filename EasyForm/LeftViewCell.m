//
//  LeftViewCell.m
//  LGSideMenuControllerDemo
//
//  Created by Friend_LGA on 26.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewCell.h"
#import "Constants.h"

@interface LeftViewCell ()

@end

@implementation LeftViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    // -----

    self.backgroundColor = EASY_BLUE;

    self.textLabel.font = [UIFont fontWithName:@"OpenSans" size:18];//[UIFont boldSystemFontOfSize:18.f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textLabel.textColor =  [UIColor whiteColor]; //_tintColor;
    _separatorView.backgroundColor = [_tintColor colorWithAlphaComponent:0.4];
 
        
//        CGSize size = self.bounds.size;
//        CGRect frame = CGRectMake(100.0f, 0.0f, size.width, size.height);
//    
//        CGSize imageSize = self.imageView.bounds.size;
//        CGRect imageFrame = CGRectMake(40.0f, 18.0f, imageSize.width, imageSize.height);
//    
//    
//        self.textLabel.frame =  frame;
//        self.imageView.frame = imageFrame;
        self.textLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
        self.textLabel.textColor = [UIColor lightGrayColor];//[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
    else
        self.textLabel.textColor = [UIColor whiteColor];
}

@end
