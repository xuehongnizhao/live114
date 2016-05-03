//
//  groupSubmitTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "groupSubmitTableViewCell.h"

@interface groupSubmitTableViewCell()
@property (strong,nonatomic)UILabel *group_name_lable;
@property (strong,nonatomic)UILabel *total_price_lable;
@property (strong,nonatomic)UILabel *count_lable;
@property (strong,nonatomic)UIButton *addButton;
@property (strong,nonatomic)UIButton *subButton;
@end

@implementation groupSubmitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(NSDictionary*)dic row:(NSInteger)row
{
    if (row == 0) {
        [self.contentView addSubview:self.total_price_lable];
        [_total_price_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_total_price_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_total_price_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        int count = [dic[@"count"] integerValue];
        float single_price = [dic[@"singel_price"] floatValue];
        NSString *total_price = [NSString stringWithFormat:@"%0.2f",count*single_price];
        _total_price_lable.text = total_price;
        
        [self.contentView addSubview:self.group_name_lable];
        [_group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_group_name_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_group_name_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_total_price_lable withOffset:-2.0f];
        _group_name_lable.text = dic[@"group_name"];
        
        [self setBackgroundColor:UIColorFromRGB(0xf3f3f3)];
        
    }else if (row == 1){
        [self.contentView addSubview:self.addButton];
        [_addButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_addButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_addButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_addButton autoSetDimension:ALDimensionWidth toSize:30.0f];
        
        [self.contentView addSubview:self.count_lable];
        [_count_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_count_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_count_lable autoSetDimension:ALDimensionWidth toSize:40.0f];
        [_count_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_addButton withOffset:-3.0f];
        _count_lable.text = dic[@"count"];
        
        [self.contentView addSubview:self.subButton];
        [_subButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_addButton];
        [_subButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_count_lable withOffset:-3.0f];
        [_subButton autoSetDimension:ALDimensionWidth toSize:30.0f];
        [_subButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_subButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        tmpLable.font = [UIFont systemFontOfSize:13.0f];
        tmpLable.textColor = [UIColor lightGrayColor];
        tmpLable.text = @"数量：";
        [self.contentView addSubview:tmpLable];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [tmpLable autoSetDimension:ALDimensionWidth toSize:100.0f];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }else if (row == 2){
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:tmpLable];
        tmpLable.font = [UIFont systemFontOfSize:13.0f];
        tmpLable.textColor = [UIColor lightGrayColor];
        tmpLable.text = @"单价：";
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [tmpLable autoSetDimension:ALDimensionWidth toSize:100.0f];
        
        UILabel *tmpLable1 = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:tmpLable1];
        tmpLable1.font = [UIFont systemFontOfSize:13.0f];
        tmpLable1.textColor = UIColorFromRGB(0xe54e55);
        tmpLable1.text = [NSString stringWithFormat:@"￥%@",dic[@"singel_price"]];
        tmpLable1.textAlignment = NSTextAlignmentRight;
        [tmpLable1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [tmpLable1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [tmpLable1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [tmpLable1 autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

#pragma mark------get UI
-(UILabel *)group_name_lable
{
    if (!_group_name_lable) {
        _group_name_lable = [[UILabel alloc] initForAutoLayout];
        _group_name_lable.font = [UIFont systemFontOfSize:13.0f];
        _group_name_lable.textColor = UIColorFromRGB(0x6c6c6c);
        _group_name_lable.numberOfLines = 2;
    }
    return _group_name_lable;
}

-(UILabel *)total_price_lable
{
    if (!_total_price_lable) {
        _total_price_lable = [[UILabel alloc] initForAutoLayout];
        _total_price_lable.font = [UIFont systemFontOfSize:13.0f];
        _total_price_lable.textColor = UIColorFromRGB(0xe54e55);
        _total_price_lable.textAlignment = NSTextAlignmentRight;
    }
    return _total_price_lable;
}

-(UILabel *)count_lable
{
    if (!_count_lable) {
        _count_lable = [[UILabel alloc] initForAutoLayout];
        _count_lable.layer.borderWidth =1;
        _count_lable.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _count_lable.font = [UIFont systemFontOfSize:13.0f];
        _count_lable.textColor = UIColorFromRGB(0x6c6c6c);
        _count_lable.textAlignment = NSTextAlignmentCenter;
    }
    return _count_lable;
}

-(UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [[UIButton alloc] initForAutoLayout];
        [_addButton setImage:[UIImage imageNamed:@"order_duction-02"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"order_duction-02"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

-(UIButton *)subButton
{
    if (!_subButton) {
        _subButton = [[UIButton alloc] initForAutoLayout];
        [_subButton setImage:[UIImage imageNamed:@"order_duction"] forState:UIControlStateNormal];
        [_subButton setImage:[UIImage imageNamed:@"order_duction"] forState:UIControlStateHighlighted];
        [_subButton addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

#pragma mark------add and sub action
-(void)addAction:(UIButton*)sender
{
    NSLog(@"加方法");
    [self.delegate buttonActionAddSub:1];
}

-(void)subAction:(UIButton*)sender
{
    NSLog(@"减方法");
    [self.delegate buttonActionAddSub:0];
}

@end
