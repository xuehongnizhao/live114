//
//  UserModel.m
//  PersonInfo
//
//  Created by Sky on 14-8-9.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize
u_id,
session_key,
user_name,
sex,
user_tel,
city,
id_card,
user_pic,
user_nickname,

background,
level_point,
pay_point,
balance,
bank,
bank_num,
mon_income,
birthday,
user_address,
localImage;


+(UserModel *)shareInstance
{
    static UserModel* user=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        user =[[self alloc]init];
       
    });
    return user;
}
-(id)init
{
    if (self=[super init])
    {
        self.session_key=@"1";
        self.sex=@"未编辑";
        self.u_id=@"0";
        self.user_address=@"未编辑";
        self.user_name=@"未编辑";
        self.user_tel=@"未编辑";
        self.id_card=@"未编辑";
        self.user_nickname=@"未编辑";
    }
    return self;
}


-(UserModel *) initWithDict:(NSDictionary *)dic
{
    if (!self) {
        self = [[UserModel alloc] init];
    }
    self.u_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"u_id"]];
    self.session_key = [NSString stringWithFormat:@"%@",[dic objectForKey:@"session_key"]];
    self.user_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_name"]];
    
    self.sex = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]];
    self.user_tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_tel"]];
    self.city = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
    
    self.id_card = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id_card"]];
    self.user_pic = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_pic"]];
    self.user_nickname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_nickname"]];
    
    self.background = [NSString stringWithFormat:@"%@",[dic objectForKey:@"background"]];
    self.level_point = [NSString stringWithFormat:@"%@",[dic objectForKey:@"level_point"]];
    self.pay_point = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pay_point"]];
    
    self.balance = [NSString stringWithFormat:@"%@",[dic objectForKey:@"balance"]];
    
    self.bank = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bank"]];
    self.bank_num = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bank_num"]];
    
    self.mon_income = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mon_income"]];
    self.birthday = [NSString stringWithFormat:@"%@",[dic objectForKey:@"birthday"]];
    self.user_address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_address"]];
    
    
    return self;
}


@end
