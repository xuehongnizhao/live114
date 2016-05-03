//
//  mySpikeTableViewCell.m
//  CardLeap
//
//  Created by lin on 1/9/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "mySpikeTableViewCell.h"

@interface mySpikeTableViewCell()
@property (strong, nonatomic) UIImageView *spike_pic;//优惠券图片
@property (strong, nonatomic) UILabel *spike_name_lable;//优惠券名称
@property (strong, nonatomic) UILabel *status_lable;//优惠券状态
@property (strong, nonatomic) UILabel *end_time_lable;//优惠券截至时间
@property (strong, nonatomic) UIButton *delete_button;//删除按钮
@end

@implementation mySpikeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)configureCell :(mySpikeInfo*)info row:(NSInteger)row
{
    //
    [self.contentView addSubview:self.spike_pic];
    [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
    [_spike_pic autoSetDimension:ALDimensionWidth toSize:100.0f];
    [_spike_pic sd_setImageWithURL:[NSURL URLWithString:info.spike_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    //
    [self.contentView addSubview:self.delete_button];
    _delete_button.tag = row;
    [_delete_button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_delete_button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
    [_delete_button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
    [_delete_button autoSetDimension:ALDimensionWidth toSize:30.0f];
    if ([info.is_delete integerValue]==0) {
        //未选择
        [_delete_button setImage:[UIImage imageNamed:@"adreess_no"] forState:UIControlStateNormal];
    }else{
        //选择
        [_delete_button setImage:[UIImage imageNamed:@"adreess_sel"] forState:UIControlStateNormal];
    }
    //
    [self.contentView addSubview:self.spike_name_lable];
    [_spike_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_spike_name_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_spike_pic withOffset:5.0f];
    [_spike_name_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [_spike_name_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_delete_button withOffset:-5.0f];
    _spike_name_lable.text = info.spike_name;
    //
    [self.contentView addSubview:self.status_lable];
    [_status_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_spike_pic withOffset:5.0f];
    [_status_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_spike_name_lable withOffset:8.0f];
    [_status_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_delete_button withOffset:-5.0f];
    [_status_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    //判断优惠券状态
    _status_lable.text=info.is_result;
    if ([info.is_use integerValue]==0) {
        _status_lable.textColor = UIColorFromRGB(0x91c0c3);
    }else{
        _status_lable.textColor = UIColorFromRGB(0xe64d54);
    }
//    if (info.is_result.length>0) {
//        _status_lable.textColor = UIColorFromRGB(0xde807e);
//        = @"已过期";
//    }else{
//        _status_lable.text = info.is_pay;
//    }
    [self.contentView addSubview:self.end_time_lable];
    [_end_time_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_spike_pic withOffset:5.0f];
    [_end_time_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_status_lable withOffset:8.0f];
    [_end_time_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_delete_button withOffset:-5.0f];
    [_end_time_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
    _end_time_lable.text = [NSString stringWithFormat:@"结束时间：%@",info.use_end_time];
}

#pragma mark----------------get UI
-(UIImageView *)spike_pic
{
    if (!_spike_pic) {
        _spike_pic = [[UIImageView alloc] initForAutoLayout];
        _spike_pic.layer.borderWidth = 0.5;
        _spike_pic.layer.borderColor = UIColorFromRGB(0x74747).CGColor;
    }
    return _spike_pic;
}

-(UILabel *)spike_name_lable
{
    if (!_spike_name_lable) {
        _spike_name_lable = [[UILabel alloc] initForAutoLayout];
        _spike_name_lable.font = [UIFont systemFontOfSize:15.0f];
        _spike_name_lable.textColor = UIColorFromRGB(indexTitle);
    }
    return _spike_name_lable;
}

-(UILabel *)status_lable
{
    if (!_status_lable) {
        _status_lable = [[UILabel alloc] initForAutoLayout];
        _status_lable.font = [UIFont systemFontOfSize:13.0f];
        _status_lable.textColor = UIColorFromRGB(0x91c0c3);
    }
    return _status_lable;
}

-(UILabel *)end_time_lable
{
    if (!_end_time_lable) {
        _end_time_lable = [[UILabel alloc] initForAutoLayout];
        _end_time_lable.font = [UIFont systemFontOfSize:12.0f];
        _end_time_lable.textColor = UIColorFromRGB(0xde807e);
    }
    return _end_time_lable;
}

-(UIButton *)delete_button
{
    if (!_delete_button) {
        _delete_button = [[UIButton alloc] initForAutoLayout];
        [_delete_button addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delete_button;
}

#pragma mark------------choose action
-(void)chooseAction:(UIButton*)sender
{
    NSLog(@"选择删除按钮");
    [self.delegate deleteMySpikeDelegate:sender.tag];
}

@end
