//
//  reviewInfo.m
//  CardLeap
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "reviewInfo.h"

@implementation reviewInfo
@synthesize user_name = _user_name;
@synthesize score = _score;
@synthesize review_text = _review_text;
@synthesize add_time = _add_time;
@synthesize type = _type;

-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self) {
        self = [[reviewInfo alloc] init];
    }
    
    _user_name = [NSString stringWithFormat:@"%@", dic[@"user_nickname"]];
    _score = [NSString stringWithFormat:@"%@", dic[@"score"]];
    _review_text = [NSString stringWithFormat:@"%@", dic[@"rev_text"]];
    _add_time = [NSString stringWithFormat:@"%@", dic[@"add_time"] ];
    _type = [NSString stringWithFormat:@"%@", dic[@"rev_type"]];
    
    return self;
}
@end
