//
//  CarouselInfo.h
//  CardLeap
//
//  Created by mac on 15/2/11.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarouselInfo : NSObject
@property (strong,nonatomic) NSString *shop_id;
@property (strong,nonatomic) NSString *goods_id;
@property (strong,nonatomic) NSString *top_desc;
@property (strong,nonatomic) NSString *top_id;
@property (strong,nonatomic) NSString *top_pic;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *url;
-(id)initWithDictionary:(NSDictionary*)dict;
@end
