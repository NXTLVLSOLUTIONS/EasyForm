//
//  AddPaymentVC.m
//  EasyForm
//
//  Created by Rahiem Klugh on 8/18/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

#import "AddPaymentVC.h"
#import "VJCreditCardValidations.h"
#import "CardIO.h"
#import "StripePayments.h"
#import <Stripe/Stripe.h>
#import "ParseDataFormatter.h"

@interface AddPaymentVC () <CardIOPaymentViewControllerDelegate>
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    NSString *newCardString;
    NSString *newMonthString;
    NSString *newCVVString;

}

@end

@implementation AddPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Add Payment";
    
    _cardView.layer.cornerRadius = 5;
    _cardView.layer.masksToBounds = NO;
    _cardView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cardView.layer.borderWidth = 0.5;
    
    _otherView.layer.cornerRadius = 5;
    _cardView.layer.masksToBounds = NO;
   // _cardView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // _cardView.layer.borderWidth = 0.5;
    _cardTextField.delegate = self;
    _monthYear.delegate = self;
    _cvv.delegate = self;
    
    //self.applePayButton.enabled = [Stripe deviceSupportsApplePay];
    [_applePayButton addTarget:self action:@selector(applePayPressed)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Add Card" style:UIBarButtonItemStyleDone target:self action:@selector(addCardButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = btnCancel;
    
    [_cardTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardAdded) name: @"cardAdded" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)applePayPressed{

    if ( [PKPassLibrary isPassLibraryAvailable] )
    {
        if ( ![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:[NSArray arrayWithObjects: PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa,PKPaymentNetworkDiscover, nil]] )
        {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Add a Credit Card to Wallet"
                                          message:@"Would you like to add a credit card to your wallet now?"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     PKPassLibrary* lib = [[PKPassLibrary alloc] init];
                                     [lib openPaymentSetup];
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
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"applepay"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)cardAdded{
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
 
    if (textField.tag == 1) {
        __block NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        newCardString = newString;
       // [self validateCardInfo];
        
        if (newString.length == 19) {
            VJCreditCardValidations *validations = [[VJCreditCardValidations alloc] initWithString:newString];
            NSLog(@"Card Type; %@",[validations cardType] );
            [self setCardTypeImage:[validations cardType]];
            [_monthYear becomeFirstResponder];
        }
        
        if (newString.length >= 20) {
            
            return NO;
        }
        
        [textField setText:newString];
        
        return NO;
    }
    if (textField.tag == 2) {

        if (range.location == 5)    //this is calculate the overall string
        {
            return NO;
        }
           NSLog(@"MONTH: %lu",[string length]);
        if ([string length] == 0)   //string length is `0` hide the keyboard
        {
            return YES;
        }
        
        if (range.location == 2)    //apply the `-` between the overall string
        {
            NSString *str  = [NSString stringWithFormat:@"%@/",textField.text];
            textField.text = str;
        }
    }
    
    if (textField.tag == 3) {
         newCVVString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //[self validateCardInfo];
        if (range.location == 3)    //apply the `-` between the overall string
        {
            return NO;
        }
    }
    return YES;
}

-(void)validateCardInfo{
    
      NSLog(@"MONTH: %lu",[_cardTextField.text length]);
      NSLog(@"MONTH: %lu",[_monthYear.text length]);
    if (([_cardTextField.text length]==19 || [_cardTextField.text length]==24) && ([_monthYear.text length]==5 || [_monthYear.text length]==4) && [_cvv.text length]==3)
    {
        NSLog(@"ADD BUTTON");
        NSString* card;
        switch (_cardType) {
            case CardTypeVisa:
                card =@"VISA";
                break;
            case CardTypeAmex:
                card =@"AMEX";
                break;
            case CardTypeDiscover:
                card =@"DISCOVER";
                break;
            case CardTypeMasterCard:
                card =@"MASTERCARD";
                break;
                
            default:
                break;
        }
        
       NSString* newString=  [_cardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
       NSString *code = [newString substringFromIndex: [newString length] - 4];
       [[ParseDataFormatter sharedInstance] addCard:card lastFour:code];
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Credit Card Incomplete"
                                      message:@"Please fill in the required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)scanCardButtonPressed:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    //NSString *trimmedString=[info.cardNumber substringFromIndex:MAX((int)[info.cardNumber length]-4, 0)];
    NSLog(@"Scan succeeded with info: %@", info.cardNumber);
    // Do whatever needs to be done to deliver the purchased items.
    switch (info.cardType) {
        case CardIOCreditCardTypeMastercard:
        {
            _cardImage.image = [UIImage imageNamed:@"Mastercard"];
            _cardType = CardTypeMasterCard;
            break;
        }
            
        case CardIOCreditCardTypeVisa:
        {
            _cardImage.image = [UIImage imageNamed:@"Visa"];
             _cardType = CardTypeVisa;
            break;
        }
            
        case CardIOCreditCardTypeDiscover:
        {
            _cardImage.image = [UIImage imageNamed:@"Discover"];
             _cardType = CardTypeDiscover;
            break;
        }
            
        case CardIOCreditCardTypeAmex:
        {
            _cardImage.image = [UIImage imageNamed:@"AmericanExpress"];
             _cardType = CardTypeAmex;
            break;
        }
            
        default:
            break;
    }
    
    [self addSpaceToString:info];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    //    self.infoLabel.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    }];
}

-(void)setCardTypeImage: (NSString*)cardType{
    
    if ([cardType isEqualToString:@"VISA"]) {
        _cardImage.image = [UIImage imageNamed:@"Visa"];
              _cardType = CardTypeVisa;
    }
    if ([cardType isEqualToString:@"DISCOVER"]) {
        _cardImage.image = [UIImage imageNamed:@"Discover"];
              _cardType = CardTypeDiscover;
    }
    if ([cardType isEqualToString:@"MASTERCARD"]) {
        _cardImage.image = [UIImage imageNamed:@"Mastercard"];
              _cardType = CardTypeMasterCard;
    }
    if ([cardType isEqualToString:@"AMEX"]) {
        _cardImage.image = [UIImage imageNamed:@"AmericanExpress"];
              _cardType = CardTypeAmex;
    }
}

-(void)addSpaceToString: (CardIOCreditCardInfo*) cardInfo{
    NSMutableString *toBespaced=[NSMutableString new];
    
    for (NSInteger i=0; i<cardInfo.cardNumber.length; i+=4) {
        NSString *two=[cardInfo.cardNumber substringWithRange:NSMakeRange(i, 4)];
        [toBespaced appendFormat:@"%@  ",two ];
    }
    
    NSLog(@"%@",toBespaced);
    _cardTextField.text = toBespaced;
    _cvv.text = cardInfo.cvv;
    
    NSString* year = [NSString stringWithFormat:@"%lu",(unsigned long)cardInfo.expiryYear];
    _monthYear.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)cardInfo.expiryMonth,[year substringFromIndex:2]];
    //[self enableDisableBarButton:YES];
}

//-(void)enableDisableBarButton: (BOOL) enabled{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(0, 0, 70, 30)];
//    [button setTitle:@"Add Card" forState:UIControlStateNormal];
//    [button.titleLabel setFont: [button.titleLabel.font fontWithSize: 12]];
//    [button addTarget:self action:@selector(addCardButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    button.layer.borderWidth = 1.0f;
//    button.layer.borderColor = [UIColor whiteColor].CGColor;
//    button.layer.cornerRadius = 5.0f;
//    button.layer.masksToBounds = NO;
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    if (enabled) {
//         self.navigationItem.rightBarButtonItem = leftItem;
//    }
//    else{
//       self.navigationItem.rightBarButtonItem = nil;
//    }
//}

-(void)addCardButtonTapped{
    // self.navigationItem.rightBarButtonItem = nil;
    [self validateCardInfo];
}
//
//
//// Source and explanation: http://stackoverflow.com/a/19161529/1709587
//-(void)reformatAsCardNumber:(UITextField *)textField
//{
//    // In order to make the cursor end up positioned correctly, we need to
//    // explicitly reposition it after we inject spaces into the text.
//    // targetCursorPosition keeps track of where the cursor needs to end up as
//    // we modify the string, and at the end we set the cursor position to it.
//    NSUInteger targetCursorPosition =
//    [textField offsetFromPosition:textField.beginningOfDocument
//                       toPosition:textField.selectedTextRange.start];
//    
//    NSString *cardNumberWithoutSpaces =
//    [self removeNonDigits:textField.text
//andPreserveCursorPosition:&targetCursorPosition];
//    
//    if ([cardNumberWithoutSpaces length] > 19) {
//        // If the user is trying to enter more than 19 digits, we prevent
//        // their change, leaving the text field in  its previous state.
//        // While 16 digits is usual, credit card numbers have a hard
//        // maximum of 19 digits defined by ISO standard 7812-1 in section
//        // 3.8 and elsewhere. Applying this hard maximum here rather than
//        // a maximum of 16 ensures that users with unusual card numbers
//        // will still be able to enter their card number even if the
//        // resultant formatting is odd.
//        [textField setText:previousTextFieldContent];
//        textField.selectedTextRange = previousSelection;
//        return;
//    }
//    
//    NSString *cardNumberWithSpaces =
//    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
//                      andPreserveCursorPosition:&targetCursorPosition];
//    
//    textField.text = cardNumberWithSpaces;
//    UITextPosition *targetPosition =
//    [textField positionFromPosition:[textField beginningOfDocument]
//                             offset:targetCursorPosition];
//    
//    [textField setSelectedTextRange:
//     [textField textRangeFromPosition:targetPosition
//                           toPosition:targetPosition]
//     ];
//}
//
//-(BOOL)textField:(UITextField *)textField
//shouldChangeCharactersInRange:(NSRange)range
//replacementString:(NSString *)string
//{
//    // Note textField's current state before performing the change, in case
//    // reformatTextField wants to revert it
//    previousTextFieldContent = textField.text;
//    previousSelection = textField.selectedTextRange;
//    
//    return YES;
//}

/*
 Removes non-digits from the string, decrementing `cursorPosition` as
 appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
 and a cursor position of `8`, the cursor position will be changed to
 `7` (keeping it between the '2' and the '3' after the spaces are removed).
 */
- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

/*
 Inserts spaces into the string to format it as a credit card number,
 incrementing `cursorPosition` as appropriate so that, for instance, if we
 pass in `@"111111231111"` and a cursor position of `7`, the cursor position
 will be changed to `8` (keeping it between the '2' and the '3' after the
 spaces are added).
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}


@end
