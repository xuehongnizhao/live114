//
//  ButtonView.m
//  LeDing
//
//  Created by Sky on 14/11/6.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "ButtonView.h"
#import "SDWebImageManager.h"

@interface ButtonView ()<SDWebImageManagerDelegate>

@property(nonatomic,strong)UIButton* imageButton;

@property(nonatomic,strong)UILabel* buttonLabel;

@end


@implementation ButtonView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
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
    //[[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url] delegate:self];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"正在下载");
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [_imageButton setImage:image forState:UIControlStateNormal];
    }];
    
    [_buttonLabel setText:title];
}
-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    //[_imageButton setImage:image forState:UIControlStateNormal];
}

#pragma mark setupViewsAndAutolayout
-(void)setupViews
{
    [self addSubview:self.imageButton];
    [self addSubview:self.buttonLabel];
    [self setAutolayout];
}

-(void)setAutolayout
{
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_imageButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_imageButton autoSetDimensionsToSize:CGSizeMake(50*LinPercent, 50*LinHeightPercent)];
    
    [_buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_buttonLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_buttonLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imageButton withOffset:0.0f];
}

#pragma mark Property Accessor
-(UIButton *)imageButton
{
    if (!_imageButton)
    {
        _imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        //_imageButton.backgroundColor=[UIColor orangeColor];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
