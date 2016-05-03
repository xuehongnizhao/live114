//
//  UserModel.h
//  PersonInfo
//
//  Created by Sky on 14-8-9.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,strong) NSString* u_id;//用户id

@property(nonatomic,strong) NSString* session_key;//用户验证码

@property(nonatomic,strong) NSString* user_name;//用户姓名

@property(nonatomic,strong) NSString* sex;//用户性别

@property(nonatomic,strong) NSString* user_tel;//用户电话号

@property(nonatomic,strong) NSString* city;//用户城市

@property(nonatomic,strong) NSString* id_card;//用户身份证号

@property(nonatomic,strong) NSString* user_pic;//用户头像

@property(nonatomic,strong) NSString* user_nickname;//用户昵称

@property(nonatomic,strong) NSString* background;//------

@property(nonatomic,strong) NSString* level_point;//-----

@property(nonatomic,strong) NSString* pay_point;//-------

@property(nonatomic,strong) NSString* balance;//---------

@property(nonatomic,strong) NSString* bank;//银行

@property(nonatomic,strong) NSString* bank_num;//银行卡号

@property(nonatomic,strong) NSString* mon_income;//月收入

@property(nonatomic,strong) NSString* birthday;//生日

@property(nonatomic,strong) NSString* user_address;//地址

@property(nonatomic,strong) UIImage* localImage;//本地头像---暂不使用

@property(nonatomic,strong)NSString* oldPass;//旧密码

@property (strong, nonatomic) NSString *my_class;//班级
+(UserModel*) shareInstance;
-(UserModel *)initWithDict:(NSDictionary *)dic;

@end
