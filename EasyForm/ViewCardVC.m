//
//  ViewCardVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "ViewCardVC.h"
#import "ParseDataFormatter.h"

@interface ViewCardVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
      UIImagePickerController *imagePickerController;
}

@end

@implementation ViewCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadCard];
    [self setupCameraView];
    _cardImage.layer.cornerRadius = 10;
    _cardImage.layer.masksToBounds = YES;
    _cardImage.layer.borderColor = [UIColor blackColor].CGColor;
    _cardImage.layer.borderWidth = 1.0;
    _cardImage.layer.shadowColor = [UIColor blackColor].CGColor;
    _cardImage.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    _cardImage.layer.shadowOpacity = 0.5f;
    _cardImage.layer.shadowRadius = 2.0f;
    
    
    _deleteButton.layer.cornerRadius = 3;
    _deleteButton.layer.masksToBounds = NO;
    _deleteButton.layer.borderColor = [UIColor colorWithRed:226/255.0 green:40/255.0 blue:55/255.0 alpha:1.0].CGColor;
    _deleteButton.layer.borderWidth = 0.5;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 70, 30)];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addCardButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = NO;
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = leftItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCard) name: @"reloadCards" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popView) name: @"cardDeleted" object:nil];
    
    [_deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loadCard{
    switch ([ParseDataFormatter sharedInstance].idType) {
        case ImageTypeLicense:
            self.title = @"Drivers License";
            _cardImage.image = [ParseDataFormatter sharedInstance].userLicenseImage;
            break;
        case ImageTypeInsurance:
            self.title = @"Insurance Card";
            _cardImage.image = [ParseDataFormatter sharedInstance].userInsuranceImage;
            break;
        case ImageTypeDiscount:
            self.title = @"Discount Card";
            _cardImage.image = [ParseDataFormatter sharedInstance].userDiscountImage;
            break;
        case ImageTypeId:
            self.title = @"Id Card";
            _cardImage.image = [ParseDataFormatter sharedInstance].userIdImage;
            break;
            
        default:
            break;
    }
}

-(void)deleteButtonTapped
{
    [[ParseDataFormatter sharedInstance] deleteCard];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
