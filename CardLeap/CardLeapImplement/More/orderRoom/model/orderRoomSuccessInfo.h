//
//  orderRoomSuccessInfo.h
//  CardLeap
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderRoomSuccessInfo : NSObject
@property (strong,nonatomic)NSString *shop_name;
@property (strong,nonatomic)NSString *shop_id;
@property (strong,nonatomic)NSString *use_name;
@property (strong,nonatomic)NSString *hotel_tel;
@property (strong,nonatomic)NSString *begin_time;
@property (strong,nonatomic)NSString *end_time;
@property (strong,nonatomic)NSString *goods_cate;
@property (strong,nonatomic)NSString *hotel_num;
@property (strong,nonatomic)NSString *share_url;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
