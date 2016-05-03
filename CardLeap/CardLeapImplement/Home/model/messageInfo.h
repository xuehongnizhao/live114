//
//  messageInfo.h
//  CardLeap
//
//  Created by lin on 12/19/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageInfo : NSObject
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *is_read;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
