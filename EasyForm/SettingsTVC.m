//
//  SettingsTVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "SettingsTVC.h"
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>

@interface SettingsTVC ()

@end

@implementation SettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Settings";
//    
//    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Logout"
//                                   style:UIBarButtonItemStyleBordered
//                                   target:self
//                                   action:@selector(flipView:)];
//    flipButton.
//    self.navigationItem.rightBarButtonItem = flipButton;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(0, 0, 70, 30)];
//    [button setTitle:@"Logout" forState:UIControlStateNormal];
//    button.layer.borderWidth = 1.0f;
//    button.layer.borderColor = [UIColor whiteColor].CGColor;
//    button.layer.cornerRadius = 5.0f;
//    button.layer.masksToBounds = NO;
//    
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    self.navigationItem.rightBarButtonItem = leftItem;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logOutUser)];
    
    self.navigationItem.rightBarButtonItem = btnCancel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) logOutUser{
    Digits *digits = [Digits sharedInstance];
    [digits logOut];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setLoginViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
        if (indexPath.row == 0 || indexPath.row == 2) {
            [self sendToEmail];
        }
}


#pragma mark - EmailComposerDelegate methods

//Opens the email composer with a nice pre-defined message
-(void) sendToEmail
{
    MFMailComposeViewController *emailComposer = [MFMailComposeViewController new];
    emailComposer.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [emailComposer setToRecipients: [NSArray arrayWithObject:@"support@easyform.us"]];
        [self presentViewController:emailComposer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50.0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
