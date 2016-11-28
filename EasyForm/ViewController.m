//
//  ViewController.m
//
//  Created by ToanDK on 4/24/15.
//  Copyright (c) 2015 ToanDK. All rights reserved.
//

#import "ViewController.h"
#import "ParseDataFormatter.h"
#import "ODSAccordionView.h"
#import "ODSAccordionSectionStyle.h"
#import "PatientInfoView.h"
#import "HMSegmentedControl.h"
#import "Constants.h"
#import "SignatureVC.h"
#import "TESignatureView.h"
#import "KLCPopup.h"

#define EASY_BLUE [UIColor colorWithRed:0.0/255 green:122.0/255 blue:255.0/255 alpha:1]
#define CANCEL_RED [UIColor colorWithRed:226.0/255 green:40.0/255 blue:55.0/255 alpha:1]

@interface ViewController ()
{
    UIButton *changePhotoButton;
    ODSAccordionView *_accordionView;
    BOOL didSelectSignature;
    TESignatureView *signtureView;
    KLCPopup* popup;
    UIImage* userSignatureImage;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    didSelectSignature = NO;
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name: @"setSignatureImage" object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
     CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Profile Info", @"Signature"]];
    [segmentedControl3 setFrame:CGRectMake(0, 180, viewWidth, 50)];
    [segmentedControl3 setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld (via block)", (long)index);
        if (index == 1) {
             didSelectSignature = YES;
        }
        else{
             didSelectSignature = NO;
        }
        
      //  NSIndexPath *row1 = 1;
      //  [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:row1] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView reloadData];
    }];
    segmentedControl3.selectionIndicatorHeight = 4.0f;
    segmentedControl3.backgroundColor = EASY_BLUE;
    segmentedControl3.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl3.selectionIndicatorColor = [UIColor whiteColor];
    segmentedControl3.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl3.selectedSegmentIndex = 0;
    segmentedControl3.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    segmentedControl3.shouldAnimateUserSelection = NO;
    segmentedControl3.tag = 2;
    
    UIImageView *eView2 = [[UIImageView alloc] initWithFrame:CGRectMake(215, 17, 15, 20)];
    eView2.image = [UIImage imageNamed:@"EasyE"];
    [segmentedControl3 addSubview:eView2];
    
    [self.view addSubview:segmentedControl3];
    
    /* Init table header view by using image or image from url*/
    DTParallaxHeaderView *headerView = [[DTParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 340) withImage:[ParseDataFormatter sharedInstance].userProfileImage withTabBar:segmentedControl3];
    
    //    DTHeaderView *headerView = [[DTHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withImageUrl:@"http://s3.favim.com/orig/47/colorful-fun-girl-night-ocean-Favim.com-437603.jpg" withTabBar:tabbar];
    
    
     UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2-110, 130, 40, 40)];
     [phoneButton setImage:  [UIImage imageNamed:@"EditPhone"] forState:UIControlStateNormal];
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2+110, 130, 40, 40)];
    [contactButton setImage:  [UIImage imageNamed:@"EmergencyContacts"] forState:UIControlStateNormal];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2-150, 25, 30, 25)];
    [backButton setImage:  [UIImage imageNamed:@"left-arrow-chevron"] forState:UIControlStateNormal];
      [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2+135, 25, 60, 30)];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 2;
    saveButton.layer.borderWidth = 1.0;
    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    saveButton.layer.masksToBounds = YES;
    
    UIImageView *eView = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2+40, 105, 30, 30)];
    eView.image = [UIImage imageNamed:@"E Bubbole.png"];
    

//    
//  
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//    attachment.image = [UIImage imageNamed:@"MapPoint.png"];
//    
//    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
//    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@"My label text"];
//    [myString appendAttributedString:attachmentString];
//    locationLabel.attributedText = myString;
    
    changePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2-40, 100, 120, 120)];
    //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    if ( [ParseDataFormatter sharedInstance].userProfileImage) {
        [changePhotoButton setImage: [ParseDataFormatter sharedInstance].userProfileImage  forState:UIControlStateNormal];
    }
    else{
        [changePhotoButton setImage: [UIImage imageNamed:@"AddPhotoIcon"] forState:UIControlStateNormal];
    }
    
    changePhotoButton.layer.masksToBounds = YES;
    changePhotoButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    changePhotoButton.layer.shouldRasterize = YES;
    changePhotoButton.clipsToBounds = YES;
    changePhotoButton.layer.cornerRadius = changePhotoButton.frame.size.height/2;
    [changePhotoButton addTarget:self action:@selector(addPhotoPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *locationLabel =   [[UILabel alloc] initWithFrame:CGRectMake(changePhotoButton.center.x-160, 230, 200, 50)];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"MapPoint.png"];
    CGFloat offsetY = -5.0;
    attachment.bounds = CGRectMake(-10, offsetY, attachment.image.size.width, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@""];
    [myString appendAttributedString:attachmentString];
    NSMutableAttributedString *myString1= [[NSMutableAttributedString alloc] initWithString:@"Miami, FL"];
    [myString appendAttributedString:myString1];
    locationLabel.textAlignment=NSTextAlignmentRight;
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.attributedText=myString;
    //[locationLabel sizeToFit];
    
    [headerView addSubview:changePhotoButton];
    [headerView addSubview:phoneButton];
    [headerView addSubview:contactButton];
    [headerView addSubview:eView];
    [headerView addSubview:locationLabel];
    [self.view addSubview:saveButton];
    [self.view addSubview:backButton];
    
    [_tableView setDTHeaderView:headerView];
    _tableView.showShadow = NO;
    

    [_tableView reloadData];
    
    
    PFUser *user = [PFUser currentUser];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]] ;
    
    //[self loadAccordionView];
}


-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadTableView
{
    [_tableView reloadData];
}


//-(void) loadAccordionView{
//    CGFloat fullSpectrum = 255.0;
//    UIColor *darkBlue = [UIColor colorWithRed:222/fullSpectrum green:235/fullSpectrum blue:247/fullSpectrum alpha:1];
//    UIColor *blue = [UIColor colorWithRed:158/fullSpectrum green:202/fullSpectrum blue:225/fullSpectrum alpha:1];
//    UIColor *lightBlue = [UIColor colorWithRed:49/fullSpectrum green:130/fullSpectrum blue:189/fullSpectrum alpha:1];
//    
//    ODSAccordionSectionStyle *style = [[ODSAccordionSectionStyle alloc] init];
//    style.arrowColor = lightBlue;
//    style.headerStyle = ODSAccordionHeaderStyleLabelLeft;
//    style.headerTitleLabelFont = [UIFont systemFontOfSize:15];
//    style.backgroundColor = blue;
//    style.headerBackgroundColor = darkBlue;
//    style.dividerColor = [UIColor lightGrayColor];
//    style.headerHeight = 40;
//    style.stickyHeaders = YES;
//   //// style.animationDuration = 0.2;
/////style.arrowHeight = 1;
//    
//    NSArray *sections = @[
//                          [[ODSAccordionSection alloc] initWithTitle:@"Text"
//                                                             andView: [self textView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Cat content"
//                                                             andView: [self imageView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Web content"
//                                                             andView: [self webView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Slow loading web content"
//                                                             andView: [self slowWebView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Your own content"
//                                                             andView: [self emptyView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Text"
//                                                             andView: [self textView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Cat content"
//                                                             andView: [self imageView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Web content"
//                                                             andView: [self webView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Slow loading web content"
//                                                             andView: [self slowWebView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Your own content"
//                                                             andView: [self emptyView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Text"
//                                                             andView: [self textView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Cat content"
//                                                             andView: [self imageView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Web content"
//                                                             andView: [self webView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Slow loading web content"
//                                                             andView: [self slowWebView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Your own content"
//                                                             andView: [self emptyView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Text"
//                                                             andView: [self textView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Cat content"
//                                                             andView: [self imageView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Web content"
//                                                             andView: [self webView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Slow loading web content"
//                                                             andView: [self slowWebView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Your own content"
//                                                             andView: [self emptyView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Text"
//                                                             andView: [self textView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Cat content"
//                                                             andView: [self imageView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Web content"
//                                                             andView: [self webView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Slow loading web content"
//                                                             andView: [self slowWebView]],
//                          [[ODSAccordionSection alloc] initWithTitle:@"Your own content"
//                                                             andView: [self emptyView]],
//                          
//                          ];
//    _accordionView = [[ODSAccordionView alloc] initWithSections:sections andSectionStyle:style];
//    _accordionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    self.view = _accordionView;
//    self.view.backgroundColor = lightBlue;
//
//}
//

-(UIView *)textView {
  /*  UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0, 0, 0, 100);
    textView.backgroundColor = [UIColor clearColor];
    textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris.\n\n Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.\n Donec et mollis dolor.";*/
    
    PatientInfoView *aVCObject = [[UIStoryboard storyboardWithName:@"MenuViews" bundle:nil] instantiateViewControllerWithIdentifier:@"@PatientInfo"];
    
    UIView *myUIViewControllerView = aVCObject.view;
//    [myUIViewControllerView.layer setCornerRadius:30.0f];
//    myUIViewControllerView.layer.masksToBounds = YES;
    myUIViewControllerView.frame = CGRectMake(0, 0, 375.0, 300.0);
    return myUIViewControllerView;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webContentHeight = webView.scrollView.contentSize.height;
    webView.bounds = CGRectMake(webView.bounds.origin.x, webView.bounds.origin.y, webView.bounds.size.width, webContentHeight);
}

-(UIView *)imageView {
    UIImage *image = [UIImage imageNamed:@"catcontent"];
    NSAssert(image != nil, @"image not found");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeBottom;
    return imageView;
}

-(UIView *)webView {
    return [self webViewForUrl:@"http://www.printhelloworld.de"];
}

-(UIView *)slowWebView {
    return [self webViewForUrl:@"http://httpbin.org/delay/5"];
}

-(UIWebView *)webViewForUrl:(NSString*)urlString {
    // Make sure the frame you init your embedded WebView with does not have a zero heigh/width,
    // otherwise it misbehaves and returns a sizeThatFits: of {0,0}
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    webView.userInteractionEnabled = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    webView.delegate = self;
    return webView;
}


-(UIView *)emptyView {
    UIView *yourContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 300)];
    yourContent.backgroundColor = [UIColor greenColor];
    return yourContent;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!didSelectSignature) {
        return 1;
    }
    else
    {
        return 2;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!didSelectSignature) {
         return 600;
    }
    else
    {
        if (indexPath.row == 0) {
            return 50;
        }
        else
        {
            return 240;
        }
   
    }
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  //  if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

  //  }
    
    
    if (!didSelectSignature) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        //        scroller.showsHorizontalScrollIndicator = NO;
        CGFloat fullSpectrum = 255.0;
        //        UIColor *darkBlue = [UIColor colorWithRed:222/fullSpectrum green:235/fullSpectrum blue:247/fullSpectrum alpha:1];
        //        UIColor *blue = [UIColor colorWithRed:158/fullSpectrum green:202/fullSpectrum blue:225/fullSpectrum alpha:1];
        //        UIColor *lightBlue = [UIColor colorWithRed:49/fullSpectrum green:130/fullSpectrum blue:189/fullSpectrum alpha:1];
        
        ODSAccordionSectionStyle *style = [[ODSAccordionSectionStyle alloc] init];
        style.arrowColor = [UIColor lightGrayColor];
        style.headerStyle = ODSAccordionHeaderStyleLabelLeft;
        style.headerTitleLabelFont = [UIFont fontWithName:@"OpenSans" size:16];
        style.backgroundColor = [UIColor whiteColor];
        style.headerBackgroundColor = [UIColor whiteColor];
        style.dividerColor = [UIColor lightGrayColor];
        style.headerHeight = 50;
        style.stickyHeaders = YES;
        //// style.animationDuration = 0.2;
        ///style.arrowHeight = 1;
        
        NSArray *sections = @[
                              [[ODSAccordionSection alloc] initWithTitle:@"Patient Information"
                                                                 andView: [self textView] andImage:[UIImage imageNamed:@"standing-up-man-0"]],
                              [[ODSAccordionSection alloc] initWithTitle:@"Medical Information"
                                                                 andView: [self webView] andImage:[UIImage imageNamed:@"health-insurance-symbol-of-a-man-with-broken-arm"]],
                              [[ODSAccordionSection alloc] initWithTitle:@"Current Medications"
                                                                 andView: [self webView] andImage:[UIImage imageNamed:@"pill-1"]],
                              [[ODSAccordionSection alloc] initWithTitle:@"X-Rays On File"
                                                                 andView: [self webView] andImage:[UIImage imageNamed:@"medical-doctor-standing-beside-x-ray"]],
                              
                              ];
        _accordionView = [[ODSAccordionView alloc] initWithSections:sections andSectionStyle:style];
        _accordionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _accordionView.frame = CGRectMake(0, 0, 375, 600);
        // scroller.contentSize = contentLabel.frame.size;
        [cell addSubview:_accordionView];
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       //  [cell setIndentationWidth:10];
       // cell.textLabel.text = [NSString stringWithFormat:@"cell %d", (int)indexPath.row];
        PFUser *user = [PFUser currentUser];
        if (indexPath.row ==0) {
            UIImageView *eView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 20, 20)];
            eView2.image = [UIImage imageNamed:@"information-symbol"];
            
             UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 17, 100, 20)];
            titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
            titleLabel.text = @"Initials";
            
       
            //nameLabel.text = [NSString stringWithFormat:@"%@ %@", , user[@"lastName"]] ;
            NSString *firstLetter = [user[@"firstName"] substringToIndex:1];
                      firstLetter = [firstLetter uppercaseString];
            
            NSString *secondLetter = [user[@"lastName"] substringToIndex:1];
            secondLetter = [secondLetter uppercaseString];
            
            UILabel *initialLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 12, 30, 30)];
            initialLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
            initialLabel.text = [NSString stringWithFormat:@"%@%@", firstLetter, secondLetter];
            initialLabel.textAlignment = NSTextAlignmentCenter;
            initialLabel.layer.borderWidth = 1.5;
            initialLabel.layer.cornerRadius = 3.0;
            
            [cell addSubview:eView2];
            [cell addSubview:titleLabel];
            [cell addSubview:initialLabel];
        }
        else{
            UIImageView *eView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 20, 20)];
            eView2.image = [UIImage imageNamed:@"pen-writing-a-line"];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 17, 200, 20)];
            titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
            titleLabel.text = @"Add Signature";
            
            if ([ParseDataFormatter sharedInstance].userSignatureImage == nil) {
                UILabel *initialLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 100, 280, 30)];
                initialLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:25];
                initialLabel.textColor = [UIColor lightGrayColor];
                initialLabel.text = @"Tap to Add Signature";
                initialLabel.textAlignment = NSTextAlignmentCenter;
                initialLabel.alpha = 0.6;
                [cell addSubview:initialLabel];
                
            }
            else
            {
                UIImageView *signatureView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 100, 240, 81.40)];
                signatureView.image = [ParseDataFormatter sharedInstance].userSignatureImage;
                [cell addSubview:signatureView];
            }
            
            [cell addSubview:eView2];
            [cell addSubview:titleLabel];
        }

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (didSelectSignature) {
        if (indexPath.row == 1) {
            [self showSignature];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // do something, like dismiss your view controller, picker, etc., etc.
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:NO];
}


-(void)addPhotoPressed
{
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
        [changePhotoButton setImage: image  forState:UIControlStateNormal];
        changePhotoButton.layer.cornerRadius = changePhotoButton.frame.size.height/2;;
        changePhotoButton.layer.masksToBounds = YES;
        //        changePhotoButton.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
        //        changePhotoButton.layer.borderWidth = 3.0;
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
    [myUIViewControllerView addSubview:signtureView];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(25, 251, 75, 35)];
    [cancelButton setTitleColor:CANCEL_RED forState:UIControlStateNormal];
    //[cancelButton setTitleColor:[[cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [myUIViewControllerView addSubview:cancelButton];
    
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(450, 251, 75, 35)];
    if (![ParseDataFormatter sharedInstance].isIphone6) {
        [doneButton setFrame:CGRectMake(425, 251, 75, 35)];
    }
    [doneButton setTitleColor:EASY_BLUE forState:UIControlStateNormal];
    //[doneButton setTitleColor:[[doneButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [myUIViewControllerView addSubview:doneButton];
    
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


#pragma mark- SignDelegate Method
-(void)successfullyCapturedSignature:(UIImage *)signatureImage{
    
    userSignatureImage = signatureImage;
}

-(void)captureSignatureCanceled:(BOOL)canceled{
    
}

-(void)cancelButtonPressed
{
    [popup dismiss:YES];
}

-(void)doneButtonPressed
{
    [popup dismiss:YES];
    userSignatureImage =  [self resizeImage:[signtureView getSignatureImage]];
    [[ParseDataFormatter sharedInstance] saveSignatureImage:userSignatureImage];
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


@end
