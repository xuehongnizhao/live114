//
//  AdBannerView.m
//  AdImageScrollBanner
//
//  Created by user on 13-3-28.
//  Copyright (c) 2013年 com.youdro. All rights reserved.
//

#import "AdBannerView.h"

@interface AdBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property float indicatorWidth;

@end

@implementation AdBannerView
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize nameLabel = _nameLabel;
@synthesize indicator = _indicator;
@synthesize bannerImageViewArray = _bannerImageViewArray;
@synthesize indicatorWidth = _indicatorWidth;
@synthesize timer = _timer;
#pragma mark --setter&getter

- (NSMutableArray *)bannerImageViewArray
{
    if(!_bannerImageViewArray){
        _bannerImageViewArray = [NSMutableArray array];
    }
    return _bannerImageViewArray;
}

- (UIView *)indicator
{
    if(!_indicator){
        _indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TAB_IMAGE]];
        [_indicator setBackgroundColor:[UIColor colorWithRed:139/255.0 green:0/255.0 blue:139/255.0 alpha:1.0]];
    }
    return _indicator;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        
        UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        tapGestureRecognize.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:tapGestureRecognize];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        [_scrollView addGestureRecognizer:longPressGr];
        
    }
    return _scrollView;
}

#pragma mark -- action

- (void)switchImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchImageItems) object:nil];
    
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    //最后一张的时候回到第一张
    if (targetX >= self.scrollView.contentSize.width){
        targetX = 0.0;
    }
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer{
    
    int page = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    if (page > -1 && page < self.bannerImageViewArray.count) {
        [self.delegate adBannerView:self itemIndex:page];
    }
}

#pragma mark --function

//实现点击图片改变以及动画效果
- (void)animateIndicator:(CGFloat)targetX
{
    
    int currentPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    float indicatorOriginY = self.indicator.frame.origin.y;
    [UIView animateWithDuration:0.3 animations:^{
        self.indicator.frame = CGRectMake(self.indicatorWidth*currentPage, indicatorOriginY, self.indicatorWidth, IndicatorHeight);
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    [self animateIndicator:targetX];
}


#pragma mark --init Ffff

- (AdBannerView *)initWithFrame:(CGRect)frame Delegate:(id<AdBannerViewDelegate>)delegate andImageViewArray:(NSArray *)imageViewArray andNameArray:(NSArray *)nameArray
{
    
    self = [super initWithFrame:frame];
    if(self)
    {
        //初始化变量
        self.indicatorWidth = frame.size.width/imageViewArray.count;
        
        //setup views
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-IndicatorHeight);
        self.scrollView.contentSize = CGSizeMake(frame.size.width*imageViewArray.count, frame.size.height-IndicatorHeight);

        self.nameLabel.frame = CGRectMake(0, 0, frame.size.width, LABEL_HEIGHT);
        self.indicator.frame = CGRectMake(0, frame.size.height-IndicatorHeight, self.indicatorWidth, IndicatorHeight);
        
        [self addSubview:self.scrollView];
//        [self addSubview:self.nameLabel];
        [self addSubview:self.indicator];
        
    
        
        int i = 0;
        for(UIImageView *imageViewItem in imageViewArray)
        {
            imageViewItem.frame = CGRectMake(frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            //设置imageView的属性
            imageViewItem.contentMode=UIViewContentModeScaleToFill;
            
            imageViewItem.tag = i;
            [self.bannerImageViewArray addObject:imageViewItem];
            [self.scrollView addSubview:imageViewItem];
            i++;
        }
        
        int j = 0;
        for (UILabel *labelIterm in nameArray)
        {
            labelIterm.frame = CGRectMake(frame.size.width*i, 0, self.scrollView.frame.size.width,30);
            
            [self.scrollView addSubview:labelIterm];
            j++;
            
        }
        
        
        //设置delegate
        self.delegate = delegate;
        
        [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        
        //设置NSTimer
        //_timer = [NSTimer scheduledTimerWithTimeInterval:SWITCH_FOCUS_PICTURE_INTERVAL target:self selector:@selector(switchImageItems) userInfo:nil repeats:YES];
    }
    return self;
}
#pragma mark---停止自动轮播
-(void)longPressToDo :(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"停止滚动");
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchImageItems) object:nil];
    }else{
        NSLog(@"继续滚动");
        [self performSelector:@selector(switchImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (void)reloadData
{
}


@end
