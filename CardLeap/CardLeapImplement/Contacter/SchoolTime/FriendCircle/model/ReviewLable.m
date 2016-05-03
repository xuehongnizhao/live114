//
//  ReviewLable.m
//  EnjoyDQ
//
//  Created by lin on 14-9-10.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "ReviewLable.h"

@implementation ReviewLable
@synthesize review_web = _review_web;
@synthesize html = _html;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setString :(NSString*)reviewText
{
    _html = reviewText;
    [self setUI];
}

-(void)setUI
{
    _review_web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 230, 50)];
    _review_web.userInteractionEnabled = NO;
    [_review_web loadHTMLString:_html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    _review_web.delegate = self;
    //lable加载web显示
    [self addSubview:_review_web];
}

//webview代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改webview的尺寸 修改lable的尺寸
    CGFloat webViewHeight = [[_review_web stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    [_review_web setFrame:CGRectMake(0, 0, 230, webViewHeight)];
    CGRect rect = self.frame;
    rect.size.height = webViewHeight;
    self.frame = rect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
