//
//  MyMD5.m
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyMD5.h"
#import "CommonCrypto/CommonDigest.h"

@implementation MyMD5

+(NSString *) md5: (NSString *) inPutText 
{
    NSLog(@"inputText:%@",inPutText);
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
   // NSLog(@"restule:%s",result);
    NSMutableString* str=[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [str appendFormat:@"%02X",result[i]];
    }
    return [MyMD5 md5Again:[str lowercaseString]];
}
+(NSString*)md5Again:(NSString*) str
{
   // NSLog(@"str:%@",str);
    NSString* sstr=[str substringToIndex:10];
   // NSLog(@"---sstr:%@  andlength:%d",sstr,sstr.length);
    const char* cStr=[sstr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSMutableString* mstr=[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [mstr appendFormat:@"%02x",result[i]];
    }
    return [mstr lowercaseString];
}
@end
