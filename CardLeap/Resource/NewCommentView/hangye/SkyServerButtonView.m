//
//  SkyServerButtonView.m
//  cityo2o
//
//  Created by hm－02 on 15/7/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SkyServerButtonView.h"
#import "UIButton+WebCache.h"

@interface SkyServerButtonView()<SDWebImageManagerDelegate>
@property(nonatomic,strong)UIButton* imageButton;
@property(nonatomic,strong)UILabel* buttonLabel;
@property (strong ,nonatomic)UIButton *blankButton;
@end

@implementation SkyServerButtonView


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

-(UIButton *)blankButton
{
    if (!_blankButton) {
        _blankButton = [[UIButton alloc] initForAutoLayout];
        _blankButton.backgroundColor = [UIColor clearColor];
        
        CGSize imageSize = CGSizeMake(50, 50);
        //修改图标尺寸
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [_blankButton setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    }
    return _blankButton;
}



#pragma mark setButtonTag
-(void)setButtonViewTag:(NSInteger)tag
{
    _blankButton.tag = tag;
    //    [_imageButton setTag:tag];
}

#pragma mark addTarget
-(void)addTarget:(id)view action:(SEL)selector
{
    [_blankButton addTarget:view action:selector forControlEvents:UIControlEventTouchUpInside];
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
    [self addSubview:self.buttonLabel];
    [self addSubview:self.blankButton];
    [self setAutolayout];
    
}
#pragma mark --- 2016.4设置生活服务图标大小
-(void)setAutolayout
{
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.f];
    [_imageButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_imageButton autoSetDimension:ALDimensionHeight toSize:37];
    [_imageButton autoSetDimension:ALDimensionWidth toSize:37];
    //[_imageButton autoSetDimensionsToSize:CGSizeMake(50*LinPercent, 50*LinHeightPercent)];
    
    [_buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_buttonLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imageButton withOffset:0.0f];
    
    [_blankButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_blankButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_blankButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_blankButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}

#pragma mark Property Accessor
-(UIButton *)imageButton
{
    if (!_imageButton)
    {
        _imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        //_imageButton.backgroundColor=[UIColor blueColor];
    }
    return _imageButton;
}

-(UILabel *)buttonLabel
{
    if (!_buttonLabel)
    {
        _buttonLabel=[[UILabel alloc]initForAutoLayout];
        _buttonLabel.font=[UIFont systemFontOfSize:9*LinPercent];
        _buttonLabel.textColor = UIColorFromRGB(indexTitle);
        _buttonLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _buttonLabel;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
