//
//  SkyBannerView.m
//  AiJuHui
//
//  Created by Sky on 15/4/24.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SkyBannerView.h"
#import "SkyBannerViewConfig.h"

//需要显示pageControl和Title的View
#import "SkyTitleView.h"

@interface SkyBannerView ()<UIScrollViewDelegate>



@property (nonatomic,strong) UIScrollView       * bannerScrollView;

@property (nonatomic,strong) UIView             * contentView;

@property (nonatomic,strong) NSLayoutConstraint * contentWidthConstraint;

@property (nonatomic,strong) NSArray            * titleArray;

@property (nonatomic,strong)SkyTitleView        * titleView;

@property (nonatomic,assign) NSInteger            pageBeforeRotation;

@property (nonatomic,assign) NSInteger            totalPages;


/*!
 *  @brief  根据数组创建子视图
 *
 *  @param urlArray 图片数组
 */
-(void)setupBannerViews:(NSArray*) urlArray;


/*!
 *  @brief  为图片添加点击效果
 *
 *  @return 点击手势实例
 */
-(UITapGestureRecognizer*)addTapGestureRecognizer;


@end

@implementation SkyBannerView


-(void)setPictureUrls:(NSArray *)urlArray andTitles:(NSArray *)titleArray
{
    //添加子视图
    [self addSubview:self.bannerScrollView];
    [self addImageView:self.bannerScrollView];
    [self.bannerScrollView addSubview:self.contentView];
    [self addImageView:self.contentView];
    
    [self addSubview:self.titleView];
    //由于在后续的动态添加图片的过程中可能会盖住文字视图,需要将它置在视图最前方
    [self bringSubviewToFront:self.titleView];
    
    //设置约束
    [self setAutoLayout];
    
    //根据图片数组创建子视图
    [self setupBannerViews:urlArray];
    
    //设置title的数组 之后的通过活动获取当前文字做准备
    self.titleArray=[NSArray arrayWithArray:titleArray];
    
    //设置titleView的PageControl总数 跟新titleView的布局
    [self.titleView setTotalPageNumer:self.titleArray.count];
    //默认选择第一个
    [self.titleView setCurrentPage:0 andTitle:titleArray[0]];
    
    //让图片自动滚动
    [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:ScrollIntervalTime];
    
    self.tapHandler=^(SkyBannerView* bannerView,NSInteger index){
        NSLog(@"tapedImage at index :%ld",index);
    };
}


#pragma mark - setAutolayout
-(void)setAutoLayout
{
    /*!
     *  @brief  将ScrollerView 扩展到整个视图上
     */
    [self.bannerScrollView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.bannerScrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.bannerScrollView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.bannerScrollView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    /*!
     *  @brief  将ContentView 扩展到Scroller上,方便使用自动布局
     */
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    /*!
     *  @brief  将contentView的高度和宽度与ScrollView设置相同，为后续添加滚动图片扩展
     */
    self.contentWidthConstraint=
    [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.bannerScrollView];
    [self.contentView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.bannerScrollView];
    
    
    /*!
     *  @brief  设置TitleView的约束
     */
    [self.titleView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.titleView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.titleView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.titleView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.bannerScrollView withMultiplier:0.2f];
}

#pragma mark - Helpful Method
-(void)setupBannerViews:(NSArray*) urlArray
{

    self.totalPages=urlArray.count;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        NSArray *subviews = self.contentView.subviews;
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        [self.contentWidthConstraint autoRemove];
        self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.bannerScrollView withMultiplier:self.totalPages];
        
        UIImageView *prevImageView = nil;
        for (NSInteger i = 0; i < self.totalPages; ++i) {
            UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:self.bannerScrollView.bounds];
            
            //设置ImageViewTag值 为了回调方便使用
            pageImageView.tag=i;
            
            pageImageView.userInteractionEnabled=YES;
            //添加手势
            [pageImageView addGestureRecognizer:[self addTapGestureRecognizer]];
#pragma mark --- 11.27 轮播图默认图片改为home_mr
            //加载图片
            UIImage *image = [UIImage imageNamed:@"home_mr"];
            [pageImageView sd_setImageWithURL:urlArray[i] placeholderImage:image];
            
            [self.contentView addSubview:pageImageView];
            
            [pageImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.bannerScrollView];
            [pageImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [pageImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            
            if (!prevImageView) {
                // Align to contentView
                [pageImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            } else {
                // Align to prev label
                [pageImageView autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:prevImageView];
            }
            
            if (i == self.totalPages - 1)
            {
                // Last page
                [pageImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
            }
            
            prevImageView = pageImageView;
        }
        
        self.bannerScrollView.contentOffset = CGPointZero;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.alpha = 1.0;
        }];
    }];
}

-(void) addImageView:(UIView *)view
{
    UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_mr"]];
    [view addSubview:imageView];
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
}


-(UITapGestureRecognizer *)addTapGestureRecognizer
{
    UITapGestureRecognizer* tapGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTaped:)];
    [tapGesutre setNumberOfTapsRequired:1];
    [tapGesutre setNumberOfTouchesRequired:1];
    return tapGesutre;
}

-(void)imageViewTaped:(UITapGestureRecognizer*) tapGesutreRecognzier
{
    //调用回调函数
    self.tapHandler(self,tapGesutreRecognzier.view.tag);
}




- (void)switchImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchImageItems) object:nil];
    
    CGFloat targetX = self.bannerScrollView.contentOffset.x + self.bannerScrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:ScrollIntervalTime];
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    //最后一张的时候回到第一张
    if (targetX >= self.bannerScrollView.contentSize.width)
    {
        targetX = 0.0;
    }
    
    [self.bannerScrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat navX = scrollView.contentOffset.x / scrollView.frame.size.width * self.bannerScrollView.frame.size.width;
    self.bannerScrollView.contentOffset = CGPointMake(navX, 0.0);
    NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    page = MAX(page, 0);
    page = MIN(page, self.totalPages - 1);
    [self.titleView setCurrentPage:page andTitle:self.titleArray[page]];
}

#pragma mark - Property Accessor
-(UIScrollView *)bannerScrollView
{
    if (!_bannerScrollView)
    {
        _bannerScrollView=[[UIScrollView alloc]initForAutoLayout];
        _bannerScrollView.delegate=self;
        //一些初始化的设置
        [_bannerScrollView setPagingEnabled:YES];
        [_bannerScrollView setShowsVerticalScrollIndicator:NO];
        [_bannerScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _bannerScrollView;
}

-(UIView *)contentView
{
    if (!_contentView)
    {
        _contentView=[[UIView alloc]initForAutoLayout];
        _contentView.backgroundColor = [UIColor redColor];
    }
    return _contentView;
}

-(SkyTitleView *)titleView
{
    if (!_titleView)
    {
        _titleView=[[SkyTitleView alloc]initForAutoLayout];
        [_titleView setBackgroundColor:[UIColor clearColor]];
    }
    return _titleView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
