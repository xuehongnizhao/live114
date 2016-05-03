//
//  UZGuideViewController.m
//  WZGuideViewController
//
//  Created by mac on 13-12-19.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "UZGuideViewController.h"

@interface UZGuideViewController ()

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) UIScrollView *pageScroll;

@end


@implementation UZGuideViewController

@synthesize animating = _animating;
@synthesize pageScroll = _pageScroll;

#pragma mark - Functions
// 获得屏幕的CGRect
- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}
// 屏幕旋转
- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}
// 显示引导界面
- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[UZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[UZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[UZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

// 开始引导界面动作
- (void)guideShown
{
	_animating = NO;
}
// 隐藏引导界面
- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[UZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}
// 隐藏引导界面动作
- (void)guideHidden
{
	_animating = NO;
	[[[UZGuideViewController sharedGuide] view] removeFromSuperview];
}
// 返回主窗口
- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}
// 外接调用，显示引导界面
+ (void)show
{
    [[UZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[UZGuideViewController sharedGuide] showGuide];
}
// 外接调用，隐藏引导界面
+ (void)hide
{
	[[UZGuideViewController sharedGuide] hideGuide];
}

#pragma mark -

+ (UZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static UZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray = [NSArray arrayWithObjects:welcomePage1,welcomePage2,welcomePage3,welcomePage4,nil];
    
    if (IPHONE5) {
        _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }else{
        _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count,
                                             self.view.frame.size.height);
    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i),
                                                        0.f,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height)];
        
        UIImage *image = [UIImage imageNamed:imgName];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.frame];
        imageview.contentMode = UIViewContentModeScaleToFill;
        imageview.image = image;
        [view addSubview:imageview];
        
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 175, 35)];
            [enterButton setTitle:@"开始体验"
                         forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateHighlighted];
            [enterButton setBackgroundColor:[UIColor whiteColor]];
            [enterButton setTitleColor:UIColorFromRGB(0xa8a8aa) forState:UIControlStateNormal];
            enterButton.layer.masksToBounds = YES;
            enterButton.layer.cornerRadius=4.0;
            if (IPHONE5) {
                [enterButton setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height-40.f)];
            }else if(IPHONE6){
                [enterButton setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height-60.f)];
            }else if(IPHONE4){
                [enterButton setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height-40.f)];
            }else {
                [enterButton setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height-60.f)];
            }
            [enterButton setBackgroundImage:[UIImage imageNamed:@"topbar-button03.png"]
                                   forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"topbar-button03-sel.png"]
                                   forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:)
                  forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
