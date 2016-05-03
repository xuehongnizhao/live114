    //
//  JsonModel.m
//  CardLeap
//
//  Created by mac on 15/3/17.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "JsonModel.h"

@implementation JsonModel

+(JsonModel *)shareInstance
{
    static JsonModel* user=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        user =[[self alloc]init];
    });
    return user;
}

-(void)readJsonFromTxt:(NSString*)fielName
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:fielName ofType:nil];
    NSString *str=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding  error:nil ];
    NSLog(@"%@",str);
    NSError *error;
    NSData *data =  [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dit= [NSJSONSerialization JSONObjectWithData: data  options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"读取的数据为%@",dit);
}

#pragma mark-----颜色字符串解析
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
