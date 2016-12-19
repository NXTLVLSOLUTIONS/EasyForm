//
//  RegisterVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/5/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "RegisterVC.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import "AppDelegate.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"

const static CGFloat kJVFieldFontSize = 13.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface RegisterVC ()
{
    UIImage *profileImage;
    BOOL isImagedSelected;
}

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    
//    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
//    NSString *userID = store.session.userID;
//    [TWTRSessionStore logOutUserID:userID];
    
    _verifyButton.layer.cornerRadius = 30;
    _verifyButton.layer.masksToBounds = YES;
    _verifyButton.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:197.0/255.0 blue:194.0/255.0 alpha:1.0].CGColor;
    _verifyButton.layer.borderWidth = 2;
    
    
    [_verifyButton addTarget:self action:@selector(validateForm) forControlEvents:UIControlEventTouchUpInside];
    [_addPhotoButton addTarget:self action:@selector(addPhotoPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTextFields:_firstNameTextField placeHolder:@"First Name"];
    [self setupTextFields:_lastNameTextField placeHolder:@"Last Name"];
    [self setupTextFields:_birthdayTextField placeHolder:@"Birthday"];
    [self setupTextFields:_emailTextField placeHolder:@"Email Address"];
}

-(JVFloatLabeledTextField*)setupTextFields: (JVFloatLabeledTextField*) textfield placeHolder: (NSString*) placeHolderString{
    UIColor *floatingLabelColor = [UIColor whiteColor];
    
    textfield.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    textfield.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(placeHolderString, @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    textfield.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    textfield.floatingLabelTextColor = floatingLabelColor;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    textfield.translatesAutoresizingMaskIntoConstraints = NO;
    textfield.keepBaseline = YES;
    textfield.returnKeyType = UIReturnKeyNext;
    textfield.delegate = self;
    
    return textfield;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)addPhotoPressed
{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Profile Picture"      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Take a photo"
                                  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                  picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  picker.delegate = self;
                                  picker.allowsEditing = YES;
                                  [self presentViewController: picker animated:YES completion:nil];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Choose existing"
                                  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  picker.delegate = self;
                                  picker.allowsEditing = YES;
                                  [self presentViewController: picker animated:YES completion:nil];
                              }];
    
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}



-(void) validateForm{
    
    [self verifyPressed];
   /* NSString *message = nil;
    BOOL validation = YES;
    
    if (_firstNameTextField.text.length == 0) {
        message = @"Please enter a first name";
        [_firstNameTextField becomeFirstResponder];
    }
    else if (_lastNameTextField.text.length == 0) {
        message = @"Please enter a last name";
    }
    else if (![self validateEmail:self.emailTextField.text]){
        validation = NO;
    }
    else if (_birthdayTextField.text.length == 0) {
        message = @"Please enter your date of birth";
    }
    else if (!isImagedSelected) {
        message = @"Please add a profile photo";
    }

    if (message != nil || validation == NO) {
        if (message != nil) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Missing Required Fields" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        [self verifyPressed];
    }*/
}

-(BOOL)validateEmail:(NSString *)email {
    
    if([email length] == 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Email" message:@"Email field should not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    if (regExMatches == 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Email" message:@"Enter proper email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else {
        return YES;
    }
}

-(void)verifyPressed
{
    Digits *digits = [Digits sharedInstance];
    DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
    configuration.appearance = [[DGTAppearance alloc] init];
    //configuration.appearance.backgroundColor = [UIColor blackColor];
    configuration.appearance.accentColor = EASY_BLUE;
    
    [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *session, NSError *error) {
        // Inspect session/error objects
        if (session != nil){
            [self signUpNewUser:session.phoneNumber];
        }
    }];
}
- (void)signUpNewUser: (NSString*) phoneNumber {
    
    [KVNProgress showWithStatus:@"Creating new account..."];
    
    PFUser *user = [PFUser user];
    user.username = phoneNumber;
    user.password = phoneNumber;
    user [@"email"] = _emailTextField.text;
    user[@"firstName"] = _firstNameTextField.text;
    user[@"lastName"] = _lastNameTextField.text;
    
    if (profileImage != nil) {
        NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.5);
        PFFile *imageFile = [PFFile fileWithName:@"ProfileImage.jpg" data:imageData];
        [imageFile saveInBackground];
        [user setObject:imageFile forKey:@"profileImage"];
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            // Hooray! Let them use the app now.
            [KVNProgress dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
               // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"registered"];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
                [self presentViewController:viewController animated:YES completion:nil];
                //                [self.navigationController setNavigationBarHidden:NO animated:YES];
            });
        }
        else
        {
            [KVNProgress dismiss];
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            if (error.code == 202) {
                UIAlertController *alert= [UIAlertController
                                           alertControllerWithTitle:@"Registration Error"
                                           message:@"User already registered"
                                           preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               NSLog(@"cancel btn");
                                                               
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                                  [(AppDelegate *)[[UIApplication sharedApplication] delegate] setLoginViewController];
                                                           }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }
    }];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    profileImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [_addPhotoButton setImage: profileImage  forState:UIControlStateNormal];
    _addPhotoButton.layer.cornerRadius = _addPhotoButton.frame.size.height/2;;
    _addPhotoButton.layer.masksToBounds = YES;
    _addPhotoButton.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    _addPhotoButton.layer.borderWidth = 3.0;
    isImagedSelected = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateStyle: NSDateFormatterShortStyle];
    
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    _birthdayTextField.text = [dateFormat stringFromDate:date];
}

- (IBAction)birthdayButtonPressed:(id)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Birthday" delegate:self];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}



@end
