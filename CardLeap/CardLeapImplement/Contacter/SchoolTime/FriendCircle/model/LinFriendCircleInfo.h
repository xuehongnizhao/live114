//
//  LinFriendCircleInfo.h
//  EnjoyDQ
//
//  Created by lin on 14-8-14.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinFriendCircleInfo : NSObject
@property (strong, nonatomic) NSString *user_pic;
@property (strong, nonatomic) NSString *user_nickname;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *com_title;
@property (strong, nonatomic) NSString *com_text;
@property (strong, nonatomic) NSArray *com_pic;
@property (strong, nonatomic) NSArray *com_pic_big;
@property (strong, nonatomic) NSString *com_id;
@property (strong, nonatomic) NSString *is_push;
@property (strong, nonatomic) NSString *is_smart;
@property (strong, nonatomic) NSString *is_top;
@property (strong, nonatomic) NSString *review_num;
@property (strong, nonatomic) NSMutableArray *com_list;
@property (strong, nonatomic) NSString *com_voice;
@property (strong, nonatomic) NSString *cut_str;
@property (strong, nonatomic) NSString *u_id;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *collect;
-(id)initWithDictionary :(NSDictionary*)dic;
-(id)initWithDetailDictionary :(NSDictionary*)dic;
@end
