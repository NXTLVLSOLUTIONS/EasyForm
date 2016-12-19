//
//  RegisterVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 8/5/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "IQActionSheetPickerView.h"

@interface RegisterVC : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, IQActionSheetPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
- (IBAction)birthdayButtonPressed:(id)sender;

@end
