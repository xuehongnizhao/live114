//
//  ReplyInfo.h
//  CardLeap
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyInfo : NSObject
@property (strong, nonatomic) NSString *com_id;
@property (strong, nonatomic) NSString *user_pic;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *reply_text;
@property (strong, nonatomic) NSString *com_text;
@property (strong, nonatomic) NSString *com_url;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
