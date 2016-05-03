//
//  EvenMoreIsToJump.h
//  CardLeap
//
//  Created by songweiping on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvenMoreIsToJump : NSObject



/** 是否跳转 关于App   YES 跳转 */
@property (assign, nonatomic) BOOL isAboutApp;

/** 是否跳转 二维码     YES 跳转 */
@property (assign, nonatomic) BOOL isCode;

/** 是否跳转 使用帮助   YES 跳转 */
@property (assign, nonatomic) BOOL isHelp;

/** 是否跳转 隐私权限   YES 跳转 */
@property (assign, nonatomic) BOOL isPrivacy;



@end
