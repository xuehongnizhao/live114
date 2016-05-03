//
//  UZCommonMethod.m
//  WMYRiceNoodles
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "UZCommonMethod.h"

@implementation UZCommonMethod : NSObject

+ (void)callPhone:(NSString *)phoneNumber superView:(UIView *)view
{
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *url = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    [view addSubview:webview];
}

+ (void)settingButton:(UIButton *)button
                Image:(NSString *)imageUrl
      hightLightImage:(NSString *)highLightImageUrl
         disableImage:(NSString *)disableImageUrl
{
    [button setImage:[UIImage imageNamed:imageUrl]
            forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:highLightImageUrl]
            forState:UIControlStateHighlighted];
    
    [button setImage:[UIImage imageNamed:disableImageUrl]
            forState:UIControlStateDisabled];
}


+ (void)settingButton:(UIButton *)button
                Image:(NSString *)imageUrl
      hightLightImage:(NSString *)highLightImageUrl
{
    [button setImage:[UIImage imageNamed:imageUrl]
            forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:highLightImageUrl]
            forState:UIControlStateHighlighted];
}


+ (void)settingButton:(UIButton *)button
                Image:(NSString *)imageUrl
        selectedImage:(NSString *)selectedImageUrl
{
    [button setImage:[UIImage imageNamed:imageUrl]
            forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:selectedImageUrl]
            forState:UIControlStateSelected];
}


+ (void)hiddleExtendCellFromTableview:(UITableView *)tableview
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [tableview setTableFooterView:view];
}


+ (void)settingBackButtonImage:(NSString *)imagename andSelectedImage:(NSString *)selImagename
{
    UIImage* backImage = [[UIImage imageNamed:imagename]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 40, 0)];
    UIImage* backImageSel = [[UIImage imageNamed:selImagename]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0,0, 40, 0)];
    
    if (IOS7||IOS8) {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBackIndicatorImage:backImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImageSel];
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


//+ (void)settingLeftButtonImage:(NSString *)imagename
//                 selectedImage:(NSString *)selectedImagename
//                        action:(SEL)action
//               andAtButtonItem:(UIBarButtonItem *)buttonItem
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageNamed:imagename]
//                      forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:selectedImagename]
//                      forState:UIControlStateHighlighted];
//    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *mybuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//#warning 内存溢出
//    buttonItem = mybuttonItem;
//}


+ (void)settingBackButtonImage:(NSString *)imagename
                 selectedImage:(NSString *)selectedImagename
                  andContrller:(UIViewController *)controller
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imagename]
                      forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImagename]
                      forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backToFather:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mybuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    controller.navigationItem.leftBarButtonItem = mybuttonItem;
}
+ (void)backToFather:(UIButton *)sender
{
    UINavigationBar *navigationBar = (UINavigationBar *)sender.superview;
    UINavigationController *nc = (UINavigationController *)[self GetViewController:navigationBar];
    [nc popViewControllerAnimated:YES];
}
+ (UIViewController*)GetViewController:(UIView*)uView
{
    for (UIView* next = [uView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


+ (CGFloat)checkSystemVersion
{
    static dispatch_once_t onceToken;
    __block float systemVersion = 0;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return systemVersion;
}

+ (NSString *)checkAPPVersion
{
    static dispatch_once_t onceToken;
    __block NSString *APPVersion = 0;
    dispatch_once(&onceToken, ^{
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        APPVersion = [infoDict objectForKey:@"CFBundleVersion"];
    });
    return APPVersion;
}



@end
