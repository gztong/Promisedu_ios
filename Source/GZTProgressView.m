//
//  GZTProgressView.m
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import "GZTProgressView.h"
#import "GZTCourse.h"

@implementation GZTProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self = [super init];
    
    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 130.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:YES ];
    
    self.circleChart.backgroundColor = [UIColor clearColor];
    [ self.circleChart setStrokeColor:PNGreen];
    [ self.circleChart strokeChart];
    
    
    [self addSubview: self.circleChart];
    
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 100, 44)];
    self.amountLabel.text = @"$";
    
    return self;

}

-(void)updateWithCourse:(GZTCourse *)c{
    [self.circleChart updateChartByCurrent: [NSNumber numberWithInt:[c amount]]];
    self.amountLabel.text =  [NSString stringWithFormat:@"$: %d", c.amount];

}

@end
