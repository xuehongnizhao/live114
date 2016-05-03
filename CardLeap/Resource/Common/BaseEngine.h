//
//  BaseEngine.h
//  QrCode
//
//  Created by feezoner-mac on 13-7-29.
//  Copyright (c) 2013年 com.youdro. All rights reserved.
//

/*
 使用的时候,在delegate中创建一个本类的实力
 然后在对应的controller中调用get和post方式
 */

#import "MKNetworkEngine.h"

typedef void (^completionBlock)(id param);

typedef enum {
    responseJsonState = 1,
    responseStringState = 2,

} responseState;

@interface BaseEngine : MKNetworkEngine
//+ (BaseEngine *)sharedBaseEngine;

- (MKNetworkOperation *)getSomethingFrom:(NSString *)apiPath
              withParams:(NSDictionary *)params
     withCompletionBlock:(completionBlock)completionBlock
           andErrorBlock:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *)getSomethingFrom:(NSString *)apiPath
                              withParams:(NSDictionary *)params
                     withCompletionBlock:(completionBlock)completionBlock
                           andErrorBlock:(MKNKErrorBlock)errorBlock
                                  option:(responseState)responseState;


- (MKNetworkOperation *)postSomethingTo:(NSString *)apiPath
              withParams:(NSDictionary *)params
     withCompletionBlock:(completionBlock)completionBlock
           andErrorBlock:(MKNKErrorBlock)errorBlock
                  option:(responseState)responseState;

// post数据中,多文件上传
- (MKNetworkOperation *)postFileTo:(NSString *)apiPath
                        withParams:(NSDictionary *)params
                         withFiles:(NSArray *)fileDatas
                          andNames:(NSArray *)fileNames
               withCompletionBlock:(completionBlock)completionBlock
                     andErrorBlock:(MKNKErrorBlock)errorBlock;

// 单文件
- (MKNetworkOperation *)postFileTo:(NSString *)apiPath
                        withParams:(NSDictionary *)params
                          withFile:(NSData *)fileData
                           andName:(NSString *)fileName
               withCompletionBlock:(completionBlock)completionBlock
                     andErrorBlock:(MKNKErrorBlock)errorBlock;
@end
