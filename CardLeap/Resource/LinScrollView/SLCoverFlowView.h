//
//  SLCoverFlowView.h
//  SLCoverFlow
//
//  Created by jiapq on 13-6-13.
//  Copyright (c) 2013年 HNAGroup. All rights reserved.
//
/**
  使用方法：delegate
    SLCoverFlowView *_coverFlowView;
     _coverFlowView = [[SLCoverFlowView alloc] initWithFrame:frame];
     _coverFlowView.backgroundColor = [UIColor lightGrayColor];
     _coverFlowView.delegate = self;
     _coverFlowView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
     _coverFlowView.coverSize = CGSizeMake(SLCoverViewWidth, SLCoverViewHeight);
     _coverFlowView.coverSpace = 0.0;
     _coverFlowView.coverAngle = 0.0;
     _coverFlowView.coverScale = 1.0;
     [self.view addSubview:_coverFlowView];
    //实现代理 视具体需求而定
     #pragma mark - SLCoverFlowViewDataSource
     - (NSInteger)numberOfCovers:(SLCoverFlowView *)coverFlowView {
        return _colors.count;
     }
     
     - (SLCoverView *)coverFlowView:(SLCoverFlowView *)coverFlowView coverViewAtIndex:(NSInteger)index {
         SLCoverView *view = [[SLCoverView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
         UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 20, 40)];
         btn.layer.borderWidth = 1;
         btn.tag = index;
         [btn addTarget:self action:@selector(getColor:) forControlEvents:UIControlEventTouchUpInside];
         [view addSubview:btn];
         view.backgroundColor = [_colors objectAtIndex:index];
         return view;
     }
 */
#import <UIKit/UIKit.h>

@class SLCoverView;
@protocol SLCoverFlowViewDataSource;

@interface SLCoverFlowView : UIView

@property (nonatomic, assign) id<SLCoverFlowViewDataSource> delegate;

// size of cover view
@property (nonatomic, assign) CGSize coverSize;
// space between cover views
@property (nonatomic, assign) CGFloat coverSpace;
// angle of side cover views
@property (nonatomic, assign) CGFloat coverAngle;
// scale of middle cover view
@property (nonatomic, assign) CGFloat coverScale;

@property (nonatomic, assign, readonly) NSInteger numberOfCoverViews;

- (void)reloadData;

- (SLCoverView *)leftMostVisibleCoverView;
- (SLCoverView *)rightMostVisibleCoverView;

@end


@protocol SLCoverFlowViewDataSource <NSObject>
- (NSInteger)numberOfCovers:(SLCoverFlowView *)coverFlowView;
- (SLCoverView *)coverFlowView:(SLCoverFlowView *)coverFlowView coverViewAtIndex:(NSInteger)index;
@end
