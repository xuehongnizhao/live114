//
//  groupPayTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "groupPayTableViewCell.h"

@interface groupPayTableViewCell()
@property (strong,nonatomic)UILabel *countLable;
@property (strong,nonatomic)UILabel *totalPriceLable;
@end

@implementation groupPayTableViewCell

-(void)confirgureCell:(NSInteger)row param:(NSDictionary*)dic
{
    if (row == 0) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        UILabel *group_name_lable = [[UILabel alloc] initForAutoLayout];
        group_name_lable.textColor = UIColorFromRGB(0x484848);
        group_name_lable.font = [UIFont systemFontOfSize:14.0f];
        group_name_lable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:group_name_lable];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        group_name_lable.text = dic[@"group_name"];
    }else if (row == 1){
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:tmpLable];
        tmpLable.font = [UIFont systemFontOfSize:13.0f];
        tmpLable.textColor = [UIColor lightGrayColor];
        tmpLable.text = @"数量：";
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [tmpLable autoSetDimension:ALDimensionWidth toSize:100.0f];
        
        [self.contentView addSubview:self.countLable];
        [_countLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_countLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_countLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_countLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100.0f];
        _countLable.text = dic[@"count"];
    }else if (row == 2){
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:tmpLable];
        tmpLable.font = [UIFont systemFontOfSize:13.0f];
        tmpLable.textColor = [UIColor lightGrayColor];
        tmpLable.text = @"总价：";
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [tmpLable autoSetDimension:ALDimensionWidth toSize:100.0f];
        
        [self.contentView addSubview:self.totalPriceLable];
        [_totalPriceLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_totalPriceLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_totalPriceLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_totalPriceLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100.0f];
        int count = [dic[@"count"] intValue];
        float single_price = [dic[@"singel_price"] floatValue];
        NSString *total_price = [NSString stringWithFormat:@"￥%0.2f",count*single_price];
        _totalPriceLable.text = total_price;
        
    }else if (row == 3){
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        UILabel *group_name_lable = [[UILabel alloc] initForAutoLayout];
        group_name_lable.textColor = UIColorFromRGB(0x484848);
        group_name_lable.font = [UIFont systemFontOfSize:14.0f];
        group_name_lable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:group_name_lable];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        group_name_lable.text = @"请选择支付方式";
    }else if (row == 4){
        UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
        imageView.image = [UIImage imageNamed:@"alipay_icon"];
        [self.contentView addSubview:imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [imageView autoSetDimension:ALDimensionWidth toSize:30.0f];
        
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        tmpLable.font = [UIFont systemFontOfSize:14.0f];
        tmpLable.textColor = UIColorFromRGB(0x484848);
        tmpLable.text = @"支付宝支付";
        [self.contentView addSubview:tmpLable];
        [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];

    }else if (row == 5){
        UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
        imageView.image = [UIImage imageNamed:@"login_wx"];
        [self.contentView addSubview:imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [imageView autoSetDimension:ALDimensionWidth toSize:30.0f];
        
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        tmpLable.font = [UIFont systemFontOfSize:14.0f];
        tmpLable.textColor = UIColorFromRGB(0x484848);
        tmpLable.text = @"微信支付";
        [self.contentView addSubview:tmpLable];
        [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];

    }
    else{
        UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
        imageView.image = [UIImage imageNamed:@"login_wx"];
        [self.contentView addSubview:imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [imageView autoSetDimension:ALDimensionWidth toSize:30.0f];
        
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        tmpLable.font = [UIFont systemFontOfSize:14.0f];
        tmpLable.textColor = UIColorFromRGB(0x484848);
        tmpLable.text = @"银联支付";
        [self.contentView addSubview:tmpLable];
        [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];

    }
}

#pragma mark-----get UI
-(UILabel *)countLable
{
    if (!_countLable) {
        _countLable = [[UILabel alloc] initForAutoLayout];
        _countLable.textColor = UIColorFromRGB(0xe54e55);
        _countLable.textAlignment = NSTextAlignmentRight;
    }
    return _countLable;
}

-(UILabel *)totalPriceLable
{
    if (!_totalPriceLable) {
        _totalPriceLable = [[UILabel alloc] initForAutoLayout];
        _totalPriceLable.textColor = UIColorFromRGB(0xe54e55);
        _totalPriceLable.textAlignment = NSTextAlignmentRight;
    }
    return _totalPriceLable;
}

@end
