//
//  TabBarViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "TabBarViewController.h"
#import "ContactViewController.h"
#import "ExtraViewController.h"
#import "HomeViewController.h"
#import "MoreViewController.h"
#import "UserViewController.h"
//tabbarcontroller
#import <RDVTabBarController.h>
#import <RDVTabBarItem.h>
#import "DSNavigationBar.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "ShopListViewController.h"
#import "UserViewController.h"
#import "LinFriendCircleController.h"

@interface TabBarViewController ()<RDVTabBarControllerDelegate>
{
    UIImageView *_homeImage;//主页提示红点
    UIImageView *_circleImage;//发现提示红点
    BOOL isReply;
    NSString *count;
}
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnHomeHint:) name:NOTIFICATION_ROOT_NEW_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnLexiangHint:) name:NOTIFICATION_CIRCLE_NEW_MESSAGE object:nil];
    isReply = NO;
    count = @"0";
}

#pragma mark-----------收到通知
- (void)UnLexiangHint:(NSNotification*)notification
{
    NSLog(@"NOTIFICATION_ROOT_NEW_MESSAGE");
    [self addCircleHint];
    isReply = YES;
    count = [NSString stringWithFormat:@"%@",notification.object];
}

- (void)UnHomeHint:(NSNotification*)notification
{
    NSLog(@"NOTIFICATION_CIRCLE_NEW_MESSAGE");
    [self addHomeHint];
}

#pragma mark---------设置返回按钮
- (void)settingBackButtonImage:(NSString *)imagename andSelectedImage:(NSString *)selImagename
{
    //[UZCommonMethod settingBackButtonImage:imagename andSelectedImage:selImagename];
    UIImage* backImage = [[UIImage imageNamed:imagename]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40,0,0)];
    UIImage* backImageSel = [[UIImage imageNamed:selImagename]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0,40,0,0)];
    
    if (IOS7||IOS8) {
        [[DSNavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[DSNavigationBar appearance] setBackIndicatorImage:backImage];
        [[DSNavigationBar appearance] setBackIndicatorTransitionMaskImage:backImageSel];
    }
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, -1000)
                                                         forBarMetrics:UIBarMetricsDefault];
}

#pragma mark -setupViewControllers
-(void)setupViewControllers
{
    NSArray* controllerNames=@[@"HomeViewController",
                               @"ShopListViewController",
                               @"UserInfoViewController"];
    [[DSNavigationBar appearance] setNavigationBarWithColor:UIColorFromRGB(0xe34a51)];
    [[DSNavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    if (IOS8) {
        [[DSNavigationBar appearance] setTranslucent:NO];
    }

    NSMutableArray* controllers=[[NSMutableArray alloc]init];
    for (NSString* controllerName in controllerNames)
    {
        BaseViewController* bvc=[[[NSClassFromString(controllerName) class] alloc]init];
        UINavigationController* nav=[[UINavigationController alloc]initWithNavigationBarClass:[DSNavigationBar class] toolbarClass:nil];
        [bvc setNeedsStatusBarAppearanceUpdate];
        [nav setViewControllers:@[bvc]];
        [controllers addObject:nav];
    }
    //设置返回按钮
    [self settingBackButtonImage:@"navbar_return_no" andSelectedImage:@"navbar_return_sel"];
    [self setViewControllers:controllers];
    [self customizeTabBarForController:self];
}

#pragma mark=====RDVTabBarDelegate
-(void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    [super tabBar:tabBar didSelectItemAtIndex:index];
    if (index == 0) {
        [self removeHomeHint];
    }else if(index == 2)
    {
        [self removeCircleHint];
        if (isReply == YES) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"ISNEWREPLY" object:count];
        }
    }
}

//设置tabbar点击两下不回退。
-(BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)viewController;
        // 这里是关键，只在栈中存大于一个viewController并且是当前选中的，就不做反应
        if ([nav.viewControllers count] > 1 && tabBarController.selectedViewController==viewController) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -customizeTabBarForController
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    //设置tab透明背景
    tabBarController.delegate = self;
    [tabBarController.tabBar setTranslucent:YES];
    tabBarController.tabBar.backgroundView.backgroundColor=UIColorFromRGB(0xe1e2e5);
    //设置选中图片
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *tabBarItemImages = [data objectForKey:@"configurationIcon"];
    NSArray *tabBarItemNames = [data objectForKey:@"configurationName"];
    NSInteger index = 0;
    
    [tabBarController.tabBar setHeight:44.0f];
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:nil withUnselectedImage:nil];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_no",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setItemHeight:44];
        //设置item名称
        NSString* itemTitle=[tabBarItemNames objectAtIndex:index];
        [item setTitle:itemTitle];
        //设置item距离图片距离
        [item setTitlePositionAdjustment:UIOffsetMake(0, 2)];
        //设置itemtitle选中颜色以及未选中颜色
        [item setUnselectedTitleAttributes: @{
                                              NSFontAttributeName: [UIFont systemFontOfSize:10],
                                              NSForegroundColorAttributeName: UIColorFromRGB(0x969595),
                                              }];
        [item setSelectedTitleAttributes: @{
                                              NSFontAttributeName: [UIFont systemFontOfSize:10],
                                              NSForegroundColorAttributeName:UIColorFromRGB(0xe34a51),
                                              }];
        
        index++;
    }
    
    
    NSUserDefaults *loginDefault = [NSUserDefaults standardUserDefaults];
    if ([[loginDefault objectForKey:@"is_HomeHint"] isEqualToString: @"YES"]) {
        [self addHomeHint];
    }
    if ([[loginDefault objectForKey:@"is_CircleHint"] isEqualToString: @"YES"]) {
        [self addCircleHint];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------首页tabbar提示
-(void)addHomeHint
{
    [self.tabBar addSubview:[self homeImage]];
    NSUserDefaults *loginDefault = [NSUserDefaults standardUserDefaults];
    [loginDefault setObject:@"YES" forKey:@"is_HomeHint"];
    [loginDefault synchronize];
}

-(void)removeHomeHint
{
    [[self homeImage] removeFromSuperview];
    NSUserDefaults *loginDefault = [NSUserDefaults standardUserDefaults];
    [loginDefault setObject:@"NO" forKey:@"is_HomeHint"];
    [loginDefault synchronize];
}

#pragma mark---------朋友圈tabbar提示
-(void)addCircleHint
{
    [self.tabBar addSubview:[self circleImage]];
    NSUserDefaults *loginDefault = [NSUserDefaults standardUserDefaults];
    [loginDefault setObject:@"YES" forKey:@"is_CircleHint"];
    [loginDefault synchronize];
}

-(void)removeCircleHint
{
    [[self circleImage] removeFromSuperview];
    NSUserDefaults *loginDefault = [NSUserDefaults standardUserDefaults];
    [loginDefault setObject:@"NO" forKey:@"is_CircleHint"];
    [loginDefault synchronize];
}

#pragma mark--------提示图标
-(UIImageView*)homeImage
{
    if (!_homeImage) {
        //CGRect rect = [[UIScreen mainScreen] bounds];
        int x_pos =  10;
        _homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(x_pos, 5, 5, 5)];
        [_homeImage setBackgroundColor:[UIColor redColor]];
    }
    return _homeImage;
}

-(UIImageView*)circleImage
{
    if (!_circleImage) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        int x_pos = rect.size.width / 5 * 2+ 10;
        _circleImage = [[UIImageView alloc] initWithFrame:CGRectMake(x_pos, 5, 5, 5)];
        [_circleImage setBackgroundColor:[UIColor redColor]];
    }
    return _circleImage;
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
