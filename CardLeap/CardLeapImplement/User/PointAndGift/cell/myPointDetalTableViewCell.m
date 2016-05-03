//
//  myPointDetalTableViewCell.m
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myPointDetalTableViewCell.h"

@interface myPointDetalTableViewCell()
@property (strong,nonatomic)UILabel *operationLable;
@property (strong,nonatomic)UILabel *pointLable;
@property (strong,nonatomic)UILabel *timeLable;
@end

@implementation myPointDetalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark-------设置cell的显示
-(void)configureCell:(myPointInfo*)info
{
    //获得积分操作
    [self.contentView addSubview:self.operationLable];
    [_operationLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_operationLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_operationLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_operationLable sizeToFit];
    _operationLable.text = info.operation;
    //获取的积分显示
    [self.contentView addSubview:self.pointLable];
    [_pointLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f];
    [_pointLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_pointLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_pointLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_operationLable withOffset:3.0f];
    _pointLable.text = info.pay_point;
    
    [self.contentView addSubview:self.timeLable];
    [_timeLable autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) excludingEdge:ALEdgeLeft];
    [_timeLable sizeToFit];
    _timeLable.text = info.time;
}

#pragma mark-------get UI
-(UILabel *)operationLable
{
    if (!_operationLable) {
        _operationLable = [[UILabel alloc] initForAutoLayout];
        _operationLable.font = [UIFont systemFontOfSize:13.0f];
        _operationLable.textColor = UIColorFromRGB(singleTitle);
    }
    return _operationLable;
}

-(UILabel *)pointLable
{
    if (!_pointLable) {
        _pointLable = [[UILabel alloc] initForAutoLayout];
        _pointLable.font = [UIFont systemFontOfSize:13.0];
        _pointLable.textColor = UIColorFromRGB(0x79c5d3);
        _pointLable.textAlignment = NSTextAlignmentLeft;
    }
    return _pointLable;
}

- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] initForAutoLayout];
        _timeLable.textColor = UIColorFromRGB(singleTitle);
        _timeLable.font = [UIFont systemFontOfSize:13];
        _timeLable.textAlignment = NSTextAlignmentRight;
    }
    return _timeLable;
}

@end
