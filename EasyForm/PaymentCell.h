//
//  PaymentCell.h
//  EasyForm
//
//  Created by Rahiem Klugh on 8/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic)  BOOL containsImage;

@end
