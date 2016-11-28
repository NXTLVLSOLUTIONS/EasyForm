//
//  SelectFormCell.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/3/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "SelectFormCell.h"

@implementation SelectFormCell

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

@end
