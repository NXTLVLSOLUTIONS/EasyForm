//
//  PaymentMethodTVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 7/23/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "PaymentMethodTVC.h"
#import "PaymentCell.h"
#import "ParseDataFormatter.h"
#import "EditPaymentVC.h"

@interface PaymentMethodTVC ()
{
    BOOL applePayEnabled;
    PFObject *cardSelectedObject;
}

@end

@implementation PaymentMethodTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Payment";
    self.tableView.tableFooterView = [[UIView alloc] init];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPayments) name:@"reloadPayments" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryPayments) name: @"QueryPayments" object:nil];
  
}

-(void)viewWillAppear:(BOOL)animated{
    applePayEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"applepay"];
    
    [[ParseDataFormatter sharedInstance].paymentsArray removeAllObjects];
    [[ParseDataFormatter sharedInstance] queryPayments];
//    
//    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(beginEdit)];
//    
//    self.navigationItem.rightBarButtonItem = btnCancel;
}

-(void)queryPayments{
   //  [[ParseDataFormatter sharedInstance].paymentsArray removeAllObjects];
   // [self.tableView reloadData];
    // [[ParseDataFormatter sharedInstance] queryPayments];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        cell.selectionStyle = (self.editing && (path.row > 1 || path.section == 0)) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
    }
}

-(void)reloadPayments
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ParseDataFormatter sharedInstance].paymentsArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section ==  [ParseDataFormatter sharedInstance].paymentsArray.count) {
           [self performSegueWithIdentifier:@"addPayment" sender:self];
    }
    else{
         cardSelectedObject = [[ParseDataFormatter sharedInstance].paymentsArray objectAtIndex:indexPath.section];
         [self performSegueWithIdentifier:@"editCard" sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"paymentCell";
    PaymentCell* postingCell = (PaymentCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[PaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [postingCell.layer setCornerRadius:7.0f];
    [postingCell.layer setMasksToBounds:YES];
    [postingCell.layer setBorderWidth:0.5f];
     postingCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [postingCell.image.layer setCornerRadius:3.0f];
    [postingCell.image.layer setMasksToBounds:YES];
    [postingCell.image.layer setBorderWidth:0.5f];
    
    if (indexPath.section !=  [ParseDataFormatter sharedInstance].paymentsArray.count) {
          [postingCell.image.layer setBorderWidth:0.0f];
        if (indexPath.section == [ParseDataFormatter sharedInstance].paymentsArray.count-1 &&  applePayEnabled) {
            postingCell.title.text = @"APPLE PAY";
            postingCell.image.image = [UIImage imageNamed:@"applepay"];
        }
        else{
            PFObject *card = [[ParseDataFormatter sharedInstance].paymentsArray objectAtIndex:indexPath.section];
            postingCell.title.text = [NSString stringWithFormat:@"PERSONAL •••• %@",card[@"lastFour"]];
            postingCell.containsImage = YES;
            postingCell.image.image = [self setCardTypeImage:card[@"cardType"]];
            postingCell.image.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    else{
        postingCell.title.text = @"ADD PAYMENT";
        postingCell.image.image = [UIImage imageNamed:@"plusbutton"];
    }
    // postingCell.backgroundColor = postingCell.backgroundColor;
   // postingCell.backgroundColor = EASY_BLUE;
    
    return postingCell;
}

-(UIImage*)setCardTypeImage: (NSString*)cardType{
    UIImage *cardImage;
    if ([cardType isEqualToString:@"VISA"]) {
        cardImage = [UIImage imageNamed:@"Visa"];
    }
    if ([cardType isEqualToString:@"DISCOVER"]) {
        cardImage = [UIImage imageNamed:@"Discover"];
    }
    if ([cardType isEqualToString:@"MASTERCARD"]) {
        cardImage = [UIImage imageNamed:@"Mastercard"];
    }
    if ([cardType isEqualToString:@"AMEX"]) {
        cardImage = [UIImage imageNamed:@"AmericanExpress"];
    }
    return cardImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // return your normal height here:
    return 40.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor whiteColor]];
    
//    if(cell.backgroundView==nil){
//        UIImageView *cellBgView =[[UIImageView alloc]init];
//        [cellBgView setImage:[UIImage imageNamed:@"EasyE"]];
//        [cell setBackgroundView:cellBgView];
//    }
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"editCard"])
    {
        EditPaymentVC *vc=[segue destinationViewController];
        vc.card = cardSelectedObject;
    }
}


@end
