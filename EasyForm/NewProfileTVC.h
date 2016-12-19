//
//  NewProfileTVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 9/26/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewProfileTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;


- (IBAction)editPhotoButtonPressed:(id)sender;

@end
