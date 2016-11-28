//
//  DescribeConditionVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 6/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "DescribeConditionVC.h"
#import "DrawPadViewController.h"
#import "UIView+MJAlertView.h"

@interface DescribeConditionVC ()

@end

@implementation DescribeConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"Describe Condition";
    [self initCapture];
    
    
    _conditionTextFIeld.layer.borderColor = [UIColor grayColor].CGColor;
    _conditionTextFIeld.layer.borderWidth = 0.5;
    [_conditionTextFIeld becomeFirstResponder];
    
    [_addPhotoButton addTarget:self action:@selector(addPhotoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInjuryPhoto:) name:@"imageAdded" object:nil];
    
    
    CGRect frameimg = CGRectMake(0, 0, 56 , 30);
    UIButton* _goButton = [[UIButton alloc] initWithFrame:frameimg];
    [_goButton setTitle:@"Done" forState:UIControlStateNormal];
    [_goButton addTarget:self action:@selector(doneButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [_goButton setShowsTouchWhenHighlighted:YES];
    _goButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _goButton.layer.borderWidth = 1.0;
    _goButton.layer.cornerRadius = 8;
    _goButton.layer.masksToBounds = YES;
    
    UIBarButtonItem *gbutton =[[UIBarButtonItem alloc] initWithCustomView:_goButton];
    self.navigationItem.rightBarButtonItem=gbutton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    // self.navigationController.navigationBar.topItem.title = @"";
    [_conditionTextFIeld becomeFirstResponder];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
}

-(void)loadInjuryPhoto:(NSNotification*)notification
{
    // UIView* newImage = [UIView]i
    _addPhotoButton.alpha = 1.0;
    imageWithDrawing = notification.userInfo[@"editedImage"] ;
    [_addPhotoButton setImage:imageWithDrawing forState:UIControlStateNormal];
}

-(void)doneButtonPressed{
//    UIImage *image = [self getImageFromCanvas];
//
    
    if (_conditionTextFIeld.text.length == 0) {
        [_conditionTextFIeld resignFirstResponder];
        [UIView addMJNotifierWithText:@"Please add a description" dismissAutomatically:YES];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showKeyboard) userInfo:nil repeats:NO];
    }
    else{
        if (imageWithDrawing != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"descriptionComplete" object:self
                                                              userInfo:@{ @"editedImage" : imageWithDrawing,
                                                                          @"description" : _conditionTextFIeld.text}];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"descriptionComplete" object:self
                                                              userInfo:@{@"description" : _conditionTextFIeld.text}];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void)showKeyboard
{
    [_conditionTextFIeld becomeFirstResponder];
}

- (void)initCapture
{
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (!captureInput) {
        return;
    }
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    /* captureOutput:didOutputSampleBuffer:fromConnection delegate method !*/
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    captureSession = [[AVCaptureSession alloc] init];
    NSString* preset = 0;
    if (!preset) {
        preset = AVCaptureSessionPresetMedium;
    }
    captureSession.sessionPreset = preset;
    if ([captureSession canAddInput:captureInput]) {
        [captureSession addInput:captureInput];
    }
    if ([captureSession canAddOutput:captureOutput]) {
        [captureSession addOutput:captureOutput];
    }
    
    //handle prevLayer
    if (!captureVideoPreviewLayer) {
        captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    }
    
    //if you want to adjust the previewlayer frame, here!
    captureVideoPreviewLayer.frame = self.videoView.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.videoView.layer addSublayer: captureVideoPreviewLayer];
    [captureSession startRunning];
}


-(void)addPhotoButtonPressed
{
    [captureSession stopRunning];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = NO;
    //picker.extendedLayoutIncludesOpaqueBars = YES;
    [self presentViewController: picker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [captureSession stopRunning];
//    captureVideoPreviewLayer = nil;
////    UIImage *returnedImage = nil;
    // _photoView.image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
//    [_addPhotoButton setImage: returnedImage forState:UIControlStateNormal];
//    _addPhotoButton.alpha = 1.0;
//    [_addPhotoButton setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.videoView = nil;
    captureVideoPreviewLayer = nil;
    
    injuryPhoto =  [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:@"goToDrawPad" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Send the current brush size and color data to the brush menu view controller
    DrawPadViewController* vc = [segue destinationViewController];
    vc.originalImage = injuryPhoto;
}


@end
