//
//  DishDetailView.m
//  LeDing
//
//  Created by Sky on 14/11/5.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "DishDetailView.h"

@interface DishDetailView ()<UIWebViewDelegate>


//关闭按钮
@property(nonatomic,strong)UIButton* closeButton;

//店铺web页面
@property(nonatomic,strong)UIWebView* shopWebView;

@property(nonatomic,strong)NSMutableArray* tableViewArray;

@end

@implementation DishDetailView
{
    
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor clearColor];
        //self.layer.borderWidth = 1;
        [self setupViews];
        //[self initWebViewContent];
    }
    return self;
}

//加载本地的html
-(void) initWebViewContent
{
    NSLog(@"%@",self.url);
    self.shopWebView.delegate=self;
    [self.shopWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}


#pragma mark webviewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    NSLog(@"components==%@",components);
    
    if ([components count] > 1 && [components[0] isEqualToString:@"testapp"])
    {
        NSLog(@"components==%@",[components objectAtIndex:1]);
        NSLog(@"components==%@",[components objectAtIndex:0]);
        if ([[components objectAtIndex:1] isEqualToString:@"praise"])
        {
            NSLog(@"电话号码是%@",[components objectAtIndex:2]);
        }
        return NO;
    }
    return YES;
}

#pragma mark setupViewsAndAutolayout
-(void)setupViews
{
    [self addSubview:self.shopWebView];
    [self addSubview:self.closeButton];
    [self setAutolayout];
}

-(void)setAutolayout
{
    [_closeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-30.0f];
    [_closeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-30.0f];
    [_closeButton autoSetDimensionsToSize:CGSizeMake(80, 80)];

    [_shopWebView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shopWebView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_shopWebView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.f];
    [_shopWebView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
}

#pragma mark 关闭view
-(void)removeView
{
    [self removeFromSuperview];
    [self.delegate isRemoveFromSuperView:YES];
}


#pragma mark Property Accessor

-(UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.layer.masksToBounds = YES;
        _closeButton.layer.cornerRadius = 20.0f;
        _closeButton.frame=CGRectMake(0, 0, 60, 60);
        [_closeButton setImage:[UIImage imageNamed:@"dish_close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"dish_close"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(UIWebView *)shopWebView
{
    if (!_shopWebView)
    {
        _shopWebView=[[UIWebView alloc]initForAutoLayout];
        //_shopWebView.layer.borderWidth  = 1;
        _shopWebView.backgroundColor = [UIColor whiteColor];
        _shopWebView.scalesPageToFit=YES;
        _shopWebView.scrollView.scrollEnabled=YES;
    }
    return _shopWebView;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
