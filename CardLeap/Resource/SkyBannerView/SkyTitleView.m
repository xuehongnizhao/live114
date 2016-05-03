//
//  SkyTitleView.m
//  AiJuHui
//
//  Created by Sky on 15/4/24.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SkyTitleView.h"
#import "SkyBannerViewConfig.h"
@interface SkyTitleView ()

@property (nonatomic,strong) UIPageControl * pageControl;

@property (nonatomic,strong) UILabel       * titleLabel;

@property (nonatomic,strong) NSLayoutConstraint * pageControlWidthConstraint;

@end

@implementation SkyTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setCurrentPage:(NSInteger)currentPage andTitle:(NSString *)title
{
    if (_pageControl.numberOfPages==0) return;
    
    [_pageControl setCurrentPage:currentPage];
    [_titleLabel setText:@""];
}

-(void)setTotalPageNumer:(NSInteger)totalPageNumer
{
    [_pageControl setNumberOfPages:totalPageNumer];
    
    //移除宽度约束重新设置
    [self.pageControlWidthConstraint autoRemove];
    
   CGFloat pageControlWidth = [_pageControl sizeForNumberOfPages:totalPageNumer].width;
    [_pageControl autoSetDimension:ALDimensionWidth toSize:pageControlWidth];
    
    /*!
     *  @brief  马上进行再次的布局
     */
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


-(instancetype)initForAutoLayout
{
    if (self=[super initForAutoLayout])
    {
        
        //一写自身的基础设置
        self.backgroundColor=TitleViewBackGroundColor;
        
        [self addSubview:self.pageControl];
        [self addSubview:self.titleLabel];
        [self setupAutolayout];
    }
    return self;
}


#pragma mark - set up autolayout
-(void)setupAutolayout
{
    [_pageControl autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.pageControlWidthConstraint=[_pageControl autoSetDimension:ALDimensionWidth toSize:0];
    
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.f];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_titleLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:_pageControl];
    
}


#pragma mark - Property Accessor
-(UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl=[[UIPageControl alloc]initForAutoLayout];
        //当前已选择Page
        [_pageControl setCurrentPage:0];
        
        [_pageControl setCurrentPageIndicatorTintColor:CurrentIndictorTintColor];
        [_pageControl setPageIndicatorTintColor:IndictorTintColor];
        [_pageControl setHidesForSinglePage:YES];
        //不允许对pagecontrol的点击做响应
        [_pageControl setUserInteractionEnabled:NO];
    }
    return _pageControl;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel=[[UILabel alloc]initForAutoLayout];
        _titleLabel.textColor=TitleLabelTextColor;
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

@end
