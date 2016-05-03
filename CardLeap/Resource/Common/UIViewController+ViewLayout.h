//
//  UIViewController+ViewLayout.h
//  WMYRiceNoodles
//
//  Created by mac on 13-12-26.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewLayout)


- (void)addLeftBarButtonWithImage:(NSString *)imageName
                 heightLightImage:(NSString *)heightLightImageName
                            title:(NSString *)title
                           action:(SEL)action;


- (void)addBackBarButtonWithImage:(NSString *)imageName
                 heightLightImage:(NSString *)heightLightImageName;


@end
