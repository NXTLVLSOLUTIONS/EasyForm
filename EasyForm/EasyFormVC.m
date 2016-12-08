//
//  EastFormVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 6/1/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "EasyFormVC.h"
#import "FancyTabBar.h"
#import "UIView+Screenshot.h"
#import "UIImage+ImageEffects.h"
#import "ProviderCell.h"
#import "ParseDataFormatter.h"
#import <Parse/Parse.h>
#import "KLCPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "TouchPopUpVC.h"
#import "Constants.h"
#import "CoreText/CoreText.h"
#import "PDFRenderer.h"
#import "KVNProgress.h"
#import "NYSegmentedControl.h"
#import "DoctorAnnotation.h"
#import "TSDemoClusteredAnnotationView.h"
#import "individualProfileVC.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "PaymentMethodTVC.h"
#import "FirstViewController.h"
#import "ViewController.h"
#import "HMSegmentedControl.h"
#import "MVPlaceSearchTextField.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "MyCardsTVC.h"
#import "SettingsTVC.h"
#import "AWNavigationMenuItem.h"
#import "EasyDefaultCollectionViewCell.h"
#import "ProviderCollectionViewCell.h"
#import "ShareVC.h"
#import "NewProfileTVC.h"
#import "SearchResultsTVC.h"
#import <Crashlytics/Crashlytics.h>



const CGFloat segment_y = -310.0f;
const CGFloat overlay_y =  0.0f;

static NSString * const CDToiletJsonFile = @"CDToilets";
static NSString * const kBathroomAnnotationImage = @"BathroomAnnotation";
static NSString * const kLawyerAnnotationImage = @"LawyerAnnotation";
static NSString * const kBusinessAnnotationImage = @"BusinessAnnotation";
static NSString * const kDentistAnnotationImage = @"DentistAnnotation";
static NSString * const kRealEstateAnnotationImage = @"RealEstateAnnotation";
static NSString * const kChiroAnnotationImage = @"ChiroAnnotation";

@interface EasyFormVC ()<FancyTabBarDelegate,GMSAutocompleteTableDataSourceDelegate, GMSAutocompleteViewControllerDelegate, GMSAutocompleteResultsViewControllerDelegate,UITextFieldDelegate,AWNavigationMenuItemDataSource, AWNavigationMenuItemDelegate>

@property (nonatomic, strong) AWNavigationMenuItem *menuItem;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) UILabel *contentLabel;
//@property MVPlaceSearchTextField *txtPlaceSearch;
@property(nonatomic,strong) FancyTabBar *fancyTabBar;
@property (nonatomic,strong) UIImageView *backgroundView;
@property NYSegmentedControl *segmentedControl;
@property NYSegmentedControl *foursquareSegmentedControl;
@property(nonatomic,strong) UIImage *targetProfile;


@end

@implementation EasyFormVC
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString* locationString;
    NSArray *fieldArray;
    UIImageView *imageView;
    UIImageView *MrEasy;
    KLCPopup* popup;
    UIImageView *overlayView;
    BOOL isMapView;
    
    NSMutableArray *usersArray;
    UIView *searchTitleView;
    UISearchBar *userSearchBar;
    UIBarButtonItem *searchBarButton;
    NSMutableArray *searchArray;
    BOOL isSearchBarEnabled;
    BOOL isSearchEnabled;
    NSString *specificSearchString;
    BOOL isMapEnabled;
    BOOL isIphone6;
    BOOL cancelledFromDrag;
    BOOL isMenuEnabled;
    BOOL selectionMadeFromCollectionView;
    BOOL isSelectCategory;
    CGFloat bar_y;
    CGFloat layer_y;
    
    UITextField *_searchField;
    UITableViewController *_resultsController;
    GMSAutocompleteTableDataSource *_tableDataSource;
    UIVisualEffectView *effectView;
    UIImageView *searchIconView;
    
    NSArray *listItems;
    PFObject *selectedProvider;
    NSInteger selectedRowIndex;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

     _searchBar.delegate = self;
    
    isSelectCategory = YES;
    
    [[ParseDataFormatter sharedInstance] queryAllProviders];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoomInToLocation:) name:@"LocationUpdatedNotification" object:nil];
    
  //  UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
   //                                        initWithTarget:self
   //                                        action:@selector(hideKeyBoard)];
   //
  //  [self.view addGestureRecognizer:tapGesture];
    
    self.definesPresentationContext = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
     UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    self.resultSearchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    //self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    // self.resultSearchController.hidesNavigationBarDuringPresentation = NO;
    // self.resultSearchController.searchBar.scopeButtonTitles = @[@"One", @"Two"];
    //self.resultSearchController.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultSearchController.searchResultsUpdater = self;
    
    self.resultSearchController.searchBar.frame = CGRectMake(0, 0, viewWidth, 44);
    
    self.resultSearchController.searchBar.delegate = self;
    self.resultSearchController.searchBar.barTintColor = [UIColor whiteColor];
    self.resultSearchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.resultSearchController.searchBar.placeholder = @"Search for a business or person";
    
    [self.view addSubview:self.resultSearchController.searchBar];

    
    [[[UIApplication sharedApplication] keyWindow] setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    
    self.title = SELECTCATEGORY;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    listItems = @ [@"ListDoctor", @"ListRealEstate", @"ListLawyer", @"ListBusiness", @"ListDentist", @"ListChiro"];
    
    isMapView = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0); //
    
    bar_y = segment_y;
    layer_y = overlay_y;
    if ([ParseDataFormatter sharedInstance].isLaunchedFromPhoneCall == YES) {
        bar_y = bar_y+10;
        layer_y = layer_y+20;
    }
   
     ((AppDelegate *)[UIApplication sharedApplication].delegate).mainViewController.rightViewSwipeGestureEnabled = NO;
//    
//    ViewController *viewController = [ViewController new];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    
//    LGSideMenuController *sideMenuController = [[LGSideMenuController alloc] initWithRootViewController:navigationController];
//    
//    [sideMenuController setLeftViewEnabledWithWidth:250.f
//                                  presentationStyle:LGSideMenuPresentationStyleScaleFromBig
//                               alwaysVisibleOptions:0];
//    
//    TableViewController *leftViewController = [TableViewController new];
//    
//    [sideMenuController.leftView addSubview:leftViewController.tableView];
    
 /*   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    MainViewController *mainViewController = [storyboard instantiateInitialViewController];
    mainViewController.rootViewController = navigationController;
    

    [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:0];

    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];*/
    
//    UIImage* image3 = [UIImage imageNamed:@"search-icon"];
//    CGRect frameimg = CGRectMake(0, 0, 25 , 25);
//    UIButton* _goButton = [[UIButton alloc] initWithFrame:frameimg];
//    [_goButton setBackgroundImage:image3 forState:UIControlStateNormal];
//    [_goButton addTarget:self action:@selector(filterResults)
//        forControlEvents:UIControlEventTouchUpInside];
//    [_goButton setShowsTouchWhenHighlighted:YES];
//    _goButton.tag =1;
//    
//    UIBarButtonItem *gbutton =[[UIBarButtonItem alloc] initWithCustomView:_goButton];
//    self.navigationItem.rightBarButtonItem=gbutton;
    
    
//    // Control in navigation bar
//    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Light", @"Dark"]];
//    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
//    self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
//    self.segmentedControl.titleTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
//    self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
//    self.segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
//    self.segmentedControl.borderWidth = 1.0f;
//    self.segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
//    self.segmentedControl.drawsGradientBackground = YES;
//    self.segmentedControl.segmentIndicatorInset = 2.0f;
//    self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
//    self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
//    self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
//    self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
//    self.segmentedControl.selectedSegmentIndex = 0;
//    [self.segmentedControl sizeToFit];
//    self.navigationItem.titleView = self.segmentedControl;
    _mapView.hidden =YES;
    
    
    _foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Map    ", @"List    "]];
     [_foursquareSegmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    _foursquareSegmentedControl.titleTextColor = EASY_BLUE;
    _foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    _foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:13.0f];
    _foursquareSegmentedControl.segmentIndicatorBackgroundColor = EASY_BLUE;
    _foursquareSegmentedControl.backgroundColor = [UIColor whiteColor];
    _foursquareSegmentedControl.borderWidth = 2.0f;
    _foursquareSegmentedControl.borderColor = [UIColor whiteColor];
    _foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    _foursquareSegmentedControl.segmentIndicatorInset = 2.0f;
    _foursquareSegmentedControl.segmentIndicatorBorderColor = EASY_BLUE;
    _foursquareSegmentedControl.selectedSegmentIndex =1;
    //[foursquareSegmentedControl sizeToFit];
    _foursquareSegmentedControl.frame = CGRectMake(0, 0, 250, 30);
    _foursquareSegmentedControl.cornerRadius = CGRectGetHeight(_foursquareSegmentedControl.frame) / 2.0f;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    _foursquareSegmentedControl.usesSpringAnimations = YES;
#endif
    
   // self.navigationItem.titleView = _foursquareSegmentedControl;
    
    
      UIView *lightControlExampleView = [[UIView alloc] initWithFrame:self.view.bounds];
    _foursquareSegmentedControl.center = CGPointMake(lightControlExampleView.center.x, lightControlExampleView.center.y + bar_y);
  //  self.navigationItem.titleView = _foursquareSegmentedControl;
   // [self.view addSubview:_foursquareSegmentedControl];
    
    //OVerlay
//    overlayView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, layer_y, self.view.frame.size.width, self.view.frame.size.height)];
//    overlayView.image = [UIImage imageNamed:@"overlay"];
//    [[[UIApplication sharedApplication] delegate].window addSubview:overlayView];
    
    CGPoint buttonOrigin =  CGPointMake(self.view.frame.size.width/2-35, 395);
    isIphone6 = NO;
    
    [ParseDataFormatter sharedInstance].isIphone6 = NO;
    
    if (IS_IPHONE6PLUS || IS_IPHONE6) {
        buttonOrigin = CGPointMake(150, 552);
        isIphone6 = YES;
        [ParseDataFormatter sharedInstance].isIphone6 = YES;
    }
 //   _fancyTabBar = [[FancyTabBar alloc]initWithFrame:self.view.bounds];
    //    //Set Pop Items Direction
  //  _fancyTabBar.currentDirectionToPopOptions=FancyTabBarItemsPop_Up;
    //    //Custom Placement
//    [_fancyTabBar setUpChoices:self choices:@[@"smallbiz",@"lawyer",@"realestate",@"doctor", @"dentist"] withMainButtonImage:[UIImage imageNamed:@"ActionButton"] andMainButtonCustomOrigin:buttonOrigin];
//    _fancyTabBar.delegate = self;
//    [[[UIApplication sharedApplication] delegate].window addSubview:_fancyTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCenterButton) name:@"hideButton" object:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCenterButton) name:@"showButton" object:nil];

    ;
    
    
    if (!isIphone6) {
        
              CGFloat height = 0.0;//self.tableView.contentSize.height;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.tableviewConstraint.constant = height;
                [self.view setNeedsUpdateConstraints];
            }];
    }
    
//    
//    __weak __typeof(&*self)ws = self;
//    
//    self.anim = [MMTweenAnimation animation];
//    self.anim.functionType   = MMTweenFunctionBounce;
//    self.anim.easingType     = MMTweenEasingOut;
//    self.anim.duration       = 2.0f;
//    self.anim.fromValue      = @[@(self.fancyTabBar.center.y-200)];
//    self.anim.toValue        = @[@(self.fancyTabBar.center.y )];
//    self.anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation)
//    {
//        double value = [v[0] doubleValue];
//        ws.self.fancyTabBar.center = CGPointMake(ws.self.fancyTabBar.center.x, value);
//       // ws.ball.center = CGPointMake(50+(CGRectGetWidth([UIScreen mainScreen].bounds)-150)*(c/d), value);
//        
//       // [ws.paintView addDot:ws.ball.center];
//    };
//    
//     [self.fancyTabBar pop_addAnimation:self.anim forKey:@"center"];
// 
//    
//    
    
    //self.tableView.tableFooterView = [[UIView alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProviders) name:@"reloadProviders" object:nil];
 
    
    if (isIphone6) {
          MrEasy =[[UIImageView alloc] initWithFrame:CGRectMake(65,160,250,140)];
    }
    else
    {
          MrEasy =[[UIImageView alloc] initWithFrame:CGRectMake(20,90,218,218)];
    }
  
//    MrEasy.image=[UIImage imageNamed:@"EtextBlue"];
//    [self.view addSubview:MrEasy];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEasyFormCreatedAlert) name:@"EasyFormCreated" object:nil];
    
    
    UIButton *menuButton = [[UIButton alloc] init];
    [menuButton setImage:[UIImage imageNamed:@"threeline"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 25, 20)];
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc]
                                     initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuButtonItem;
    
    
  /*  if (isIphone6) {
        userSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 310, 35)];
        userSearchBar.placeholder = @"Search by last name";
        userSearchBar.delegate = self;
        userSearchBar.searchBarStyle = UISearchBarStyleMinimal;
        userSearchBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        [userSearchBar setImage:[[UIImage imageNamed: @"search-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //userSearchBar.showsCancelButton = YES;
        //self.navigationItem.titleView = userSearchBar;
        searchTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 35)];
        [searchTitleView addSubview:userSearchBar];
        
        searchBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchOptions)];
        self.navigationItem.rightBarButtonItem = searchBarButton;
    }*/

    isSearchEnabled = NO;
    isMapEnabled = NO;
     usersArray = [[NSMutableArray alloc] init];
     searchArray = [[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchOptions) name:@"showSearchBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayments) name:@"showPayments" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProfile) name:@"showProfile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCards) name:@"showCards" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings) name:@"showSettings" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShare) name:@"showShare" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imessageButtonPressed) name:@"showShareMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewProfile) name:@"showNewProfile" object:nil];
    
    //MAPVIEW CODE
   // [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(48.857617, 2.338820), MKCoordinateSpanMake(1.0, 1.0))];
    _mapView.clusterDiscrimination = 1.0;
    
   // [self parseJsonData];
    
    [self refreshBadges];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kdTreeLoadingProgress:)
                                                 name:KDTreeClusteringProgress
                                               object:nil];
    
    
    
    
    
    //Side MEnu
    // Init default left-side menu with custom width
    self.menuLeft = [[VKSideMenu alloc] initWithWidth:220 andDirection:VKSideMenuDirectionLeftToRight];
    self.menuLeft.dataSource = self;
    self.menuLeft.delegate   = self;
    
    [self setupTabbar];
  //  [self setupSearchBar];
    [self setupNavMenu];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"Update should happen here");
    
    
    //SString *searchString = [self.searchController.searchBar text];
    
  //  [self updateFilteredContentForProductName:searchString type:scope];
    
    if (self.resultSearchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.resultSearchController.searchResultsController;
        
        SearchResultsTVC *vc = (SearchResultsTVC *)navController.topViewController;
        vc.searchResults = searchArray;
        
        if (_mapView.hidden == NO) {
            vc.isOnMapView = YES;
        }
        [vc.tableView reloadData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([ParseDataFormatter sharedInstance].providersArray.count == 0) {
        return listItems.count;
    }
    else
    {
        if (!isSearchEnabled) {
            return [ParseDataFormatter sharedInstance].providersArray.count;
        }
        else{
            return searchArray.count;
        }
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    isMenuEnabled = NO;
    if ([ParseDataFormatter sharedInstance].providersArray.count == 0) {
        
//        [ParseDataFormatter sharedInstance].isSelectionMade = NO;
   //     [self.menuItem refreshNavTitle:@"Select Category"];
        
        EasyDefaultCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.imageView.image = [UIImage imageNamed:listItems[indexPath.row]];
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
    }
    else{
        
        isMenuEnabled = YES;
        
         ProviderCollectionViewCell *postingCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ProviderCollectionCell" forIndexPath:indexPath];
        
        PFObject *provider;
        
        if (!isSearchEnabled) {
            provider = [[ParseDataFormatter sharedInstance].providersArray objectAtIndex:indexPath.row];
        }
        else
        {
            provider = [searchArray objectAtIndex:indexPath.row];
        }
        
        
        postingCell.providerImage.layer.cornerRadius =  35;
        postingCell.providerImage.layer.masksToBounds = YES;
        
        NSString *nameString;
        if ([provider[@"type"] isEqualToString:@"Doctor"]) {
            nameString =  postingCell.name.text = [NSString stringWithFormat:@"%@ %@",provider[@"firstName"], provider[@"lastName"]];
        }
        else{
            nameString =  postingCell.name.text = [NSString stringWithFormat:@"%@ %@",provider[@"firstName"], provider[@"lastName"]];
        }
        postingCell.name.text = nameString;
        postingCell.specialty.text = [NSString stringWithFormat:@"%@",provider[@"speciality"]];
        postingCell.cityState.text = [NSString stringWithFormat:@"%@, %@", provider[@"city"], provider[@"state"]];
        postingCell.distance.text = [NSString stringWithFormat:@"%@ mi away", provider[@"miles"]];
        
        PFFile *imageFile = [provider objectForKey:@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:result];
                postingCell.providerImage.image = image;
            }
        }];
        
        return postingCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( IS_IPHONE6PLUS){
       return CGSizeMake(204, 204);
    }
    else{
       return CGSizeMake(185, 185);
    }
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    isSelectCategory = NO;
    //ProviderCollectionViewCell* postingCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (isMenuEnabled){
        ProviderCollectionViewCell *postingCell=[_collectionView cellForItemAtIndexPath:indexPath];
        
        [[NSUserDefaults standardUserDefaults] setObject:postingCell.name.text forKey:@"profile_name"];
        [[NSUserDefaults standardUserDefaults] setObject:postingCell.specialty.text forKey:@"profile_job"];
        [[NSUserDefaults standardUserDefaults] setObject:postingCell.cityState.text forKey:@"profile_region"];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
         selectedProvider = [[ParseDataFormatter sharedInstance].providersArray objectAtIndex:indexPath.row];
        
        _targetProfile=postingCell.providerImage.image;
        if (isIphone6) {
            [self performSegueWithIdentifier:@"showIndividual" sender:self];
            
            //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //        individualProfileVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@DoctorProfile"];
            //        UINavigationController *navCon5 = [[UINavigationController alloc] initWithRootViewController:viewController];
            //        [self presentViewController:navCon5 animated:YES completion:nil];
        }
        else{
            [self performSegueWithIdentifier:@"showIndividual" sender:self];
        }
    }
    else{
        
        isMenuEnabled = YES;
        selectionMadeFromCollectionView = YES;
        [ParseDataFormatter sharedInstance].isSelectionMade = YES;
        selectedRowIndex = indexPath.row;
        [self.menuItem setSelectedIndex:selectedRowIndex+1];
        switch (indexPath.row) {
            case 3:
                [[ParseDataFormatter sharedInstance] queryProviderType:BUSINESS];
                self.title = BUSINESS;//[BUSINESS uppercaseString];
                [[NSUserDefaults standardUserDefaults] setObject:@"business" forKey:@"fancyType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 2:
                [[ParseDataFormatter sharedInstance] queryProviderType:LAWYER];
                self.title = LAWYER;//[LAWYER uppercaseString];
                [[NSUserDefaults standardUserDefaults] setObject:@"lawyer" forKey:@"fancyType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 1:
                [[ParseDataFormatter sharedInstance] queryProviderType:REAL_ESTATE];
                self.title = REAL_ESTATE;//[REAL_ESTATE uppercaseString];
                [[NSUserDefaults standardUserDefaults] setObject:@"realestate" forKey:@"fancyType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 0:
//                [self.menuItem.delegate navigationMenuItem:self.menuItem selectionDidChange:1];
//                [self.menuItem.delegate navigationMenuItemWillFold:self.menuItem];
                [[ParseDataFormatter sharedInstance] queryProviderType:DOCTOR];
                self.title =DOCTOR;//[DOCTOR uppercaseString];
                [[NSUserDefaults standardUserDefaults] setObject:@"doctor" forKey:@"fancyType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 4:
                [[ParseDataFormatter sharedInstance] queryProviderType:DENTIST];
                self.title = DENTIST;//[DENTIST uppercaseString];
                [[NSUserDefaults standardUserDefaults] setObject:@"dentist" forKey:@"fancyType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 5:
                [[ParseDataFormatter sharedInstance] queryProviderType:CHIROPRACTOR];
                self.title = CHIROPRACTOR;//[DENTIST uppercaseString];
                [[NSUserDefaults standardUserDefaults] setObject:@"chiropractor" forKey:@"fancyType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
                
            default:
                break;
        }
        [self.menuItem refreshNavTitle:self.title];
    }
}



-(void) setupNavMenu {
    self.titles = @[@"Select Category",@"Doctor", @"Real Estate", @"Lawyer", @"Business", @"Dentist", @"Chiropractor"];

    self.menuItem = [[AWNavigationMenuItem alloc] init];
    self.menuItem.dataSource = self;
    self.menuItem.delegate = self;
}

#pragma mark - AWNavigationMenuItemDataSource

- (NSUInteger)numberOfRowsInNavigationMenuItem:(AWNavigationMenuItem *)inMenuItem
{
    return self.titles.count;
}

- (NSString *)navigationMenuItem:(AWNavigationMenuItem *)inMenuItem menuTitleAtIndex:(NSUInteger)inIndex
{
    return self.titles[inIndex];
}

//-(void)adjustTitleArray{
//    self.titles = @[@"Doctor", @"Real Estate", @"Lawyer", @"Business", @"Dentist", @"Chiropractor"];
//}

//- (NSAttributedString *)navigationMenuItem:(AWNavigationMenuItem *)inMenuItem attributedMenuTitleAtIndex:(NSUInteger)inIndex
//{
//    NSMutableAttributedString *attributedMenu = [[NSMutableAttributedString alloc] initWithString:self.titles[inIndex] attributes:@{NSForegroundColorAttributeName: [UIColor purpleColor], NSFontAttributeName: [UIFont systemFontOfSize:20.f]}];
//    [attributedMenu setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont systemFontOfSize:26.f]} range:NSMakeRange(self.titles[inIndex].length - 1, 1)];
//    
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//    attachment.image = [UIImage imageNamed:@"icon_pressure"];
//    attachment.bounds = CGRectMake(0.f, 0.f, 20.f, 20.f);
//    
//    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
//    [attributedMenu insertAttributedString:attachmentString atIndex:5];
//    
//    return (inIndex % 2) == 0 ? attributedMenu : nil;
//}

- (CGRect)maskViewFrameInNavigationMenuItem:(AWNavigationMenuItem *)inMenuItem
{
    return self.view.frame;
}

#pragma mark - AWNavigationMenuItemDelegate

- (void)navigationMenuItem:(AWNavigationMenuItem *)inMenuItem selectionDidChange:(NSUInteger)inIndex
{
   // [self adjustTitleArray];
    [ParseDataFormatter sharedInstance].isSelectionMade = YES;
    isMenuEnabled = YES;
    isSelectCategory = NO;
    self.contentLabel.text = self.titles[inIndex];
    
    switch (inIndex) {
        case 4:
            [[ParseDataFormatter sharedInstance] queryProviderType:BUSINESS];
            self.title = BUSINESS;
            [[NSUserDefaults standardUserDefaults] setObject:@"business" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 3:
            [[ParseDataFormatter sharedInstance] queryProviderType:LAWYER];
            self.title = LAWYER;
            [[NSUserDefaults standardUserDefaults] setObject:@"lawyer" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 2:
            [[ParseDataFormatter sharedInstance] queryProviderType:REAL_ESTATE];
            self.title = REAL_ESTATE;
            [[NSUserDefaults standardUserDefaults] setObject:@"realestate" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 1:
            [[ParseDataFormatter sharedInstance] queryProviderType:DOCTOR];
            self.title =DOCTOR;
            [[NSUserDefaults standardUserDefaults] setObject:@"doctor" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 5:
            [[ParseDataFormatter sharedInstance] queryProviderType:DENTIST];
            self.title = DENTIST;
            [[NSUserDefaults standardUserDefaults] setObject:@"dentist" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 6:
            [[ParseDataFormatter sharedInstance] queryProviderType:CHIROPRACTOR];
            self.title = CHIROPRACTOR;//[DENTIST uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"chiropractor" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        case 0:
            isSelectCategory = YES;
            [[ParseDataFormatter sharedInstance] queryProviderType:SELECTCATEGORY];
            self.title = SELECTCATEGORY;//[DENTIST uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"chiropractor" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        default:
            break;
    }
}

- (void)navigationMenuItemWillUnfold:(AWNavigationMenuItem *)inMenuItem
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)navigationMenuItemWillFold:(AWNavigationMenuItem *)inMenuItem
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)setupSearchBar{
    
//   _txtPlaceSearch = [[MVPlaceSearchTextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
//    // Configure the text field to our linking.
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(32, 20, 300, 40)];
    //_searchField.translatesAutoresizingMaskIntoConstraints = NO;
    _searchField.borderStyle = UITextBorderStyleNone;
    _searchField.backgroundColor = [UIColor whiteColor];
    _searchField.placeholder = @"Enter a city name";
    _searchField.textAlignment = NSTextAlignmentCenter;
    _searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchField.keyboardType = UIKeyboardTypeDefault;
    _searchField.returnKeyType = UIReturnKeyDone;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //_searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchField.alpha = 0.9;
    _searchField.layer.cornerRadius = 4.0;
    _searchField.layer.borderWidth = 0.5;
    _searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchField.layer.masksToBounds = NO;
    _searchField.layer.shadowColor = [UIColor blackColor].CGColor;
    _searchField.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    _searchField.layer.shadowOpacity = 0.5f;
    _searchField.layer.shadowRadius = 4.0f;
    
    [_searchField addTarget:self
                     action:@selector(textFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
    _searchField.delegate = self;
    
    // Setup the results view controller.
    _tableDataSource = [[GMSAutocompleteTableDataSource alloc] init];
    _tableDataSource.delegate = self;
    _tableDataSource.tableCellBackgroundColor = [UIColor clearColor];
    _tableDataSource.primaryTextHighlightColor = EASY_BLUE;
    _resultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    _resultsController.tableView.delegate = _tableDataSource;
    _resultsController.tableView.dataSource = _tableDataSource;
    _resultsController.tableView.backgroundColor = [UIColor clearColor];
//    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
//     [[UITableViewCell appearance] setBackgroundView:nil];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    // add effect to an effect view
    effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.alpha = 0.90;
    effectView.frame = self.view.frame;
    
    // add the effect view to the image view
    
    //_resultsController.tableView.cellb
    [_mapView addSubview:effectView];
    effectView.hidden = YES;
    
    
    searchIconView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 20, 20)];
    searchIconView.image = [UIImage imageNamed:@"searchicon"];
    [_searchField addSubview:searchIconView];
    [self.view addSubview:_searchField];
    _searchField.hidden = YES;
    // Use auto layout to place the text field, as we need to take the top layout guide into
    // consideration.
//    [self.view
//     addConstraints:[NSLayoutConstraint
//                     constraintsWithVisualFormat:@"H:|-[_searchField]-|"
//                     options:0
//                     metrics:nil
//                     views:NSDictionaryOfVariableBindings(_searchField)]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchField
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.topLayoutGuide
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1
//                                                           constant:8]];
    
  //  [self addResultViewBelow:_searchField];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}


#pragma mark - GMSAutocompleteTableDataSourceDelegate

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didAutocompleteWithPlace:(GMSPlace *)place {
    [_searchField resignFirstResponder];
   // [self autocompleteDidSelectPlace:place];
    _searchField.text = place.name;
    NSLog(@"%f",place.coordinate.latitude);
    
    //MKCoordinateRegion region =_mapView.region;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(place.coordinate, 10000.0, 10000.0);
    
//    region.center.latitude = place.coordinate.latitude ;
//    region.center.longitude = place.coordinate.longitude;
//    region.span.longitudeDelta /= 10000.0;
//    region.span.latitudeDelta /= 10000.0;
    
    [_mapView setRegion:region animated:YES];
    [_mapView regionThatFits:region];
    
      searchIconView.image = [UIImage imageNamed:@"navigation"];
}

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didFailAutocompleteWithError:(NSError *)error {
    [_searchField resignFirstResponder];
    //[self autocompleteDidFail:error];
    _searchField.text = @"";
}

- (void)didRequestAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_resultsController.tableView reloadData];
}

- (void)didUpdateAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_resultsController.tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    effectView.hidden = NO;
    
    [self addChildViewController:_resultsController];
    
    // Add the results controller.
    _resultsController.view.translatesAutoresizingMaskIntoConstraints = NO;
    _resultsController.view.alpha = 0.0f;
    [self.view addSubview:_resultsController.view];
    
    // Layout it out below the text field using auto layout.
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[_searchField]-[resultView]-(0)-|"
                               options:0
                               metrics:nil
                               views:@{
                                       @"_searchField" : _searchField,
                                       @"resultView" : _resultsController.view
                                       }]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-(0)-[resultView]-(0)-|"
                               options:0
                               metrics:nil
                               views:@{
                                       @"resultView" : _resultsController.view
                                       }]];
    
    // Force a layout pass otherwise the table will animate in weirdly.
    [self.view layoutIfNeeded];
    
    // Reload the data.
    [_resultsController.tableView reloadData];
    
    // Animate in the results.
    [UIView animateWithDuration:0.5
                     animations:^{
                         _resultsController.view.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [_resultsController didMoveToParentViewController:self];
                     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Dismiss the results.
     effectView.hidden = YES;
    [_resultsController willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.5
                     animations:^{
                         _resultsController.view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [_resultsController.view removeFromSuperview];
                         [_resultsController removeFromParentViewController];
                     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [textField resignFirstResponder];
    textField.text = @"";
    searchIconView.image = [UIImage imageNamed:@"searchicon"];
    return NO;
}

#pragma mark - Private Methods

- (void)textFieldDidChange:(UITextField *)textField {
    [_tableDataSource sourceTextHasChanged:textField.text];
    if ([textField.text length] ==0) {
         searchIconView.image = [UIImage imageNamed:@"searchicon"];
    }
}

//-(void)setupTabbar{
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"initial_popup"];
//    
//    [self showInitialPopUp];
//    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
//  
//    // Segmented control with images
//    HMSegmentedControl *segmentedControl2 = [[HMSegmentedControl alloc] initWithSectionImages:@[[self resizeImage:[UIImage imageNamed:@"4"] withSize:CGSizeMake(35, 35)] , [self resizeImage:[UIImage imageNamed:@"5"]withSize:CGSizeMake(40, 40)], [self resizeImage:[UIImage imageNamed:@"1"]withSize:CGSizeMake(55, 55)], [self resizeImage:[UIImage imageNamed:@"3"] withSize:CGSizeMake(35, 35)],[self resizeImage:[UIImage imageNamed:@"2"] withSize:CGSizeMake(45, 45)]] sectionSelectedImages:@[[UIImage imageNamed:@"4"], [UIImage imageNamed:@"5"], [UIImage imageNamed:@"1"], [UIImage imageNamed:@"3"],[self resizeImage:[UIImage imageNamed:@"2"] withSize:CGSizeMake(45, 45)]]];
//    segmentedControl2.frame = CGRectMake(0, 555, viewWidth, 50);
//    segmentedControl2.selectionIndicatorHeight = 3.0f;
//    segmentedControl2.backgroundColor = EASY_BLUE;
//    segmentedControl2.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    segmentedControl2.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
//    segmentedControl2.selectionIndicatorColor  = [UIColor clearColor];
//    segmentedControl2.selectedSegmentIndex = 4;
//    [segmentedControl2 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segmentedControl2];
//}

-(void)setupTabbar{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    UIView *tabView;
        if ( IS_IPHONE6PLUS){
           tabView =     [[UIView alloc] initWithFrame:CGRectMake(0, 622, viewWidth, 50)];
        }
        else{
           tabView =     [[UIView alloc] initWithFrame:CGRectMake(0, 555, viewWidth, 50)];
        }

    tabView.backgroundColor = EASY_BLUE;
    
    
    _foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"mapBlue", @"listBlue"]];
    [_foursquareSegmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    _foursquareSegmentedControl.titleTextColor = EASY_BLUE;
    _foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    _foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:13.0f];
    _foursquareSegmentedControl.segmentIndicatorBackgroundColor = EASY_BLUE;
    _foursquareSegmentedControl.backgroundColor = [UIColor whiteColor];
    _foursquareSegmentedControl.borderWidth = 2.0f;
    _foursquareSegmentedControl.borderColor = [UIColor whiteColor];
    _foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    _foursquareSegmentedControl.segmentIndicatorInset = 2.0f;
    _foursquareSegmentedControl.segmentIndicatorBorderColor = EASY_BLUE;
    _foursquareSegmentedControl.selectedSegmentIndex =1;
    //[_foursquareSegmentedControl sizeToFit];
    
     if (IS_IPHONE6PLUS){
            _foursquareSegmentedControl.frame = CGRectMake(76, 10, 250, 30);
     }
     else{
           _foursquareSegmentedControl.frame = CGRectMake(58, 10, 250, 30);
     }
 
    _foursquareSegmentedControl.cornerRadius = CGRectGetHeight(_foursquareSegmentedControl.frame) / 2.0f;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    _foursquareSegmentedControl.usesSpringAnimations = YES;
#endif

    
    [tabView addSubview:_foursquareSegmentedControl];
    [self.view addSubview:tabView];
}

-(UIImage *) resizeImage: (UIImage*) inputImage withSize: (CGSize) sacleSize
{
    UIImage * image = inputImage;
//    CGSize sacleSize = CGSizeMake(35, 35);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 4:
            [[ParseDataFormatter sharedInstance] queryProviderType:BUSINESS];
            self.title = [BUSINESS uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"business" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 1:
            [[ParseDataFormatter sharedInstance] queryProviderType:LAWYER];
            self.title = [LAWYER uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"lawyer" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 2:
            [[ParseDataFormatter sharedInstance] queryProviderType:REAL_ESTATE];
            self.title = [REAL_ESTATE uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"realestate" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 0:
            [[ParseDataFormatter sharedInstance] queryProviderType:DOCTOR];
            self.title =[DOCTOR uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"doctor" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 3:
            [[ParseDataFormatter sharedInstance] queryProviderType:DENTIST];
            self.title = [DENTIST uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"dentist" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 5:
            [[ParseDataFormatter sharedInstance] queryProviderType:CHIROPRACTOR];
            self.title = CHIROPRACTOR;//[DENTIST uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"chiropractor" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        default:
            break;
    }
}

-(void)menuButtonPressed{
    // [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
   // ((AppDelegate *)[UIApplication sharedApplication].delegate).mainViewController.leftViewSwipeGestureEnabled = NO;
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


typedef void(^addressCompletion)(NSString *);

-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark1;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder1 = [CLGeocoder new];
    [geocoder1 reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark1 = [placemarks lastObject];
             address = placemark1.name;
             //[NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality];
             completionBlock(address);
         }
     }];
}

- (void)parseObjectData {
    
    _bathroomAnnotations = [[NSMutableArray alloc] init];
    _bathroomAnnotationsAdded = [[NSMutableArray alloc] init];
    NSLog(@"Loading data…");
    
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSMutableArray * queryArray;
        queryArray = [[NSMutableArray alloc] init];
        
        if (isSelectCategory) {
            queryArray = [ParseDataFormatter sharedInstance].allProvidersArray;
        }
        else{
            queryArray = [ParseDataFormatter sharedInstance].providersArray;
        }
        
        for (PFObject *object in queryArray) {
            
            PFGeoPoint *mapPoint = object[@"coordinates"];
            CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:mapPoint.latitude longitude:mapPoint.longitude];
            
            //            [self getAddressFromLocation:eventLocation complationBlock:^(NSString * address) {
            //                if(address) {
            NSString *locationAddress;
            if (object[@"address"]) {
                locationAddress = object[@"address"];
            }
            else{
                locationAddress = @"No address found";
            }
            DoctorAnnotation * annotation = [[DoctorAnnotation alloc] initWithParseObject:object locationName:locationAddress];
            
            PFFile *imageFile = [object objectForKey:@"image"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:result];
                    annotation.image = image;
                    annotation.firstName = object[@"firstName"];
                    annotation.lastName = object[@"lastName"];
                    annotation.speciality = object[@"speciality"];
                    annotation.type = object[@"type"];
                    annotation.city = object[@"city"];
                    annotation.state = object[@"state"];
                    annotation.latitude = mapPoint.latitude;
                    
                    [_bathroomAnnotations addObject:annotation];
                    
                    if (_bathroomAnnotations.count <= queryArray.count) {
                        [self addNewBathroom];
                    }
                    
                }
            }];
            
            //    }
           // }];
        }
        //        NSLog(@"Finished CDToiletJsonFile");
        //        for (int i = 0; i <= _bathroomAnnotations.count; i++) {
        //            [self addNewBathroom];
        //        }
        
    }];
}

- (void)parseJsonData {
    
    _bathroomAnnotations = [[NSMutableArray alloc] initWithCapacity:10];
    _bathroomAnnotationsAdded = [[NSMutableArray alloc] initWithCapacity:10];
    NSLog(@"Loading data…");
    
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSData * JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CDToiletJsonFile ofType:@"json"]];
        
        for (NSDictionary * annotationDictionary in [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:NULL]) {
            DoctorAnnotation * annotation = [[DoctorAnnotation alloc] initWithDictionary:annotationDictionary];
            [_bathroomAnnotations addObject:annotation];
        }
        
        NSLog(@"Finished CDToiletJsonFile");
        for (int i = 0; i < 20; i++) {
            [self addNewBathroom];
        }
      
    }];
}

- (void)refreshBadges {
    //Update Label
    //label = [NSString stringWithFormat:@"%lu", (unsigned long)_bathroomAnnotationsAdded.count];
}

#pragma mark - MKMapViewDelegate
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(DoctorAnnotation*)annotation {
//    
//    MKAnnotationView *view;
//    
//    if ([annotation isKindOfClass:[DoctorAnnotation class]]) {
//        view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DoctorAnnotation class])];
//        if (!view) {
//            view = [[MKAnnotationView alloc] initWithAnnotation:annotation
//                                                reuseIdentifier:NSStringFromClass([DoctorAnnotation class])];
//            view.image = [UIImage imageNamed:kBathroomAnnotationImage];
//           // view.enabled = YES;
//            //view.userInteractionEnabled = YES;
//            view.canShowCallout = YES;
//            view.centerOffset = CGPointMake(view.centerOffset.x, -view.frame.size.height/2);
//            
//            UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50 , 51)];
//            vw.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:223.0/255.0 blue:181.0/255.0 alpha:1.0];
//            
//            UIImageView *icon =[[UIImageView alloc] initWithFrame:CGRectMake(15,5,25,25)];
//            icon.image= [UIImage imageNamed:@"DrWhite"];
//            [vw addSubview:icon];
//            
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 12, 50, 50)];
//            label.numberOfLines = 4;
//            label.text = @"3 mins";
//            label.textColor = [UIColor whiteColor];
//            label.font =  [UIFont fontWithName:@"OpenSans" size:14];
//            [vw addSubview:label];
//            view.rightCalloutAccessoryView = vw;
//            
//            
//            UIView *vw2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50 , 51)];
//            vw2.backgroundColor = [UIColor whiteColor];
//            UIImageView *profile =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
//            profile.image= annotation.image;  //[UIImage imageNamed:@"doctor1"];
//            [vw2 addSubview:profile];
//            view.leftCalloutAccessoryView = vw2;
//            
//            
//            UITapGestureRecognizer *tapGesture =
//            [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                    action:@selector(calloutTapped:)];
//            [view addGestureRecognizer:tapGesture];
//        }
//    }
//    
//    return view;
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    //  NSLog(annotation);

//    MKAnnotationView * annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DoctorAnnotation class])];
//    if (!annotationView)
//    {
    
//        
      MKAnnotationView *    annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([DoctorAnnotation class])];
        
        NSLog(@"Self: %@", self.title);
        
        NSString *imageName;
//        if ([self.title isEqualToString:BUSINESS]) {
//            imageName = kBusinessAnnotationImage;
//        }
//        if ([self.title isEqualToString:REAL_ESTATE]) {
//          imageName = kRealEstateAnnotationImage;
//        }
//        if ([self.title isEqualToString:DENTIST]) {
//          imageName = kDentistAnnotationImage;
//        }
//        if ([self.title isEqualToString:DOCTOR]) {
//         imageName = kBathroomAnnotationImage;
//        }
//        if ([self.title isEqualToString:LAWYER]) {
//        imageName = kLawyerAnnotationImage;
//        }
//        if ([self.title isEqualToString:CHIROPRACTOR]) {
//        imageName = kChiroAnnotationImage;
//        }
//    
 
        DoctorAnnotation* annotation1 = annotationView.annotation;
    
    if ([annotation1.type isEqualToString:BUSINESS]) {
        imageName = kBusinessAnnotationImage;
    }
    if ([annotation1.type isEqualToString:REAL_ESTATE]) {
        imageName = kRealEstateAnnotationImage;
    }
    if ([annotation1.type isEqualToString:DENTIST]) {
        imageName = kDentistAnnotationImage;
    }
    if ([annotation1.type isEqualToString:DOCTOR]) {
        imageName = kBathroomAnnotationImage;
    }
    if ([annotation1.type isEqualToString:LAWYER]) {
        imageName = kLawyerAnnotationImage;
    }
    if ([annotation1.type isEqualToString:CHIROPRACTOR]) {
        imageName = kChiroAnnotationImage;
    }
    
           annotationView.image = [UIImage imageNamed:imageName];
    annotationView.canShowCallout = YES;
    
    
        UIView *vw2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50 , 51)];
        vw2.backgroundColor = [UIColor whiteColor];
        UIImageView *profile =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
        profile.image= annotation1.image;  //[UIImage imageNamed:@"doctor1"];
        [vw2 addSubview:profile];
        annotationView.leftCalloutAccessoryView = vw2;
        
//    }else {
//        annotationView.annotation = annotation;
//    }
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView*)view
{
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Handle it, such as showing another view controller
    
    DoctorAnnotation* annotation = view.annotation;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ %@",annotation.firstName, annotation.lastName] forKey:@"profile_name"];
    [[NSUserDefaults standardUserDefaults] setObject:annotation.speciality forKey:@"profile_job"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@, %@", annotation.city, annotation.state] forKey:@"profile_region"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    _targetProfile=annotation.image;
    
    
    NSMutableArray * queryArray;
    queryArray = [[NSMutableArray alloc] init];
    
    if (!isMenuEnabled || (isMenuEnabled && [ParseDataFormatter sharedInstance].providersArray.count == 0)) {
        queryArray = [ParseDataFormatter sharedInstance].allProvidersArray;
    }
    else{
        queryArray = [ParseDataFormatter sharedInstance].providersArray;
    }
    
    
    for (PFObject *object in queryArray) {
        if ([object[@"firstName"] isEqualToString:annotation.firstName]) {
            selectedProvider = object;
        }
    }
    
    [self performSegueWithIdentifier:@"showIndividual" sender:self];
}

//- (void)mapView:(MKMapView *)mapView annotationView:(DoctorAnnotation *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    [self performSegueWithIdentifier:@"DetailsIphone" sender:view];
//}

#pragma mark - ADClusterMapView Delegate

- (MKAnnotationView *)mapView:(TSClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation {
    
    TSDemoClusteredAnnotationView * view = (TSDemoClusteredAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([TSDemoClusteredAnnotationView class])];
    if (!view) {
        view = [[TSDemoClusteredAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:NSStringFromClass([TSDemoClusteredAnnotationView class])];
    }
    
    return view;
}

- (void)mapView:(TSClusterMapView *)mapView willBeginBuildingClusterTreeForMapPoints:(NSSet<ADMapPointAnnotation *> *)annotations {
    NSLog(@"Kd-tree will begin mapping item count %lu", (unsigned long)annotations.count);
    
    _startTime = [NSDate date];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        if (annotations.count > 10000) {
//            [_progressView setHidden:NO];
//        }
//        else {
//            [_progressView setHidden:YES];
//        }
    }];
}

- (void)mapView:(TSClusterMapView *)mapView didFinishBuildingClusterTreeForMapPoints:(NSSet<ADMapPointAnnotation *> *)annotations {
    NSLog(@"Kd-tree finished mapping item count %lu", (unsigned long)annotations.count);
    NSLog(@"Took %f seconds", -[_startTime timeIntervalSinceNow]);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [_progressView setHidden:YES];
//        _progressView.progress = 0.0;
    }];
}

- (void)mapViewWillBeginClusteringAnimation:(TSClusterMapView *)mapView{
    
    NSLog(@"Animation operation will begin");
}

- (void)mapViewDidCancelClusteringAnimation:(TSClusterMapView *)mapView {
    
    NSLog(@"Animation operation cancelled");
}

- (void)mapViewDidFinishClusteringAnimation:(TSClusterMapView *)mapView{
    
    NSLog(@"Animation operation finished");
}

- (void)userWillPanMapView:(TSClusterMapView *)mapView {
    
    NSLog(@"Map will pan from user interaction");
}

- (void)userDidPanMapView:(TSClusterMapView *)mapView {
    
    NSLog(@"Map did pan from user interaction");
}

- (BOOL)mapView:(TSClusterMapView *)mapView shouldForceSplitClusterAnnotation:(ADClusterAnnotation *)clusterAnnotation {
    
    return YES;
}

- (BOOL)mapView:(TSClusterMapView *)mapView shouldRepositionAnnotations:(NSArray<ADClusterAnnotation *> *)annotations toAvoidClashAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    return YES;
}

- (void)addNewBathroom {
    
//    if (_bathroomAnnotationsAdded.count >= _bathroomAnnotations.count) {
//        return;
//    }
    
    NSLog(@"Adding 1 %@", CDToiletJsonFile);
    
//    DoctorAnnotation *annotation = [_bathroomAnnotations objectAtIndex:_bathroomAnnotationsAdded.count];
//    [_bathroomAnnotationsAdded addObject:annotation];
    
    //[_mapView addClusteredAnnotation:annotation clusterTreeRefresh:YES];
    
    [_mapView addClusteredAnnotations:_bathroomAnnotations];
}

- (void)kdTreeLoadingProgress:(NSNotification *)notification {
    NSNumber *number = [notification object];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //_progressView.progress = number.floatValue;
    }];
}

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    // Get Coords
//    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
//    
//    NSLog(@"Location %@", userLocation);
//    
//    //Zoom Region
//    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(coord, 15000.0, 15000.0);
//    
//    // [self.myMapView setCenterCoordinate:phoneLocation animated:YES];
//    // Show our location
//    [self.mapView setRegion:zoomRegion animated:YES];
//}




- (void)segmentSelected {
    
    if (_collectionView.hidden) {
        _collectionView.hidden = NO;
        _mapView.hidden = YES;
        //_resultSearchController.searchBar.hidden = NO;
        _searchField.hidden = YES;
        [self showAndEnableRightNavigationItem];
        isMapEnabled = NO;
        if (usersArray.count ==0) {
            MrEasy.hidden = NO;
        }
        else{
            MrEasy.hidden = YES;
        }

    }
    else{
        _collectionView.hidden = YES;
        _mapView.hidden = NO;
        //_resultSearchController.searchBar.hidden = YES;
        _searchField.hidden = NO;
        isMapEnabled =YES;
         MrEasy.hidden = YES;
        [userSearchBar resignFirstResponder];
        [_searchBar resignFirstResponder];
        [self hideAndDisableRightNavigationItem];
  //      isSearchEnabled = NO;
//        specificSearchString = nil;
//        self.navigationItem.rightBarButtonItem = searchBarButton;
//        self.navigationItem.titleView = nil;
//        [userSearchBar setShowsCancelButton:NO animated:NO];
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        

    }
 
}

//hide and reveal bar buttons
-(void) hideAndDisableRightNavigationItem
{
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void) showAndEnableRightNavigationItem
{
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

-(void)showEasyFormCreatedAlert
{
    [KVNProgressConfiguration defaultConfiguration].fullScreen = YES;
    [KVNProgress setConfiguration: [KVNProgressConfiguration defaultConfiguration]];
    [KVNProgress showSuccessWithStatus:@"EasyForm Sent to Provider"];
}



-(void)viewDidDisappear:(BOOL)animated
{
     _fancyTabBar.hidden = YES;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).mainViewController.leftViewSwipeGestureEnabled = NO;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).mainViewController.rightViewSwipeGestureEnabled = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
     ((AppDelegate *)[UIApplication sharedApplication].delegate).mainViewController.leftViewSwipeGestureEnabled = YES;
    
}

-(void)hideCenterButton{
   _fancyTabBar.hidden = YES;
}

-(void)showCenterButton{
    _fancyTabBar.hidden = NO;
}

-(void)showSearchOptions
{
    if (!isMapEnabled){
        self.navigationItem.rightBarButtonItem = nil;
        [userSearchBar setShowsCancelButton:YES animated:NO];
            [_searchBar setShowsCancelButton:YES animated:NO];
        self.navigationItem.titleView = searchTitleView;
        [userSearchBar becomeFirstResponder];
        [_searchBar becomeFirstResponder];
    }
}

-(void)showPayments
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViews" bundle:nil];
    PaymentMethodTVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@Payments"];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)showCards
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViews" bundle:nil];
    MyCardsTVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@MyCards"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)showShare
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViews" bundle:nil];
    ShareVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@Share"];
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)showSettings
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViews" bundle:nil];
    SettingsTVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@Settings"];
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)showNewProfile
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViews" bundle:nil];
    NewProfileTVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@NewProfile"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)showProfile
{
        [self.navigationController setNavigationBarHidden:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViews" bundle:nil];
//    FirstViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@Profile"];
//    [self.navigationController pushViewController:viewController animated:YES];
    
  //  [self.navigationController setNavigationBarHidden:YES];
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    _fancyTabBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    [self.view setNeedsLayout];
    
    NSLog(@"STATUS BAR HEIGHT: %f", [UIApplication sharedApplication].statusBarFrame.size.height);
   
   //  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0); //
    
    [self getCurrentLocation];
    // [self.locManager startUpdatingLocation];
    [self requestAlwaysAuthorization];
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
            _locationLabel.text = [NSString stringWithFormat:@"%@, %@",placemark.locality,placemark.administrativeArea];
           
            
            // Get Coords
            CLLocationCoordinate2D coord = [newLocation coordinate];
            
            //Zoom Region
            MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(coord, 15000.0, 15000.0);
            
            // [self.myMapView setCenterCoordinate:phoneLocation animated:YES];
            // Show our location
            [self.mapView setRegion:zoomRegion animated:YES];
            
            [locationManager stopUpdatingLocation];
            [locationManager stopMonitoringSignificantLocationChanges];
             locationManager = nil;
            

            
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



#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showIndividual"])
    {
        individualProfileVC *vc=[segue destinationViewController];
        [vc setImage:_targetProfile];
        vc.parseObject = selectedProvider;
    }
}


#pragma mark - FancyTabBarDelegate
- (void) didCollapse{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [_backgroundView removeFromSuperview];
            _backgroundView = nil;
        }
    }];
}


- (void) didExpand{
    
    overlayView.hidden = YES;
    if(!_backgroundView){
        _backgroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backgroundView.alpha = 0;
        [self.view addSubview:_backgroundView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
    [self.view bringSubviewToFront:_fancyTabBar];
    UIImage *backgroundImage = [self.view convertViewToImage];
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    UIImage *image = [backgroundImage applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    _backgroundView.image = image;
}
// PERFORM SEGUES TO NEXT VIEWS BASED ON INDEX PATH
- (void)optionsButton:(UIButton*)optionButton didSelectItem:(int)index{
    NSLog(@"Hello index %d tapped !", index);
    //GALLERY SEGUE
    // [@"Doctor", @"Dentist", @"Lawyer", @"Real Estate", @"Small Business"];
    switch (index) {
        case 1:
            [[ParseDataFormatter sharedInstance] queryProviderType:BUSINESS];
            self.title = [BUSINESS uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"business" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 2:
            [[ParseDataFormatter sharedInstance] queryProviderType:LAWYER];
            self.title = [LAWYER uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"lawyer" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 3:
            [[ParseDataFormatter sharedInstance] queryProviderType:REAL_ESTATE];
            self.title = [REAL_ESTATE uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"realestate" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 4:
            [[ParseDataFormatter sharedInstance] queryProviderType:DOCTOR];
            self.title =[DOCTOR uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"doctor" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 5:
            [[ParseDataFormatter sharedInstance] queryProviderType:DENTIST];
            self.title = [DENTIST uppercaseString];
            [[NSUserDefaults standardUserDefaults] setObject:@"dentist" forKey:@"fancyType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        default:
            break;
    }
}

-(void)showPopUp
{
    TouchPopUpVC *aVCObject = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"@PopUp"];
  
    UIView *myUIViewControllerView = aVCObject.view;
    [myUIViewControllerView.layer setCornerRadius:30.0f];
     myUIViewControllerView.layer.masksToBounds = YES;
    myUIViewControllerView.frame = CGRectMake(0, 0, 200.0, 300.0);
    NSLog(@"TITLE: %@",self.title);
    
    //Determine image
    if ([self.title isEqualToString:BUSINESS]) {
        aVCObject.image.image = [UIImage imageNamed:@"Nobusiness"];
    }
    if ([self.title isEqualToString:REAL_ESTATE]) {
        aVCObject.image.image = [UIImage imageNamed:@"NoReal"];
    }
    if ([self.title isEqualToString:DENTIST]) {
        aVCObject.image.image = [UIImage imageNamed:@"NoDentist"];
    }
    if ([self.title isEqualToString:DOCTOR]) {
        aVCObject.image.image = [UIImage imageNamed:@"NoDoctors"];
    }
    if ([self.title isEqualToString:LAWYER]) {
        aVCObject.image.image = [UIImage imageNamed:@"NoLawyers"];
    }
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"CancelTopRight"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissButtonPressed)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(163, 9, 20, 20)];
    [myUIViewControllerView addSubview:button];
    
    UIButton* RequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RequestButton setFrame:CGRectMake(0, 200, 200, 49)];
    [RequestButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [RequestButton setTitleColor:[[RequestButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    RequestButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    [RequestButton setTitle:@"Request EasyForm" forState:UIControlStateNormal];
    [RequestButton addTarget:self action:@selector(requestButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [myUIViewControllerView addSubview:RequestButton];
    
    UIButton* SearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [SearchButton setFrame:CGRectMake(0, 251, 200, 49)];
    [SearchButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [SearchButton setTitleColor:[[SearchButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    SearchButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    [SearchButton setTitle:@"Search Nationwide" forState:UIControlStateNormal];
    [SearchButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [myUIViewControllerView addSubview:SearchButton];
    
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


-(void)showInitialPopUp
{
    UIViewController *aVCObject = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"@InitialPopUp"];
    
    UIView *myUIViewControllerView = aVCObject.view;
    [myUIViewControllerView.layer setCornerRadius:5.0f];
    myUIViewControllerView.layer.masksToBounds = YES;
    myUIViewControllerView.frame = CGRectMake(0, 0, 250.0, 250.0);
    
    // Show in popup
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupVerticalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupHorizontalLayoutCenter);
    
    popup = [KLCPopup popupWithContentView:myUIViewControllerView
                                  showType:KLCPopupShowTypeBounceInFromTop
                               dismissType:KLCPopupDismissTypeBounceOutToBottom
                                  maskType:KLCPopupMaskTypeDimmed
                  dismissOnBackgroundTouch:YES
                     dismissOnContentTouch:NO];
    

    [popup showWithLayout:layout];
}

-(void)dismissButtonPressed
{
    [popup dismiss:YES];
}

-(void)requestButtonPressed
{
    [popup dismiss:YES];
    [self sendToEmail];
}

-(void)searchButtonPressed
{
    
}

#pragma mark - EmailComposerDelegate methods

//Opens the email composer with a nice pre-defined message
-(void) sendToEmail
{
    MFMailComposeViewController *emailComposer = [MFMailComposeViewController new];
    emailComposer.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [emailComposer setSubject:@"Request EasyForm"];
        [emailComposer setToRecipients: [NSArray arrayWithObject:@"support@easyform.us"]];
        [self presentViewController:emailComposer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)reloadProviders
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.collectionView reloadData];
//    [self.tableView.tableFooterView setNeedsLayout];
//    [self.tableView layoutIfNeeded];
    
    //Restore tableview
    [_bathroomAnnotations removeAllObjects];
    [_bathroomAnnotationsAdded removeAllObjects];
    
    _bathroomAnnotations = nil;
    _bathroomAnnotationsAdded = nil;
   // if (_bathroomAnnotationsAdded == nil) {
    [self parseObjectData];
    //}
  
    [usersArray removeAllObjects];
    
    if (isMenuEnabled) {
        if ([ParseDataFormatter sharedInstance].providersArray.count == 0) {
            
            usersArray = [ParseDataFormatter sharedInstance].allProvidersArray;
        }
        else{
            usersArray = [ParseDataFormatter sharedInstance].providersArray;
        }
        
    }
    else{
        usersArray =  [ParseDataFormatter sharedInstance].allProvidersArray;
    }
   
    if ([ParseDataFormatter sharedInstance].providersArray.count == 0) {
        if (MrEasy.hidden) {
            if (!isMapEnabled) {
                MrEasy.hidden = NO;
            }
        }
       // [self showPopUp];
    }
    else{
        self.tableView.tableFooterView = [[UIView alloc] init];
        MrEasy.hidden = YES;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return tableView.tableFooterView;
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!isSearchEnabled) {
        return [ParseDataFormatter sharedInstance].providersArray.count;
    }
    else{
        return searchArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // return your normal height here:
    return 80.0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return 150;
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"providerCell";
    ProviderCell* postingCell = (ProviderCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[ProviderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    postingCell.contentView.frame = postingCell.bounds;
    //    postingCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    PFObject *provider;
    
    if (!isSearchEnabled) {
        provider = [[ParseDataFormatter sharedInstance].providersArray objectAtIndex:indexPath.row];
    }
    else
    {
        provider = [searchArray objectAtIndex:indexPath.row];
    }
    
    
    postingCell.providerImage.layer.cornerRadius =  30;
    postingCell.providerImage.layer.masksToBounds = YES;
    
    NSString *nameString;
    if ([provider[@"type"] isEqualToString:@"Doctor"]) {
        nameString =  postingCell.name.text = [NSString stringWithFormat:@"%@ %@",provider[@"firstName"], provider[@"lastName"]];
    }
    else{
        nameString =  postingCell.name.text = [NSString stringWithFormat:@"%@ %@",provider[@"firstName"], provider[@"lastName"]];
    }
    postingCell.name.text = nameString;
    postingCell.specialty.text = [NSString stringWithFormat:@"%@",provider[@"speciality"]];
    //    postingCell.priceLabel.text = [NSString stringWithFormat:@"$%@", [car[@"price"] stringValue]];
    postingCell.cityState.text = [NSString stringWithFormat:@"%@, %@", provider[@"city"], provider[@"state"]];
    postingCell.distance.text = [NSString stringWithFormat:@"%@ mi away", provider[@"miles"]];
    
    
    postingCell.phoneButton.tag = indexPath.row;
    [postingCell.phoneButton addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    postingCell.formButton.tag = indexPath.row;
    [postingCell.formButton addTarget:self action:@selector(formButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    if ([postingCell.carType.text isEqualToString:@"Exotic"]) {
    //        postingCell.carType.backgroundColor = [UIColor colorWithRed:112.0/255.0 green:199.0/255.0 blue:53.0/255.0 alpha:1.0];
    //    }
    //    else
    //    {
    //        postingCell.carType.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:155.0/255.0 blue:220.0/255.0 alpha:1.0];
    //    }
    
    PFFile *imageFile = [provider objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:result];
            postingCell.providerImage.image = image;
            // [imageArray addObject:image];
        }
    }];
    
    
    return postingCell;
}

-(void)phoneButtonPressed:(UIButton*)sender
{
    PFObject *provider;
    
    if (!isSearchEnabled) {
        provider =  [[ParseDataFormatter sharedInstance].providersArray objectAtIndex:sender.tag];
    }
    else{
       provider =  [searchArray objectAtIndex:sender.tag];
    }

    NSString *title = [NSString stringWithFormat:@"Call %@", provider[@"lastName"]];
    NSString *message = [NSString stringWithFormat:@"%@", provider[@"phone"]];
    
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
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", provider[@"phone"]]]];
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

-(void)formButtonPressed:(UIButton*)sender{
//    if (isIphone6) {
//          [self performSegueWithIdentifier:@"showForm" sender:self];
//    }
//    else{
//         [self performSegueWithIdentifier:@"smallForm" sender:self];
//    }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"providerCell";
    ProviderCell* postingCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [[NSUserDefaults standardUserDefaults] setObject:postingCell.name.text forKey:@"profile_name"];
    [[NSUserDefaults standardUserDefaults] setObject:postingCell.specialty.text forKey:@"profile_job"];
    [[NSUserDefaults standardUserDefaults] setObject:postingCell.cityState.text forKey:@"profile_region"];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    _targetProfile=postingCell.providerImage.image;
    
    
    selectedProvider = [[ParseDataFormatter sharedInstance].providersArray objectAtIndex:indexPath.row];

    if (isIphone6) {
        [self performSegueWithIdentifier:@"showIndividual" sender:self];
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        individualProfileVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@DoctorProfile"];
//        UINavigationController *navCon5 = [[UINavigationController alloc] initWithRootViewController:viewController];
//        [self presentViewController:navCon5 animated:YES completion:nil];
    }
    else{
        [self performSegueWithIdentifier:@"showIndividual" sender:self];
    }
//    if (isIphone6) {
//        [self performSegueWithIdentifier:@"showForm" sender:self];
//    }
//    else{
//        [self performSegueWithIdentifier:@"smallForm" sender:self];
//    }
}


-(void)swapViews
{

    if (!isMapView) {
        [UIView transitionFromView:_collectionView
                            toView:_mapView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished)
         {
             isMapView = YES;
             [_collectionView removeFromSuperview];
             [self.view addSubview:_mapView];
             _collectionView.hidden = YES;
         }
         ];
    }
    else
    {
        [UIView transitionFromView:_mapView
                            toView:_collectionView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished)
         {
             isMapView = NO;
             [_mapView removeFromSuperview];
             [self.view addSubview:_collectionView];
         }
         ];
    }
}


#pragma mark- UISearchBar Delegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [userSearchBar setShowsCancelButton:YES animated:NO];
        [_searchBar setShowsCancelButton:YES animated:NO];
        _foursquareSegmentedControl.enabled = NO;
    _searchBar.barTintColor = EASY_BLUE;
    _searchBar.backgroundColor = EASY_BLUE;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
        _foursquareSegmentedControl.enabled = YES;
    
    if (cancelledFromDrag) {
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        [self resetToDefaultListOfUsers];
        cancelledFromDrag = NO;
    }
    if (searchBar.text.length == 0 && !isSearchBarEnabled) {
        [self resetToDefaultListOfUsers];
    }
    
      // [self.menuItem setSelectedIndex:selectedRowIndex];
     //  [self.menuItem refreshNavTitle:self.title];
    
      _searchBar.barTintColor = [UIColor whiteColor];
      _searchBar.backgroundColor = [UIColor whiteColor];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //[searchBar resignFirstResponder];
    [self loadNewUsersWithSearchString:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self resetToDefaultListOfUsers];
}


-(void)resetToDefaultListOfUsers{
    isSearchEnabled = NO;
    specificSearchString = nil;
 //   self.navigationItem.rightBarButtonItem = searchBarButton;
    [userSearchBar setShowsCancelButton:NO animated:NO];
    [_searchBar setShowsCancelButton:NO animated:NO];
    [self.collectionView reloadData];
    
    if (usersArray.count ==0) {
        MrEasy.hidden = NO;
    }
    else{
        MrEasy.hidden = YES;
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    NSString *str = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self loadNewUsersWithSearchString:str];
    return YES;
}

-(void)loadNewUsersWithSearchString:(NSString *)searchString{
    isSearchEnabled = YES;
    
    if (searchString.length>0) {
        NSPredicate *applePred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"firstName CONTAINS[cd] '%@'",  searchString]];
        [searchArray setArray:[usersArray filteredArrayUsingPredicate:applePred]];
       // [self.collectionView reloadData];
        if (searchArray.count ==0) {
            MrEasy.hidden = NO;
        }
        else{
            MrEasy.hidden = YES;
        }
       
    }
    else{
        [searchArray setArray:usersArray];
      //  [self.collectionView reloadData];
        if (searchArray.count ==0) {
            MrEasy.hidden = NO;
        }
        else{
            MrEasy.hidden = YES;
        }
    }
}

-(void)hideKeyBoard {
    [_searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    cancelledFromDrag = YES;
    [userSearchBar resignFirstResponder];
    [_searchBar resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
    [self.resultSearchController setActive:NO];
  //   [self.resultSearchController.searchBar resignFirstResponder];
}


-(void)zoomInToLocation: (NSNotification*) notification
{
    _resultSearchController.searchBar.text = @"";
    
    CLLocation * location = [notification object];
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = location.coordinate.latitude ;
    region.center.longitude = location.coordinate.longitude;
    region.span.longitudeDelta = 0.05f;
    region.span.latitudeDelta = 0.05f;
    [_mapView setRegion:region animated:YES];
    
    [_mapView annotationsInMapRect:_mapView.visibleMapRect];
   // [_mapView openAnnotation:closestAnnotation];
    
    NSUInteger fooIndex;
    for(DoctorAnnotation *object in _bathroomAnnotations) {
        if (object.latitude == location.coordinate.latitude) {
            fooIndex = [_bathroomAnnotations indexOfObject: object];
       }
            NSLog(@"BATHROOM: %@", object.firstName);
    }

    [_mapView selectAnnotation:[_bathroomAnnotations objectAtIndex:fooIndex] animated:YES];
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
