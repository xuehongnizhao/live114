//
//  AppStoreEngine.m
//  wellness
//
//  Created by feezoner-mac on 13-10-30.
//  Copyright (c) 2013年 com.youdro. All rights reserved.
//

#import "AppStoreEngine.h"

@implementation AppStoreEngine

- (MKNetworkOperation *)getSomethingFrom:(NSString *)apiPath
                              withParams:(NSDictionary *)params
                     withCompletionBlock:(completionStoreBlock)completionBlock
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


@end
