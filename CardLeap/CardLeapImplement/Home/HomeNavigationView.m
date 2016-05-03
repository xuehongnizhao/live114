//
//  HomeNavigationView.m
//  CardLeap
//
//  Created by lin on 12/8/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "HomeNavigationView.h"

@interface HomeNavigationView()
{
    UIImageView *_searchView;//搜索图片
    UIImageView *_hintImage;//小红点
}
@property (strong,nonatomic)UIButton *logoButton;//logo的显示按钮
@property (strong,nonatomic)UIButton *messageButton;//进入私信的按钮
@property (strong,nonatomic)UIButton *phoneButton;//114button
@end

@implementation HomeNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor clearColor];
        [self setUI];
    }
    return self;
}

+(HomeNavigationView*)shareInstance
{
    static HomeNavigationView* user=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        user =[[self alloc]init];
        [user setUI];
    });
    return user;
}

-(void)setUI
{
    //logo button
    [self addSubview:self.logoButton];
    [_logoButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2.5f];
    [_logoButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.5f];
    [_logoButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_logoButton autoSetDimension:ALDimensionWidth toSize:60.0f];
    //message button
    [self addSubview:self.messageButton];
    [_messageButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-5.0f];
    [_messageButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-5.0f];
    [_messageButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_messageButton autoSetDimension:ALDimensionWidth toSize:35.0f];
    
    [self addSubview:self.phoneButton];
    [_phoneButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-5.0f];
    [_phoneButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-5.0f];
    [_phoneButton autoSetDimension:ALDimensionWidth toSize:45.0f];
    [_phoneButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_messageButton withOffset:-2.0f];
    //searchView
    [self addSubview:[self searchView]];
//    [[self searchView] autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [[self searchView] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-5.0f];
//    [[self searchView] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-5.0f];
   
//    [[self searchView] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.frame.size.width/2.0];
    [[self searchView] autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [[self searchView] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-8.0f];
    [[self searchView] autoSetDimension:ALDimensionWidth toSize:108.0f];
    [[self searchView] autoSetDimension:ALDimensionHeight toSize:44.0f];
//    self.laye.borderWidth = 1;
}

/**
 获取城市名称之后设置
 */
-(void)setCityName :(NSString*)cityName
{
    [_logoButton setTitle:cityName forState:UIControlStateNormal];
    [_logoButton setTitle:cityName forState:UIControlStateHighlighted];
}

/**
 添加提示红点
 */
-(void)addHint
{
    [[self messageButton] addSubview:[self hintImage]];
}

/**
 移除提示
*/
-(void)removeHint
{
    [[self hintImage] removeFromSuperview];
}

#pragma mark------获取控件
//应该为多城市按钮
-(UIButton *)logoButton
{
    if (!_logoButton) {
        _logoButton = [[UIButton alloc] initForAutoLayout];
        [_logoButton setTitle:@"哈尔滨﹀" forState:UIControlStateNormal];
        [_logoButton setTitle:@"哈尔滨﹀" forState:UIControlStateHighlighted];
        [_logoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _logoButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_logoButton addTarget:self action:@selector(goCityList:) forControlEvents:UIControlEventTouchDown];
    }
    return _logoButton;
}

-(UIButton *)phoneButton
{
    if (!_phoneButton) {
        _phoneButton = [[UIButton alloc] initForAutoLayout];
        [_phoneButton setImage:[UIImage imageNamed:@"telphome114_no"] forState:UIControlStateNormal];
        [_phoneButton setImage:[UIImage imageNamed:@"telphome114_sel"] forState:UIControlStateHighlighted];
        [_phoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchDown];
    }
    return _phoneButton;
}

//搜索框
-(UIImageView*)searchView
{
    if (!_searchView) {
        _searchView = [[UIImageView alloc] initForAutoLayout];
        [_searchView setImage:[UIImage imageNamed:@"home_logo"]];
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchShop:)];
//        _searchView.userInteractionEnabled = YES;
//        [_searchView addGestureRecognizer:gesture];
    }
    return _searchView;
}

//新消息button
-(UIButton*)messageButton
{
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] initForAutoLayout];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_search_no"]];
        [image setFrame:CGRectMake(5, 5, 25, 25)];
        [_messageButton addSubview:image];
        [_messageButton addTarget:self action:@selector(go2MyMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

-(UIImageView*)hintImage
{
    if (!_hintImage) {
        _hintImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 3, 8, 8)];
        _hintImage.layer.masksToBounds = YES;
        _hintImage.layer.cornerRadius = 4;
        [_hintImage setBackgroundColor:[UIColor whiteColor]];
    }
    return _hintImage;
}

-(void)setlogoButtonEnabel
{
    self.logoButton.userInteractionEnabled = YES;
}

-(void)go2MyMessage :(UIButton*)btn
{
//    [self removeHint];
    NSLog(@"跳转我的消息页面");
    [self.delegate goSeachShop:0];
}

-(void)searchShop :(UITapGestureRecognizer*)gesture
{
    NSLog(@"跳转搜索页面");
    [self.delegate goSeachShop:0];
}

-(void)goCityList:(UIButton*)sender
{
    sender.userInteractionEnabled = NO;
    NSLog(@"跳转到多城市列表");
    [self.delegate goSeachShop:2];
}

-(void)callPhone:(UIButton*)sender
{
    NSLog(@"拨打电话");
    [self.delegate goSeachShop:3];
}

@end
