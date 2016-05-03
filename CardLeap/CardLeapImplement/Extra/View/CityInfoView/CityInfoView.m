//
//  CityInfoView.m
//  CardLeap
//
//  Created by songweiping on 14/12/29.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityInfoView.h"


@interface CityInfoView()<UIScrollViewDelegate>

/** 定时器 */
@property (strong, nonatomic) NSTimer *timer;



@end

@implementation CityInfoView



#pragma mark @@@@ ----> 初始化自定义view
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 添加scrollView
        [self scrollView];
    }
    return self;
}

#pragma mark @@@@ ----> 添加轮播scrollView
- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, self.frame.size.width, 150);
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView         = scrollView;
        [self addSubview:_scrollView];
    }
    return  _scrollView;
}


#pragma mark @@@@ ----> 图片数组 set 方法
/**
 *  重写图片数组的 set 方法 添加图片到 
 *
 *  @param images images
 */
- (void)setImages:(NSArray *)images {
    _images = images;
    
    // 添加图片到scrollView
    [self addImageToScrollView];
    
    // 添加分页控件
    [self page];
}



#pragma mark @@@@ ----> 添加图片 到 scrollView上
/**
 *  添加图片到 scrollView
 */
- (void) addImageToScrollView{
    
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    for (int i=0; i<self.images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat imageX   = i * imageW;
        imageView.frame  = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 网络加载数据
        NSURL *url       = [NSURL URLWithString:self.images[i]];
        [imageView sd_setImageWithURL:url placeholderImage:nil];
        
        // 本地图片
//        imageView.image  = [UIImage imageNamed:self.images[i]];
        [self.scrollView addSubview:imageView];
    }
    
    // 设置 滑动尺寸
    CGFloat contentSizeW = self.images.count * imageW;
    CGFloat contentSizeH = 0;
    self.scrollView.contentSize   = CGSizeMake(contentSizeW, contentSizeH);
    self.scrollView.pagingEnabled = YES;
    
    // 创建定时器 启动
    [self addTimer];
}


#pragma mark @@@@ ----> 重写page get方法
/**
 *  添加分页控件
 *
 *  @return
 */
- (UIPageControl *)page {
    
    if (_page == nil) {
       
        UIPageControl *page = [[UIPageControl alloc] init];
        CGFloat pageX = self.scrollView.frame.size.width / 2;
        CGFloat pageY = self.scrollView.frame.size.height - 10;
        CGFloat pageW = 0;
        CGFloat pageH = 0;
        
        page.frame = CGRectMake(pageX, pageY, pageW, pageH);
        // 总页数
        page.numberOfPages = self.images.count;
        
        // 前页数
        page.currentPageIndicatorTintColor = Color(251, 90, 96, 255);
        
        // 非当前页数
        page.pageIndicatorTintColor        = Color(250, 235, 236, 255);

        _page = page;
        [self addSubview:_page];
    }
    return _page;
}


#pragma mark @@@@ ----> 代理方法 scrollView 正在滚动时候调用
/**
 *  计算 分页 UIPageControl 分页显示
 *  @param scrollView
 */
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 分页 固定写法
    int page = (self.scrollView.contentOffset.x + self.scrollView.frame.size.width * 0.5) / self.scrollView.frame.size.width;
    self.page.currentPage = page;
}

#pragma mark @@@@ ----> 代理方法 scrollView 开始拖拽时候调用
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 停止定时器
    [self endTimer];
}

#pragma mark @@@@ ----> 代理方法 scrollView 完全定制拖拽调用
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // 创建定时器 开启自动滚动
    [self addTimer];
}

#pragma mark @@@@ ----> 计算图片滚动的位置
/**
 *  计算图片滚动的位置
 *  图片的页数 * 图片的宽度
 */
- (void) nextImage {
    
    // 算出 图片的 页数
    long page = 0;
    if (self.page.currentPage == self.images.count - 1) {
        page = 0;
    } else {
        page = self.page.currentPage + 1;
    }
    
    // 计算 scrollView 的滚动位置
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    
    // 水平滚动 Y 值为零
    CGPoint offset  = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}


#pragma mark @@@@ ----> 创建一个定时器 自动滚动
- (void) addTimer {
    // 定时器 自动滚动
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

#pragma mark @@@@ ----> 停止一个定时器
- (void) endTimer {
    
    // 定时器 一旦停止就不能使用 清空，需要重新创建
    [self.timer invalidate];
    // 清空定时器
    self.timer = nil;
}



@end
