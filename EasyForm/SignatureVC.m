//
//  SignatureVC.m
//  forms
//
//  Created by rahiem.klugh on 5/18/16.
//  Copyright © 2016 rahiem.klugh. All rights reserved.
//

#import "SignatureVC.h"
#import "TESignatureView.h"
#import "KLCPopup.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"
#import "EasyFormVC.h"


@interface SignatureVC ()
{
    KLCPopup* popup;
    UIImage* userSignatureImage;
    __weak IBOutlet TESignatureView *signtureView;
}
@end

  SignatureVC *aVCObject;

@implementation SignatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- SignDelegate Method
-(void)successfullyCapturedSignature:(UIImage *)signatureImage{
    
    userSignatureImage = signatureImage;
}

-(IBAction)resetButtonPressed:(id)sender {
    
    [signtureView clearSignature];
    
}

-(IBAction)cancelButtonPressed:(id)sender {
    
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
}

-(IBAction)doneButtonPressed:(id)sender {
    // Do additional task..
    UIImageWriteToSavedPhotosAlbum([signtureView getSignatureImage], nil, nil, nil);
    [KVNProgress show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if ([sender isKindOfClass:[UIView class]]) {
            [(UIView*)sender dismissPresentingPopup];
        }
        [KVNProgress dismissWithCompletion:^{
            [KVNProgress showSuccessWithStatus:@"Submitted"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"contentController"];
//                [self presentViewController:vc animated:YES completion:nil];
                [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];
            
            });
            
        }];
        
    });

}



-(void)showSignature
{
    aVCObject = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"@Signature"];
    [aVCObject.view.layer setCornerRadius:30.0f];
    aVCObject.view.frame = CGRectMake(0, 0, 550.0, 300.0);
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        //aVCObject.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }else{
        
       aVCObject.view.transform = CGAffineTransformMakeRotation(M_PI_2);

    }

    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupVerticalLayoutCenter,(KLCPopupVerticalLayout)KLCPopupHorizontalLayoutCenter);
    
    popup = [KLCPopup popupWithContentView:aVCObject.view
                                  showType:KLCPopupShowTypeBounceInFromBottom
                               dismissType:KLCPopupDismissTypeBounceOutToBottom
                                  maskType:KLCPopupMaskTypeDimmed
                  dismissOnBackgroundTouch:YES
                     dismissOnContentTouch:NO];
    
    
    [popup showWithLayout:layout];
}

@end
