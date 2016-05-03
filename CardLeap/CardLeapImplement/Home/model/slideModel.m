//
//  slideModel.m
//  CardLeap
//
//  Created by lin on 12/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "slideModel.h"

@implementation slideModel
@synthesize top_id = _top_id;
@synthesize top_pic = _top_pic;
@synthesize top_desc = _top_desc;
@synthesize type = _type;
@synthesize shop_id = _shop_id;
-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self)
    {
        self = [[slideModel alloc] init];
    }
    _top_id = [NSString stringWithFormat:@"%@", dic[@"top_id"]];
    _top_pic = [NSString stringWithFormat:@"%@", dic[@"top_pic"]];
    _top_desc = [NSString stringWithFormat:@"%@", dic[@"top_desc"]];
    _type = [NSString stringWithFormat:@"%@", dic[@"type"] ];
    _shop_id = [NSString stringWithFormat:@"%@", dic[@"shop_id"]];
    return self;
}
@end
