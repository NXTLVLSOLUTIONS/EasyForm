//
//  individualProfileVC.h
//  EasyForm
//
//  Created by Clean on 7/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
@interface individualProfileVC : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    UIImage *image;
}
@property (nonatomic,retain) UIImage *image;
@property (strong, nonatomic) IBOutlet MKMapView *individualMapView;
@property (strong, nonatomic) IBOutlet UILabel *individualName;
@property (strong, nonatomic) IBOutlet UILabel *individualJob;
@property (strong, nonatomic) IBOutlet UILabel *individualRegion;
@property (strong, nonatomic) IBOutlet UIImageView *individualBackground;
@property (strong, nonatomic) IBOutlet UIImageView *individualProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnMedical;
@property (strong, nonatomic) IBOutlet UIButton *btnPatient;
@property (strong, nonatomic) IBOutlet UIButton *btnXRay;
@property (weak, nonatomic) IBOutlet UIButton *viewWebsiteButton;
@property (weak, nonatomic) IBOutlet UIButton *sendPaymentButton;
@property (weak, nonatomic) IBOutlet UIButton *takeUberButton;
@property (weak, nonatomic) IBOutlet UIButton *fillOutFormsButton;
@property (strong, nonatomic) PFObject *parseObject;
- (IBAction)websiteButtonPressed:(id)sender;
- (IBAction)apptButtonPressed:(id)sender;
- (IBAction)phoneButtonPressed:(id)sender;
- (IBAction)paymentPressed:(id)sender;


@end
