//
//  GZTPaymentViewController.h
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZTCourse.h"

@interface GZTPaymentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cancel;
- (IBAction)cancelMethod:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
- (IBAction)payMethod:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *textView;

@end
