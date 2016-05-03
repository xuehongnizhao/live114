//
//  SkyBannerViewConfig.h
//  AiJuHui
//
//  Created by Sky on 15/4/24.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#ifndef AiJuHui_SkyBannerViewConfig_h
#define AiJuHui_SkyBannerViewConfig_h


/*!
 *  @brief  indicator(小圆点) 高度
 */
static const NSInteger  indicatorHeight = 2 ;


/*!
 *  @brief  自动滚动间隔时间
 */
static const NSInteger ScrollIntervalTime = 3;


/*!
 *  @brief  pageControl 常态下的颜色
 */
#define IndictorTintColor    [UIColor whiteColor]

/*!
 *  @brief  pageControl 滑动到当前图片的颜色
 */
#define CurrentIndictorTintColor UIColorFromRGB(0x57dbed)


/*!
 *  @brief  TitleView的背景颜色
 */
#define TitleViewBackGroundColor [UIColor colorWithWhite:0 alpha:0.7]


/*!
 *  @brief  TitleLabel的字体颜色
 */
#define TitleLabelTextColor       [UIColor whiteColor]


#endif
