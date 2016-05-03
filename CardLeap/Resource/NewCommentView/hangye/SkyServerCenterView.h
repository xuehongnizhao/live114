//
//  SkyServerCenterView.h
//  cityo2o
//
//  Created by hm－02 on 15/7/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
//一共有多少列
//#define ColumnOfTagButton   4

//一共有多少行
//#define RowOfTagButton      3

//按钮水平间距
#define TagButtonHorizontalMargin     0

//按钮垂直间距
#define TagButtonVerticalMargin       0

@class linServicemodel;
@class ccDisplayModel;
@protocol SkyServerCenterViewDelegate <NSObject>

-(void)serverCenterClickButtonToPushViewController:(linServicemodel*)module;//服务代理
-(void)disPlayCenterClickButtonToPushViewController:(ccDisplayModel*)module;//商品展示代理
@end

@interface SkyServerCenterView : UIView


@property(nonatomic,assign)id<SkyServerCenterViewDelegate> delegate;

@property (nonatomic) NSInteger ColumnOfTagButton;

@property (nonatomic) NSInteger RowOfTagButton;

+(instancetype)initViewWithXib:(NSInteger)column andRow:(NSInteger)row;


-(void)setButtonViewWithModuleArray:(NSArray*) moduleArray;

-(void)setDisplayButtonViewWithModuleArray:(NSArray *)moduleArray;
@end
