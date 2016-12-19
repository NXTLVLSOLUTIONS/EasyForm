//
//  PatientInfoView.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/11/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "PatientInfoView.h"
#import "ParseDataFormatter.h"

@interface PatientInfoView ()

@end


const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;
const static CGFloat kJVFieldFontSize = 13.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@implementation PatientInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTextFields];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupTextFields{
    
    PFUser *user = [PFUser currentUser];
    
    UIColor *floatingLabelColor = [UIColor lightGrayColor];
    
    _nameTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _nameTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"First Name", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _nameTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _nameTextField.floatingLabelTextColor = floatingLabelColor;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _nameTextField.keepBaseline = YES;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.delegate = self;
    _nameTextField.text =user[@"firstName"];
    
    _lastTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _lastTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Last Name", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _lastTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _lastTextField.floatingLabelTextColor = floatingLabelColor;
    _lastTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _lastTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _lastTextField.keepBaseline = YES;
    _lastTextField.returnKeyType = UIReturnKeyNext;
    _lastTextField.delegate = self;
    _lastTextField.text = user[@"lastName"];
    
    //  UIView *div1 = [UIView new];
    //  div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    //  [self.view addSubview:div1];
    //  div1.translatesAutoresizingMaskIntoConstraints = NO;
    
    _phoneTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _phoneTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Phone Number", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _phoneTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _phoneTextField.floatingLabelTextColor = floatingLabelColor;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.delegate = self;
    _phoneTextField.returnKeyType = UIReturnKeyNext;
    _phoneTextField.tag =1;
    _phoneTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _phoneTextField.keepBaseline = YES;
    
    _emailTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _emailTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email Address", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _emailTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _emailTextField.floatingLabelTextColor = floatingLabelColor;
    _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _emailTextField.keepBaseline = YES;
    _emailTextField.returnKeyType = UIReturnKeyNext;
    _emailTextField.delegate = self;
    
    
    _addressTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _addressTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Home Address", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _addressTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _addressTextField.floatingLabelTextColor = floatingLabelColor;
    _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _addressTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _addressTextField.keepBaseline = YES;
    _addressTextField.returnKeyType = UIReturnKeyNext;
    _addressTextField.delegate = self;
    
    
    _cityTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _cityTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"City", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _cityTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _cityTextField.floatingLabelTextColor = floatingLabelColor;
    _cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _cityTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _cityTextField.keepBaseline = YES;
    _cityTextField.returnKeyType = UIReturnKeyNext;
    _cityTextField.delegate = self;
    
    
    _stateTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _stateTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"State", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _stateTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _stateTextField.floatingLabelTextColor = floatingLabelColor;
    _stateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _stateTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _stateTextField.keepBaseline = YES;
    
    _zipTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _zipTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Zip code", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _zipTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _zipTextField.floatingLabelTextColor = floatingLabelColor;
    _zipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _zipTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _zipTextField.keepBaseline = YES;
    _zipTextField.delegate = self;
    _zipTextField.tag = 3;
    _zipTextField.returnKeyType = UIReturnKeyNext;
    
    
    _ssnTextField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _ssnTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Social Security Number", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _ssnTextField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _ssnTextField.floatingLabelTextColor = floatingLabelColor;
    _ssnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:titleField];
    _ssnTextField.delegate = self;
    _ssnTextField.tag = 2;
    _ssnTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _ssnTextField.keepBaseline = YES;
    _ssnTextField.returnKeyType = UIReturnKeyNext;
    
    //    UIView *div1 = [UIView new];
    //    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    //    [self.view addSubview:div1];
    //    div1.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_phoneTextField addTarget:self action:@selector(phoneChanged) forControlEvents:UIControlEventEditingChanged];
    [_zipTextField addTarget:self action:@selector(zipChanged) forControlEvents:UIControlEventEditingChanged];
    
    // [_nameTextField becomeFirstResponder];
    //[self configureStateButton];
    self.singlePickerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
        return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
            i2KEPCSingleComponentPickerView *singleComponentPickerView = [[i2KEPCSingleComponentPickerView alloc]
                                                                          initWithTitle:@"Select State"
                                                                          valuesArray:@[ @"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY" ]
                                                                          initialValueIndex:0];
            
            [[singleComponentPickerView valueSignal] subscribeNext:^(RACTuple *x) {
                //@strongify(self);
                //self.selectedIndexSingle = [x.first integerValue];
                self.selectedValueSingle = x.second;
                [self.singlePickerButton setTitle:_selectedValueSingle forState:UIControlStateNormal];
                [self.singlePickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_zipTextField becomeFirstResponder];
            }];
            
            [singleComponentPickerView showPicker];
            
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}



-(void)phoneChanged
{
    NSLog(@"LENGTH: %lu",_phoneTextField.text.length ) ;
    
    if (_phoneTextField.text.length ==14) {
        [_phoneTextField resignFirstResponder];
        [_emailTextField becomeFirstResponder];
    }
}

-(void)zipChanged
{
    NSLog(@"LENGTH: %lu",_zipTextField.text.length ) ;
    
    if (_zipTextField.text.length ==5) {
        [_zipTextField resignFirstResponder];
        [_ssnTextField becomeFirstResponder];
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 1)  //Phone number
    {
        int length = (int)[self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        //        if (range.location ==13) {
        //            [_phoneTextField resignFirstResponder];
        //            [_emailTextField becomeFirstResponder];
        //        }
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    else if (textField.tag == 2) //SSN
    {
        if (range.location == 11)    //this is calculate the overall string
        {
            return NO;
        }
        
        if ([string length] == 0)   //string length is `0` hide the keyboard
        {
            return YES;
        }
        
        if ((range.location == 3) || (range.location == 6))    //apply the `-` between the overall string
        {
            NSString *str  = [NSString stringWithFormat:@"%@-",textField.text];
            textField.text = str;
        }
        //[formatter setLenient:YES];
    }
    else if (textField.tag == 3)
    {
        if (range.location == 5)    //this is calculate the overall string
        {
            return NO;
        }
    }
    
    return YES;
}

- (NSString *)formatNumber:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}

- (int)getLength:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    return length;
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
