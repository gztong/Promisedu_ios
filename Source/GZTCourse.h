//
//  GZTCourse.h
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZTCourse : NSObject
@property BOOL completed;
@property int amount;
@property NSString *cid;
@property int progress_percent; // out of 100

@end
