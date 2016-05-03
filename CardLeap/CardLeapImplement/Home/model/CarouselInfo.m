//
//  CarouselInfo.m
//  CardLeap
//
//  Created by mac on 15/2/11.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CarouselInfo.h"

@implementation CarouselInfo
@synthesize shop_id = _shop_id;
@synthesize top_desc = _top_desc;
@synthesize top_id = _top_id;
@synthesize top_pic = _top_pic;
@synthesize type = _type;
@synthesize url = _url;
@synthesize goods_id = _goods_id;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (!self) {
        self = [[CarouselInfo alloc] init];
    }
    _shop_id = [NSString stringWithFormat:@"%@",dict[@"shop_id"]];
    _top_desc = [NSString stringWithFormat:@"%@",dict[@"top_desc"]];
    _top_id = [NSString stringWithFormat:@"%@",dict[@"top_id"]];
    _top_pic = [NSString stringWithFormat:@"%@",dict[@"top_pic"]];
    _type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    _url = [NSString stringWithFormat:@"%@",dict[@"url"]];
    _goods_id = [NSString stringWithFormat:@"%@",dict[@"goods_id"]];
    return self;
}
@end
