//
//  GZTCourse.m
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import "GZTCourse.h"

@implementation GZTCourse

-(id) initWithAmout:(int)amount{
    self = [super init];
    self.completed = false;
    self.amount = amount;

    return self;
}
@end
