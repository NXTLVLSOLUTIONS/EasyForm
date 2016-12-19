//
//  AppDelegate.m
//  EasyForm
//
//  Created by Rahiem Klugh on 5/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ParseDataFormatter.h"
#import "EasyFormVC.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import <Crashlytics/Crashlytics.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <Stripe/Stripe.h>
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.0];

    
    self.window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    
    [Fabric with:@[[Digits class]]];
    [Fabric with:@[[Crashlytics class]]];
    
    [Stripe setDefaultPublishableKey:@"pk_test_4759uGB7vPfwCxbqbJboDlxG"];
    [[STPPaymentConfiguration sharedConfiguration] setAppleMerchantIdentifier:@"your apple merchant identifier"];

    // Provide the Places API with your API key.
    [GMSPlacesClient provideAPIKey:@"AIzaSyBdnKDbxIgRXzeyI_5JODJZfi10znYZtCc"];
    // Provide the Maps API with your API key. You may not need this in your app, however we do need
    // this for the demo app as it uses Maps.
    [GMSServices provideAPIKey:@"AIzaSyBdnKDbxIgRXzeyI_5JODJZfi10znYZtCc"];
    
//    application.statusBarHidden = YES;
    
    [Parse setApplicationId:@"WCSaHSXAqDIXvx8kcLYEzYSn5CeD9a1fAFWgtVVL"
                  clientKey:@"75NtEvTaZci6FOgjh3mia5gRJNQWMKsPZj4pbrMI"];
    [PFUser enableRevocableSessionInBackground];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = EASY_BLUE;
    pageControl.backgroundColor = [UIColor clearColor];
    //pageControl.frame = CGRectMake(0, 10, pageControl.frame.size.width, pageControl.frame.size.height);
    
    //[[UILabel appearance] setFont:[UIFont fontWithName:@"Avenir"]];
   // [[UILabel appearance] setSubstituteFontName:@"Avenir"];
    
    //[application setStatusBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    if ([PFUser currentUser] ){
            [self setRootViewController];
        }
        else{
            [self setLoginViewController];
        }

    if ([UIApplication sharedApplication].statusBarFrame.size.height == 40) {
        [ParseDataFormatter sharedInstance].isLaunchedFromPhoneCall = YES;
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)setLoginViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@LoginVC"];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}

-(void)setRegisterViewController
{
        // your navigation controller action goes here
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@RegisterVC"];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
}

-(void)setRootViewController{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    
//    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
//    _mainViewController = [storyboard instantiateInitialViewController];
//    _mainViewController.rootViewController = navigationController;
// 
//    [_mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:0];
//
//    
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    
//    window.rootViewController = _mainViewController;
//    
//    [UIView transitionWithView:window
//                      duration:0.3
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:nil
//                    completion:nil];
}

@end
