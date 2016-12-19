//
//  ProviderCollectionViewCell.h
//  EasyForm
//
//  Created by Rahiem Klugh on 9/23/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *providerImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *specialty;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *cityState;
@end
