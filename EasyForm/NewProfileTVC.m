//
//  NewProfileTVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 9/26/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "NewProfileTVC.h"
#import "ParseDataFormatter.h"
#import "UserModel.h"

@interface NewProfileTVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate>

@end

@implementation NewProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    if ( [ParseDataFormatter sharedInstance].userProfileImage) {
        [_changePhotoButton setImage: [ParseDataFormatter sharedInstance].userProfileImage  forState:UIControlStateNormal];
    }
    else{
        [_changePhotoButton setImage: [UIImage imageNamed:@"AddPhotoIcon"] forState:UIControlStateNormal];
    }
    
    _changePhotoButton.layer.masksToBounds = YES;
    _changePhotoButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _changePhotoButton.layer.shouldRasterize = YES;
    _changePhotoButton.clipsToBounds = YES;
    _changePhotoButton.layer.cornerRadius = _changePhotoButton.frame.size.height/2;
    [_changePhotoButton addTarget:self action:@selector(addPhotoPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserImage:) name: @"setProfileImage" object:nil];
    
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleDone target:self action:@selector(saveUserInfo)];
    
    self.navigationItem.rightBarButtonItem = btnCancel;
    
    
    [self loadUserData];
}

-(void)saveUserInfo{
    
     [self.view endEditing:YES];
    
    UserModel *user = [UserModel new];
    
    user.firstName = _firstNameTextField.text;
    user.lastName = _lastNameTextField.text;
    user.address = _homeAddressTextField.text;
    user.email = _emailAddressTextField.text;
    user.city = _cityTextField.text;
    user.state = _stateTextField.text;
    user.zip = _zipTextField.text;
    
    [[ParseDataFormatter sharedInstance] updateUserProfile:user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadUserData{
    PFUser *user = [PFUser currentUser];
    
    if (user[@"firstName"]) {
        _firstNameTextField.text =  user[@"firstName"];
    }
    if (user[@"lastName"]) {
        _lastNameTextField.text =  user[@"lastName"];
    }
    if (user[@"email"]) {
        _emailAddressTextField.text =  user[@"email"];
    }
    if (user[@"address"]) {
        _homeAddressTextField.text =  user[@"address"];
    }
    if (user[@"city"]) {
        _cityTextField.text =  user[@"city"];
    }
    if (user[@"state"]) {
        _stateTextField.text =  user[@"state"];
    }
    if (user[@"zip"]) {
        _zipTextField.text =  user[@"zip"];
    }
    if (user[@"username"]) {
        _phoneNumberLabel.text =  user[@"username"];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // do something, like dismiss your view controller, picker, etc., etc.
    [self.view endEditing:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}



-(void)addPhotoPressed
{
    [self.view endEditing:YES];
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Upload New Profile Picture"      //  Must be "nil", otherwise a blank title area will appear above our two buttons
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

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[ParseDataFormatter sharedInstance] saveProfileImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUserImage: (NSNotification*) imageData
{
    if (imageData != NULL) {
        UIImage *image = [imageData object];
        [_changePhotoButton setImage: image  forState:UIControlStateNormal];
        _changePhotoButton.layer.cornerRadius = _changePhotoButton.frame.size.height/2;;
        _changePhotoButton.layer.masksToBounds = YES;
        //        changePhotoButton.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
        //        changePhotoButton.layer.borderWidth = 3.0;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editPhotoButtonPressed:(id)sender {
    [self addPhotoPressed];
}
@end
