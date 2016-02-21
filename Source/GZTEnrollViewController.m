//
//  GZTEnrollViewController.m
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import "GZTEnrollViewController.h"
#import "GZTPaymentViewController.h"

@interface GZTEnrollViewController ()

@end

@implementation GZTEnrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)enrollMethod:(id)sender {
    GZTPaymentViewController *pvc = [[GZTPaymentViewController alloc] init];
    [self presentViewController:pvc animated:YES completion:nil];
}

- (IBAction)laterMethod:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
