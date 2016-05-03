//
//  cateModel.m
//  CardLeap
//
//  Created by lin on 12/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  114   ---->     如意专区 六大分类数据模型

#import "cateModel.h"

@implementation cateModel
@synthesize cat_img = _cat_img;
@synthesize cat_name = _cat_name;
@synthesize cat_id = _cat_id;
@synthesize cat_subHead = _cat_subHead;
@synthesize normalColor = _normalColor;
@synthesize hightLightedColor = _hightLightedColor;
@synthesize layoutColor = _layoutColor;
@synthesize cate_type = _cate_type;
-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self)
    {
        self = [[cateModel alloc] init];
    }
    _cat_img = [NSString stringWithFormat:@"%@", dic[@"cat_img"] ];
    _cat_name = [NSString stringWithFormat:@"%@", dic[@"cat_name"] ];
    _cat_id = [NSString stringWithFormat:@"%@", dic[@"cat_id"] ];
    _cat_subHead = [NSString stringWithFormat:@"%@", dic[@"cat_description"] ];
    _normalColor = [NSString stringWithFormat:@"%@", dic[@"back_color"] ];
    _layoutColor = [NSString stringWithFormat:@"%@", dic[@"boder_color"] ];
    _hightLightedColor = [NSString stringWithFormat:@"%@", dic[@"click_color"]];
    _cate_type = [NSString stringWithFormat:@"%@", dic[@"cate_type"]];
    return self;
}

@end
