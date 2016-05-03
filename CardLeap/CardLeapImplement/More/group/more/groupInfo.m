//
//  groupInfo.m
//  CardLeap
//
//  Created by mac on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "groupInfo.h"

@implementation groupInfo
@synthesize score,group_people,message_url,area_id,cat_id,begin_hour,end_hour,shop_address,shop_name,
            shop_tel,shop_lng,shop_lat,group_name,group_brief,
            group_endtime,now_price,before_price,group_id,
            distance,end_time,pic,review_people,pic_list,shop_id,group_cate;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[groupInfo alloc] init];
    }
    self.score = [NSString stringWithFormat:@"%@",dic[@"score"]];
    self.group_people = [NSString stringWithFormat:@"%@",dic[@"group_people"]];
    self.message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    self.area_id = [NSString stringWithFormat:@"%@",dic[@"area_id"]];
    self.cat_id = [NSString stringWithFormat:@"%@",dic[@"cat_id"]];
    self.begin_hour = [NSString stringWithFormat:@"%@",dic[@"begin_hour"]];
    self.end_hour = [NSString stringWithFormat:@"%@",dic[@"end_hour"]];
    self.shop_address = [NSString stringWithFormat:@"%@",dic[@"shop_address"]];
    self.shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    self.shop_tel = [NSString stringWithFormat:@"%@",dic[@"shop_tel"]];
    self.shop_lng = [NSString stringWithFormat:@"%@",dic[@"shop_lng"]];
    self.shop_lat = [NSString stringWithFormat:@"%@",dic[@"shop_lat"]];
    self.group_name = [NSString stringWithFormat:@"%@",dic[@"group_name"]];
    self.group_brief = [NSString stringWithFormat:@"%@",dic[@"group_brief"]];
    self.group_endtime = [NSString stringWithFormat:@"%@",dic[@"group_endtime"]];
    self.now_price = [NSString stringWithFormat:@"%@",dic[@"now_price"]];
    self.before_price = [NSString stringWithFormat:@"%@",dic[@"before_price"]];
    self.group_id = [NSString stringWithFormat:@"%@",dic[@"group_id"]];
    self.distance = [NSString stringWithFormat:@"%@",dic[@"distance"]];
    self.end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
    self.pic = [NSString stringWithFormat:@"%@",dic[@"pic"]];
    self.review_people = [NSString stringWithFormat:@"%@",dic[@"review_people"]];
    self.shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    self.group_cate = [NSString stringWithFormat:@"%@",dic[@"group_cate"]];
//    self.group_url = [NSString stringWithFormat:@"%@",dic[@"group_url"]];
    self.pic_list = dic[@"pic_lists"];
    return self;
}
@end
