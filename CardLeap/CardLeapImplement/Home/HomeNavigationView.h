//
//  HomeNavigationView.h
//  CardLeap
//
//  Created by lin on 12/8/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoSearchDelegate <NSObject>
-(void)goSeachShop :(NSInteger)index;
@end

@interface HomeNavigationView : UIView
@property (strong,nonatomic) id<GoSearchDelegate> delegate;
//单例 便于添加hint
+(HomeNavigationView*)shareInstance;
//添加提醒
-(void)addHint;
//移除提醒
-(void)removeHint;
//设置城市名称
-(void)setCityName :(NSString*)cityName;
//设置button状态
-(void)setlogoButtonEnabel;
@end
