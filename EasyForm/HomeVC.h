//
//  HomeVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 5/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HomeVC : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *selectNameButton;
@property (strong, nonatomic) IBOutlet UIButton *selectFieldButton;
@property (strong, nonatomic) UIButton *goButton;
@property (strong, nonatomic) IBOutlet UITextField *selectionTextField;
@property (strong, nonatomic) IBOutlet UIImageView *workerImage;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *buttonImageView;
@property (strong, nonatomic) CLLocationManager *locManager;

@end
