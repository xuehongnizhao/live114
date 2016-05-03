//
//  roomInfo.h
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface roomInfo : NSObject
@property (strong,nonatomic)NSString *goods_id;
@property (strong,nonatomic)NSString *shop_id;
@property (strong,nonatomic)NSString *goods_cate;
@property (strong,nonatomic)NSString *goods_desc;
@property (strong,nonatomic)NSString *goods_price;
#pragma mark --- 11.28 房间详情web页的url（暂时没用到，因为用的是酒店详情的web页）
@property (nonatomic ,strong) NSString * message_url;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
