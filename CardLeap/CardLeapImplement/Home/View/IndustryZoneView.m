//
//  IndustryZoneView.m
//  cityo2o
//
//  Created by mac on 15/9/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "IndustryZoneView.h"
#import "linHangyeModel.h"
#import "UIButton+WebCache.h"
#import "linHangyeButtonView.h"

#define ViewHeight  220*LinHeightPercent
#define LeftSpacing 2  //左右间距
#define SubViewWidth (SCREEN_WIDTH -8)/4.0  //视图高度 (ViewHeight-30-6)/2.0
#define SubViewHeight (ViewHeight-30-6)/2.0  //视图高度
#define TopY        ((ViewHeight-30-SubViewHeight*2)-LeftSpacing)/2.0
#define DownY       (ViewHeight-30)/2.0 + 2.5 +30
#define SmallX      SCREEN_WIDTH/2.0
#define SmallWeith  (SCREEN_WIDTH - 20)/4.0
@interface IndustryZoneView ()

//左上大图
@property (nonatomic, strong) UIImageView *bigTopView;
//左下大图
@property (nonatomic, strong) UIImageView *bigDownView;
//左上小图
@property (nonatomic, strong) UIImageView *sLeftTopView;
//右上小图
@property (nonatomic, strong) UIImageView *sRightTopView;
//左下小图
@property (nonatomic, strong) UIImageView *sLeftDownView;
//右下小图
@property (nonatomic, strong) UIImageView *sRightDownView;
@end

@implementation IndustryZoneView

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
        [self initUI];
    }
    return self;
}

- (void) setModuleArray:(NSArray *)moduleArray{
    _moduleArray = moduleArray;
    [_bigTopView sd_setImageWithURL:[self backImageUrl:0] placeholderImage:nil];
    [_bigDownView sd_setImageWithURL:[self backImageUrl:3] placeholderImage:nil];
    [_sLeftTopView sd_setImageWithURL:[self backImageUrl:1] placeholderImage:nil];
    [_sRightTopView sd_setImageWithURL:[self backImageUrl:2] placeholderImage:nil];
    [_sLeftDownView sd_setImageWithURL:[self backImageUrl:4] placeholderImage:nil];
    [_sRightDownView sd_setImageWithURL:[self backImageUrl:5] placeholderImage:nil];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

}

- (void) initUI
{
    self.backgroundColor = [UIColor whiteColor];
    //添加标题label
    UILabel* serverLabel= [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    serverLabel.text    = @"如意专区";
    [self addSubview:serverLabel];
    //灰线
    UILabel* line       = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 0.3)];
    line.backgroundColor= UIColorFromRGB(0xe6e6e6);
    [self addSubview:line];
    
    
    //左上大图
    [self addSubview:self.bigTopView];
    [self.bigTopView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:TopY+30];
    [self.bigTopView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LeftSpacing];
    [self.bigTopView autoSetDimension:ALDimensionWidth toSize:SubViewWidth*2.0];
    [self.bigTopView autoSetDimension:ALDimensionHeight toSize:SubViewHeight];
    //左下大图
    [self addSubview:self.bigDownView];
    [self.bigDownView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigTopView withOffset:2];
    [self.bigDownView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LeftSpacing];
    [self.bigDownView autoSetDimension:ALDimensionWidth toSize:SubViewWidth*2.0];
    [self.bigDownView autoSetDimension:ALDimensionHeight toSize:SubViewHeight];
    CGFloat spacing = (SCREEN_WIDTH - SubViewWidth*4.0 - LeftSpacing*2.0)/2.0;
    //左上小图
    [self addSubview:self.sLeftTopView];
    [self.sLeftTopView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:TopY+30];
    [self.sLeftTopView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.bigDownView withOffset:spacing];
    [self.sLeftTopView autoSetDimension:ALDimensionWidth toSize:SubViewWidth];
    [self.sLeftTopView autoSetDimension:ALDimensionHeight toSize:SubViewHeight];
    //右上小图
    [self addSubview:self.sRightTopView];
    [self.sRightTopView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:TopY+30];
    [self.sRightTopView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sLeftTopView withOffset:spacing];
    [self.sRightTopView autoSetDimension:ALDimensionWidth toSize:SubViewWidth];
    [self.sRightTopView autoSetDimension:ALDimensionHeight toSize:SubViewHeight];
    //左下小图
    [self addSubview:self.sLeftDownView];
    [self.sLeftDownView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.sLeftTopView withOffset:2];
    [self.sLeftDownView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.bigDownView withOffset:spacing];
    [self.sLeftDownView autoSetDimension:ALDimensionWidth toSize:SubViewWidth];
    [self.sLeftDownView autoSetDimension:ALDimensionHeight toSize:SubViewHeight];
    //右下小图
    [self addSubview:self.sRightDownView];
    [self.sRightDownView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.sRightTopView withOffset:2];
    [self.sRightDownView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sLeftDownView withOffset:spacing];
    [self.sRightDownView autoSetDimension:ALDimensionWidth toSize:SubViewWidth];
    [self.sRightDownView autoSetDimension:ALDimensionHeight toSize:SubViewHeight];
}

- (NSURL *)backImageUrl:(int)i;
{
    linHangyeModel *model = [self.moduleArray objectAtIndex:i];
    return [NSURL URLWithString:model.index_pic];
}

#pragma mark - 懒加载
- (UIImageView *) bigTopView
{
    if (!_bigTopView) {
        _bigTopView =   [[UIImageView alloc] initForAutoLayout];//initWithFrame:CGRectMake(LeftSpacing, TopY+30, SubViewHeight*2+5,SubViewHeight)
        int i = 0;
        _bigTopView.tag = i;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonviewClick:)];
        [_bigTopView addGestureRecognizer:gesture];
        _bigTopView.userInteractionEnabled = YES;
    }
    return _bigTopView;
}

- (UIImageView *) bigDownView
{
    if (!_bigDownView) {
        _bigDownView = [[UIImageView alloc] initForAutoLayout];//initWithFrame:CGRectMake(LeftSpacing, DownY, SubViewHeight*2+5,SubViewHeight)
        int i = 3;
        _bigDownView.tag = i;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonviewClick:)];
        [_bigDownView addGestureRecognizer:gesture];
        _bigDownView.userInteractionEnabled = YES;
    }
    return _bigDownView;
}

- (UIImageView *) sLeftTopView
{
    if (!_sLeftTopView) {
        _sLeftTopView = [[UIImageView alloc] initForAutoLayout];//initWithFrame:CGRectMake(SmallX, TopY+30, SmallWeith,SubViewHeight)
        int i = 1;
        _sLeftTopView.tag = i;
        [_sLeftTopView sd_setImageWithURL:[self backImageUrl:i] placeholderImage:nil];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonviewClick:)];
        [_sLeftTopView addGestureRecognizer:gesture];
        _sLeftTopView.userInteractionEnabled = YES;
    }
    return _sLeftTopView;
}

- (UIImageView *) sRightTopView
{
    if (!_sRightTopView) {
        _sRightTopView = [[UIImageView alloc] initForAutoLayout];//initWithFrame:CGRectMake(SmallX+SmallWeith+5, TopY+30, SmallWeith, SubViewHeight)
        int i = 2;
        _sRightTopView.tag = i;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonviewClick:)];
        [_sRightTopView addGestureRecognizer:gesture];
        _sRightTopView.userInteractionEnabled = YES;
    }
    return _sRightTopView;
}

- (UIImageView *) sLeftDownView
{
    if (!_sLeftDownView) {
        _sLeftDownView = [[UIImageView alloc] initForAutoLayout];//initWithFrame:CGRectMake(SmallX, DownY, SmallWeith, SubViewHeight)
        int i = 4;
        _sLeftDownView.tag = i;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonviewClick:)];
        [_sLeftDownView addGestureRecognizer:gesture];
        _sLeftDownView.userInteractionEnabled = YES;
    }
    return _sLeftDownView;
}

- (UIImageView *) sRightDownView
{
    if (!_sRightDownView) {
        _sRightDownView = [[UIImageView alloc] initForAutoLayout];//initWithFrame:CGRectMake(SmallX+SmallWeith+5, DownY, SmallWeith, SubViewHeight)
        int i = 5;
        _sRightDownView.tag = i;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonviewClick:)];
        [_sRightDownView addGestureRecognizer:gesture];
        _sRightDownView.userInteractionEnabled = YES;
    }
    return _sRightDownView;
}

-(void)buttonviewClick:(UITapGestureRecognizer *) sender
{
    linHangyeModel* module=[self.moduleArray objectAtIndex:sender.view.tag];
    [self.delegate linHangyeclikButtonToPushViewController:module];
}

@end
