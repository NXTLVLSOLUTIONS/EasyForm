//
//  individualProfileVC.m
//  EasyForm
//
//  Created by Clean on 7/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "individualProfileVC.h"
#import "ParseDataFormatter.h"
#import "UIView+MJAlertView.h"
#import "KLCPopup.h"
#import "SelectFormVC.h"
#import "SelectFormCell.h"
#import "MXParallaxHeader.h"
#import "Constants.h"
#import "ViewPDFController.h"
#import "KVNProgress.h"

@interface individualProfileVC ()
{
    KLCPopup* popup;
    NSString* website;
    NSData* pdfData;
     NSString* email;

}

@property (strong, nonatomic) UITableView *tableViewNew;
@property (strong, nonatomic) NSArray *titlesArray;


@end

@implementation individualProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure the cell...
    
    //    postingCell.contentView.frame = postingCell.bounds;
    //    postingCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    _titlesArray = @[@"FORM 1",
                     @"FORM 2",
                     @"FORM 3"];

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0,-60) forBarMetrics:UIBarMetricsDefault];
    _individualProfile.layer.cornerRadius =  65;
    _individualProfile.layer.masksToBounds = YES;

    
    _individualName.text= [[NSUserDefaults standardUserDefaults] valueForKey:@"profile_name"];
    _individualRegion.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"profile_region"];
    _individualJob.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"profile_job"];
    _individualProfile.image=_image;

   
    
    
    if([_parseObject[@"type"] isEqualToString:@"Dentist"])
    {
        _individualBackground.image=[UIImage imageNamed:@"DentistBackground"];
      
    }
    if([_parseObject[@"type"] isEqualToString:@"Doctor"])
    {
        _individualBackground.image=[UIImage imageNamed:@"DRbackground"];
     
    }
    if([_parseObject[@"type"] isEqualToString:@"Lawyer"])
    {
        _individualBackground.image=[UIImage imageNamed:@"LawyerBackground"];
        
    }
    if([_parseObject[@"type"] isEqualToString:@"Real Estate"])
    {
        _individualBackground.image=[UIImage imageNamed:@"RealEstateBackground"];
            }
    if([_parseObject[@"type"] isEqualToString:@"Business"])
    {
        _individualBackground.image=[UIImage imageNamed:@"PersonalBackground"];
       
    }
    if([_parseObject[@"type"] isEqualToString:@"Chiropractor"])
    {
      _individualBackground.image=[UIImage imageNamed:@"ChiroBack"];
        
    }
    
    _individualMapView.delegate = self;
    
    _individualMapView.showsUserLocation=YES;
    
    
    
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView1.center = CGPointMake(35, _viewWebsiteButton.frame.size.height / 2);
    imageView1.image = [UIImage imageNamed:@"BookAppointment"];
    [_viewWebsiteButton addSubview:imageView1];
    
     UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    imageView2.center = CGPointMake(45, _sendPaymentButton.frame.size.height / 2);
    imageView2.image = [UIImage imageNamed:@"pay"];
    [_sendPaymentButton addSubview:imageView2];
    
    _takeUberButton.layer.cornerRadius = 20;
    _takeUberButton.layer.masksToBounds = NO;
    _takeUberButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _takeUberButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    _takeUberButton.layer.shadowOpacity = 0.5f;
    _takeUberButton.layer.shadowRadius = 4.0f;
     [_takeUberButton addTarget:self action:@selector(uberButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _fillOutFormsButton.layer.cornerRadius = 20;
    _fillOutFormsButton.layer.masksToBounds = NO;
    _fillOutFormsButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _fillOutFormsButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    _fillOutFormsButton.layer.shadowOpacity = 0.5f;
    _fillOutFormsButton.layer.shadowRadius = 4.0f;
    [_fillOutFormsButton addTarget:self action:@selector(formsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
    [self loadProviderProfile];
    [self displayLocationOnMap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(formsFetched) name: @"ProviderFormsFetched" object:nil];
    [[ParseDataFormatter sharedInstance] getProviderForms:_parseObject.objectId];
    
}

-(void)loadProviderProfile{
    website = _parseObject[@"website"];
}

-(void)formsFetched{
    [self.tableViewNew reloadData];
}


- (void)displayLocationOnMap
{
     PFGeoPoint * mapPoint = _parseObject[@"coordinates"];
    
    _individualMapView.delegate = self;
    _individualMapView.showsUserLocation = YES;
    _individualMapView.zoomEnabled = NO;
    _individualMapView.scrollEnabled = NO;
    _individualMapView.userInteractionEnabled = NO;
    
    CLLocationCoordinate2D deviceCoordinates = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude);
    //MannyCustomAnnotation *deviceAnnotation = [[MannyCustomAnnotation alloc]initWithTitle:_theEvent.parseEventObject[VENUENAME] Location:deviceCoordinates];
    
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(deviceCoordinates, 35000.0, 35000.0);
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = deviceCoordinates;
    point.title  = [NSString stringWithFormat:@"%@ %@", _parseObject[@"firstName"], _parseObject[@"lastName"]];
    // point.subtitle = [NSString stringWithFormat:@"%@ %@",_car[MAKE], _car[MODEL]];
    
    [_individualMapView addAnnotation:point];
    [_individualMapView selectAnnotation:point animated:YES];
    // [_locationMapView addAnnotation:deviceAnnotation];
    
    // Show our location
    [_individualMapView setRegion:zoomRegion animated:YES];
    
    // [self.locManager startUpdatingLocation];
    
    CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:mapPoint.latitude longitude:mapPoint.longitude];
    
 //   [self getAddressFromLocation:eventLocation complationBlock:^(NSString * address, NSString* cityState) {
//        if(address) {
//            _addressLabel.text  = address;
//            _cityStateLabel.text = cityState;
//        }
//    }];
    
}

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    // Get Coords
//    CLLocationCoordinate2D coord = _individualMapView.userLocation.location.coordinate;
//
//    NSLog(@"Location %@", userLocation);
//
//    //Zoom Region
//    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(coord, 15000.0, 15000.0);
//
//    // Show our location
//    [_individualMapView setRegion:zoomRegion animated:YES];
//}

-(void) setImage:(UIImage *)image
{
    _image=image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClickForms:(id)sender {
    
    if ([ParseDataFormatter sharedInstance].isIphone6) {
        //[self performSegueWithIdentifier:@"showForm" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"smallForm" sender:self];
    }
}
- (IBAction)MedicalBtnPressed:(id)sender {
   
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"incomplete.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
}
- (IBAction)NewBtnPressed:(id)sender {
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"incomplete.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }

}
- (IBAction)XRayBtn:(id)sender {
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"incomplete.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }

}

-(void) formsButtonPressed
{
    SelectFormVC *aVCObject = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"@SelectFormNew"];
    aVCObject.providerName.text = @"TEXTING";
    UIView *myUIViewControllerView = aVCObject.view;
    [myUIViewControllerView.layer setCornerRadius:10.0f];
    myUIViewControllerView.layer.masksToBounds = YES;
    
    CGFloat cellHeight;
    NSUInteger numberOfForms =   [ParseDataFormatter sharedInstance].providerFormsArray.count;
    switch (numberOfForms) {
        case 0:
            cellHeight = 150;
            break;
        case 1:
            cellHeight = 220;
            break;
        case 2:
            cellHeight = 300;
            break;
        case 3:
            cellHeight = 350;
            break;

        default:
            break;
    }
    myUIViewControllerView.frame = CGRectMake(0, 0, 320.0, cellHeight);
    
    UIImageView *providerImage =  [[UIImageView alloc]initWithFrame:CGRectMake(25,20, 80, 80)];
    providerImage.image = _individualProfile.image;
    providerImage.layer.cornerRadius = providerImage.frame.size.height/2;;
    providerImage.layer.masksToBounds = YES;

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 35, 158, 29)];
    nameLabel.text = [NSString stringWithFormat:@"%@'s",_individualName.text];
    nameLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
   // [nameLabel sizeToFit];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [myUIViewControllerView addSubview:nameLabel];
    [myUIViewControllerView addSubview:providerImage];
//    UIButton *button = [[UIButton alloc] init];
//    [button setImage:[UIImage imageNamed:@"CancelTopRight"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissButtonPressed)forControlEvents:UIControlEventTouchUpInside];
//    [button setFrame:CGRectMake(163, 9, 20, 20)];
//    [myUIViewControllerView addSubview:button];
    
    CGFloat x = 0;
    CGFloat y = 105;
    CGFloat width = myUIViewControllerView.frame.size.width;
    CGFloat height = myUIViewControllerView.frame.size.height -120;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    _tableViewNew = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    _tableViewNew.rowHeight = 50;
    _tableViewNew.sectionFooterHeight = 22;
    _tableViewNew.sectionHeaderHeight = 22;
    _tableViewNew.scrollEnabled = YES;
    _tableViewNew.showsVerticalScrollIndicator = YES;
    _tableViewNew.userInteractionEnabled = YES;
    _tableViewNew.bounces = YES;
    
    _tableViewNew.delegate = self;
    _tableViewNew.dataSource = self;
    
    _tableViewNew.tableFooterView = [[UIView alloc] init];
    _tableViewNew.backgroundColor = [UIColor whiteColor];
    _tableViewNew.backgroundView.backgroundColor = [UIColor whiteColor];
    
    [myUIViewControllerView addSubview:_tableViewNew];
    
  /*  UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissButtonPressed)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(270, 12, 20, 20)];
    [myUIViewControllerView addSubview:button];*/
    
//    UIButton* RequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [RequestButton setFrame:CGRectMake(0, 370, 330, 49)];
//    [RequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [RequestButton setTitleColor:[[RequestButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    RequestButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
//    [RequestButton setTitle:@"COMPLETE FORM" forState:UIControlStateNormal];
//    [RequestButton addTarget:self action:@selector(requestButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [myUIViewControllerView addSubview:RequestButton];
    
//    UIButton* RequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [RequestButton setFrame:CGRectMake(0, 200, 200, 49)];
//    [RequestButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
//    [RequestButton setTitleColor:[[RequestButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    RequestButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
//    [RequestButton setTitle:@"Request EasyForm" forState:UIControlStateNormal];
//    [RequestButton addTarget:self action:@selector(requestButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [myUIViewControllerView addSubview:RequestButton];
//    
//    
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


-(void)uberButtonPressed{
//    NSURL* uberURL = [NSURL URLWithString:@"uber://"];
//    NSURL* appStoreURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/uber/id368677368?mt=8"];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:uberURL])
//    {
//        [[UIApplication sharedApplication] openURL:uberURL];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] openURL:appStoreURL];
//    }
//    
    PFGeoPoint * mapPoint = _parseObject[@"coordinates"];
    
    // Open the Uber application
    
    [self openAppWithURLScheme:@"uber://"
                    parameters:[NSString stringWithFormat:@"?client_id=aO8gYPaT6ksLqzaJ2bF6Oe8g3VO550ly&action=setPickup&pickup=my_location&dropoff[latitude]=%fl&dropoff[longitude]=%fl", mapPoint.latitude, mapPoint.longitude]
                   appStoreURL:@"https://itunes.apple.com/us/app/uber/id368677368?mt=8"];
}


- (void)openAppWithURLScheme:(NSString *)urlScheme parameters:(NSString *)parameters appStoreURL:(NSString *)storeURL
{
    // Check if the Google Maps application is available
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[urlScheme stringByAppendingString:urlScheme]]])
    {
        // Create the URL to open the Google Maps app with coordinates already set
        NSString *url = [urlScheme stringByAppendingString:parameters];
        
        // Open the Google Maps application
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeURL]]; // Open the Google Maps App Store page
}

-(void) dismissButtonPressed
{
      [popup dismiss:YES];
}

-(void)requestButtonPressed
{
    [popup dismiss:YES];
    if ([ParseDataFormatter sharedInstance].isIphone6) {
        [self performSegueWithIdentifier:@"showNewPdf" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"smallForm" sender:self];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  [ParseDataFormatter sharedInstance].providerFormsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // return your normal height here:
    return 65.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor whiteColor];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.1]];
    [cell setSelectedBackgroundView:view];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 150;
//
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        if (tableView == self.tableViewNew) {
//            CGFloat cornerRadius = 5.f;
//            cell.backgroundColor = UIColor.clearColor;
//            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//            CGMutablePathRef pathRef = CGPathCreateMutable();
//            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
//            BOOL addLine = NO;
//            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//            } else if (indexPath.row == 0) {
//                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//                addLine = YES;
//            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//            } else {
//                CGPathAddRect(pathRef, nil, bounds);
//                addLine = YES;
//            }
//            layer.path = pathRef;
//            CFRelease(pathRef);
//            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
//            
//            if (addLine == YES) {
//                CALayer *lineLayer = [[CALayer alloc] init];
//                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
//                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//                [layer addSublayer:lineLayer];
//            }
//            UIView *testView = [[UIView alloc] initWithFrame:bounds];
//            [testView.layer insertSublayer:layer atIndex:0];
//            testView.backgroundColor = UIColor.clearColor;
//            cell.backgroundView = testView;
//        }
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"SelectFormCell";
    SelectFormCell* postingCell = (SelectFormCell*)[self.tableViewNew dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[SelectFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    
    PFObject *object =   [ParseDataFormatter sharedInstance].providerFormsArray[indexPath.section];

    [postingCell.layer setCornerRadius:7.0f];
    [postingCell.layer setMasksToBounds:YES];
     postingCell.backgroundColor = EASY_BLUE;

    UILabel *label =  [[UILabel alloc]initWithFrame:CGRectMake(15,20, 230, 25)];
    label.text = object[@"formName"];
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont fontWithName:@"OpenSans" size:13]];
     label.adjustsFontSizeToFitWidth = YES;
   // label.textAlignment = NSTextAlignmentCenter;
    [postingCell.contentView addSubview:label];
    
//    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(27,20, 18, 25)];
//    imv.image=[UIImage imageNamed:@"EasyE"];
//    [postingCell.contentView addSubview:imv];
    
//    UIImageView *check = [[UIImageView alloc]initWithFrame:CGRectMake(240,18, 25, 25)];
////    if (indexPath.section == 0) {
////          check.image=[UIImage imageNamed:@"checking"];
////    }
////    else{
//          check.image=[UIImage imageNamed:@"circle"];
//   // }
//  
//    [postingCell.contentView addSubview:check];
    
    return postingCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    PFObject *object = [[ParseDataFormatter sharedInstance].providerFormsArray objectAtIndex:indexPath.section];
    PFFile *imageFile = [object objectForKey:@"file"];
    
    [KVNProgress setConfiguration:[KVNProgressConfiguration defaultConfiguration]];
    [KVNProgress showWithStatus:@"Loading Form"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
         [KVNProgress dismiss];
        if (!error) {
            [popup dismiss:YES];
            pdfData = result;
            email = _parseObject[@"email"];
            if ([ParseDataFormatter sharedInstance].isIphone6) {
                [self performSegueWithIdentifier:@"showNewPdf" sender:self];
            }
            else{
                [self performSegueWithIdentifier:@"smallForm" sender:self];
            }
        }
    }];

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showNewPdf"])
    {
        ViewPDFController *vc=[segue destinationViewController];
        vc.pdfData = pdfData;
        vc.providerEmail = email;
    }
}

- (IBAction)websiteButtonPressed:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Book Appointments"
                                  message:@"Feature coming soon!"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)apptButtonPressed:(id)sender {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];  

}

- (IBAction)phoneButtonPressed:(id)sender {
    
    
    NSString *title = [NSString stringWithFormat:@"Call %@ %@", _parseObject[@"firstName"], _parseObject[@"lastName"]];
    NSString *message = [NSString stringWithFormat:@"%@", _parseObject[@"phone"]];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Call"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _parseObject[@"phone"]]]];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)paymentPressed:(id)sender {
    
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Make Payments"
                                      message:@"Feature coming soon!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok];
        
        
        [self presentViewController:alert animated:YES completion:nil];
}
@end
