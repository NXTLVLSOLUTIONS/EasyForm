//
//  EasyFormTVC.h
//  forms
//
//  Created by rahiem.klugh on 5/18/16.
//  Copyright © 2016 rahiem.klugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JTMaterialSwitch.h"
#import "i2KEPCSingleComponentPickerView.h"
#import "ReactiveCocoa.h"

@interface EasyFormTVC : UITableViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
     UIImagePickerController *imagePickerController;
     UIImage *injuryImage;
}
- (IBAction)signButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *nameTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *lastTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *emailTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *addressTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *ssnTextField;
@property (strong, nonatomic) NSString *injuryDescription;
- (IBAction)insuranceCardButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet JTMaterialSwitch *insSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
- (IBAction)addCardButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *creditCardImageView;
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pregnantSegmentControl;
@property (strong, nonatomic) IBOutlet UILabel *healthRatingLabel;

@property (strong, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *cityTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *stateTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *zipTextField;

@property (nonatomic, weak) IBOutlet UIButton *singlePickerButton;
@property (nonatomic, weak) i2KEPCSingleComponentPickerView *singleComponentPicker;
@property (nonatomic, strong) NSString *selectedValueSingle;
@property (strong, nonatomic) IBOutlet UIImageView *contitionPhoto;
- (IBAction)sexSegmentSelected:(id)sender;
- (IBAction)pregnacySegmentSelected:(id)sender;

-(void)showSignature;

@end
