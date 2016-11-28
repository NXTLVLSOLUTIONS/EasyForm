//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"
#import "EasyFormVC.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "PaymentMethodTVC.h"
#import "MyCardsTVC.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

     self.tableView.backgroundColor = [UIColor blackColor];
    // -----

    _titlesArray = @[@"Search",
                     @"Profile",
                     @"My Cards",
                     @"Payment",
                     @"Settings"];
    
    
    _imageArray =  @[@"Search",
                     @"Profile",
                     @"MyCards",
                     @"Payments",
                     @"Settings"];

    // -----

    self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);
    
    self.tableView.tableHeaderView = ({
        UIView *view;

            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 110.0f)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 70, 70)];
            //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            imageView.image = [UIImage imageNamed:@"AddPhoto"];
            imageView.layer.masksToBounds = YES;
//            imageView.layer.cornerRadius = 35.0;
//            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//            imageView.layer.borderWidth = 3.0f;
            imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
            imageView.layer.shouldRasterize = YES;
            imageView.clipsToBounds = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 0, 24)];
            label.text = @"Enter Details";
            label.font = [UIFont fontWithName:@"OpenSans" size:18];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            [label sizeToFit];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 0, 24)];
            label2.text = @"Verify Phone";
            label2.font = [UIFont fontWithName:@"OpenSans" size:15];
            label2.backgroundColor = [UIColor clearColor];
            label2.textColor = [UIColor whiteColor];
            [label2 sizeToFit];
            //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            [view addSubview:imageView];
            [view addSubview:label];
            [view addSubview:label2];
        view;
    });
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.separatorView.hidden = YES; //!(indexPath.row != 0 && indexPath.row != 1 && indexPath.row != _titlesArray.count-1);
    //cell.userInteractionEnabled = (indexPath.row != 1);

    cell.imageView.image = [self imageWithImage:[UIImage imageNamed:_imageArray[indexPath.row]] scaledToSize:CGSizeMake(30.0, 30.0)];

    cell.tintColor = _tintColor;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1) return 22.f;
//    else
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0)
//    {
//        if (![kMainViewController isLeftViewAlwaysVisible])
//        {
//            [kMainViewController hideLeftViewAnimated:YES completionHandler:^(void)
//             {
//                 [kMainViewController showRightViewAnimated:YES completionHandler:nil];
//             }];
//        }
//        else [kMainViewController showRightViewAnimated:YES completionHandler:nil];
//    }
//    else
//    {
//        UIViewController *viewController = [UIViewController new];
//        viewController.view.backgroundColor = [UIColor whiteColor];
//        viewController.title = _titlesArray[indexPath.row];
//        [kNavigationController pushViewController:viewController animated:YES];
//
//        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
 //   }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViews" bundle: nil];
    UIViewController *viewController;
    
    switch (indexPath.row) {
            
        case 0:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchBar" object:nil];
        }
            break;
            
        case 2:
        {
            
            MyCardsTVC *MyCardsViewController  = [storyboard instantiateViewControllerWithIdentifier:@"@MyCards"];
            viewController = MyCardsViewController;
        }
            break;
        case 3:
        {
            PaymentMethodTVC * paymentViewController  = [storyboard instantiateViewControllerWithIdentifier:@"@Payments"];
            viewController = paymentViewController;
        }
            break;
        case 4:
        {
            viewController = [UIViewController new];
            viewController.view.backgroundColor = [UIColor whiteColor];
            viewController.title = _titlesArray[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        [kNavigationController pushViewController:viewController animated:YES];
    }
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
}



@end
