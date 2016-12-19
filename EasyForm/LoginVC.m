//
//  LoginVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/2/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "IntroPageVC.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"
@import MediaPlayer;
#import "RegisterVC.h"

@interface LoginVC ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the video from the app bundle.
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"EVid" withExtension:@"mp4"];
    
    // Create and configure the movie player.
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    
    self.moviePlayer.view.frame = self.view.frame;
    [self.view insertSubview:self.moviePlayer.view atIndex:0];
    
    UIView *backgrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    backgrView.backgroundColor = [UIColor blackColor];
    backgrView.alpha = 0.5;
    [self.view insertSubview:backgrView atIndex:1];
    
    _loginButton.layer.cornerRadius = 2;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginButton.layer.borderWidth = 2;
    [_loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _enterButton.layer.cornerRadius = 2;
    _enterButton.layer.masksToBounds = YES;
     [_enterButton addTarget:self action:@selector(enterPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    _eView.layer.shadowColor = [UIColor blackColor].CGColor;
    _eView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    _eView.layer.shadowOpacity = 0.5f;
    _eView.layer.shadowRadius = 4.0f;
    
    [self.moviePlayer play];
    
    // Loop video.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loopVideo) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
}

- (void)loopVideo {
    [self.moviePlayer play];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)enterPressed
{
    //  [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
//    IntroPageVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@IntroVC"];
//    [self.navigationController showViewController:viewController sender:self];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"@RegisterVC2"];
    [self.navigationController showViewController:viewController sender:self];
}

-(void)loginPressed
{
    Digits *digits = [Digits sharedInstance];
    DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
    configuration.appearance = [[DGTAppearance alloc] init];
    //configuration.appearance.backgroundColor = [UIColor blackColor];
    configuration.appearance.accentColor = EASY_BLUE;
    
    [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *session, NSError *error) {
        // Inspect session/error objects
        if (session != nil){
            [self loginInNewUser:session.phoneNumber];
        }
    }];
}
- (void)loginInNewUser: (NSString*) phoneNumber {
    
    PFUser *user = [PFUser user];
    user.username = phoneNumber;
    user.password = phoneNumber;
    

    [KVNProgress show];
    
    [PFUser logInWithUsernameInBackground:user.username password:user.password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [KVNProgress dismiss];
                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                                            [[UIApplication sharedApplication] setStatusBarHidden:NO];
                                            [self presentViewController:viewController animated:YES completion:nil];
                                        } else {
                                            [KVNProgress dismiss];
                                            // The login failed. Check error to see why.
                                        }
                                    }];
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
