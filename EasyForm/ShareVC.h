//
//  ShareVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 9/25/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShareVC : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)fbButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)messengerButtonPressed:(id)sender;
- (IBAction)imessageButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;

@end
