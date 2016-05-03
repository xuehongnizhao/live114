//
//  messageInfo.m
//  CardLeap
//
//  Created by lin on 12/19/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "messageInfo.h"

@implementation messageInfo
@synthesize message = _message;
@synthesize is_read = _is_read;
-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self) {
        self = [[messageInfo alloc] init];
    }
    
    return self;
}
@end
