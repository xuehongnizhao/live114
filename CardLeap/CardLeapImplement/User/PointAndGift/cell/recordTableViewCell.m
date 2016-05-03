//
//  recordTableViewCell.m
//  cityo2o
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "recordTableViewCell.h"

@interface recordTableViewCell()
@property (strong,nonatomic)UIImageView *giftImage;//礼品图片
@property (strong,nonatomic)UILabel *giftName;//礼品名称
@property (strong,nonatomic)UILabel *giftBrief;//注释
@property (strong,nonatomic)UILabel *pointLable;//兑换码
@property (strong,nonatomic)UILabel *stateLable;//兑换状态
@end

@implementation recordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 配置cell的显示样式
 */
-(void)configureCell:(recordInfo*)info
{
    //礼品图片显示
    [self.contentView addSubview:self.giftImage];
    [_giftImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_giftImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_giftImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_giftImage autoSetDimension:ALDimensionWidth toSize:115];
    [_giftImage sd_setImageWithURL:[NSURL URLWithString:info.img] placeholderImage:[UIImage imageNamed:@"user"]];
    //礼品名称
    [self.contentView addSubview:self.giftName];
    [_giftName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_giftName autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_giftName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_giftImage withOffset:5.0f];
    [_giftName autoSetDimension:ALDimensionHeight toSize:20.0f];
    _giftName.text = info.mall_name;
    //礼品需要积分数量
    [self.contentView addSubview:self.pointLable];
    [_pointLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_pointLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_giftImage withOffset:5.0f];
    [_pointLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_pointLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    _pointLable.text = [NSString stringWithFormat:@"兑换码:%@",info.order_id];
    //礼品描述
    [self.contentView addSubview:self.giftBrief];
    [_giftBrief autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_giftImage withOffset:5.0f];
    [_giftBrief autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_giftName withOffset:10.0f];
    [_giftBrief autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f];
    [_giftBrief autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_pointLable withOffset:-5.0f];
    _giftBrief.text = [NSString stringWithFormat:@"数量:%@",info.num];
    //使用未使用状态
    [self.contentView addSubview:self.stateLable];
    [_stateLable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_giftBrief];
    [_stateLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_stateLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [_stateLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_giftBrief withOffset:5.0f];
    if ([info.is_use integerValue]==0) {
        _stateLable.text = @"未完成";
        _stateLable.textColor = UIColorFromRGB(0x00aa00);
    }else{
        _stateLable.text = @"已完成";
        _stateLable.textColor = UIColorFromRGB(0xe34a51);
    }
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
        _pointLable.textColor = UIColorFromRGB(0xff9900);
    }
    return _pointLable;
}

-(UILabel *)stateLable
{
    if (!_stateLable) {
        _stateLable = [[UILabel alloc] initForAutoLayout];
        _stateLable.font = [UIFont systemFontOfSize:13.0f];
        _stateLable.textAlignment = NSTextAlignmentRight;
    }
    return _stateLable;
}

@end
