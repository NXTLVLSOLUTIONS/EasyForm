//
//  EditPaymentVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 9/29/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "EditPaymentVC.h"

@interface EditPaymentVC ()

@end

@implementation EditPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cardLabel.text = [NSString stringWithFormat:@"PERSONAL •••• %@",_card[@"lastFour"]];
    _cardImage.image = [self setCardTypeImage:_card[@"cardType"]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCard) name: @"reloadCards" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popView) name: @"cardDeleted" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*)setCardTypeImage: (NSString*)cardType{
    UIImage *cardImage;
    if ([cardType isEqualToString:@"VISA"]) {
        cardImage = [UIImage imageNamed:@"Visa"];
    }
    if ([cardType isEqualToString:@"DISCOVER"]) {
        cardImage = [UIImage imageNamed:@"Discover"];
    }
    if ([cardType isEqualToString:@"MASTERCARD"]) {
        cardImage = [UIImage imageNamed:@"Mastercard"];
    }
    if ([cardType isEqualToString:@"AMEX"]) {
        cardImage = [UIImage imageNamed:@"AmericanExpress"];
    }
    return cardImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)removePressed:(id)sender {
    
    [[ParseDataFormatter sharedInstance] deleteCreditCard:_card.objectId];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
