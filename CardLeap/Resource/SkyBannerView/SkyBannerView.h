//
//  SkyBannerView.h
//  AiJuHui
//
//  Created by Sky on 15/4/24.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SkyBannerView;

/*!
 *  @brief  轮播图片点击回调
 *
 *  @param bannerView 轮播实体类
 *  @param index      所点图片的索引值
 */
typedef void(^SkyBannerHandler)(SkyBannerView* bannerView,NSInteger index);


@interface SkyBannerView : UIView

/*!
 *  @brief  图片点击回调
 */
@property(nonatomic,copy)SkyBannerHandler tapHandler;


/*!
 *  @brief  初始化方法
 *
 *  @param urlArray   图片地址数组
 *  @param titleArray 图片文字介绍 可以为空
 *
 */
-(void)setPictureUrls:(NSArray*) urlArray andTitles:(NSArray*) titleArray;




@end
