//
//  SearchResultsTVC.h
//  
//
//  Created by Rahiem Klugh on 10/12/16.
//
//

#import <UIKit/UIKit.h>

@interface SearchResultsTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (nonatomic) BOOL isOnMapView;
@end
