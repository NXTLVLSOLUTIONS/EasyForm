//
//  AddPaymentVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 8/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface AddPaymentVC : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
- (IBAction)scanCardButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *monthYear;
@property (weak, nonatomic) IBOutlet UITextField *cvv;
@property (weak, nonatomic) IBOutlet UIButton *applePayButton;
@property(nonatomic) CardType cardType;

@end
