//
//  BaseEngine.m
//  QrCode
//
//  Created by feezoner-mac on 13-7-29.
//  Copyright (c) 2013年 com.youdro. All rights reserved.
//

#import "BaseEngine.h"
#import "Base64.h"
#import "MyMD5.h"
@implementation BaseEngine

//+ (BaseEngine *)sharedBaseEngine
//{
//    static dispatch_once_t pred = 0;
//    __strong static id _sharedObject = nil;
//    dispatch_once(&pred, ^{
//        _sharedObject = [[BaseEngine alloc] init]; // or some other init method
//    });
//    return _sharedObject;
//}

- (MKNetworkOperation *)getSomethingFrom:(NSString *)apiPath
                              withParams:(NSDictionary *)params
                     withCompletionBlock:(completionBlock)completionBlock
                           andErrorBlock:(MKNKErrorBlock)errorBlock
                                  option:(responseState)responseState;
{
    MKNetworkOperation *op = [self operationWithPath:apiPath params:params httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id feedBackStatu = nil;
        if (responseState == responseJsonState) {
            feedBackStatu = [completedOperation responseJSON];
        }
        if (responseState == responseStringState) {
            feedBackStatu = [completedOperation responseString];
        }
        DLog(@"feedBackStatu %@",feedBackStatu);
        completionBlock(feedBackStatu);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    return op;
}
- (MKNetworkOperation *)getSomethingFrom:(NSString *)apiPath
              withParams:(NSDictionary *)params
     withCompletionBlock:(completionBlock)completionBlock
           andErrorBlock:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:apiPath params:params httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id feedBackStatu = [completedOperation responseJSON];
        completionBlock(feedBackStatu);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    return op;
}

- (MKNetworkOperation *)postSomethingTo:(NSString *)apiPath
                             withParams:(NSDictionary *)params
                    withCompletionBlock:(completionBlock)completionBlock
                          andErrorBlock:(MKNKErrorBlock)errorBlock
                                 option:(responseState)responseState
{
    MKNetworkOperation *op = [self operationWithPath:apiPath params:params httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
    {
        id feedBackStatu = nil;
        if (responseState == responseJsonState)
        {
            NSLog(@"json");
            feedBackStatu = [completedOperation responseJSON];
        }
        if (responseState == responseStringState) {
            NSLog(@"codeData:%@",[completedOperation responseString]);
            feedBackStatu =[completedOperation responseData] ;
        }
        completionBlock(feedBackStatu);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"解析错误:%@",error);
        errorBlock(error);
        //当网络返回异常的时候 重新访问
        //[self postSomethingTo:apiPath withParams:params withCompletionBlock:completionBlock andErrorBlock:errorBlock option:responseState];
    }];
    
    [self enqueueOperation:op];
    return op;
}


- (MKNetworkOperation *)postFileTo:(NSString *)apiPath
                             withParams:(NSDictionary *)params
                           withFiles:(NSArray *)fileDatas
                              andNames:(NSArray *)fileNames
                    withCompletionBlock:(completionBlock)completionBlock
                        andErrorBlock:(MKNKErrorBlock)errorBlock
{
    
    
    MKNetworkOperation *op = [self operationWithPath:apiPath params:params httpMethod:@"POST"];
    
//    [op addFile:filePath forKey:fileName];
    for (int i=0; i<fileDatas.count; i++) {
        [op addData:[fileDatas objectAtIndex:i] forKey:[fileNames objectAtIndex:i]];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //id feedBackStatu = [completedOperation responseJSON];
        
      id  feedBackStatu =[completedOperation responseData] ;
       NSLog(@"feedBackStatus %@",[completedOperation responseString]);
        completionBlock(feedBackStatu); 
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}


- (MKNetworkOperation *)postFileTo:(NSString *)apiPath
                        withParams:(NSDictionary *)params
                          withFile:(NSData *)fileData
                           andName:(NSString *)fileName
               withCompletionBlock:(completionBlock)completionBlock
                     andErrorBlock:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:apiPath params:params httpMethod:@"POST"];
    
    //    [op addFile:filePath forKey:fileName];
    [op addData:fileData forKey:fileName];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //id feedBackStatu = [completedOperation responseJSON];
        
                id feedBackString =  [completedOperation responseData];
            //   NSLog(@"feedBackStatus --------%@",[completedOperation responseString]);
        completionBlock(feedBackString);

        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}
@end
