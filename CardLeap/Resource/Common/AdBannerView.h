//
//  AdBannerView.h
//  AdImageScrollBanner
//
//  Created by user on 13-3-28.
//  Copyright (c) 2013年 com.youdro. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IndicatorHeight 2
#define TAB_IMAGE @"button_bg.png"
#define SWITCH_FOCUS_PICTURE_INTERVAL 3
#define LABEL_HEIGHT 30

@class AdBannerView;
@protocol AdBannerViewDelegate <NSObject>

- (void)adBannerView:(AdBannerView *)adBannerView itemIndex:(int)index;

@end

@interface AdBannerView : UIView

- (AdBannerView *)initWithFrame:(CGRect)frame Delegate:(id<AdBannerViewDelegate>)delegate andImageViewArray:(NSArray *)imageViewArray andNameArray:(NSArray *)nameArray;

@property (nonatomic, weak) id<AdBannerViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *bannerImageViewArray;

@end
