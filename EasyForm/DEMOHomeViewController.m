//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"

@interface DEMOHomeViewController ()

@end

@implementation DEMOHomeViewController

- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
    CGSize imageSize = CGSizeMake(40, 40);
    CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
    
    imageView.frame = CGRectMake(marginX, 0, imageSize.width, imageSize.height);
    [self.navigationController.navigationBar addSubview:imageView];
}


@end
