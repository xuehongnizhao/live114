//
//  myCollectionInfo.h
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myCollectionInfo : NSObject
@property (strong,nonatomic)NSString *shop_action;//商家权限
@property (strong,nonatomic)NSString *rev_people;//回复人数
@property (strong,nonatomic)NSString *shop_id;//商家id
@property (strong,nonatomic)NSString *shop_name;//商家名称
@property (strong,nonatomic)NSString *shop_pic;//商家图片
@property (strong,nonatomic)NSString *shop_address;//商家地址
@property (strong,nonatomic)NSString *shop_cate;//商家分类
@property (strong,nonatomic)NSString *score;//商家评分
-(id)initWithDictionary:(NSDictionary*)dic;
@end
