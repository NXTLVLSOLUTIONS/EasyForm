//
//  SearchResultsTVC.m
//  
//
//  Created by Rahiem Klugh on 10/12/16.
//
//

#import "SearchResultsTVC.h"
#import "SearchResultsCell.h"
#import "ParseDataFormatter.h"
#import <Parse/Parse.h>
#import "individualProfileVC.h"

@interface SearchResultsTVC ()
{
        PFObject *selectedProvider;
}

@property(nonatomic,strong) UIImage *targetProfile;

@end

@implementation SearchResultsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    effectView.alpha = 0.90;
    
    // add the effect view to the image view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     nil];
    [self.tableView.backgroundView addSubview:effectView];
    
    self.definesPresentationContext = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* CellIdentifier = @"SearchResultCell";
    SearchResultsCell* postingCell = (SearchResultsCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[SearchResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PFObject *provider;
    
    provider = [_searchResults objectAtIndex:indexPath.row];
    
    
    postingCell.image.layer.cornerRadius =  postingCell.image.frame.size.height/2;
    postingCell.image.layer.masksToBounds = YES;
    
    NSString *nameString =  postingCell.name.text = [NSString stringWithFormat:@"%@ %@",provider[@"firstName"], provider[@"lastName"]];

    postingCell.name.text = nameString;
    postingCell.speciality.text = [NSString stringWithFormat:@"%@",provider[@"speciality"]];

    PFFile *imageFile = [provider objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:result];
            postingCell.image.image = image;
        }
    }];
    
    return postingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"providerCell";
    SearchResultsCell* postingCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [[NSUserDefaults standardUserDefaults] setObject:postingCell.name.text forKey:@"profile_name"];
    [[NSUserDefaults standardUserDefaults] setObject:postingCell.speciality.text forKey:@"profile_job"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    _targetProfile=postingCell.image.image;
    
    selectedProvider = [_searchResults objectAtIndex:indexPath.row];
    
    
    if (!_isOnMapView) {
        individualProfileVC *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"@DoctorProfile"];
        //self.presentingViewController.navigationItem.title = @"Search";
        [vc setImage:_targetProfile];
        vc.parseObject = selectedProvider;
        [self.presentingViewController.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        PFGeoPoint *mapPoint = selectedProvider[@"coordinates"];
        CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:mapPoint.latitude longitude:mapPoint.longitude];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdatedNotification" object:eventLocation];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    
      //  [self performSegueWithIdentifier:@"showIndividualFromSearch" sender:self];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showIndividualFromSearch"])
    {
        individualProfileVC *vc=[segue destinationViewController];
        [vc setImage:_targetProfile];
        vc.parseObject = selectedProvider;
    }
}



/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = [self.searchResults objectAtIndex:indexPath.row];
    DetailViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    self.presentingViewController.navigationItem.title = @"Search";
    vc.product = product;
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
