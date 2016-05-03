//
//  JSONOfNetWork.m
//  EnjoyDQ
//
//  Created by Sky on 14-8-5.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "JSONOfNetWork.h"
#import "AppDelegate.h"
#import "Base64.h"

@implementation JSONOfNetWork


+(BOOL)createPlist:(NSDictionary*)dict
{
 
    //建立文件管理
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //找到Documents文件所在的路径
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"path=%@",path);
    
    //取得第一个Documents文件夹的路径
    
    NSString *filePath = [path objectAtIndex:0];
    
    //把TestPlist文件加入
    
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"totalUrl.plist"];
    
    if ([fm fileExistsAtPath:plistPath])
    {
        NSLog(@"文件已存在,开始删除源文件");
        //修改文件内容
        if ([fm removeItemAtPath:plistPath error:nil])
        {
            NSLog(@"文件删除成功");
            //开始创建文件
            if ([fm createFileAtPath:plistPath contents:nil attributes:nil])
            {
                NSLog(@"文件创建成功,开始写入数据");
                if ([dict writeToFile:plistPath atomically:YES])
                {
                    return YES;
                }
            }
            else
            {
                NSLog(@"文件创建失败");
                return NO;
            }
        }
        else
        {
            NSLog(@"文件删除失败");
            return NO;
        }
        
    }
    else
    {
        //开始创建文件
        if ([fm createFileAtPath:plistPath contents:nil attributes:nil])
        {
            NSLog(@"文件创建成功,开始写入数据");
            if ([dict writeToFile:plistPath atomically:YES])
            {
                return YES;
            }
        }
        else
        {
            NSLog(@"文件创建失败,尝试重新获取接口数据");
            return NO;
        }
    }
    return NO;
   
}

+(NSDictionary*)getDictionaryFromPlist
{
    //建立文件管理
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //找到Documents文件所在的路径
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //取得第一个Documents文件夹的路径
    
    NSString *filePath = [path objectAtIndex:0];
    
    //把TestPlist文件加入
    
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"totalUrl.plist"];
    
    if ([fm fileExistsAtPath:plistPath])
    {
        NSLog(@"plist文件已找到,返回各个文件接口");
        NSDictionary* dict=[NSDictionary dictionaryWithContentsOfFile:plistPath];
        return dict;
    }
    else
    {
        NSLog(@"plist文件未找到");
        return nil;
    }
}

@end
