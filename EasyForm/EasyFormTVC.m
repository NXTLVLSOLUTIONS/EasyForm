//
//  EasyFormTVC.m
//  forms
//
//  Created by rahiem.klugh on 5/18/16.
//  Copyright © 2016 rahiem.klugh. All rights reserved.
//

#import "EasyFormTVC.h"
#import "SignatureVC.h"
#import "RRSendMessageViewController.h"
#import "ASValueTrackingSlider.h"
#import "KLCPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "CardIO.h"
#import "ParseDataFormatter.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "CoreText/CoreText.h"
#import "PDFRenderer.h"
#import "TESignatureView.h"
#import "UIView+MJAlertView.h"

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;
const static CGFloat kJVFieldFontSize = 13.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

#define EASY_BLUE [UIColor colorWithRed:0.0/255 green:122.0/255 blue:255.0/255 alpha:1]
#define CANCEL_RED [UIColor colorWithRed:226.0/255 green:40.0/255 blue:55.0/255 alpha:1]

@interface EasyFormTVC () <ASValueTrackingSliderDataSource,CardIOPaymentViewControllerDelegate>
{
    KLCPopup* popup;
    UIImage* userSignatureImage;
    TESignatureView *signtureView;
    BOOL insuranceCardAdded;
    BOOL conditionPhotoAdded;
    BOOL sexSelected;
    BOOL pregnacySelected;
}
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider1;
@end

@implementation EasyFormTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"New Patient Form";
    
    UIImage *bckgrndimage = [UIImage imageNamed:@"bkgrond"];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add the effect view to the image view
    
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     bckgrndimage];
    [self.tableView.backgroundView addSubview:effectView];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
    // customize slider 1
    self.slider1.maximumValue = 10.0;
    self.slider1.minimumValue = 1.0;
    self.slider1.popUpViewCornerRadius = 12.0;
    [self.slider1 setMaxFractionDigitsDisplayed:0];
    self.slider1.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.slider1.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.slider1.textColor = [UIColor whiteColor];
    self.slider1.popUpViewWidthPaddingFactor = 1.7;
    
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *yellow = [UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];
    
    [self.slider1 setPopUpViewAnimatedColors:@[red, yellow,green]
                               withPositions:@[@1, @6, @8]];
    
    self.slider1.dataSource = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    _cardNumberLabel.hidden = YES;
    
    [self setupTextFields];
    [self setupCameraView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insuranceSelected:) name:@"insuranceSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(descriptionComplete:) name:@"descriptionComplete" object:nil];
}

-(void)insuranceSelected:(NSNotification*)notification
{
   _insuranceLabel.text = notification.userInfo[@"insuranceName"];
}

-(void)descriptionComplete:(NSNotification*)notification
{
    injuryImage = notification.userInfo[@"editedImage"] ;
    _injuryDescription = notification.userInfo[@"description"];
    
    if (injuryImage) {
        _contitionPhoto.image = injuryImage;
        _contitionPhoto.frame = CGRectMake(254, 16, 41.2, 55);
    }
}


-(void) setupCameraView{
    // Do any additional setup after loading the view, typically from a nib.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = NO;
        imagePickerController.delegate = self;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
        imgView.image = [UIImage imageNamed:@"cardScanOverlay"];
        
       // Device *device = [Device currentDevice];
        CGFloat y;
        if ([ParseDataFormatter sharedInstance].isIphone6) {
            y=180;
        }
        else
        {
            y=120;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 130, y, 260, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Place Insurance card in the frame below";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"ArialMT" size:14];
        [imgView addSubview:label];
        
        imagePickerController.cameraOverlayView = imgView;
    }
}


-(void)setupTextFields{
    UIColor *floatingLabelColor = [UIColor lightGrayColor];
    
    _nameTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _nameTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"First Name", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _nameTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _nameTextField.floatingLabelTextColor = floatingLabelColor;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _nameTextField.keepBaseline = YES;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.delegate = self;
    
    _lastTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _lastTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Last Name", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _lastTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _lastTextField.floatingLabelTextColor = floatingLabelColor;
    _lastTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _lastTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _lastTextField.keepBaseline = YES;
    _lastTextField.returnKeyType = UIReturnKeyNext;
    _lastTextField.delegate = self;
    
  //  UIView *div1 = [UIView new];
  //  div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
  //  [self.view addSubview:div1];
  //  div1.translatesAutoresizingMaskIntoConstraints = NO;
    
    _phoneTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _phoneTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Phone Number", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _phoneTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _phoneTextField.floatingLabelTextColor = floatingLabelColor;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.delegate = self;
    _phoneTextField.returnKeyType = UIReturnKeyNext;
    _phoneTextField.tag =1;
    _phoneTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _phoneTextField.keepBaseline = YES;
    
    _emailTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _emailTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email Address", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _emailTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _emailTextField.floatingLabelTextColor = floatingLabelColor;
    _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _emailTextField.keepBaseline = YES;
    _emailTextField.returnKeyType = UIReturnKeyNext;
    _emailTextField.delegate = self;
    
    
    _addressTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _addressTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Home Address", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _addressTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _addressTextField.floatingLabelTextColor = floatingLabelColor;
    _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _addressTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _addressTextField.keepBaseline = YES;
    _addressTextField.returnKeyType = UIReturnKeyNext;
    _addressTextField.delegate = self;
    
    
    _cityTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _cityTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"City", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _cityTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _cityTextField.floatingLabelTextColor = floatingLabelColor;
    _cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _cityTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _cityTextField.keepBaseline = YES;
    _cityTextField.returnKeyType = UIReturnKeyNext;
    _cityTextField.delegate = self;
    
    
    _stateTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _stateTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"State", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _stateTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _stateTextField.floatingLabelTextColor = floatingLabelColor;
    _stateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _stateTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _stateTextField.keepBaseline = YES;
    
    _zipTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _zipTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Zip code", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _zipTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _zipTextField.floatingLabelTextColor = floatingLabelColor;
    _zipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _zipTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _zipTextField.keepBaseline = YES;
    _zipTextField.delegate = self;
    _zipTextField.tag = 3;
    _zipTextField.returnKeyType = UIReturnKeyNext;
    
    
    _ssnTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _ssnTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Social Security Number", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    _ssnTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _ssnTextField.floatingLabelTextColor = floatingLabelColor;
    _ssnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _ssnTextField.delegate = self;
    _ssnTextField.tag = 2;
    _ssnTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _ssnTextField.keepBaseline = YES;
    _ssnTextField.returnKeyType = UIReturnKeyNext;
    
//    UIView *div1 = [UIView new];
//    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
//    [self.view addSubview:div1];
//    div1.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_phoneTextField addTarget:self action:@selector(phoneChanged) forControlEvents:UIControlEventEditingChanged];
    [_zipTextField addTarget:self action:@selector(zipChanged) forControlEvents:UIControlEventEditingChanged];
    
   // [_nameTextField becomeFirstResponder];
    //[self configureStateButton];
    self.singlePickerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
        return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
            i2KEPCSingleComponentPickerView *singleComponentPickerView = [[i2KEPCSingleComponentPickerView alloc]
                                                                          initWithTitle:@"Select State"
                                                                          valuesArray:@[ @"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY" ]
                                                                          initialValueIndex:0];
            
            [[singleComponentPickerView valueSignal] subscribeNext:^(RACTuple *x) {
                //@strongify(self);
                //self.selectedIndexSingle = [x.first integerValue];
                self.selectedValueSingle = x.second;
                [self.singlePickerButton setTitle:_selectedValueSingle forState:UIControlStateNormal];
                [self.singlePickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_zipTextField becomeFirstResponder];
            }];
            
            [singleComponentPickerView showPicker];
            
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}


-(void)phoneChanged
{
    NSLog(@"LENGTH: %lu",_phoneTextField.text.length ) ;
    
    if (_phoneTextField.text.length ==14) {
        [_phoneTextField resignFirstResponder];
        [_emailTextField becomeFirstResponder];
    }
}

-(void)zipChanged
{
    NSLog(@"LENGTH: %lu",_zipTextField.text.length ) ;
    
    if (_zipTextField.text.length ==5) {
        [_zipTextField resignFirstResponder];
        [_ssnTextField becomeFirstResponder];
    }
}

//- (void)configureStateButton
//{
//    @weakify(self);
//    
//    RAC(self.singlePickerButton, titleLabel) = [RACObserve(self, selectedValueSingle) map:^id(NSString *value) {
//        @strongify(self);
//        return [NSString stringWithFormat:@"%@", self.selectedValueSingle];
//    }];
//}

-(void)viewWillAppear:(BOOL)animated
{
   // self.navigationController.navigationBar.topItem.title = @"";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
}


- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    value = roundf(value);
    NSString *s;
    
      NSLog(@"Slider valie: %f", value);
     _healthRatingLabel.text = [NSString stringWithFormat:@"%.f", value];
    if (value < 4.0) {
           //self.slider1.popUpViewColor = [UIColor redColor];
    } 
    return s;
}

- (void)animateSlider:(ASValueTrackingSlider*)slider toValue:(float)value
{
    [slider setValue:value animated:YES];
    
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider;
{
    //[self.superview bringSubviewToFront:self];
    
    NSLog(@"Slider valie: %f", slider.value);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 17;
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row == 9) {
        [self performSegueWithIdentifier:@"selectProvider" sender:self];
    }
    
    if (indexPath.row == 13){
        
    
        
        if ([ParseDataFormatter sharedInstance].isIphone6) {
             [self performSegueWithIdentifier:@"conditionDescription" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"smallConditionDescription" sender:self];
        }
    }
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark- SignDelegate Method
-(void)successfullyCapturedSignature:(UIImage *)signatureImage{
    
    userSignatureImage = signatureImage;
}

-(void)captureSignatureCanceled:(BOOL)canceled{
    
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

- (IBAction)signButtonPressed:(id)sender {
    [self validateForm];

}

-(void)cancelButtonPressed
{
    [popup dismiss:YES];
}

-(void)doneButtonPressed
{
    [popup dismiss:YES];
    
    NSString* fileName = [self getPDFFileName];
    
    [self setPDFRenderedData];
    
    [[PDFRenderer sharedInstance] drawPDF:fileName];
    
//    [self sendEmailWithAttachment];
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(sendEmailWithAttachment)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EasyFormCreated" object:nil];

   // [self showPDFFile];
}





-(void)showPDFFile
{
    NSString* pdfFileName = [self getPDFFileName];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    //[self sendEmailWithAttachment];
}

-(NSString*)getPDFFileName
{
    NSString* fileName = @"easyform.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
}

-(void)sendEmailWithAttachment
{
    NSString* pdfFileName = [self getPDFFileName];
    NSData *pdfData = [NSData dataWithContentsOfFile:pdfFileName];
    NSString *base64pdfString = [pdfData base64EncodedStringWithOptions:0];
    
    [PFCloud callFunctionInBackground:@"email" withParameters:@{@"email": @"Jared@nxtlvl.xyz", @"text": @"Congratulations, You have a new patient form!", @"content": base64pdfString} block:^(NSString *result, NSError *error) {
        if (error) {
            //error
        } else {
            NSLog(@"result :%@", result);
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // do something, like dismiss your view controller, picker, etc., etc.
     [self.view endEditing:YES];
}


- (IBAction)insuranceCardButtonTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.cameraViewTransform = CGAffineTransformTranslate(imagePickerController.cameraViewTransform, 0.0, 37.0);
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark- UIImagePickerController Delegate Method.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        //currentVisitor.business_card_image = originalImage;
    }
    else
    {
        UIImage *cardImage = [self cropImage:originalImage];
        _cardImageView.image = cardImage;
            _cardImageView.layer.cornerRadius = 6;
            _cardImageView.layer.masksToBounds = YES;
            _cardImageView.layer.borderColor = [UIColor blackColor].CGColor;
            _cardImageView.layer.borderWidth = 0.5;
      //  _cardImageView.frame = CGRectMake(214, 10, 60, 20);
        UIImageWriteToSavedPhotosAlbum(cardImage, nil, nil, nil);
        
        insuranceCardAdded = YES;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (UIImage *)cropImage:(UIImage *)oldImage {
    CGSize imageSize = oldImage.size;
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( imageSize.width-650, imageSize.height - 2150), NO, 0.0);
    [oldImage drawAtPoint:CGPointMake(-325, -1075+40) blendMode:kCGBlendModeCopy alpha:1];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}
- (IBAction)addCardButtonPressed:(id)sender {
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSString *trimmedString=[info.cardNumber substringFromIndex:MAX((int)[info.cardNumber length]-4, 0)];
    NSLog(@"Scan succeeded with info: %@", trimmedString);
    // Do whatever needs to be done to deliver the purchased items.
    switch (info.cardType) {
        case CardIOCreditCardTypeMastercard:
        {
            _creditCardImageView.image = [UIImage imageNamed:@"Mastercard"];
            break;
        }
            
        case CardIOCreditCardTypeVisa:
        {
            _creditCardImageView.image = [UIImage imageNamed:@"Visa"];
            break;
        }
            
        case CardIOCreditCardTypeDiscover:
        {
            _creditCardImageView.image = [UIImage imageNamed:@"Discover"];
            break;
        }
            
        case CardIOCreditCardTypeAmex:
        {
            _creditCardImageView.image = [UIImage imageNamed:@"AmericanExpress"];
            break;
        }
            
        default:
            break;
    }
    
    _cardNumberLabel.hidden = NO;
    _cardNumberLabel.text = [NSString stringWithFormat:@"X-%@", trimmedString];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //    self.infoLabel.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 1)  //Phone number
    {
        int length = (int)[self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
//        if (range.location ==13) {
//            [_phoneTextField resignFirstResponder];
//            [_emailTextField becomeFirstResponder];
//        }
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    else if (textField.tag == 2) //SSN
    {
        if (range.location == 11)    //this is calculate the overall string
        {
            return NO;
        }
        
        if ([string length] == 0)   //string length is `0` hide the keyboard
        {
            return YES;
        }
        
        if ((range.location == 3) || (range.location == 6))    //apply the `-` between the overall string
        {
            NSString *str  = [NSString stringWithFormat:@"%@-",textField.text];
            textField.text = str;
        }
        //[formatter setLenient:YES];
    }
    else if (textField.tag == 3)
    {
        if (range.location == 5)    //this is calculate the overall string
        {
            return NO;
        }
    }
    
    return YES;
}

- (NSString *)formatNumber:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}

- (int)getLength:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    return length;
}


-(void)setPDFRenderedData
{
    PDFRenderer *pdf = [PDFRenderer sharedInstance];
    pdf.name = [NSString stringWithFormat:@"%@ %@", _nameTextField.text, _lastTextField.text];
    pdf.phoneNumber = _phoneTextField.text;
    pdf.email =_emailTextField.text;
    pdf.ssn = _ssnTextField.text;
    
    NSString* sexString;
    if (_sexSegmentControl.selectedSegmentIndex ==0) {
        sexString = @"Male";
    }
    else
    {
        sexString = @"Female";
    }
    
    NSString* pregString;
    switch (_sexSegmentControl.selectedSegmentIndex) {
        case 0:
             pregString = @"YES";
            break;
        case 1:
            pregString = @"NO";
            break;
        case 2:
            pregString = @"NA";
            break;
            
        default:
            break;
    }
    
    pdf.sex = sexString;
    pdf.address = _addressTextField.text;
    pdf.cityStateZip = [NSString stringWithFormat:@"%@, %@ %@", _cityTextField.text, _singlePickerButton.titleLabel.text, _zipTextField.text];
    pdf.insurance = _insuranceLabel.text;
    pdf.pregnacyStatus = pregString;
    pdf.healthRating = _healthRatingLabel.text;
    pdf.conditionDescription = _injuryDescription;
    pdf.cardImage =[self resizeImage: _cardImageView.image];
    pdf.signatureImage = [self resizeImage:[signtureView getSignatureImage]];
    pdf.injuryImage = [self resizeImage:injuryImage];
    
}
-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

-(void) validateForm{
   // BOOL isComplete = NO;
    NSString *message = nil;
    
    if (_nameTextField.text.length == 0) {
        message = @"Please enter a first name";
    }
    else if (_lastTextField.text.length == 0) {
        message = @"Please enter a last name";
    }
    else if (_phoneTextField.text.length == 0) {
        message = @"Please enter a phone number";
    }
    else if (_emailTextField.text.length == 0) {
        message = @"Please enter a email address";
    }
    else if (_addressTextField.text.length == 0) {
        message = @"Please enter a home address";
    }
    else if (_cityTextField.text.length == 0) {
        message = @"Please enter a city";
    }
    else if ([_singlePickerButton.titleLabel.text isEqualToString:@"State"]) {
        message = @"Please select a state";
    }
    else if (_zipTextField.text.length == 0) {
        message = @"Please enter a zip code";
    }
    else if (_ssnTextField.text.length == 0) {
        message = @"Please enter a social security #";
    }
    else if (!sexSelected) {
        message = @"Please choose your sex";
    }
    else if (!insuranceCardAdded) {
        message = @"Please add a insurance card";
    }
    else if ([_insuranceLabel.text isEqualToString:@"Select Insurance Provider"]) {
        message = @"Please select your insurance provider";
    }
    else if (!pregnacySelected) {
        message = @"Please choose pregnacy status";
    }
    else if (_injuryDescription == nil) {
        message = @"Please describe your condition";
    }
    
    
    
    
    if (message != nil) {
         [UIView addMJNotifierWithText:message dismissAutomatically:YES];
    }
    else
    {
        [self showSignature];
    }
}

-(void)showSignature
{
    SignatureVC *aVCObject = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"@Signature"];
    
    UIView *myUIViewControllerView = aVCObject.view;
    [myUIViewControllerView.layer setCornerRadius:30.0f];
 
    
    
    if ([ParseDataFormatter sharedInstance].isIphone6) {
           myUIViewControllerView.frame = CGRectMake(0, 0, 550.0, 300.0);
          signtureView =[[TESignatureView alloc]initWithFrame:CGRectMake(12, 65, 525, 178)];
    }
    else{
           myUIViewControllerView.frame = CGRectMake(0, 0, 500.0, 300.0);
          signtureView =[[TESignatureView alloc]initWithFrame:CGRectMake(12, 65, 525, 150)];
    }
  
    signtureView.backgroundColor = [UIColor whiteColor];
    //[myUIViewControllerView addSubview:signtureView];
    
//    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelButton setFrame:CGRectMake(25, 251, 75, 35)];
//    [cancelButton setTitleColor:CANCEL_RED forState:UIControlStateNormal];
//    //[cancelButton setTitleColor:[[cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    cancelButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [myUIViewControllerView addSubview:cancelButton];
//    
//    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [doneButton setFrame:CGRectMake(450, 251, 75, 35)];
//      if (![ParseDataFormatter sharedInstance].isIphone6) {
//        [doneButton setFrame:CGRectMake(425, 251, 75, 35)];
//      }
//    [doneButton setTitleColor:EASY_BLUE forState:UIControlStateNormal];
//    //[doneButton setTitleColor:[[doneButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    doneButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
//    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [myUIViewControllerView addSubview:doneButton];
    
    myUIViewControllerView.transform = CGAffineTransformMakeRotation(M_PI_2);
    // Show in popup
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupVerticalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupHorizontalLayoutCenter);
    
    popup = [KLCPopup popupWithContentView:myUIViewControllerView
                                  showType:KLCPopupShowTypeBounceInFromBottom
                               dismissType:KLCPopupDismissTypeBounceOutToBottom
                                  maskType:KLCPopupMaskTypeDimmed
                  dismissOnBackgroundTouch:YES
                     dismissOnContentTouch:NO];
    
    
    [popup showWithLayout:layout];
}
- (IBAction)sexSegmentSelected:(id)sender {
    sexSelected = YES;
}

- (IBAction)pregnacySegmentSelected:(id)sender {
    pregnacySelected = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTextField) {
        [textField resignFirstResponder];
        [_lastTextField becomeFirstResponder];
    } else if (textField == _lastTextField) {
        [textField resignFirstResponder];
        [_phoneTextField becomeFirstResponder];
    } else if (textField == _phoneTextField) {
        [textField resignFirstResponder];
        [_emailTextField becomeFirstResponder];
    } else if (textField == _emailTextField) {
        [textField resignFirstResponder];
        [_addressTextField becomeFirstResponder];
    } else if (textField == _addressTextField) {
        [textField resignFirstResponder];
        [_cityTextField becomeFirstResponder];
    } else if (textField == _cityTextField) {
        [textField resignFirstResponder];
        //call state button
    } else if (textField == _zipTextField) {
        [textField resignFirstResponder];
        [_ssnTextField becomeFirstResponder];
    }
    
    return YES;
}
@end
