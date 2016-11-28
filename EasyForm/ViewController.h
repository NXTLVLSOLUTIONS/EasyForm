//
//  ViewController.h
//
//  Created by ToanDK on 4/24/15.
//  Copyright (c) 2015 ToanDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTParallaxTableView.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate> {
    __weak IBOutlet DTParallaxTableView *_tableView;
    __weak IBOutlet UIView *tabbar;
    __weak IBOutlet UILabel *nameLabel;
}

@end
