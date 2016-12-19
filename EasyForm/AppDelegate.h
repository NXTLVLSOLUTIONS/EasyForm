//
//  AppDelegate.h
//  EasyForm
//
//  Created by Rahiem Klugh on 5/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//
//DigitalHole.Co

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "MainViewController.h"
#define kMainViewController  (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController
#define kNavigationController (NavigationController *)[(MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController rootViewController]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;
-(void)setRootViewController;
-(void)setRegisterViewController;
-(void)setLoginViewController;


@end

