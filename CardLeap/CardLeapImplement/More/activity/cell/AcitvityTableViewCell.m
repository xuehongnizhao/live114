//
//  AcitvityTableViewCell.m
//  CardLeap
//
//  Created by lin on 1/12/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "AcitvityTableViewCell.h"

@interface AcitvityTableViewCell()
@property (strong, nonatomic) UIImageView *activityImage;
@property (strong, nonatomic) UILabel *activityNameLable;
@property (strong, nonatomic) UILabel *beginTimeLable;
@property (strong, nonatomic) UILabel *endTimeLable;
@end

@implementation AcitvityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confirgureCell:(activityInfo*)info
{
    //---image------
    [self.contentView addSubview:self.activityImage];
    [_activityImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_activityImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_activityImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_activityImage autoSetDimension:ALDimensionWidth toSize:80.0f];
    [_activityImage sd_setImageWithURL:[NSURL URLWithString:info.activity_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    //---name-------
    [self.contentView addSubview:self.activityNameLable];
    [_activityNameLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_activityNameLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_activityNameLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [_activityNameLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_activityImage withOffset:8.0f];
    _activityNameLable.text = info.activity_name;
    //----begin time----
    [self.contentView addSubview:self.beginTimeLable];
    [_beginTimeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_activityNameLable withOffset:5.0f];
    [_beginTimeLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_beginTimeLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_beginTimeLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_activityImage withOffset:8.0f];
    _beginTimeLable.text = [NSString stringWithFormat:@"开始时间：%@",info.begin_time];
    //----end time-------
    [self.contentView addSubview:self.endTimeLable];
    [_endTimeLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_endTimeLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_endTimeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_beginTimeLable withOffset:5.0f];
    [_endTimeLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_activityImage withOffset:8.0f];
    _endTimeLable.text = [NSString stringWithFormat:@"结束时间：%@",info.end_time];
}

#pragma mark----------get UI
-(UIImageView *)activityImage
{
    if (!_activityImage) {
        _activityImage = [[UIImageView  alloc] initForAutoLayout];
        _activityImage.layer.borderWidth = 0.5;
        _activityImage.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
    }
    return _activityImage;
}

-(UILabel *)activityNameLable
{
    if (!_activityNameLable) {
        _activityNameLable = [[UILabel alloc] initForAutoLayout];
        _activityNameLable.textColor = UIColorFromRGB(indexTitle);
        _activityNameLable.font = [UIFont systemFontOfSize:15.0f];
    }
    return _activityNameLable;
}

-(UILabel *)beginTimeLable
{
    if (!_beginTimeLable) {
        _beginTimeLable = [[UILabel alloc] initForAutoLayout];
        _beginTimeLable.textColor = UIColorFromRGB(0xbadd7b);
        _beginTimeLable.font = [UIFont systemFontOfSize:13.0f];
    }
    return _beginTimeLable;
}

-(UILabel *)endTimeLable
{
    if (!_endTimeLable) {
        _endTimeLable = [[UILabel alloc] initForAutoLayout];
        _endTimeLable.font = [UIFont systemFontOfSize:13.0f];
        _endTimeLable.textColor = UIColorFromRGB(0xbf737f);
    }
    return _endTimeLable;
}

@end
