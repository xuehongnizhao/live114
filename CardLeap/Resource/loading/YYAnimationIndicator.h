//
//  YYAnimationIndicator.h
//  AnimationIndicator
//
//  Created by 王园园 on 14-8-26.
//  Copyright (c) 2014年 王园园. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
/**
    使用方法：
     YYAnimationIndicator *indicator;
     //创建
     indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-40, 80, 80)];
     [indicator setLoadText:@"正在加载..."];
     [self.view addSubview:indicator];
     //各种状态
      [indicator startAnimation];  //开始转动
      [indicator stopAnimationWithLoadText:@"加载成功" withType:YES];//加载成功
      [indicator stopAnimationWithLoadText:@"加载失败" withType:YES];//加载失败
 */
#import <UIKit/UIKit.h>

@interface YYAnimationIndicator : UIView

{
    UIImageView *imageView;
    UILabel *Infolabel;
}

@property (nonatomic, assign) NSString *loadtext;
@property (nonatomic, readonly) BOOL isAnimating;


//use this to init
- (id)initWithFrame:(CGRect)frame;
-(void)setLoadText:(NSString *)text;

- (void)startAnimation;
- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;

-(instancetype)shareInstance;
@end
