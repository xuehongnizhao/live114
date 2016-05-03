//
//  AppStoreEngine.h
//  wellness
//
//  Created by feezoner-mac on 13-10-30.
//  Copyright (c) 2013年 com.youdro. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^completionStoreBlock)(id param);

@interface AppStoreEngine : MKNetworkEngine

- (MKNetworkOperation *)getSomethingFrom:(NSString *)apiPath
                              withParams:(NSDictionary *)params
                     withCompletionBlock:(completionStoreBlock)completionBlock
                           andErrorBlock:(MKNKErrorBlock)errorBlock;

@end
