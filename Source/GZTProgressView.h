//
//  GZTProgressView.h
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface GZTProgressView : UIView

@property(strong) UILabel *amountLabel;
@property(strong) PNCircleChart * circleChart;
@end
