//
//  PersonalInformationCell.h
//  FZAccordionTableViewExample
//
//  Created by Rahiem Klugh on 8/7/16.
//  Copyright © 2016 Fuzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "i2KEPCSingleComponentPickerView.h"
#import "ReactiveCocoa.h"

@interface PersonalInformationCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *nameTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *lastTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *emailTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *addressTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *ssnTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *cityTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *stateTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *zipTextField;
@property (nonatomic, weak) IBOutlet UIButton *singlePickerButton;
@property (nonatomic, weak) i2KEPCSingleComponentPickerView *singleComponentPicker;
@property (nonatomic, strong) NSString *selectedValueSingle;
@end
