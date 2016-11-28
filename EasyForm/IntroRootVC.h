//
//  IntroRootVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 6/13/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageContentViewController.h"

@interface IntroRootVC : UIViewController
<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSArray *arrPageTitles;
@property (nonatomic,strong) NSArray *arrPageImages;
@property (nonatomic,strong) UIPageControl *pageControl;

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index;

- (IBAction)btnStartAgain:(id)sender;
@end