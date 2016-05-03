//
//  activityInfo.h
//  CardLeap
//
//  Created by lin on 1/9/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activityInfo : NSObject
@property (strong, nonatomic) NSString *activity_pic;
@property (strong, nonatomic) NSString *activity_id;
@property (strong, nonatomic) NSString *activity_name;
@property (strong, nonatomic) NSString *begin_time;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *activity_brief;
@property (strong, nonatomic) NSString *activity_desc;
@property (strong, nonatomic) NSString *message_url;

-(id)initWithDictionary:(NSDictionary*)dic;
@end
