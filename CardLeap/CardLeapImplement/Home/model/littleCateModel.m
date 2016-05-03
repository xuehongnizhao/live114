//
//  littleCateModel.m
//  CardLeap
//
//  Created by lin on 12/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "littleCateModel.h"

@implementation littleCateModel
@synthesize cat_img = _cat_img;
@synthesize cat_name = _cat_name;
@synthesize cat_id = _cat_id;
-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self)
    {
        self = [[littleCateModel alloc] init];
    }
    _cat_img = [NSString stringWithFormat:@"%@", dic[@"cat_img"] ];
    _cat_name = [NSString stringWithFormat:@"%@", dic[@"cat_name"] ];
    _cat_id = [NSString stringWithFormat:@"%@", dic[@"cat_id"] ];
    return self;
}
@end
