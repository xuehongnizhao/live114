//
//  orderSeatSuccessInfo.h
//  CardLeap
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderSeatSuccessInfo : NSObject
@property (strong,nonatomic)NSString *shop_name;
@property (strong,nonatomic)NSString *shop_id;
@property (strong,nonatomic)NSString *use_name;
@property (strong,nonatomic)NSString *seat_tel;
@property (strong,nonatomic)NSString *use_time;
@property (strong,nonatomic)NSString *seat_num;
@property (strong,nonatomic)NSString *ri;
@property (strong,nonatomic)NSString *fen;
@property (strong,nonatomic)NSString *share_url;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
