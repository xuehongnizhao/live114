//
//  VoiceRecorderBase.h
//  UZModel
//
//  Created by Sky on 14-9-1.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

//默认最大录音时间
#define kDefaultMaxRecordTime               60

@protocol VoiceRecorderBaseDelegate <NSObject>

//录音完成回调，返回文件路径和文件名
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *) filePath fileName:(NSString*)fileName;


@end


@interface VoiceRecorderBase : NSObject
{
   @protected
    NSInteger               maxRecordTime;  //最大录音时间
    NSString                *recordFileName;//录音文件名
    NSString                *recordFilePath;//录音文件路径
}

@property (assign, nonatomic)           id<VoiceRecorderBaseDelegate> vrbDelegate;

@property (assign, nonatomic)           NSInteger               maxRecordTime;//最大录音时间
@property (copy, nonatomic)             NSString                *recordFileName;//录音文件名
@property (copy, nonatomic)             NSString                *recordFilePath;//录音文件路径

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
+ (NSString*)getCurrentTimeString;

/**
 获取缓存路径
 @returns 缓存路径
 */
+ (NSString*)getCacheDirectory;

/**
 判断文件是否存在
 @param _path 文件路径
 @returns 存在返回yes
 */
+ (BOOL)fileExistsAtPath:(NSString*)path;

/**
 删除文件
 @param _path 文件路径
 @returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString*)path;


#pragma mark -

/**
 生成文件路径
 @param _fileName 文件名
 @param _type 文件类型
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)fileName;
+ (NSString*)getPathByFileName:(NSString *)fileName ofType:(NSString *)type;

/**
 获取录音设置
 @returns 录音设置
 */
+ (NSDictionary*)getAudioRecorderSettingDict;

@end
