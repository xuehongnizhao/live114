//
//  dishCateInfo.h
//  CardLeap
//
//  Created by lin on 12/30/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dishCateInfo : NSObject
@property (strong, nonatomic) NSString *cate_name;
@property (strong, nonatomic) NSString *cate_id;
@property (assign, nonatomic) NSInteger count;

-(id)initWithDictionary :(NSDictionary*)dic;

@end
