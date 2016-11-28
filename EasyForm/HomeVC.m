//
//  HomeVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 5/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "HomeVC.h"
#import "SelectProviderTVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString* locationString;
    NSArray *fieldArray;
    UIImageView *imageView;
    NSString *title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     fieldArray = @[@"Doctor", @"Dentist", @"Lawyer", @"Real Estate", @"Small Business"];
    
//    UIImage* image3 = [UIImage imageNamed:@"right-arrow"];
//    CGRect frameimg = CGRectMake(0, 0, 30 , 30);
//    _goButton = [[UIButton alloc] initWithFrame:frameimg];
//    [_goButton setBackgroundImage:image3 forState:UIControlStateNormal];
//    [_goButton addTarget:self action:@selector(filterResults)
//            forControlEvents:UIControlEventTouchUpInside];
//    [_goButton setShowsTouchWhenHighlighted:YES];
//    _goButton.tag =4;
//    
//    UIBarButtonItem *gbutton =[[UIBarButtonItem alloc] initWithCustomView:_goButton];
//    self.navigationItem.rightBarButtonItem=gbutton;
    
    

   // _selectFieldButton.enabled = NO;
 
    
    //self.title = @"Easy Form";
    
    
    UIImage *bckgrndimage = [UIImage imageNamed:@"bkgrond"];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.buttonImageView.bounds;
    
    // add the effect view to the image view

   // self.buttonImageView = [[UIImageView alloc] initWithImage:
                              //       bckgrndimage];
    [self.buttonImageView addSubview:effectView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopAnimate
{
    [_mapView.layer removeAllAnimations];
   _locationLabel.text = locationString;
     _selectFieldButton.enabled = YES;
    
//    _selectFieldButton.layer.borderColor = [UIColor colorWithRed:39.0/255.0 green:153.0/255.0 blue:218.0/255.0 alpha:1.000].CGColor;
//    [_selectFieldButton setTitleColor:[UIColor colorWithRed:39.0/255.0 green:153.0/255.0 blue:218.0/255.0 alpha:1.000] forState:UIControlStateNormal];
    
    _workerImage.image = [UIImage imageNamed:@"engineerblue"];
    _workerImage.alpha = 1.0;
}

-(void)viewWillAppear:(BOOL)animated
{
   [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationItem setHidesBackButton:YES];

    
    //Set the logo image on the nav bar
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"easyblue"]];
    CGSize imageSize = CGSizeMake(100, 35);
    CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
    
    imageView.frame = CGRectMake(marginX, 5, imageSize.width, imageSize.height);
    [self.navigationController.navigationBar addSubview:imageView];
    
    _locationLabel.text = @"Searching...";
    
    
    _workerImage.image = [UIImage imageNamed:@"engineer"];
    _workerImage.alpha = 0.35;
    
    _selectFieldButton.layer.cornerRadius = 20;
    _selectFieldButton.layer.masksToBounds = YES;
    _selectFieldButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _selectFieldButton.layer.borderWidth = 1.5;
    [_selectFieldButton addTarget:self action:@selector(fieldButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _selectFieldButton.enabled = NO;
//       [_selectFieldButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    // Show our location
    // Get Coords
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    _mapView.layer.cornerRadius = 150;
    _mapView.layer.masksToBounds = YES;
    
    _imageView.layer.cornerRadius = 60;
    _imageView.layer.masksToBounds = YES;
    
    [self animateMapView];
    
    [self getCurrentLocation];
    // [self.locManager startUpdatingLocation];
    [self requestAlwaysAuthorization];
    
    [NSTimer scheduledTimerWithTimeInterval:4.0f
                                     target:self
                                   selector:@selector(stopAnimate)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
     [imageView removeFromSuperview];
    [locationManager stopUpdatingLocation];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}


-(void)animateMapView
{
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.6;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.3];
    [_mapView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.6;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.1];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.9];
    
    [_mapView.layer addAnimation:scaleAnimation forKey:@"scale"];
}




-(void) getCurrentLocation{
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        // longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        // latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            locationString = [NSString stringWithFormat:@"%@, %@",placemark.locality,placemark.administrativeArea];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
//        NSString *title;
//        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
//        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Settings", nil];
//
//        [alertView show];
    }
//    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Get Coords
    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
    
    NSLog(@"Location %@", userLocation);
    
    //Zoom Region
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(coord, 15000.0, 15000.0);
    
    // [self.myMapView setCenterCoordinate:phoneLocation animated:YES];
    // Show our location
    [self.mapView setRegion:zoomRegion animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"selectProvider"]){
        SelectProviderTVC *controller = (SelectProviderTVC *)segue.destinationViewController;
        controller.providerType = title;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
