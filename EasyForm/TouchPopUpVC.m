//
//  TouchPopUpVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 6/6/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "TouchPopUpVC.h"

@interface TouchPopUpVC ()

@end

@implementation TouchPopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_cancelButton addTarget:self action:@selector(cancelAlertPressed) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelAlertPressed
{
    
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
