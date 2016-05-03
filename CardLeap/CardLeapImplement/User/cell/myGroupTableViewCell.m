//
//  myGroupTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myGroupTableViewCell.h"

@interface myGroupTableViewCell()
@property (strong,nonatomic) UIImageView *shop_pic;//商家照片
@property (strong,nonatomic) UILabel    *shop_name_lable;//商家姓名
@property (strong,nonatomic) UILabel    *price_lable;//价格
@property (strong,nonatomic) UILabel    *status_lable;//状态
@property (strong,nonatomic) UIButton   *pay_button;//支付button
@property (strong,nonatomic) UIButton   *pay_back_button;//退款显示
@property (strong,nonatomic) UIButton   *review_button;//评价button
@property (strong,nonatomic) UIView *scoreView;
@end

@implementation myGroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(myGroupInfo*)info row:(NSInteger)row
{
    //---shop pic-----
    [self.contentView addSubview:self.shop_pic];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_shop_pic autoSetDimension:ALDimensionWidth toSize:88.0f];
    [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.group_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    //---shop name----
    [self.contentView addSubview:self.shop_name_lable];
    [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_shop_name_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_shop_name_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
    _shop_name_lable.text = info.group_name;
    //---shop num-----
    [self.contentView addSubview: self.price_lable];
    [_price_lable autoAlignAxis:ALAxisVertical toSameAxisOfView:_price_lable];
    [_price_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_price_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:6.0f];
    [_price_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
    _price_lable.text = [NSString stringWithFormat:@"总价:%@元  数量:%@",info.grab_price,info.grab_num];
    //---all status----
    if ([info.status integerValue]==0) {
        [self.contentView addSubview:self.pay_button];
        _pay_button.tag = row;
        [_pay_button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
        [_pay_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_price_lable withOffset:6.0f];
        [_pay_button autoSetDimension:ALDimensionHeight toSize:23.0f];
        [_pay_button autoSetDimension:ALDimensionWidth toSize:80.0f];
    }else if ([info.status integerValue]==1){
        [self.contentView addSubview:self.status_lable];
        [_status_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
        [_status_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_price_lable withOffset:8.0f];
        [_status_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [_status_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        _status_lable.text = @"未消费";
    }else if ([info.status integerValue]==2){
        [self.contentView addSubview:self.review_button];
        _review_button.tag = row;
        [_review_button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
        [_review_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_price_lable withOffset:6.0f];
        [_review_button autoSetDimension:ALDimensionHeight toSize:25.0f];
        [_review_button autoSetDimension:ALDimensionWidth toSize:80.0f];
    }else if ([info.status integerValue]==3){
        [self.contentView addSubview:self.scoreView];
        [_scoreView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
        [_scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_price_lable withOffset:6.0f];
        [_scoreView autoSetDimension:ALDimensionHeight toSize:25.0f];
        [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
        [self setScore:_scoreView :info.score];
    }else if ([info.status integerValue]==4){
        [self.contentView addSubview:self.pay_back_button];
        [_pay_back_button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
        [_pay_back_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_price_lable withOffset:3.0f];
        [_pay_back_button autoSetDimension:ALDimensionHeight toSize:23.0f];
        [_pay_back_button autoSetDimension:ALDimensionWidth toSize:60.0f];
    }else if ([info.status integerValue]==5){
        [self.contentView addSubview:self.status_lable];
        [_status_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
        [_status_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_price_lable withOffset:8.0f];
        [_status_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [_status_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        _status_lable.text = @"退款成功";
    }
}

#pragma mark--------get UI
-(UIImageView *)shop_pic
{
    if (!_shop_pic) {
        _shop_pic = [[UIImageView alloc] initForAutoLayout];
        _shop_pic.layer.borderWidth = 0.5;
        _shop_pic.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
    }
    return _shop_pic;
}

-(UILabel *)shop_name_lable
{
    if (!_shop_name_lable) {
        _shop_name_lable = [[UILabel alloc] initForAutoLayout];
        _shop_name_lable.font = [UIFont systemFontOfSize:15.0f];
        _shop_name_lable.textColor = UIColorFromRGB(indexTitle);
    }
    return _shop_name_lable;
}

-(UILabel *)price_lable
{
    if (!_price_lable) {
        _price_lable = [[UILabel alloc] initForAutoLayout];
        _price_lable.font = [UIFont systemFontOfSize:13.0f];
        _price_lable.textColor = UIColorFromRGB(addressTitle);
    }
    return _price_lable;
}

-(UILabel *)status_lable
{
    if (!_status_lable) {
        _status_lable = [[UILabel alloc] initForAutoLayout];
        _status_lable.font = [UIFont systemFontOfSize:13.0f];
        _status_lable.textColor = UIColorFromRGB(0x76c4d0);
    }
    return _status_lable;
}

-(UIButton *)pay_button
{
    if (!_pay_button) {
        _pay_button = [[UIButton alloc] initForAutoLayout];
        [_pay_button setTitle:@"付款" forState:UIControlStateNormal];
        [_pay_button setTitle:@"付款" forState:UIControlStateHighlighted];
        [_pay_button setBackgroundColor:UIColorFromRGB(0xe44a52)];
        _pay_button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_pay_button addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pay_button;
}

-(UIButton *)pay_back_button
{
    if (!_pay_back_button) {
        _pay_back_button = [[UIButton alloc] initForAutoLayout];
        [_pay_back_button setTitle:@"退款中" forState:UIControlStateNormal];
        [_pay_back_button setTitle:@"退款中" forState:UIControlStateHighlighted];
        _pay_back_button.userInteractionEnabled = NO;
        _pay_back_button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_pay_back_button setBackgroundColor:UIColorFromRGB(0x828282)];
    }
    return _pay_back_button;
}

-(UIButton *)review_button
{
    if (!_review_button) {
        _review_button = [[UIButton alloc] initForAutoLayout];
        [_review_button setTitle:@"评价" forState:UIControlStateNormal];
        [_review_button setTitle:@"评价" forState:UIControlStateHighlighted];
        _review_button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_review_button setBackgroundColor:UIColorFromRGB(0xe44a52)];
        [_review_button addTarget:self action:@selector(reviewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _review_button;
}

-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] initForAutoLayout];
    }
    return _scoreView;
}

#pragma mark------button action
-(void)payAction:(UIButton*)sender
{
    NSLog(@"去支付");
    [self.delegate myOperation:0 row:sender.tag];
}

-(void)payBackAction:(UIButton*)sender
{
    NSLog(@"申请退款");
    //[self.delegate myOperation:1];
}

-(void)reviewAction:(UIButton*)sender
{
    NSLog(@"去评价");
    [self.delegate myOperation:2 row:sender.tag];
}

-(void)setScore:(UIView *)score :(NSString*)count
{
    //判断星星数量
    int scores = [count floatValue]*2;
    for (int n=0; n<5; n++) {
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(16*n, 0, 13, 13);
        NSString *starName;
        //判断每一颗星星
        if (scores>=(n+1)*2) {
            //有星星
            starName = @"home_allstar";
        }else{
            //判断没有星星 还是半颗星星
            if (scores == (n+1)*2-1) {
                //半颗星星
                starName = @"home_starhalf";
            }else{
                //没有星星
                starName = @"home_star";
            }
        }
        [imageview setImage:[UIImage imageNamed:starName]];
        [score addSubview:imageview];
    }
}

@end
