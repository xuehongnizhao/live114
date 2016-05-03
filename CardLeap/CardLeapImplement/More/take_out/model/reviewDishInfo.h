//
//  reviewDishInfo.h
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reviewDishInfo : NSObject

@property (strong, nonatomic) NSString *take_id;
@property (strong, nonatomic) NSString *take_name;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *order_id;
-(id)initWithDictinoary:(NSDictionary*)dic;

@end
