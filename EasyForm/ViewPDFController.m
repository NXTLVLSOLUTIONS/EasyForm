//
//  ViewPDFController.m
//  EasyForm
//
//  Created by Rahiem Klugh on 9/26/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "ViewPDFController.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"
#import "ParseDataFormatter.h"
#import "SignatureVC.h"
#import "TESignatureView.h"
#import "KLCPopup.h"
#import "Constants.h"

#define CANCEL_RED [UIColor colorWithRed:226.0/255 green:40.0/255 blue:55.0/255 alpha:1]

@interface ViewPDFController (){
    ILPDFDocument *document;
    TESignatureView *signtureView;
    KLCPopup* popup;
    UIImage* userSignatureImage;
    UIBarButtonItem *btnSend;
}

@end

@implementation ViewPDFController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"New Form";
    
    document = [[ILPDFDocument alloc] initWithData:_pdfData];
    self.document = document;
    
    btnSend = [[UIBarButtonItem alloc] initWithTitle:@"Sign Form" style:UIBarButtonItemStyleDone target:self action:@selector(showAlertView)];
    
    self.navigationItem.rightBarButtonItem = btnSend;
}

-(void)viewWillAppear:(BOOL)animated{
    
   // UIScrollView *sv = (UIScrollView*)self.view;//[[self.view subviews] objectAtIndex:0];
  //  [sv zoomToRect:CGRectMake(100, 100, sv.contentSize.width, sv.contentSize.height) animated:YES];
   // UIScrollView * sv = document.scrollView;
  //  [sv setZoomScale:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showAlertView{
    
    if ([btnSend.title isEqualToString:@"Send Form"]) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"SEND EASYFORM"
                                      message:@"Your form will be sent to your selected provider. Are you sure you want to submit your form?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self savePDF];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"SIGN EASYFORM"
                                      message:@"Are you sure you want to sign your form?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self showSignature];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil]; 
    }
}

-(void)savePDF{
    [KVNProgress show];
    
    NSData* flatPDF = [document savedStaticPDFData];
    NSString *base64pdfString = [flatPDF base64EncodedStringWithOptions:0];
    
    NSString *emailAddress;
    
    if (_providerEmail == nil) {
        emailAddress = @"support@easyform.us";
    }
    else{
        emailAddress = _providerEmail;
    }
    [PFCloud callFunctionInBackground:@"email" withParameters:@{@"email": emailAddress, @"text": @"Congratulations, You have a new EasyForm!", @"content": base64pdfString} block:^(NSString *result, NSError *error) {
        if (error) {
            //error 
            [KVNProgress dismiss];
        } else {
            NSLog(@"result :%@", result);
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EasyFormCreated" object:nil];
        }
    }];
}



-(void)showSignature
{
    [self.view endEditing:YES];
    SignatureVC *aVCObject = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"@Signature"];
    
    UIView *myUIViewControllerView = aVCObject.view;
    [myUIViewControllerView.layer setCornerRadius:30.0f];
    
    
    
    if ([ParseDataFormatter sharedInstance].isIphone6) {
        myUIViewControllerView.frame = CGRectMake(0, 0, 550.0, 300.0);
        signtureView =[[TESignatureView alloc]initWithFrame:CGRectMake(12, 65, 525, 178)];
    }
    else{
        myUIViewControllerView.frame = CGRectMake(0, 0, 500.0, 300.0);
        signtureView =[[TESignatureView alloc]initWithFrame:CGRectMake(12, 65, 525, 150)];
    }
    
    signtureView.backgroundColor = [UIColor whiteColor];
    [myUIViewControllerView addSubview:signtureView];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(25, 251, 75, 35)];
    [cancelButton setTitleColor:CANCEL_RED forState:UIControlStateNormal];
    //[cancelButton setTitleColor:[[cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [myUIViewControllerView addSubview:cancelButton];
    
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(450, 251, 75, 35)];
    if (![ParseDataFormatter sharedInstance].isIphone6) {
        [doneButton setFrame:CGRectMake(425, 251, 75, 35)];
    }
    [doneButton setTitleColor:EASY_BLUE forState:UIControlStateNormal];
    //[doneButton setTitleColor:[[doneButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [myUIViewControllerView addSubview:doneButton];
    
    myUIViewControllerView.transform = CGAffineTransformMakeRotation(M_PI_2);
    // Show in popup
    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupVerticalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupHorizontalLayoutCenter);
    
    popup = [KLCPopup popupWithContentView:myUIViewControllerView
                                  showType:KLCPopupShowTypeBounceInFromBottom
                               dismissType:KLCPopupDismissTypeBounceOutToBottom
                                  maskType:KLCPopupMaskTypeDimmed
                  dismissOnBackgroundTouch:YES
                     dismissOnContentTouch:NO];
    
    
    [popup showWithLayout:layout];
}

#pragma mark- SignDelegate Method
-(void)cancelButtonPressed
{
    [popup dismiss:YES];
}

-(void)doneButtonPressed
{
    [popup dismiss:YES];
    userSignatureImage =  [self resizeImage:[signtureView getSignatureImage]];
    //document.signature = userSignatureImage;
    
    [self showPDFFile];
   // [[ParseDataFormatter sharedInstance] saveSignatureImage:userSignatureImage];
}

-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

-(void)showPDFFile
{
    btnSend.title = @"Send Form";
    NSData* flatPDF = [document savedStaticPDFData];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    [webView setScalesPageToFit:YES];
    [webView loadData:flatPDF MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    
    [self.view addSubview:webView];
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
