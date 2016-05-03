//
//  LinLoadingView.m
//  CardLeap
//
//  Created by lin on 12/19/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "LinLoadingView.h"

@interface LinLoadingView()
@end

@implementation LinLoadingView
static YYAnimationIndicator *loading;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(LinLoadingView*)shareInstances:(UIView *)view
{
    static LinLoadingView* user=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        user =[[LinLoadingView alloc]init];
        user.frame = CGRectMake(view.frame.size.width/2-40, view.frame.size.height/2-80, 80, 80);
        user.backgroundColor = [UIColor clearColor];
        loading = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [loading setLoadText:@"玩命加载中..."];
        [user addSubview:loading];
    });
    [view addSubview:user];
    return user;
}

-(void)startAnimation
{
    [loading startAnimation];
}

-(void)stopWithAnimation :(NSString*)text
{
    [self removeFromSuperview];
    [loading stopAnimationWithLoadText:text withType:YES];//加载成功
}

@end
