//
//  IntroPageVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 5/19/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "IntroPageVC.h"
#import "SMPageControl.h"
#import "EAIntroView.h"
#import "HomeVC.h"
#import "AppDelegate.h"
#import "RegisterVC.h"
#import "Constants.h"

static NSString * const sampleDescription1 = @"EasyForm makes filling required forms a breeze";
static NSString * const sampleDescription2 = @"Search through business professionals and companies across the nation";
static NSString * const sampleDescription3 = @"Fill out necessary forms ahead of time right from the palm of your hands";
static NSString * const sampleDescription4 = @"Link bank cards, scan driver's license, photo ID's and medical cards instantly";
static NSString * const sampleDescription5 = @"Fiinished forms will be sent securely to the designated EasyForm user";

@interface IntroPageVC () <EAIntroDelegate>{
    UIView *rootView;
    EAIntroView *_intro;
}

@end

@implementation IntroPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     rootView = self.navigationController.view;
    [self showIntroWithCustomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeIntro) name:@"removeIntro" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showIntroWithCustomView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Welcome to EasyForm!";
    page1.desc = sampleDescription1;
    page1.descPositionY = self.view.bounds.size.height/2 - 140;
    page1.titleIconView = [[UIImageView alloc] initWithImage:[self resizeImage:[UIImage imageNamed:@"1stpic"]]];
    page1.titleIconPositionY = 0;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Search Nationwide";
    page2.desc = sampleDescription2;
    page2.descPositionY = self.view.bounds.size.height/2 - 140;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[self resizeImage:[UIImage imageNamed:@"2ndpic"]]];
    page2.titleIconPositionY = 0;

    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"No Hassle, No Waiting";
    page3.desc = sampleDescription3;
    page3.descPositionY = self.view.bounds.size.height/2 - 140;
    page3.titleIconView = [[UIImageView alloc] initWithImage:[self resizeImage:[UIImage imageNamed:@"3rdpic"]]];
    page3.titleIconPositionY = 0;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Upload In A Snap";
    page4.desc = sampleDescription4;
    page4.descPositionY = self.view.bounds.size.height/2 - 140;
    page4.titleIconView = [[UIImageView alloc] initWithImage:[self resizeImage:[UIImage imageNamed:@"4thpic"]]];
    page4.titleIconPositionY = 0;
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"Life Just Got Easier";
    page5.desc = sampleDescription5;
    page5.descPositionY = self.view.bounds.size.height/2 - 140;
    page5.titleIconView = [[UIImageView alloc] initWithImage:[self resizeImage:[UIImage imageNamed:@"5thpic"]]];
    page5.titleIconPositionY = 0;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    [intro.skipButton setTitle:@"SKIP" forState:UIControlStateNormal];
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
    
    [self addBookButton];
}

-(UIImage *) resizeImage: (UIImage*) inputImage
{
    UIImage * image = inputImage;
    CGSize sacleSize = CGSizeMake(375, 375);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

-(UIImage *) resizeSecondImage: (UIImage*) inputImage
{
    UIImage * image = inputImage;
    CGSize sacleSize = CGSizeMake(355, 355);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
  
}


-(void)removeIntro{
    //[self performSegueWithIdentifier:@"gotohome" sender:self];
   // dispatch_async(dispatch_get_main_queue(), ^{
        // your navigation controller action goes here
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"registered"];
//        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setRegisterViewController];
   // });

    
//
    
     dispatch_async(dispatch_get_main_queue(), ^{
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
         RegisterVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@RegisterVC2"];
         [self.navigationController showViewController:viewController sender:self];
     });


}

-(void)addBookButton
{
    /*Initializes the Done button*/
    _bookButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 620, self.view.frame.size.width, 50)];
    [_bookButton setTitle:@"Swipe Left To Continue" forState:UIControlStateNormal];
    [_bookButton setBackgroundColor:EASY_BLUE];
   // [_bookButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //Inserts the Done button on top of the tableview
    [self.view insertSubview:_bookButton aboveSubview:self.view];
}

#pragma mark <UIScrollViewDelegate>

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"progress %f", scrollView.parallaxHeader.progress);
//    
//    CGRect frame = self.bookButton.frame;
//    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.bookButton.frame.size.height;
//    self.bookButton.frame = frame;
//    
//    [self.view bringSubviewToFront:self.bookButton];
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
