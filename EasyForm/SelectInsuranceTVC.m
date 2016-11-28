//
//  SelectInsuranceTVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 6/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "SelectInsuranceTVC.h"
#import "ParseDataFormatter.h"
#import "InsuranceProviderCell.h"

@interface SelectInsuranceTVC ()

@end

@implementation SelectInsuranceTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Select Insurance Provider";
    
     [[ParseDataFormatter sharedInstance] queryInsurance];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadInsurance) name:@"reloadInsurance" object:nil];
}

-(void)reloadInsurance
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    // self.navigationController.navigationBar.topItem.title = @"";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [ParseDataFormatter sharedInstance].insuranceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"InsuranceProviderCell";
    InsuranceProviderCell* postingCell = (InsuranceProviderCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[InsuranceProviderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    postingCell.contentView.frame = postingCell.bounds;
    //    postingCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    PFObject *provider = [[ParseDataFormatter sharedInstance].insuranceArray objectAtIndex:indexPath.row];
    postingCell.name.text = [NSString stringWithFormat:@"%@",provider[@"name"]];
    
    PFFile *imageFile = [provider objectForKey:@"logo"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:result];
            postingCell.image.image = image;
        }
    }];
    
    return postingCell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    PFObject *provider = [[ParseDataFormatter sharedInstance].insuranceArray objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"insuranceSelected" object:self
                        userInfo:@{ @"insuranceName" : provider[@"name"]}];
     [self.navigationController popViewControllerAnimated:YES];
    
}


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

@end
