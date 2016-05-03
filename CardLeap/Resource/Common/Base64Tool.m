//
//  Base65Tool.m
//  PersonInfo
//
//  Created by Sky on 14-8-25.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "Base64Tool.h"
#import "Base64.h"
#import "MyMD5.h"
#import "AppDelegate.h"
@implementation Base64Tool
+(void)postSomethingToServe:(NSString *)url andParams:(NSDictionary *)dict isBase64:(BOOL)base64 CompletionBlock:(completionBlock)completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock
{
    NSDictionary* dictionary=dict;
    NSMutableDictionary* mDict;
    if (base64==YES)
    {
        dictionary=[self encodeDict:dict];
        mDict=[[NSMutableDictionary alloc]initWithDictionary:dictionary];
    }else{
        NSString *app_key = [NSString stringWithFormat:@"http://%@%@",baseUrl,[dictionary objectForKey:@"app_key"]];
        mDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        [mDict removeObjectForKey:@"app_key"];
        NSLog(@"mDict:%@",mDict);
        [mDict setObject:app_key forKey:@"app_key"];
    }
  __block  NSDictionary* result=nil;
        [ApplicationDelegate.baseEngine postSomethingTo:url withParams:mDict withCompletionBlock:^(id param)
         {
             if (param == nil) {
                 //当网络不返回数据时候 手动拼错误json格式--测试中
                 result = @{
                            @"code": @"400",
                            @"message": @"网络异常情况",
                            @"obj": @{}
                            };
             }else{
                 NSDictionary* dic=nil;
                 if (base64==YES)
                 {
                     NSLog(@"%@",param);
                     dic=[NSJSONSerialization JSONObjectWithData:[Base64 decodeData:param] options:NSJSONReadingMutableContainers error:nil];
                 }else{
                     dic=[NSJSONSerialization JSONObjectWithData:param options:NSJSONReadingMutableContainers error:nil];
                 }
                 NSLog(@"dict:%@",dic);
                 NSLog(@" message:%@",[dic objectForKey:@"message"]);
                 result=dic;
             }
             completionBlock(result);
         } andErrorBlock:^(NSError *error) {
             errorBlock(error);
         } option:responseStringState];
    return;
}

+(void)postFileTo:(NSString *)url andParams:(NSDictionary *)dict  andFile:(NSData*) fileData andFileName:(NSString*) fileName  isBase64:(BOOL)base64 CompletionBlock:(completionBlock) completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock
{
    NSDictionary* dictionary=dict;
    if (base64==YES)
    {
        dictionary=[self encodeDict:dict];
    }
    
    __block  NSDictionary* result=nil;
    [ApplicationDelegate.baseEngine postFileTo:url withParams:dictionary withFile:fileData andName:fileName withCompletionBlock:^(id param)
    {
        NSDictionary* dic=nil;
        if (base64==YES)
        {
            dic=[NSJSONSerialization JSONObjectWithData:[Base64 decodeData:param] options:NSJSONReadingMutableContainers error:nil];
        }
        else
        {
            dic=[NSJSONSerialization JSONObjectWithData:param options:NSJSONReadingMutableContainers error:nil];
        }
        NSLog(@"dict:%@",dic);
        NSLog(@" message:%@",[dic objectForKey:@"message"]);
        
        result=dic;
        completionBlock(result);
    }
    andErrorBlock:^(NSError *error)
    {
        errorBlock(error);
    }];
    return;
}


+(void)postFileTo:(NSString *)url andParams:(NSDictionary *)dict andFiles:(NSArray *)fileDatas andFileNames:(NSArray *)fileNames isBase64:(BOOL)isBase64 CompletionBlock:(completionBlock)completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock
{
    NSDictionary* dictionary=dict;
    if (isBase64==YES)
    {
        dictionary=[self encodeDict:dict];
    }
    __block  NSDictionary* result=nil;
    [ApplicationDelegate.baseEngine postFileTo:url withParams:dictionary withFiles:fileDatas andNames:fileNames withCompletionBlock:^(id param)
    {
        if (param)
        {
            NSDictionary* dic=nil;
            if (isBase64==YES)
            {
                dic=[NSJSONSerialization JSONObjectWithData:[Base64 decodeData:param] options:NSJSONReadingMutableContainers error:nil];
            }
            else
            {
                dic=[NSJSONSerialization JSONObjectWithData:param options:NSJSONReadingMutableContainers error:nil];
            }
            NSLog(@"dict:%@",dic);
            NSLog(@" message:%@",[dic objectForKey:@"message"]);
            
            result=dic;
            completionBlock(result);
        }
        else
        {
            NSLog(@"数据解析错误，可能是php问题");
        }
        
    } andErrorBlock:^(NSError *error)
    {
        errorBlock(error);
    }];
    
    return;

}

#pragma mark---------app_keyMd5加密 dictBase64加密
+(NSDictionary*)encodeDict:(NSDictionary*) params
{
    //app_key加密
    NSString* app_key=[MyMD5 md5:[NSString stringWithFormat:@"http://%@/%@",baseUrl,[params objectForKey:@"app_key"]]];
    NSLog(@"before app_key:%@",app_key);
    NSLog(@"%@%@",baseUrl,[params objectForKey:@"app_key"]);
    NSLog(@"app_key:%@",app_key);
    NSMutableDictionary* mDict=[[NSMutableDictionary alloc]initWithDictionary:params];
    [mDict removeObjectForKey:@"app_key"];
    NSLog(@"mDict:%@",mDict);
    [mDict setObject:app_key forKey:@"app_key"];
    NSMutableArray* allValues=[[NSMutableArray alloc]init];
    for (id obj in [mDict allValues])
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"已找到字典");
            NSMutableArray* muArr=[[NSMutableArray alloc]init];
            for (NSString* s in [obj allValues])
            {
                NSString* string=[Base64 stringByEncodingData:[s dataUsingEncoding:NSUTF8StringEncoding]];
                [muArr addObject:string];
            }
            
            NSMutableArray* keyArr=[[NSMutableArray alloc]init];
            for (NSString* s in [obj allKeys])
            {
                NSString* string=[Base64 stringByEncodingData:[s dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"str:%@",string);
                [keyArr addObject:string];
            }
        
            NSDictionary* dict=[[NSDictionary alloc]initWithObjects:muArr forKeys:keyArr];
            NSLog(@"base64后字典为:%@",dict);
            [allValues addObject:dict];
        }
        else
        {
            NSString* string=[Base64 stringByEncodingData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
            [allValues addObject:string];
        }
    }
    NSDictionary* dict=[[NSDictionary alloc]initWithObjects:allValues forKeys:[mDict allKeys]];
    NSLog(@"base64加密后的字典%@",dict);
    return dict;
}

+(NSString*)fuckNULL:(NSObject*)obj
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]]){
        return @"null";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    }else{
        return [NSString stringWithFormat:@"%@",obj];
    }
}

+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}

@end
