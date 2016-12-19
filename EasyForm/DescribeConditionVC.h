//
//  DescribeConditionVC.h
//  EasyForm
//
//  Created by Rahiem Klugh on 6/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "AVFoundation/AVCaptureVideoPreviewLayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import "AVFoundation/AVCaptureSession.h"
#import "AVFoundation/AVCaptureOutput.h"
#import "AVFoundation/AVCaptureDevice.h"
#import "AVFoundation/AVCaptureInput.h"
#import "AVFoundation/AVMediaFormat.h"

@interface DescribeConditionVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
     AVCaptureSession* captureSession;
     AVCaptureVideoPreviewLayer* captureVideoPreviewLayer;
     UIImage* injuryPhoto;
     UIImage* imageWithDrawing;
}
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UITextField *conditionTextFIeld;
@property (strong, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;

@end
