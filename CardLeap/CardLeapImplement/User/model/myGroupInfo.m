//
//  myGroupInfo.m
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myGroupInfo.h"
#import "groupDetailInfo.h"

@implementation myGroupInfo
@synthesize order_id,group_pic,group_name,grab_price,grab_num,is_pay,group_brief,
group_desc,group_pass,add_time,group_id,pay_url,status,shop_id,score,group_endtime,pass_array,group_url,single_price;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (!self) {
        self = [[myGroupInfo alloc] init];
    }
    //----
    self.order_id = [NSString stringWithFormat:@"%@",dict[@"order_id"]];
    self.group_pic = [NSString stringWithFormat:@"%@",dict[@"group_pic"]];
    self.group_name = [NSString stringWithFormat:@"%@",dict[@"group_name"]];
    self.grab_price = [NSString stringWithFormat:@"%@",dict[@"grab_price"]];
    self.grab_num = [NSString stringWithFormat:@"%@",dict[@"grab_num"]];
    self.is_pay = [NSString stringWithFormat:@"%@",dict[@"is_pay"]];
    self.group_brief = [NSString stringWithFormat:@"%@",dict[@"group_brief"]];
    self.group_desc = [NSString stringWithFormat:@"%@",dict[@"group_desc"]];
    self.group_pass = [NSString stringWithFormat:@"%@",dict[@"group_pass"]];
    self.add_time = [NSString stringWithFormat:@"%@",dict[@"add_time"]];
    self.group_id = [NSString stringWithFormat:@"%@",dict[@"group_id"]];
    self.pay_url = [NSString stringWithFormat:@"%@",dict[@"pay_url"]];
    self.status = [NSString stringWithFormat:@"%@",dict[@"status"]];
    self.shop_id =[NSString stringWithFormat:@"%@",dict[@"shop_id"]];
    self.score = [NSString stringWithFormat:@"%@",dict[@"score"]];
    self.group_endtime = [NSString stringWithFormat:@"%@",dict[@"group_endtime"]];
    self.group_url = [NSString stringWithFormat:@"%@",dict[@"group_url"]];
    self.single_price = [NSString stringWithFormat:@"%@",dict[@"now_price"]];
    self.pass_array = dict[@"code_array"];
    //----
    return self;
}
@end
