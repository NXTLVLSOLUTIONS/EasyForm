//
//  SearchResultsCell.h
//  EasyForm
//
//  Created by Rahiem Klugh on 10/12/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *speciality;

@end
