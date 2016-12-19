//
//  PaymentCell.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFrame:(CGRect)frame {
    frame.origin.x += 20;
    frame.size.width -= 2 * 20;
    [super setFrame:frame];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_containsImage) {
        self.image.frame = CGRectMake(self.image.frame.origin.x,
                                      self.image.frame.origin.y,
                                      25,
                                      25);
    }
    
}

@end
