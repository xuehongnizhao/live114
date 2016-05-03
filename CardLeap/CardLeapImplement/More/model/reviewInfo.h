//
//  reviewInfo.h
//  CardLeap
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reviewInfo : NSObject
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *review_text;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *type;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
