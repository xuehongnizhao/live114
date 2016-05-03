//
//  cateInfo.m
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "cateInfo.h"
#import "cateSonInfo.h"

@implementation cateInfo
@synthesize cate_name = _cate_name;
@synthesize cate_id = _cate_id;
@synthesize son = _son;

-(id)initWithDictinoary :(NSDictionary*)dic
{
    if (!self) {
        self = [[cateInfo alloc] init];
    }
    _cate_name = [NSString stringWithFormat:@"%@",dic[@"cat_name"]];
    _cate_id = [NSString stringWithFormat:@"%@",dic[@"cat_id"]];
    if (_cate_name==nil || [_cate_name isEqualToString:@"(null)"]) {
        _cate_name = [NSString stringWithFormat:@"%@",dic[@"area_name"]];
        _cate_id = [NSString stringWithFormat:@"%@",dic[@"area_id"]];
    }
    _son = [[NSMutableArray alloc] init] ;
    //cate id
    NSArray *sonArray = dic[@"son"];
    for (NSDictionary *dict in sonArray) {
        cateSonInfo *info = [[cateSonInfo alloc] initWithDictionary:dict];
        [_son addObject:info];
    }
    return self;
}

@end
