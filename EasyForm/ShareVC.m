//
//  ShareVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 9/25/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "ShareVC.h"
#import "Constants.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>


static NSString * const shareText = @"Try out EasyForm! The fastest way to fill out forms for any business! Bit.ly/EasyForm";

@interface ShareVC ()

@end

@implementation ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Share";
    
    [_shareButton addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.layer.borderWidth = 1.0f;
    _shareButton.layer.borderColor = EASY_BLUE.CGColor;
    _shareButton.layer.cornerRadius = 5.0f;
    _shareButton.layer.masksToBounds = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)shareButtonTapped{

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fbButtonPressed:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [slComposeViewController setInitialText:shareText];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    } else {
        //Show alert or in some way handle the fact that the device does not support this feature
          [self showAlert:@"No Facebook Account Found" desc:@"Facebook"];
        
    }
}
- (IBAction)twitterButtonPressed:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [slComposeViewController setInitialText:shareText];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    } else {
        //Show alert or in some way handle the fact that the device does not support this feature
        [self showAlert:@"No Twitter Account Found" desc:@"Twitter"];
        
    }
}

- (IBAction)messengerButtonPressed:(id)sender {
}

- (IBAction)imessageButtonPressed:(id)sender {
    
        MFMessageComposeViewController* messageComposer = [MFMessageComposeViewController new];
        messageComposer.messageComposeDelegate = self;
        [messageComposer setBody:shareText];
        [self presentViewController:messageComposer animated:YES completion:nil];
}

- (IBAction)emailButtonPressed:(id)sender {
    
  //  UIImage *image = [UIImage imageNamed:@"EasyE1"];
    MFMailComposeViewController *emailComposer = [MFMailComposeViewController new];
    emailComposer.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [emailComposer setMessageBody:shareText isHTML:NO];
        
//        NSData *imageData = UIImagePNGRepresentation(image);
//        [emailComposer addAttachmentData:imageData  mimeType:@"image/jpeg" fileName:@"image.jpg"];
        [self presentViewController:emailComposer animated:YES completion:nil];
    }
}

#pragma mark - EmailComposerDelegate methods


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) showAlert:(NSString*) title desc: (NSString*) desc {
    
    NSString *description = [NSString stringWithFormat:@"Please add a %@ account in settings in order to share using %@",desc , desc];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:description
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];

    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
