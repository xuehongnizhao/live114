//
//  NSString+JSON.m
//  WMYRiceNoodles
//
//  Created by mac on 13-12-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

+ (NSString *)JSONStringWithObject:(id)object
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
