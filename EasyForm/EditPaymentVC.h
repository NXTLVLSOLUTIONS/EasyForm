//
//  EditPaymentVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 9/29/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseDataFormatter.h"

@interface EditPaymentVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
- (IBAction)removePressed:(id)sender;
@property (strong, nonatomic) PFObject *card;
@end
