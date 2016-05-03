//
//  JSONOfNetWork.h
//  EnjoyDQ
//
//  Created by Sky on 14-8-5.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//
/*
  该类用于将网络解析base64的编码解码  并返回相应的字典
 
 */
#import <Foundation/Foundation.h>

@interface JSONOfNetWork : NSObject



/*
   @brief 程序每次启动时需要将各个接口重新写入plist 若是plist文件存在则删除源文件重新写入
   @param 需要写入的字典
 */

+(BOOL)createPlist:(NSDictionary*)dict;


/*
   @brief 获取各个需要的网络接口 已字典的形式返回
   
   @param  返回字典
 
 */

+(NSDictionary*)getDictionaryFromPlist;



@end
