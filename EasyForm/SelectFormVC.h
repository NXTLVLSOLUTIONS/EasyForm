//
//  SelectFormVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 8/3/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFormVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *providerImage;
@property (weak, nonatomic) IBOutlet UILabel *providerName;

@end
