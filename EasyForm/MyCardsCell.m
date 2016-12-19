//
//  MyCardsCell.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/17/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "MyCardsCell.h"
#import "ParseDataFormatter.h"

@implementation MyCardsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_containsImage) {
        self.image.frame = CGRectMake(self.image.frame.origin.x-10,
                                      self.image.frame.origin.y,
                                      50,
                                      30);
    }

}

@end
