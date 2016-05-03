//
//  HomeSelectedCityHeaderView.h
//  WeiBang
//
//  Created by songweipng on 15/3/18.
//  Copyright (c) 2015年 songweipng. All rights reserved.
//
//  微榜 ---- 选择城市列表选择当前城市的view ---- view

#import <UIKit/UIKit.h>

@class HomeSelectedCityHeaderView;

/** 协议 */
@protocol HomeSelectedCityHeaderViewDelegate <NSObject>

@optional

/**
 *  点击定位当前城市的代理方法
 *
 *  @param cityHeaderView
 *  @param cityName         定位城市的名称
 *  @param cityID           定位城市的城市ID
 */
- (void) homeSelectedCityHeaderView:(HomeSelectedCityHeaderView *)cityHeaderView cityName:(NSString *)cityName cityID:(NSString *)cityID;

- (void)clickButtonPopController;

@end

@interface HomeSelectedCityHeaderView : UIView

/** 定位城市的名称 */
@property (strong, nonatomic) NSString *currentCityName;
/** 定位城市的ID */
@property (strong, nonatomic) NSString *cityID;

/** 选择当前定位城市按钮 */
@property (strong, nonatomic) UIButton *homeSelectedCityDescView;

/** 代理属性 */
@property (assign, nonatomic) id<HomeSelectedCityHeaderViewDelegate> delegate;

//-----关闭定位------
-(void)stopLocation;
//-----开启定位------
-(void)openLoaction;
@end
