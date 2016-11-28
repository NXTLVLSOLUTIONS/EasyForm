//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"
#import "EasyFormVC.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "PaymentMethodTVC.h"
#import "MyCardsTVC.h"
#import "Constants.h"
#import "ParseDataFormatter.h"
//#import <DigitsKit/DigitsKit.h>
//#import "ConfigurationHelper.h"

@interface DEMOMenuViewController ()
{
    BOOL didSelectCell;
    UIButton *changePhotoButton;
    UILabel *nameLabel;
}

@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(getProfileImage) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(getSignatureImage) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4.2f target:self selector:@selector(getIdCardsImage) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(setName) userInfo:nil repeats:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserImage:) name: @"setProfileImage" object:nil];
   
    didSelectCell = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    
   // self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = EASY_BLUE;
    self.tableView.alpha = 0.9;
    
    //self.tableView.backgroundColor = [UIColor colorWithRed:0.0/255 green:122.0/255 blue:255.0/255 alpha:0.9];//[UIColor colorWithWhite:1.f alpha:0.9];
    
    
    //_leftViewController.tableView.backgroundColor = [UIColor clearColor];

    // -----
    
    _titlesArray = @[@" Search",
                     @"Payment",
                     @"Share",
                     @"Settings"];
    
    
    _imageArray =  @[@"Search",
                     @"Payments",
                     @"Share",
                     @"Settings"];
    
    // -----
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 0.f, 0.f);
    
    self.tableView.tableHeaderView = ({
        UIView *view;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 180.0f)];
         changePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(65, 15, 90, 90)];
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [changePhotoButton setImage: [UIImage imageNamed:@"AddPhotoIcon"] forState:UIControlStateNormal];
        changePhotoButton.layer.masksToBounds = YES;
        //            imageView.layer.cornerRadius = 35.0;
        //            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        //            imageView.layer.borderWidth = 3.0f;
        changePhotoButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        changePhotoButton.layer.shouldRasterize = YES;
        changePhotoButton.clipsToBounds = YES;
        [changePhotoButton addTarget:self action:@selector(viewProfilePressed) forControlEvents:UIControlEventTouchUpInside];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 122, 0, 24)];
        nameLabel.text = @"Name Goes Here";
        nameLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel sizeToFit];
        CGPoint labelCenter = CGPointMake(changePhotoButton.center.x,changePhotoButton.center.y+65);
        [nameLabel setCenter:labelCenter];
        
        UIButton *viewProfileButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 145, 0, 24)];
        [viewProfileButton setTitle:@"View Profile" forState:UIControlStateNormal];
        [viewProfileButton addTarget:self action:@selector(viewProfilePressed) forControlEvents:UIControlEventTouchUpInside];
        viewProfileButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        viewProfileButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        viewProfileButton.titleLabel.textColor = [UIColor whiteColor];
        [viewProfileButton sizeToFit];
        CGPoint buttonCenter = CGPointMake(changePhotoButton.center.x,changePhotoButton.center.y+90);
        [viewProfileButton setCenter:buttonCenter];
        //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:changePhotoButton];
        [view addSubview:nameLabel];
        [view addSubview:viewProfileButton];
        view;
    });
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 0, 24)];
    label.text = @"Enter Details";
    label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:label];
}


-(void)setUserImage: (NSNotification*) imageData
{
    if (imageData != NULL) {
        UIImage *image = [imageData object];
        [changePhotoButton setImage: image  forState:UIControlStateNormal];
        changePhotoButton.layer.cornerRadius = changePhotoButton.frame.size.height/2;;
        changePhotoButton.layer.masksToBounds = YES;
        changePhotoButton.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
        changePhotoButton.layer.borderWidth = 3.0;
    }
}

-(void)setName{
    PFUser *user = [PFUser currentUser];
    
    if (user[@"firstName"]) {
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]] ;
    }
    else{
        nameLabel.text = @"Enter Name";
    }
 
}


-(void)getProfileImage{
    [[ParseDataFormatter sharedInstance] getProfileImage];
}

-(void)getSignatureImage{
    [[ParseDataFormatter sharedInstance] getSignatureImage];
}

-(void)getIdCardsImage{
    [[ParseDataFormatter sharedInstance] getIdCards];
}



#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
  //  cell.separatorView.hidden = YES; //!(indexPath.row != 0 && indexPath.row != 1 && indexPath.row != _titlesArray.count-1);
    //cell.userInteractionEnabled = (indexPath.row != 1);
    
    if (indexPath.row == 0 ) {
         cell.imageView.image = [self imageWithImage:[UIImage imageNamed:_imageArray[indexPath.row]] scaledToSize:CGSizeMake(25.0, 25.0)];
    }
    else if (indexPath.row == 2)
    {
          cell.imageView.image = [self imageWithImage:[UIImage imageNamed:_imageArray[indexPath.row]] scaledToSize:CGSizeMake(27.0, 30.0)];
    }
    else{
         cell.imageView.image = [self imageWithImage:[UIImage imageNamed:_imageArray[indexPath.row]] scaledToSize:CGSizeMake(30.0, 30.0)];
    }

    
    cell.tintColor = EASY_BLUE;
    cell.backgroundColor = EASY_BLUE;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 70;
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == 1) return 22.f;
    //    else
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    didSelectCell = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.frostedViewController hideMenuViewController];
    
    switch (indexPath.row) {
            
        case 0:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchBar" object:nil];
        }
            break;
            
        case 1:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showPayments" object:nil];
        }
            break;
        case 2:
        {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"showShareMessage" object:nil];
        }
            break;
        case 3:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showSettings" object:nil];
        }
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 165.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sampleView = [[UIView alloc] init];
    sampleView.frame = CGRectMake(tableView.frame.size.width/2, 5, 60, 4);
    sampleView.backgroundColor = [UIColor clearColor];
    
//    UIButton *viewProfileButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, 110, 280, 50)];
//    [viewProfileButton setTitle:@"Sign up for EasyForm" forState:UIControlStateNormal];
//    [viewProfileButton addTarget:self action:@selector(signUpPressed) forControlEvents:UIControlEventTouchUpInside];
//    viewProfileButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
//    //viewProfileButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    viewProfileButton.titleLabel.textColor = [UIColor whiteColor];
    
//    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    imageView2.center = CGPointMake(45, viewProfileButton.frame.size.height / 2);
//    imageView2.image = [UIImage imageNamed:@"SignUP"];
//    [viewProfileButton addSubview:imageView2];
//    [sampleView addSubview:viewProfileButton];
//    
    return sampleView;
}

-(void)viewProfilePressed
{
      [self.frostedViewController hideMenuViewController];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"showNewProfile" object:nil];
}

-(void)signUpPressed
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.easyform.us/#package"]];
}

-(void)viewWillAppear:(BOOL)animated
{
        didSelectCell = NO;
      [[NSNotificationCenter defaultCenter] postNotificationName:@"hideButton" object:nil];
    //   [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (!didSelectCell) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"showButton" object:nil];
    }
     //  [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)imessageButtonPressed{
    
    MFMessageComposeViewController* messageComposer = [MFMessageComposeViewController new];
    messageComposer.messageComposeDelegate = self;
    [messageComposer setBody:@"Try out EasyForm! The fastest way to fill out forms for any business! Bit.ly/EasyForm"];
    [self presentViewController:messageComposer animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
