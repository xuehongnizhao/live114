//
//  LoginMethodButtonView.m
//  CardLeap
//
//  Created by lin on 12/15/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "LoginMethodButtonView.h"

@interface LoginMethodButtonView ()
@property (strong, nonatomic) UIButton *LoginButton;//点击第三方的按钮
@property (strong, nonatomic) UILabel *buttonLabel;//注释lable
@end

@implementation LoginMethodButtonView

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
        [self setupViews];
    }
    return self;
}
#pragma mark-------布局显示
-(void)setupViews
{
    [self addSubview:self.LoginButton];
    [self.LoginButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [self.LoginButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [self.LoginButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [self.LoginButton autoSetDimension:ALDimensionWidth toSize:25.0f];
    [self addSubview:self.buttonLabel];
    [self.buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [self.buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [self.buttonLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.LoginButton withOffset:1.0f];
    [self.buttonLabel autoSetDimension:ALDimensionWidth toSize:45.0f];
}

-(NSInteger)getButtonViewTag
{
    return self.LoginButton.tag;
}

-(void)addTarget:(id)view action:(SEL)selector
{
    [self.LoginButton addTarget:view action:selector forControlEvents:UIControlEventTouchUpInside];
}


-(void)setButtonViewTag:(NSInteger) tag
{
    self.LoginButton.tag = tag;
}

-(void)setButtonImage:(NSString *)image text:(NSString *)text
{
    [self.LoginButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.LoginButton setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    self.buttonLabel.text = text;
}
#pragma mark------------clickAction
-(void)clickAction :(UIButton*)sender
{
    [self.delegate clickAction:sender.tag];
}
#pragma mark------------element
-(UIButton *)LoginButton
{
    if (!_LoginButton) {
        _LoginButton = [[UIButton alloc] initForAutoLayout];
        [_LoginButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _LoginButton;
}

-(UILabel *)buttonLabel
{
    if (!_buttonLabel) {
        _buttonLabel = [[UILabel alloc] initForAutoLayout];
        _buttonLabel.textColor = [UIColor lightGrayColor];
        _buttonLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _buttonLabel;
}
@end
