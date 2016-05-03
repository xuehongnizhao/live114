//
//  myPointGiftTableViewCell.m
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myPointGiftTableViewCell.h"

@interface myPointGiftTableViewCell()
@property (strong,nonatomic)UIImageView *giftImage;//礼品图片
@property (strong,nonatomic)UILabel *giftName;//礼品名称
@property (strong,nonatomic)UILabel *giftBrief;//礼品描述
@property (strong,nonatomic)UILabel *pointLable;//礼品所需积分
@property (strong,nonatomic)UILabel *stateLable;//兑换状态
@end

@implementation myPointGiftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 设置cell的样式显示
 */
-(void)configureCell:(myPointGiftInfo*)myInfo
{
    //礼品图片显示
    [self.contentView addSubview:self.giftImage];
    [_giftImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_giftImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_giftImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_giftImage autoSetDimension:ALDimensionWidth toSize:115];
    [_giftImage sd_setImageWithURL:[NSURL URLWithString:myInfo.img] placeholderImage:[UIImage imageNamed:@"user"]];
    //礼品名称
    [self.contentView addSubview:self.giftName];
    [_giftName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_giftName autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_giftName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_giftImage withOffset:5.0f];
    [_giftName autoSetDimension:ALDimensionHeight toSize:20.0f];
    _giftName.text = myInfo.mall_name;
    //礼品需要积分数量
    [self.contentView addSubview:self.pointLable];
    [_pointLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_pointLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_giftImage withOffset:5.0f];
    [_pointLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_pointLable autoSetDimension:ALDimensionWidth toSize:100.0f];
    _pointLable.text = [NSString stringWithFormat:@"%@积分",myInfo.mall_integral];
    //兑换状态
    [self.contentView addSubview:self.stateLable];
    [_stateLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_stateLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_stateLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_pointLable withOffset:-3.0f];
    [_stateLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    _stateLable.text=myInfo.result;
    if ([myInfo.color integerValue]==2) {
        _stateLable.textColor = [UIColor lightGrayColor];
    }
    //礼品描述
    [self.contentView addSubview:self.giftBrief];
    [_giftBrief autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_giftImage withOffset:5.0f];
    [_giftBrief autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_giftName withOffset:10.0f];
    [_giftBrief autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//    [_giftBrief autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_pointLable withOffset:-5.0f];
    _giftBrief.text = myInfo.how_use;
}

#pragma mark-------getUI
-(UIImageView *)giftImage
{
    if (!_giftImage) {
        _giftImage = [[UIImageView alloc] initForAutoLayout];
        _giftImage.layer.borderWidth = 0.5;
        _giftImage.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
    }
    return _giftImage;
}

-(UILabel *)giftName
{
    if (!_giftName) {
        _giftName = [[UILabel alloc] initForAutoLayout];
        _giftName.font = [UIFont systemFontOfSize:15.0f];
        _giftName.textColor = UIColorFromRGB(indexTitle);
    }
    return _giftName;
}

-(UILabel *)giftBrief
{
    if (!_giftBrief) {
        _giftBrief = [[UILabel alloc] initForAutoLayout];
        _giftBrief.font = [UIFont systemFontOfSize:13.0f];
        _giftBrief.textColor = UIColorFromRGB(addressTitle);
        _giftBrief.numberOfLines = 0;
    }
    return _giftBrief;
}

-(UILabel *)pointLable
{
    if (!_pointLable) {
        _pointLable = [[UILabel alloc] initForAutoLayout];
        _pointLable.font = [UIFont systemFontOfSize:13.0f];
        _pointLable.textColor = UIColorFromRGB(0xe16c6c);
    }
    return _pointLable;
}

-(UILabel *)stateLable
{
    if (!_stateLable) {
        _stateLable = [[UILabel alloc] initForAutoLayout];
        _stateLable.font = [UIFont systemFontOfSize:13.0f];
        _stateLable.textColor = UIColorFromRGB(0x09b3cd);
        _stateLable.textAlignment = NSTextAlignmentRight;
    }
    return _stateLable;
}

@end
