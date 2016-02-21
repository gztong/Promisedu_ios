//
//  GZTEnrollViewController.h
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZTEnrollViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *enrollButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *laterButton;

- (IBAction)enrollMethod:(id)sender;

- (IBAction)laterMethod:(id)sender;

@end
