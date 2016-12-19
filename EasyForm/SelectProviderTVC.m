//
//  SelectProviderTVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 5/12/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "SelectProviderTVC.h"
#import "ProviderCell.h"
#import "ParseDataFormatter.h"
#import <Parse/Parse.h>

@interface SelectProviderTVC ()

@end

@implementation SelectProviderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Select Provider";
    self.tableView.tableFooterView = [[UIView alloc] init];
    [[ParseDataFormatter sharedInstance] queryProviderType:_providerType];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProviders) name:@"reloadProviders" object:nil];
    
    NSLog(@"eeeee: %@", _providerType);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadProviders
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [ParseDataFormatter sharedInstance].providersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        // return your normal height here:
        return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"providerCell";
    ProviderCell* postingCell = (ProviderCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[ProviderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    postingCell.contentView.frame = postingCell.bounds;
//    postingCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    PFObject *provider = [[ParseDataFormatter sharedInstance].providersArray objectAtIndex:indexPath.row];
    
    postingCell.providerImage.layer.cornerRadius =  30;
    postingCell.providerImage.layer.masksToBounds = YES;
    
    postingCell.name.text = [NSString stringWithFormat:@"Dr. %@ %@",provider[@"firstName"], provider[@"lastName"]];
    postingCell.specialty.text = [NSString stringWithFormat:@"%@",provider[@"speciality"]];
//    postingCell.priceLabel.text = [NSString stringWithFormat:@"$%@", [car[@"price"] stringValue]];
    postingCell.cityState.text = [NSString stringWithFormat:@"%@, %@", provider[@"city"], provider[@"state"]];
    postingCell.distance.text = [NSString stringWithFormat:@"%@ mi away", provider[@"miles"]];
    
    
    postingCell.phoneButton.tag = indexPath.row;
    [postingCell.phoneButton addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    postingCell.formButton.tag = indexPath.row;
    [postingCell.formButton addTarget:self action:@selector(formButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//
//    if ([postingCell.carType.text isEqualToString:@"Exotic"]) {
//        postingCell.carType.backgroundColor = [UIColor colorWithRed:112.0/255.0 green:199.0/255.0 blue:53.0/255.0 alpha:1.0];
//    }
//    else
//    {
//        postingCell.carType.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:155.0/255.0 blue:220.0/255.0 alpha:1.0];
//    }
    
    PFFile *imageFile = [provider objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:result];
            postingCell.providerImage.image = image;
           // [imageArray addObject:image];
        }
    }];
    
    return postingCell;
}

-(void)phoneButtonPressed:(UIButton*)sender
{
    PFObject *provider = [[ParseDataFormatter sharedInstance].providersArray objectAtIndex:sender.tag];
    ;
    
    NSString *title = [NSString stringWithFormat:@"Call Dr. %@", provider[@"lastName"]];
    NSString *message = [NSString stringWithFormat:@"%@", provider[@"phone"]];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Call"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", provider[@"phone"]]]];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
   
}

-(void)formButtonPressed:(UIButton*)sender{
    [self performSegueWithIdentifier:@"showForm" sender:self];
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
