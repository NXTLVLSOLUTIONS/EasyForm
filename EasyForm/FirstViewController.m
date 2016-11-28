//
//  FirstViewController.m
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 6/7/15.
//  Copyright (c) 2015 Fuzz Productions, LLC. All rights reserved.
//

#import "FirstViewController.h"
#import "FZAccordionTableView.h"
#import "AccordionHeaderView.h"
#import "PersonalInformationCell.h"
#import "ParseDataFormatter.h"
#import "MXParallaxHeader.h"
#import "DTParallaxTableView.h"
#import "DTParallaxHeaderView.h"

static NSString *const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface FirstViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
       UIButton *changePhotoButton;
       UIButton *updatePhoneButton;
      UIButton *emergencyContactButton;
}

@property (weak, nonatomic) IBOutlet FZAccordionTableView *tableView;

@end

@implementation FirstViewController

#pragma mark - Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.allowMultipleSectionsOpen = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccordionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kAccordionHeaderViewReuseIdentifier];
    
//    UIViewController *aVCObject = [[UIStoryboard storyboardWithName:@"MenuViews" bundle:nil] instantiateViewControllerWithIdentifier:@"@tabbar"];
//    UIView *myUIViewControllerView = aVCObject.view;
//    
//    DTParallaxHeaderView *headerView = [[DTParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withImage:[ParseDataFormatter sharedInstance].userProfileImage withTabBar:myUIViewControllerView];
//    
//    //    DTHeaderView *headerView = [[DTHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withImageUrl:@"http://s3.favim.com/orig/47/colorful-fun-girl-night-ocean-Favim.com-437603.jpg" withTabBar:tabbar];
//    
//  //  [_tableView setDTHeaderView:headerView];
//   // _tableView.showShadow = NO;
//    
//    [_tableView reloadData];
    
    
//    self.tableView.tableHeaderView = ({
//        UIView *view;
//        
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 120.0f)];
//
//        changePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 80, 80)];
//        //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        if ( [ParseDataFormatter sharedInstance].userProfileImage) {
//            [changePhotoButton setImage: [ParseDataFormatter sharedInstance].userProfileImage forState:UIControlStateNormal];
//        }
//        else{
//            [changePhotoButton setImage: [UIImage imageNamed:@"AddPhotoIcon"] forState:UIControlStateNormal];
//        }
//    
//        changePhotoButton.layer.masksToBounds = YES;
//        changePhotoButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        changePhotoButton.layer.shouldRasterize = YES;
//        changePhotoButton.clipsToBounds = YES;
//        changePhotoButton.layer.cornerRadius = changePhotoButton.frame.size.height/2;
//        [changePhotoButton addTarget:self action:@selector(addPhotoPressed) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
//        nameLabel.text = @"Edit Photo";
//        nameLabel.font = [UIFont systemFontOfSize:12];
//        nameLabel.backgroundColor = [UIColor clearColor];
//        nameLabel.textColor = [UIColor darkGrayColor];
//        nameLabel.textAlignment = NSTextAlignmentCenter;
//        [nameLabel sizeToFit];
//        CGPoint labelCenter = CGPointMake(changePhotoButton.center.x,changePhotoButton.center.y+50);
//        [nameLabel setCenter:labelCenter];
//        
//        updatePhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 15, 0, 80)];
//        [updatePhoneButton setTitle:@"Update Phone Number" forState:UIControlStateNormal];
//        [updatePhoneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [updatePhoneButton addTarget:self action:@selector(updatePhonePressed) forControlEvents:UIControlEventTouchUpInside];
//        updatePhoneButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        updatePhoneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        updatePhoneButton.titleLabel.textColor = [UIColor blueColor];
//        [updatePhoneButton sizeToFit];
//        
//        UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        imageView2.center = CGPointMake(-30, updatePhoneButton.frame.size.height / 2);
//        imageView2.image = [UIImage imageNamed:@"phone-receiver"];
//        [updatePhoneButton addSubview:imageView2];
//        
//        
//        emergencyContactButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 70, 0, 80)];
//        [emergencyContactButton setTitle:@"Emergency Contact" forState:UIControlStateNormal];
//        [emergencyContactButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [emergencyContactButton addTarget:self action:@selector(emergencyPressed) forControlEvents:UIControlEventTouchUpInside];
//        emergencyContactButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        emergencyContactButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        emergencyContactButton.titleLabel.textColor = [UIColor blueColor];
//        [emergencyContactButton sizeToFit];
//        
//        UIImageView * imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        imageView3.center = CGPointMake(-30, emergencyContactButton.frame.size.height / 2);
//        imageView3.image = [UIImage imageNamed:@"first-aid-kit"];
//        [emergencyContactButton addSubview:imageView3];
//        
//        
//        UIView *topSeparatorView = [[UIView alloc] initWithFrame:
//                                    CGRectMake(115, 60, 255, 0.7)];
//        topSeparatorView.backgroundColor = [UIColor lightGrayColor];
//  
//        
//        [view addSubview:changePhotoButton];
//        [view addSubview:nameLabel];
//        [view addSubview:updatePhoneButton];
//        [view addSubview:emergencyContactButton];
//        [view addSubview:topSeparatorView];
//
//        view;
//    });
//    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserImage:) name: @"setProfileImage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTableViewUp) name: @"scrollUp" object:nil];
    
//    
//    UIImageView *headerView = [UIImageView new];
//    headerView.image = [ParseDataFormatter sharedInstance].userProfileImage;
//    headerView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    // create effect
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    // add effect to an effect view
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
//    effectView.frame = self.view.frame;
//    
//    // add the effect view to the image view
//    [headerView addSubview:effectView];
//    
//    changePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2, 15, 100, 100)];
//    //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    if ( [ParseDataFormatter sharedInstance].userProfileImage) {
//        [changePhotoButton setImage: [ParseDataFormatter sharedInstance].userProfileImage forState:UIControlStateNormal];
//    }
//    else{
//        [changePhotoButton setImage: [UIImage imageNamed:@"AddPhotoIcon"] forState:UIControlStateNormal];
//    }
//    
//    changePhotoButton.layer.masksToBounds = YES;
//    changePhotoButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    changePhotoButton.layer.shouldRasterize = YES;
//    changePhotoButton.clipsToBounds = YES;
//    changePhotoButton.layer.cornerRadius = changePhotoButton.frame.size.height/2;
//    [changePhotoButton addTarget:self action:@selector(addPhotoPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:changePhotoButton];
//    
//    self.tableView.parallaxHeader.view = headerView;
//    self.tableView.parallaxHeader.height = 250;
//    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
//    self.tableView.parallaxHeader.minimumHeight = 0;
//    
//    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
//     self.edgesForExtendedLayout=UIRectEdgeNone;
    
   //  [[NSBundle mainBundle] loadNibNamed:@"ViewController" owner:self options:nil];
   //    [self addSubview:self.toplevelSubView];
//    
//    [self.view addSubview:[[[UINib nibWithNibName:@"ViewController" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0]];
    
    /* Init table header view by using image or image from url*/
    DTParallaxHeaderView *headerView = [[DTParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) withImage:[ParseDataFormatter sharedInstance].userProfileImage withTabBar:tabbar];
    
    //    DTHeaderView *headerView = [[DTHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withImageUrl:@"http://s3.favim.com/orig/47/colorful-fun-girl-night-ocean-Favim.com-437603.jpg" withTabBar:tabbar];
    
    
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2-110, 110, 40, 40)];
    [phoneButton setImage:  [UIImage imageNamed:@"EditPhone"] forState:UIControlStateNormal];
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2+110, 110, 40, 40)];
    [contactButton setImage:  [UIImage imageNamed:@"EmergencyContacts"] forState:UIControlStateNormal];
    
    
    UIImageView *eView = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2+40, 85, 30, 30)];
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
    
    changePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2-40, 80, 120, 120)];
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
    
    
    UILabel *locationLabel =   [[UILabel alloc] initWithFrame:CGRectMake(changePhotoButton.center.x-200, 200, 200, 50)];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"MapPoint.png"];
    CGFloat offsetY = -5.0;
    attachment.bounds = CGRectMake(-10, offsetY, attachment.image.size.width, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@""];
    [myString appendAttributedString:attachmentString];
    NSMutableAttributedString *myString1= [[NSMutableAttributedString alloc] initWithString:@"Fort Lauderdale, FL"];
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
    
    [_tableView setDTHeaderView:headerView];
    _tableView.showShadow = NO;
    
    
    
    [_tableView reloadData];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y == 1)
//        _tableView.scrollEnabled = NO;
//        NSLog(@"At the top");
//}


-(void)updatePhonePressed{
    
}

-(void)emergencyPressed{
    
}


#pragma mark - Class Overrides -
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

#pragma mark - <UITableViewDataSource> / <UITableViewDelegate> -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        return 255.0;
    }else{
        return 44.0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kDefaultAccordionHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView heightForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString* CellIdentifier = @"PersonalCell";
        PersonalInformationCell* postingCell = (PersonalInformationCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        
        // Configure the cell...
        if (postingCell == nil) {
            postingCell = [[PersonalInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
         return postingCell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"No Information on file";
        return cell;
    }
   


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    AccordionHeaderView * customHeaderCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kAccordionHeaderViewReuseIdentifier];
    
    switch (section) {
        case 0:
            customHeaderCell.title.text = @"Personal Information";
            customHeaderCell.image.image = [UIImage imageNamed:@"personal"];
            break;
        case 1:
            customHeaderCell.title.text = @"Medical Information";
            customHeaderCell.image.image = [UIImage imageNamed:@"injury"];
            break;
        case 2:
            customHeaderCell.title.text = @"Current Medications";
            customHeaderCell.image.image = [UIImage imageNamed:@"pill"];
            break;
        case 3:
            customHeaderCell.title.text = @"X-Rays On FIle";
            customHeaderCell.image.image = [UIImage imageNamed:@"xray"];
            break;
            
        default:
            break;
    }
    
    // customHeaderCell.layer.cornerRadius = 10;
   // customHeaderCell.layer.masksToBounds = YES;

    return customHeaderCell;
    
   // return [tableView dequeueReusableHeaderFooterViewWithIdentifier:kAccordionHeaderViewReuseIdentifier];
}


#pragma mark - <FZAccordionTableViewDelegate> -

- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {

}

- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {

}

- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {

}

- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    
}

- (void)viewDidAppear:(BOOL)animated
{
  //  [self.tableView setFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect footerFrame = CGRectMake(0.0, self.tableView.bounds.size.height - 12, self.tableView.bounds.size.width, 30);
    UIView *footerView = [[UIView alloc] initWithFrame:footerFrame];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
   
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


-(void)scrollTableViewUp{
    [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top+120) animated:YES];
    //[self.tableView setContentOffset:CGPointZero animated:YES];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
//                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



@end
