//
//  GroupCheckCodeTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  团购凭证cell

#import "GroupCheckCodeTableViewCell.h"
//#import "QREncoder.h"
#import "QRCodeGenerator.h"

@interface GroupCheckCodeTableViewCell()
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *shop_desc_lable;
@property (strong, nonatomic) UILabel *invalue_date_lable;
@property (strong, nonatomic) UILabel *pass_word_lable;
@property (strong, nonatomic) UIImageView *spike_code_image;
@end

@implementation GroupCheckCodeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confirgureCell:(NSDictionary*)dic section:(NSInteger)section row:(NSInteger)row
{
    if (section == 0) {
#pragma mark --- 12.1 删除图标
//        [self.contentView addSubview:self.iconImage];
//        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
//        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
//        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50.0f];
//        [_iconImage autoSetDimension:ALDimensionWidth toSize:40.0f];
        //        _iconImage.layer.masksToBounds = YES;
        //        _iconImage.layer.cornerRadius = 20.0f;
//        _iconImage.image = [UIImage imageNamed:@"yhq_icon"];
        
        [self.contentView addSubview:self.shop_desc_lable];
        //_shop_desc_lable.layer.borderWidth = 1;
        [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_shop_desc_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
//        [_shop_desc_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:5.0f];
        [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
        [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        _shop_desc_lable.text = dic[@"spike_desc"];
        
        [self.contentView addSubview:self.invalue_date_lable];
//        [_invalue_date_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:5.0f];
        [_invalue_date_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
        [_invalue_date_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_desc_lable withOffset:5.0f];
        [_invalue_date_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_invalue_date_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        _invalue_date_lable.text = [NSString stringWithFormat:@"有效期至：%@",dic[@"spike_end_time"]];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else{
        [self setAccessoryType:UITableViewCellAccessoryNone];
        NSArray *array = dic[@"spike_code"];
        NSString *code = [[array objectAtIndex:row] objectForKey:@"order_pass"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.pass_word_lable];
        [_pass_word_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
        [_pass_word_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
        [_pass_word_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_pass_word_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
        _pass_word_lable.text = [NSString stringWithFormat:@"密码为：%@",code];
        
        [self.contentView addSubview:self.spike_code_image];
        [_spike_code_image autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_pass_word_lable withOffset:5.0f];
        [_spike_code_image autoAlignAxis:ALAxisVertical toSameAxisOfView:_pass_word_lable];
        [_spike_code_image autoSetDimension:ALDimensionHeight toSize:150.0f];
        [_spike_code_image autoSetDimension:ALDimensionWidth toSize:150.0f];
        _spike_code_image.image =  [QRCodeGenerator qrImageForString:code imageSize:200];
        [_spike_code_image layer].magnificationFilter = kCAFilterNearest;
    }
}

#pragma mark-----------get UI
-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initForAutoLayout];
        _iconImage.layer.borderWidth = 0.5;
        _iconImage.layer.borderColor = UIColorFromRGB(0x949494).CGColor;
    }
    return _iconImage;
}

-(UILabel *)shop_desc_lable
{
    if (!_shop_desc_lable) {
        _shop_desc_lable = [[UILabel alloc] initForAutoLayout];
        _shop_desc_lable.font = [UIFont systemFontOfSize:14.0f];
        _shop_desc_lable.textColor = UIColorFromRGB(0x484848);
    }
    return _shop_desc_lable;
}

-(UILabel *)invalue_date_lable
{
    if (!_invalue_date_lable) {
        _invalue_date_lable = [[UILabel alloc] initForAutoLayout];
        _invalue_date_lable.font = [UIFont systemFontOfSize:13.0f];
        _invalue_date_lable.textColor = [UIColor lightGrayColor];
    }
    return _invalue_date_lable;
}

-(UILabel *)pass_word_lable
{
    if (!_pass_word_lable) {
        _pass_word_lable = [[UILabel alloc] initForAutoLayout];
        _pass_word_lable.textAlignment = NSTextAlignmentCenter;
        _pass_word_lable.font = [UIFont systemFontOfSize:13.0f];
        _pass_word_lable.textColor = UIColorFromRGB(0x484848);
    }
    return _pass_word_lable;
}

-(UIImageView *)spike_code_image
{
    if (!_spike_code_image) {
        _spike_code_image = [[UIImageView alloc] initForAutoLayout];
        _spike_code_image.layer.masksToBounds = YES;
        _spike_code_image.layer.cornerRadius = 4.0f;
        _spike_code_image.layer.borderWidth = 0.5f;
        _spike_code_image.layer.borderColor = UIColorFromRGB(0xcbcbcb).CGColor;
    }
    return _spike_code_image;
}


@end
