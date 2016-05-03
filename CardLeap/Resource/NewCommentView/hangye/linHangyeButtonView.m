//
//  linHangyeButtonView.m
//  cityo2o
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "linHangyeButtonView.h"
#import "UIButton+WebCache.h"

@interface linHangyeButtonView()<SDWebImageManagerDelegate>
@property(nonatomic,strong)UIButton* imageButton;
@property(nonatomic,strong)UILabel* buttonLabel;
@end

@implementation linHangyeButtonView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setupViews];
    }
    return self;
}

-(instancetype)initForAutoLayout
{
    if (self=[super initForAutoLayout])
    {
        [self setupViews];
        
    }
    return self;
}

#pragma mark setButtonTag
-(void)setButtonViewTag:(NSInteger)tag
{
    [_imageButton setTag:tag];
}

#pragma mark addTarget
-(void)addTarget:(id)view action:(SEL)selector
{
    [_imageButton addTarget:view action:selector forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark setImageAndLabel
-(void)setButtonImageurl:(NSString *)url andTitle:(NSString *)title
{
    [self.imageButton sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    
    [_buttonLabel setText:title];
}


#pragma mark setupViewsAndAutolayout
-(void)setupViews
{
    [self addSubview:self.imageButton];
    [self setAutolayout];
}

-(void)setAutolayout
{
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

#pragma mark Property Accessor
-(UIButton *)imageButton
{
    if (!_imageButton)
    {
        _imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _imageButton;
}

-(UILabel *)buttonLabel
{
    if (!_buttonLabel)
    {
        _buttonLabel=[[UILabel alloc]initForAutoLayout];
        _buttonLabel.font=[UIFont systemFontOfSize:11*LinPercent];
        _buttonLabel.textColor = UIColorFromRGB(indexTitle);
        _buttonLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _buttonLabel;
}


@end
