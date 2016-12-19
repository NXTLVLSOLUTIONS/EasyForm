//
//  IntroRootVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 6/13/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "IntroRootVC.h"

@interface IntroRootVC ()

@end

@implementation IntroRootVC

@synthesize PageViewController,arrPageTitles,arrPageImages;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //arrPageTitles = @[@"This is The App Guruz",@"This is Table Tennis 3D",@"This is Hide Secrets"];
    arrPageImages =@[@"Appstore1",@"Appstore2",@"Appstore3",@"Appstore4",@"Appstore5"];
    
    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;
    self.PageViewController.delegate = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    
//    NSArray *subviews = self.PageViewController.view.subviews;
//    UIPageControl *thisControl = nil;
//    for (int i=0; i<[subviews count]; i++) {
//        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
//            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
//            thisControl.frame = CGRectMake( 100, 200, self.view.frame.size.width, 50);
//            [self.view bringSubviewToFront:thisControl];
//        }
//    }
    
    //self.PageViewController.view.frame =CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 60);
    
    //thisControl.hidden = true;
   // self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40);
   // [[self.PageViewController view] setFrame:[[self view] bounds]];
    
    //[self pageControl];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20,  100, (self.view.frame.size.width), 50)];
    pageControl.numberOfPages=arrPageImages.count;
    [pageControl setNeedsLayout];
    [self.view addSubview:pageControl];
    self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100);
    //self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)]; // your position
    
   // [self.view addSubview: self.pageControl];
    
    [self addChildViewController:PageViewController];
    [self.view addSubview:PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Datasource Methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if (index == [self.arrPageImages count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Other Methods
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrPageImages count] == 0) || (index >= [self.arrPageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imgFile = self.arrPageImages[index];
    pageContentViewController.txtTitle = self.arrPageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - No of Pages Methods
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.arrPageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
//{
//    PageContentViewController *pageContentView = (PageContentViewController*) pendingViewControllers[0];
//    _pageControl.currentPage = pageContentView.pageIndex;
//}

//- (UIPageControl*)pageControl {
//    for (UIView* view in self.view.subviews) {
//        if ([view isKindOfClass:[UIPageControl class]]) {
//            //set new pageControl position
//            view.frame = CGRectMake( 100, 200, self.view.frame.size.width, 50);
//            return (id)view;
//        }
//    }
//    return nil;
//}

- (IBAction)btnStartAgain:(id)sender
{
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

@end
