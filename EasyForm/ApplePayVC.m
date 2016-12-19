//
//  ApplePayVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 7/23/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "ApplePayVC.h"
#import "Constants.h"

@interface ApplePayVC ()

@end

@implementation ApplePayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Apple Pay";
    _makeDefualtButton.layer.masksToBounds = YES;
    _makeDefualtButton.layer.cornerRadius = 15;
    _makeDefualtButton.layer.borderWidth = 3;
    _makeDefualtButton.layer.borderColor = EASY_BLUE.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
