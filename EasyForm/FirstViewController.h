//
//  FirstViewController.h
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 6/7/15.
//  Copyright (c) 2015 Fuzz Productions, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "i2KEPCSingleComponentPickerView.h"
#import "ReactiveCocoa.h"

@interface FirstViewController : UIViewController
{
     __weak IBOutlet UIView *tabbar;
}

//@property (strong, nonatomic) IBOutlet UIView *tabbar;
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

