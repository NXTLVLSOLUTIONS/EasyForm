//
//  MyCardsTVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 7/23/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "MyCardsTVC.h"
#import "MyCardsCell.h"
#import "ParseDataFormatter.h"
#import "Constants.h"

@interface MyCardsTVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
      UIImagePickerController *imagePickerController;
}

@end

@implementation MyCardsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"My Cards";
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setupCameraView];
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name: @"reloadCards" object:nil];
}


-(void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"MyCardsCell";
    MyCardsCell* postingCell = (MyCardsCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (postingCell == nil) {
        postingCell = [[MyCardsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            postingCell.title.text = @"Drivers License";
            if ([ParseDataFormatter sharedInstance].userLicenseImage == nil) {
                postingCell.image.image = [UIImage imageNamed:@"car"];
            }
            else{
                postingCell.image.image = [ParseDataFormatter sharedInstance].userLicenseImage ;
                postingCell.image.layer.cornerRadius = 3;
                postingCell.image.layer.masksToBounds = NO;
                postingCell.image.layer.borderColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.borderWidth = 0.5;
                postingCell.image.layer.shadowColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
                postingCell.image.layer.shadowOpacity = 0.5f;
                postingCell.image.layer.shadowRadius = 2.0f;
                postingCell.subtitle.text = @"Added Today";
                postingCell.plusView.hidden = YES;
                postingCell.containsImage =YES;
                [postingCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            }
        }
            break;
        case 1:
        {
            postingCell.title.text = @"Insurance Card";
            if ([ParseDataFormatter sharedInstance].userInsuranceImage == nil) {
                postingCell.image.image = [UIImage imageNamed:@"id-card-1"];
            }
            else{
                postingCell.image.image = [ParseDataFormatter sharedInstance].userInsuranceImage ;
                postingCell.image.layer.cornerRadius = 3;
                postingCell.image.layer.masksToBounds = NO;
                postingCell.image.layer.borderColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.borderWidth = 0.5;
                postingCell.image.layer.shadowColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
                postingCell.image.layer.shadowOpacity = 0.5f;
                postingCell.image.layer.shadowRadius = 2.0f;
                postingCell.subtitle.text = @"Added Today";
                postingCell.plusView.hidden = YES;
                postingCell.containsImage =YES;
                [postingCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            }
        }
            break;
        case 2:
        {
            postingCell.title.text = @"Discount Card";
            if ([ParseDataFormatter sharedInstance].userDiscountImage == nil) {
                postingCell.image.image = [UIImage imageNamed:@"percentage"];
            }
            else{
                postingCell.image.image = [ParseDataFormatter sharedInstance].userDiscountImage ;
                postingCell.image.layer.cornerRadius = 3;
                postingCell.image.layer.masksToBounds = NO;
                postingCell.image.layer.borderColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.borderWidth = 0.5;
                postingCell.image.layer.shadowColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
                postingCell.image.layer.shadowOpacity = 0.5f;
                postingCell.image.layer.shadowRadius = 2.0f;
                postingCell.subtitle.text = @"Added Today";
                postingCell.plusView.hidden = YES;
                postingCell.containsImage =YES;
                [postingCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            }
        }
            break;
        case 3:
        {
            postingCell.title.text = @"State ID";
            if ([ParseDataFormatter sharedInstance].userIdImage == nil) {
                postingCell.image.image = [UIImage imageNamed:@"id-card-2"];
            }
            else{
                postingCell.image.image = [ParseDataFormatter sharedInstance].userIdImage ;
                postingCell.image.layer.cornerRadius = 3;
                postingCell.image.layer.masksToBounds = NO;
                postingCell.image.layer.borderColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.borderWidth = 0.5;
                postingCell.image.layer.shadowColor = [UIColor blackColor].CGColor;
                postingCell.image.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
                postingCell.image.layer.shadowOpacity = 0.5f;
                postingCell.image.layer.shadowRadius = 2.0f;
                postingCell.subtitle.text = @"Added Today";
                postingCell.plusView.hidden = YES;
                postingCell.containsImage =YES;
                [postingCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            }
        }
            break;
            
        default:
            break;
    }
    
    return postingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
           [ParseDataFormatter sharedInstance].idType = ImageTypeLicense;
            
            if ([ParseDataFormatter sharedInstance].userLicenseImage) {
                [self performSegueWithIdentifier:@"ShowCard" sender:self];
            }
            else{
                [self addCardButtonTapped];
            }
  
        }
            break;
        case 1:
        {
            [ParseDataFormatter sharedInstance].idType = ImageTypeInsurance;
            
            if ([ParseDataFormatter sharedInstance].userInsuranceImage) {
                [self performSegueWithIdentifier:@"ShowCard" sender:self];
            }
            else{
                [self addCardButtonTapped];
            }
            
        }
            break;
        case 2:
        {
            [ParseDataFormatter sharedInstance].idType = ImageTypeDiscount;
            
            if ([ParseDataFormatter sharedInstance].userDiscountImage) {
                [self performSegueWithIdentifier:@"ShowCard" sender:self];
            }
            else{
                [self addCardButtonTapped];
            }
            
        }
            break;
        case 3:
        {
            [ParseDataFormatter sharedInstance].idType = ImageTypeId;
            
            if ([ParseDataFormatter sharedInstance].userIdImage) {
                [self performSegueWithIdentifier:@"ShowCard" sender:self];
            }
            else{
                [self addCardButtonTapped];
            }
            
        }
            break;
            
        default:
            break;
    }
    
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

-(void) setupCameraView{
    // Do any additional setup after loading the view, typically from a nib.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = NO;
        imagePickerController.delegate = self;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
        imgView.image = [UIImage imageNamed:@"cardScanOverlay"];
        
        // Device *device = [Device currentDevice];
        CGFloat y;
        if ([ParseDataFormatter sharedInstance].isIphone6) {
            y=180;
        }
        else
        {
            y=120;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 130, y, 260, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Place card in the frame below";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"ArialMT" size:14];
        [imgView addSubview:label];
        
        imagePickerController.cameraOverlayView = imgView;
    }
}


-(void) addCardButtonTapped{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.cameraViewTransform = CGAffineTransformTranslate(imagePickerController.cameraViewTransform, 0.0, 37.0);
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark- UIImagePickerController Delegate Method.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        //currentVisitor.business_card_image = originalImage;
    }
    else
    {
        UIImage *cardImage = [self cropImage:originalImage];
        
        [[ParseDataFormatter sharedInstance] saveIdImage:cardImage idType:[ParseDataFormatter sharedInstance].idType];

        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (UIImage *)cropImage:(UIImage *)oldImage {
    CGSize imageSize = oldImage.size;
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( imageSize.width-650, imageSize.height - 2150), NO, 0.0);
    [oldImage drawAtPoint:CGPointMake(-325, -1075+40) blendMode:kCGBlendModeCopy alpha:1];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

@end
