//
//  EastFormVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 6/1/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TSClusterMapView.h"
#import "VKSideMenu.h"
#import "REFrostedViewController.h"
#import <MessageUI/MessageUI.h>

@interface EasyFormVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UISearchBarDelegate,UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, TSClusterMapViewDelegate,VKSideMenuDelegate, VKSideMenuDataSource>

@property (nonatomic, strong) VKSideMenu *menuLeft;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet TSClusterMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableviewConstraint;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchController *resultSearchController;


@property (strong, nonatomic) NSMutableArray *bathroomAnnotations;
@property (strong, nonatomic) NSMutableArray *bathroomAnnotationsAdded;
@property (strong, nonatomic) NSDate *startTime;
@end

