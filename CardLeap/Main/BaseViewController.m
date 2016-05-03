//
//  BaseViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//


#import "BaseViewController.h"
#import "FontLabel.h"

@interface BaseViewController ()
@property(nonatomic,strong)UIImageView* backgroundImageview;
@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;
@end

@implementation BaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //设置bar的风格，控制字体颜色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    //添加背景图片
    [self.view addSubview:self.backgroundImageview];
    [_backgroundImageview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_backgroundImageview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_backgroundImageview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_backgroundImageview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    //[self settingBackButtonImage:@"navbar_return_no" andSelectedImage:@"navbar_return_sel"];
}

#pragma mark---------设置返回按钮
- (void)settingBackButtonImage:(NSString *)imagename andSelectedImage:(NSString *)selImagename
{
    UIImage* backImage = [[UIImage imageNamed:imagename]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage* backImageSel = [[UIImage imageNamed:selImagename]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    if (IOS7 || IOS8) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [btn setImage:backImage forState:UIControlStateNormal];
        [btn setImage:backImageSel forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
        [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.backBarButtonItem = backButton;
    }
    else{
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImageSel
                                                          forState:UIControlStateHighlighted
                                                        barMetrics:UIBarMetricsDefault];
    }

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, -1000)
                                                         forBarMetrics:UIBarMetricsDefault];
}

#pragma mark-------返回按钮方法
-(void)backAction:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark------隐藏tabbar
-(void)setHiddenTabbar :(BOOL)hidden
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    TabBarViewController *firVC = (TabBarViewController *)window.rootViewController;
    if ([window.rootViewController isKindOfClass:[TabBarViewController class]]) {
        [firVC setTabBarHidden:hidden animated:YES];
    }
}

#pragma mark------获取tabbar是否隐藏
-(BOOL)getHiddenTabbar
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    TabBarViewController *firVC = (TabBarViewController*)window.rootViewController;
    return firVC.tabBarHidden;
}

#pragma mark setNavBarTitleWithFont
-(void)setNavBarTitle:(NSString *)navTitle withFont:(CGFloat)navFont
{
    FontLabel* titleLabel = [[FontLabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44) fontName:@"OpenSans-Light" pointSize:navFont];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.opaque=NO;
    titleLabel.text = navTitle;  //设置标题
    /**
     设置字体大小 颜色等
     */
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    //title.layer.borderWidth=1;
    title.font = [UIFont systemFontOfSize:18.0f];//外边的没改 直接在内部统一fontsize尺寸
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = navTitle;
    self.navigationItem.titleView = title;
}

#pragma mark Property Accessor
-(UIImageView *)backgroundImageview
{
    if (!_backgroundImageview)
    {
        _backgroundImageview=[[UIImageView alloc]initForAutoLayout];
        _backgroundImageview.userInteractionEnabled=YES;
        _backgroundImageview.backgroundColor = [UIColor whiteColor];
        //_backgroundImageview.image=[UIImage imageNamed:@"Background"];
        _backgroundImageview.alpha = 1.0f;
    }
    return _backgroundImageview;
}

/**
 following scorll view
 */
- (void)followScrollView:(UIView*)scrollableView
{
    self.scrollableView = scrollableView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    
    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];
    
    /* The navbar fadeout is achieved using an overlay view with the same barTintColor.
     this might be improved by adjusting the alpha component of every navbar child */
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.origin = CGPointZero;
    self.overlay = [[UIView alloc] initWithFrame:frame];
    if (!self.navigationController.navigationBar.barTintColor) {
        NSLog(@"[%s]: %@", __func__, @"Warning: no bar tint color set");
    }
    [self.overlay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    [self.overlay setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar addSubview:self.overlay];
    [self.overlay setAlpha:0];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
    float delta = self.lastContentOffset - translation.y;
    self.lastContentOffset = translation.y;
    
    CGRect frame;
    
    if (delta > 0) {
        if (self.isCollapsed) {
            return;
        }
        
        frame = self.navigationController.navigationBar.frame;
        
        if (frame.origin.y - delta < -24) {
            delta = frame.origin.y + 24;
        }
        
        frame.origin.y = MAX(-24, frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == -24) {
            self.isCollapsed = YES;
            self.isExpanded = NO;
        }
        
        [self updateSizingWithDelta:delta];
        
        // Keeps the view's scroll position steady until the navbar is gone
        if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.scrollableView setContentOffset:CGPointMake(((UIScrollView*)self.scrollableView).contentOffset.x, ((UIScrollView*)self.scrollableView).contentOffset.y - delta)];
        }
    }
    
    if (delta < 0) {
        if (self.isExpanded) {
            return;
        }
        
        frame = self.navigationController.navigationBar.frame;
        
        if (frame.origin.y - delta > 20) {
            delta = frame.origin.y - 20;
        }
        frame.origin.y = MIN(20, frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == 20) {
            self.isExpanded = YES;
            self.isCollapsed = NO;
        }
        
        [self updateSizingWithDelta:delta];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        // Reset the nav bar if the scroll is partial
        self.lastContentOffset = 0;
        [self checkForPartialScroll];
    }
}

- (void)checkForPartialScroll
{
    CGFloat pos = self.navigationController.navigationBar.frame.origin.y;
    
    // Get back down
    if (pos >= -2) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame;
            frame = self.navigationController.navigationBar.frame;
            CGFloat delta = frame.origin.y - 20;
            frame.origin.y = MIN(20, frame.origin.y - delta);
            self.navigationController.navigationBar.frame = frame;
            
            self.isExpanded = YES;
            self.isCollapsed = NO;
            
            [self updateSizingWithDelta:delta];
            
            // This line needs tweaking
            // [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - delta) animated:YES];
        }];
    } else {
        // And back up
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame;
            frame = self.navigationController.navigationBar.frame;
            CGFloat delta = frame.origin.y + 24;
            frame.origin.y = MAX(-24, frame.origin.y - delta);
            self.navigationController.navigationBar.frame = frame;
            
            self.isExpanded = NO;
            self.isCollapsed = YES;
            
            [self updateSizingWithDelta:delta];
        }];
    }
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
    CGRect frame = self.navigationController.navigationBar.frame;
    
    float alpha = (frame.origin.y + 24) / frame.size.height;
    [self.overlay setAlpha:1 - alpha];
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
    
    frame = self.scrollableView.superview.frame;
    frame.origin.y = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    frame.size.height = frame.size.height + delta;
    self.scrollableView.superview.frame = frame;
    
    // Changing the layer's frame avoids UIWebView's glitchiness
    frame = self.scrollableView.layer.frame;
    frame.size.height += delta;
    self.scrollableView.layer.frame = frame;
}
//---------------------------------

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
