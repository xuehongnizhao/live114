//
//  dishConfirmTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/31/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "dishConfirmTableViewCell.h"

@interface dishConfirmTableViewCell()<UIAlertViewDelegate>
@property (strong, nonatomic) UILabel *take_name_lable;
@property (strong, nonatomic) UILabel *take_price;
@property (strong, nonatomic) UILabel *count_lable;
@property (strong, nonatomic) UIButton *subButton;
@property (strong, nonatomic) UIButton *addButton;
@end

@implementation dishConfirmTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confirgureCell :(takeoutDishInfo*)info
{
    //----商品单价--------------
    [self.contentView addSubview:self.take_price];
    [_take_price autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_take_price autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_take_price autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [_take_price autoSetDimension:ALDimensionWidth toSize:80.0f];
    _take_price.text = [NSString stringWithFormat:@"￥%@",info.take_price];
//    _take_price.layer.borderWidth = 1;
    
    //----count lable----------
    [self.contentView addSubview:self.count_lable];
    [_count_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_count_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_count_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_take_price withOffset:-5.0f];
    [_count_lable autoSetDimension:ALDimensionWidth toSize:35.0f];
    _count_lable.text = [NSString stringWithFormat:@"x%ld",(long)info.count];
    if (info.count == 0) {
        self.count_lable.hidden = YES;
    }
//    _count_lable.layer.borderWidth = 1;
    
    //---外卖商品名称-----------
    [self.contentView addSubview:self.take_name_lable];
    [_take_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0f];
    [_take_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_take_name_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_take_name_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_count_lable withOffset:-3.0f];
    _take_name_lable.text = info.take_name;
//    _take_name_lable.layer.borderWidth = 1;
}

#pragma mark------get UI
-(UILabel *)take_name_lable
{
    if (!_take_name_lable) {
        _take_name_lable = [[UILabel alloc] initForAutoLayout];
        _take_name_lable.font = [UIFont systemFontOfSize:14.0f];
        _take_name_lable.textColor = UIColorFromRGB(singleTitle);
    }
    return _take_name_lable;
}

-(UILabel *)take_price
{
    if (!_take_price) {
        _take_price = [[UILabel alloc] initForAutoLayout];
        _take_price.font = [UIFont systemFontOfSize:14.0f];
        _take_price.textColor = UIColorFromRGB(0xe34a51);
        _take_price.numberOfLines = 0;
        _take_price.textAlignment = NSTextAlignmentRight;
    }
    return _take_price;
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

-(UILabel *)count_lable
{
    if (!_count_lable) {
        _count_lable = [[UILabel alloc] initForAutoLayout];
        _count_lable.textAlignment = NSTextAlignmentCenter;
        _count_lable.font = [UIFont systemFontOfSize:14.0f];
        _count_lable.textColor = UIColorFromRGB(singleTitle);
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

#pragma mark------------alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TIPS" message:@"你以为你不傻嘛，做梦吧" delegate:nil cancelButtonTitle:@"哈哈" otherButtonTitles:@"嘲讽", nil];
            [alert show];
        }
    }
}

#pragma mark------------action
-(void)subAction :(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TIPS" message:@"傻缺，摆这是逗你玩的，不让点" delegate:self cancelButtonTitle:@"傻叉知道了" otherButtonTitles:@"cancel", nil];
    alert.tag = 1;
    [alert show];
}

-(void)addAction :(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TIPS" message:@"傻缺，摆这是逗你玩的，不让点" delegate:self cancelButtonTitle:@"傻叉知道了" otherButtonTitles:@"cancel", nil];
    alert.tag = 1;
    [alert show];
}

@end
