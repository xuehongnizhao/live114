//
//  CityUserFrame.h
//  CardLeap
//
//  Created by songweiping on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityUser;

@interface CityUserFrame : NSObject

/** 浏览量的frame */
@property (assign, nonatomic) CGRect cityUserBrowseFrame;

/** 显示固定字符串 frame */
@property (assign, nonatomic) CGRect cityUserStrFrame;

/** 分割线的frame */
@property (assign, nonatomic) CGRect cityUserImageFrame;

/** 简介frame */
@property (assign, nonatomic) CGRect cityUserMessageFrame;

/** 分类的frame */
@property (assign, nonatomic) CGRect cityUserCateFrame;

/** 时间的frame */
@property (assign, nonatomic) CGRect cityUserAddTiemFrame;

/** 数据模型 */
@property (strong, nonatomic) CityUser *cityUser;



@end
