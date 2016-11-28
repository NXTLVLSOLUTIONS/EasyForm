//
//  MyCardsCell.h
//  EasyForm
//
//  Created by Rahiem Klugh on 8/17/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *plusView;
@property (nonatomic)  BOOL containsImage;

@end
