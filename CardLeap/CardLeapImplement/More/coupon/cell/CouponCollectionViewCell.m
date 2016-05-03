//
//  CouponCollectionViewCell.m
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "CouponCollectionViewCell.h"

@interface CouponCollectionViewCell ()

@property (strong, nonatomic) UIImageView *spike_pic;
@property (strong, nonatomic) UILabel *remain_num;
@property (strong, nonatomic) UILabel *end_time;
@property (strong, nonatomic) UILabel *spike_name;

@end

@implementation CouponCollectionViewCell

-(void)configureCell:(couponInfo*)info
{
    //--spike picture------------
    [self.contentView addSubview:self.spike_pic];
    [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:3.0f];
    [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:3.0f];
    [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3.0f];
    [_spike_pic autoSetDimension:ALDimensionHeight toSize:140.0f*LinPercent];
    [_spike_pic sd_setImageWithURL:[NSURL URLWithString:info.spike_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    
    [_spike_pic addSubview:self.end_time];
    [_end_time autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_end_time autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_end_time autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_end_time autoSetDimension:ALDimensionHeight toSize:20.0f];
    _end_time.textAlignment = NSTextAlignmentRight;
    _end_time.textColor = [UIColor whiteColor];
    _end_time.font = [UIFont systemFontOfSize:11.0f];
    _end_time.text = [NSString stringWithFormat:@"剩余%@张 截止%@",info.spike_lastnum,info.spike_end_time];
    //-----spike number left------
//    [_end_time addSubview:self.remain_num];
//    [_remain_num autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2.0f];
//    [_remain_num autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2.0f];
//    [_remain_num autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.0f];
//    [_remain_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2.0f];
//    _remain_num.text = [NSString stringWithFormat:@"剩余%@张",info.spike_lastnum];
//    _remain_num.layer.borderWidth = 1;
    //_remain_num.layer.borderColor = [UIColor redColor].CGColor;
    
    [self.contentView addSubview:self.spike_name];
    [_spike_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2.0f];
    [_spike_name autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2.0f];
    [_spike_name autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.0f];
    [_spike_name autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_spike_pic withOffset:2.0f];
    _spike_name.text = info.spike_name;
}

#pragma mark-----------get UI
-(UIImageView *)spike_pic
{
    if (!_spike_pic) {
        _spike_pic = [[UIImageView  alloc] initForAutoLayout];
        _spike_pic.layer.borderWidth = 0.5;
        _spike_pic.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    }
    return _spike_pic;
}

-(UILabel *)remain_num
{
    if (!_remain_num) {
        _remain_num = [[UILabel alloc] initForAutoLayout];
        _remain_num.font = [UIFont systemFontOfSize:11.0f];
        _remain_num.textColor = [UIColor whiteColor];
        _remain_num.backgroundColor = [UIColor clearColor];
        //_remain_num.alpha = 0.3;
    }
    return _remain_num;
}

-(UILabel *)end_time
{
    if (!_end_time) {
        _end_time = [[UILabel alloc] initForAutoLayout];
        _end_time.font = [UIFont systemFontOfSize:11.0f];
        _end_time.textColor = [UIColor whiteColor];
        _end_time.backgroundColor = [UIColor blackColor];
        _end_time.alpha = 0.5;
    }
    return _end_time;
}

-(UILabel *)spike_name
{
    if (!_spike_name) {
        _spike_name = [[UILabel alloc] initForAutoLayout];
        _spike_name.font = [UIFont systemFontOfSize:11.0f*LinPercent];
        _spike_name.textColor = UIColorFromRGB(indexTitle);
        _spike_name.textAlignment = NSTextAlignmentCenter;
    }
    return _spike_name;
}

@end
