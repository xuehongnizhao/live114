//
//  takeoutDishInfo.h
//  CardLeap
//
//  Created by lin on 12/29/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface takeoutDishInfo : NSObject
@property (strong, nonatomic) NSString *take_id;
@property (strong, nonatomic) NSString *pay_num;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *take_name;
@property (strong, nonatomic) NSString *take_pic;
@property (strong, nonatomic) NSString *take_price;
@property (strong, nonatomic) NSString *review_url;

@property (assign, nonatomic) NSInteger count;

-(id)initWithDictionary :(NSDictionary*)dict;
@end
