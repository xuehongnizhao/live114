//
//  myPointInfo.m
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myPointInfo.h"

@implementation myPointInfo
@synthesize operation = _operation;
@synthesize pay_point = _pay_point;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[myPointInfo alloc] init];
    }
    _operation = [NSString stringWithFormat:@"%@",dic[@"log_message"]];
    _pay_point = [NSString stringWithFormat:@"%@",dic[@"point"]];
    _time      = [NSString stringWithFormat:@"%@",dic[@"time"]];
    return self;
}
@end
