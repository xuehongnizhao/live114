//
//  UIViewController+ViewLayout.m
//  WMYRiceNoodles
//
//  Created by mac on 13-12-26.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "UIViewController+ViewLayout.h"

@implementation UIViewController (ViewLayout)


- (void)addLeftBarButtonWithImage:(NSString *)imageName
                 heightLightImage:(NSString *)heightLightImageName
                            title:(NSAttributedString *)title
                           action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, title.length*20, 22);
    [button setAttributedTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:heightLightImageName] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barbutton;
}



- (void)addBackBarButtonWithImage:(NSString *)imageName
                 heightLightImage:(NSString *)heightLightImageName
{
    [self addLeftBarButtonWithImage:imageName
                   heightLightImage:heightLightImageName
                              title:nil
                             action:@selector(backToFather)];
}

- (void)backToFather
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
