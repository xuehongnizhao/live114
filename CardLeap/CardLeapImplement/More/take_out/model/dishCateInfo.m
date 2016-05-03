//
//  dishCateInfo.m
//  CardLeap
//
//  Created by lin on 12/30/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "dishCateInfo.h"

@implementation dishCateInfo
@synthesize cate_name = _cate_name;
@synthesize cate_id = _cate_id;
@synthesize count = _count;

-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self) {
        self = [[dishCateInfo alloc] init];
    }
    _cate_name = [NSString stringWithFormat:@"%@",dic[@"cat_name"]];
    _cate_id = [NSString stringWithFormat:@"%@",dic[@"cat_id"]];
    _count = 0;
    return self;
}

@end
