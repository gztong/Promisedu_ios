//
//  GZTPaymentViewController.m
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import "GZTPaymentViewController.h"
#import "Stripe.h"
#import "AFNetworking.h"


@interface GZTPaymentViewController ()<STPPaymentCardTextFieldDelegate>

    @property(nonatomic) STPPaymentCardTextField *paymentTextField;

@end

@implementation GZTPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(0, 0,  300, 44)];
    self.paymentTextField.delegate = self;
    
    [self.textView addSubview:self.paymentTextField];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createBackendChargeWithToken:(STPToken *)token
                          completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSString *url = @"http://ec2-54-187-234-28.us-west-2.compute.amazonaws.com/submit_payment/";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    let params: [String : AnyObject] = ["stripeToken": token.tokenId,"amount": amount!, "currency": "usd","description": self.emailTextField.text!]
    
    
    NSDictionary *parameters = @{@"token": token.tokenId,
                                 @"amount": @1999,
                                 @"currency": @"USD",
                                 @"des" :@"baba"
                                 };
    
    [manager POST:url parameters:parameters progress:nil
     success:^(NSURLSessionDataTask *operation, id responseObject) {
      
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succeed!"
                                                         message:@"Start learning!"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         alert.tag = 100;
         [alert show];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }];
    
   
    
}

    
- (IBAction)cancelMethod:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleError: (NSError*)error{
  
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                    message:[error localizedDescription]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    
    NSLog(@"PAYMENT ERROR");
}

- (IBAction)payMethod:(id)sender {
    
    // test
    self.payButton.enabled = NO;
    
    [[STPAPIClient sharedClient]
     createTokenWithCard: self.paymentTextField.cardParams
     completion:^(STPToken *token, NSError *error) {
         if (error) {
             [self handleError:error];
         } else {
             [self createBackendChargeWithToken:token completion:^(PKPaymentAuthorizationStatus status) {
                 // scucceed


                 
             }];
         }
     }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        [self cancel];
    }
}
@end


