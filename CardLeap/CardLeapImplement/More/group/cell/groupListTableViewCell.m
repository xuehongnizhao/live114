//
//  groupListTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "groupListTableViewCell.h"

@interface groupListTableViewCell()
@property (strong,nonatomic)UIImageView *shop_pic;
@property (strong,nonatomic)UILabel *shop_name;
@property (strong,nonatomic)UILabel *shop_address;
@property (strong,nonatomic)UILabel *shop_price;
@end

@implementation groupListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)confirgureCell:(groupInfo*)info
{
    [self.contentView addSubview:self.shop_pic];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_shop_pic autoSetDimension:ALDimensionWidth toSize:80.0f];
    [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.pic] placeholderImage:[UIImage imageNamed:@"user"]];
    
    [self.contentView addSubview:self.shop_name];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_shop_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_shop_name autoSetDimension:ALDimensionHeight toSize:25.0f];
    _shop_name.text = info.group_name;
    
    [self.contentView addSubview:self.shop_address];
    [_shop_address autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_shop_address autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_shop_address autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:3.0f];
    [_shop_address autoSetDimension:ALDimensionHeight toSize:18.0f];
    _shop_address.text = [NSString stringWithFormat:@"【%@】",info.shop_address];
    
    [self.contentView addSubview:self.shop_price];
    [_shop_price autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_address withOffset:5.0f];
    [_shop_price autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_shop_price autoSetDimension:ALDimensionHeight toSize:18.0f];
    [_shop_price autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    _shop_price.text = [NSString stringWithFormat:@"￥%@",info.now_price];
}

#pragma mark-------get　UI
-(UIImageView *)shop_pic
{
    if (!_shop_pic) {
        _shop_pic = [[UIImageView alloc] initForAutoLayout];
        _shop_pic.layer.borderColor = UIColorFromRGB(0xa7a7a5).CGColor;
        _shop_pic.layer.borderWidth = 0.5;
    }
    return _shop_pic;
}

-(UILabel *)shop_name
{
    if (!_shop_name) {
        _shop_name = [[UILabel alloc] initForAutoLayout];
        _shop_name.font = [UIFont systemFontOfSize:15.0f];
        _shop_name.textColor = UIColorFromRGB(indexTitle);
    }
    return _shop_name;
}

-(UILabel *)shop_address
{
    if (!_shop_address) {
        _shop_address = [[UILabel alloc] initForAutoLayout];
        _shop_address.font = [UIFont systemFontOfSize:13.0f];
        _shop_address.textColor = UIColorFromRGB(addressTitle);
    }
    return _shop_address;
}

-(UILabel *)shop_price
{
    if (!_shop_price) {
        _shop_price = [[UILabel alloc] initForAutoLayout];
        _shop_price.font = [UIFont systemFontOfSize:13.0f];
        _shop_price.textColor = UIColorFromRGB(0xda8793);
    }
    return _shop_price;
}

@end
