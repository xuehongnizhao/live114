//
//  LinFriendCircleInfo.m
//  EnjoyDQ
//
//  Created by lin on 14-8-14.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "LinFriendCircleInfo.h"

@implementation LinFriendCircleInfo

@synthesize user_pic;
@synthesize user_nickname;
@synthesize add_time;
@synthesize com_title;
@synthesize com_text;
@synthesize com_pic;
@synthesize com_pic_big;
@synthesize com_id;
@synthesize is_push;
@synthesize is_smart;
@synthesize is_top;
@synthesize review_num;
@synthesize com_list;
@synthesize com_voice;
@synthesize cut_str;
@synthesize distance;
-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self) {
        self = [[LinFriendCircleInfo alloc] init];
    }
    cut_str = @"0";
    self.user_pic = [dic objectForKey:@"user_pic"];
    self.user_nickname = [dic objectForKey:@"user_nickname"];
    self.add_time = [dic objectForKey:@"add_time"];
    self.com_title = [dic objectForKey:@"com_title"];
    self.com_text = [self fuckNULL:[dic objectForKey:@"com_text"]];//;
    //NSLog(@"%@",self.com_text);
    self.com_pic = [dic objectForKey:@"com_pic"];
    self.com_pic_big = [dic objectForKey:@"com_pic_big"];
    self.com_id = [dic objectForKey:@"com_id"];
    self.is_push = [dic objectForKey:@"is_push"];
    self.is_smart = [dic objectForKey:@"is_smart"];
    self.is_top = [dic objectForKey:@"is_top"];
    self.review_num = [self fuckNULL:[dic objectForKey:@"review_num"]];
    self.com_list = [dic objectForKey:@"com_list"];
    //NSLog(@"回复列表到底是什么%@",self.com_list);
    self.com_voice = [self fuckNULL:[dic objectForKey:@"com_voice"]];
    self.u_id = [self fuckNULL:[dic objectForKey:@"u_id"]];
    self.distance = [self fuckNULL:[dic objectForKey:@"distance"]];
    return self;
}

-(id)initWithDetailDictionary :(NSDictionary*)dic
{
    if (!self) {
        self = [[LinFriendCircleInfo alloc] init];
    }
    cut_str = @"0";
    NSDictionary *dict = [dic objectForKey:@"com_message"];
    self.user_pic = [dict objectForKey:@"user_pic"];
    self.user_nickname = [dict objectForKey:@"user_nickname"];
    self.add_time = [dict objectForKey:@"add_time"];
    self.com_text = [self fuckNULL:[dict objectForKey:@"com_text"]];//;
    //NSLog(@"%@",self.com_text);
    self.com_pic = [dict objectForKey:@"com_pic"];
    self.com_pic_big = [dict objectForKey:@"com_pic_big"];
    //NSLog(@"发表的图片为%@",self.com_pic);
    self.com_id = [dict objectForKey:@"com_id"];
    //NSLog(@"回复列表到底是什么%@",self.com_list);
    self.com_voice = [self fuckNULL:[dict objectForKey:@"com_voice"]];
    self.u_id = [self fuckNULL:[dict objectForKey:@"u_id"]];
    self.com_list = [dic objectForKey:@"com_list"];
    return self;
}

- (NSString*)fuckNULL:(NSObject*)obj;
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]]){
        return @"";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    }else{
        return [NSString stringWithFormat:@"%@",obj];
    }
}
@end
