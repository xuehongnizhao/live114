//
//  myOrderCenterTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderCenterTableViewCell.h"

@interface myOrderCenterTableViewCell()
@property (strong,nonatomic)UIImageView *shop_pic;//商家图片
@property (strong,nonatomic)UILabel *shop_name;//商家名称
@property (strong,nonatomic)UILabel *total_price;//总价
@property (strong,nonatomic)UILabel *order_status;//订单状态
@property (strong,nonatomic)UIView *scoreView;//评分显示view
@property (strong,nonatomic)UIButton *reviewButton;//评价button
@property (strong,nonatomic)UIButton *payButton;//付款按钮
@end

@implementation myOrderCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)confirgureCell:(myOrderCenterInfo*)info row:(NSInteger)row
{
    //shop_pic
    [self.contentView addSubview:self.shop_pic];
    [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.shop_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_shop_pic autoSetDimension:ALDimensionWidth toSize:80.0f];
    
    //shop_name
    [self.contentView addSubview:self.shop_name];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_shop_name autoSetDimension:ALDimensionHeight toSize:20.0f];
    _shop_name.text = info.shop_name;
    
    //total_price
    [self.contentView addSubview:self.total_price];
    [_total_price autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_total_price autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_total_price autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:5.0f];
    [_total_price autoSetDimension:ALDimensionHeight toSize:15.0f];
    _total_price.text = [NSString stringWithFormat:@"总价：%@",info.total_price];
    
    if ([info.is_pay integerValue]==0) {
        //在线支付尚未支付的情况
        [self.contentView addSubview:self.payButton];
        _payButton.tag = row;
        [_payButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
        [_payButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_total_price withOffset:5.0f];
        [_payButton autoSetDimension:ALDimensionHeight toSize:20.0f];
        [_payButton autoSetDimension:ALDimensionWidth toSize:60.0f];
    }else{
        if ([info.confirm_status isEqualToString:@"0"] || [info.confirm_status isEqualToString:@"1"]) {
            [self.contentView addSubview:self.order_status];
            [_order_status autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
            [_order_status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_total_price withOffset:5.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_order_status autoSetDimension:ALDimensionHeight toSize:20.0f];
            _order_status.text = @"未送达";
        }else if ([info.confirm_status isEqualToString:@"2"]){
            [self.contentView addSubview:self.reviewButton];
            _reviewButton.tag = row;
            [_reviewButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
            [_reviewButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_total_price withOffset:5.0f];
            [_reviewButton autoSetDimension:ALDimensionHeight toSize:20.0f];
            [_reviewButton autoSetDimension:ALDimensionWidth toSize:60.0f];
        }else if ([info.confirm_status isEqualToString:@"3"]){
            [self.contentView addSubview:self.scoreView];
            [_scoreView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
            [_scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_total_price withOffset:5.0f];
            [_scoreView autoSetDimension:ALDimensionHeight toSize:25.0f];
            [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
            [self setScore:_scoreView :info.score];
        }else if ([info.confirm_status isEqualToString:@"4"]||[info.confirm_status isEqualToString:@"6"]){
            [self.contentView addSubview:self.order_status];
            [_order_status autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
            [_order_status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_total_price withOffset:5.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_order_status autoSetDimension:ALDimensionHeight toSize:20.0f];
            _order_status.text = @"退款中";
        }else if ([info.confirm_status isEqualToString:@"5"]){
            [self.contentView addSubview:self.order_status];
            [_order_status autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
            [_order_status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_total_price withOffset:5.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_order_status autoSetDimension:ALDimensionHeight toSize:20.0f];
            _order_status.text = @"已取消";
        }else if ([info.confirm_status isEqualToString:@"7"]){
            [self.contentView addSubview:self.order_status];
            [_order_status autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
            [_order_status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_total_price withOffset:5.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_order_status autoSetDimension:ALDimensionHeight toSize:20.0f];
            _order_status.text = @"退款成功";
        }
    }
}

#pragma mark------get UI
-(UIImageView *)shop_pic
{
    if (!_shop_pic) {
        _shop_pic = [[UIImageView alloc] initForAutoLayout];
        _shop_pic.layer.borderColor = UIColorFromRGB(0xcbcbcb).CGColor;
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

-(UILabel *)total_price
{
    if (!_total_price) {
        _total_price = [[UILabel alloc] initForAutoLayout];
        _total_price.font = [UIFont systemFontOfSize:13.0f];
        _total_price.textColor = UIColorFromRGB(addressTitle);
    }
    return _total_price;
}

-(UILabel *)order_status
{
    if (!_order_status) {
        _order_status = [[UILabel alloc] initForAutoLayout];
        _order_status.font = [UIFont systemFontOfSize:13.0f];
        _order_status.textColor = UIColorFromRGB(0x95c4ce);
    }
    return _order_status;
}

-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] initForAutoLayout];
    }
    return _scoreView;
}

-(UIButton *)reviewButton
{
    if (!_reviewButton) {
        _reviewButton = [[UIButton alloc] initForAutoLayout];
        [_reviewButton setTitle:@"评价" forState:UIControlStateNormal];
        [_reviewButton setTitle:@"评价" forState:UIControlStateHighlighted];
        [_reviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reviewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _reviewButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_reviewButton setBackgroundColor:UIColorFromRGB(0xe34a51)];
        [_reviewButton addTarget:self action:@selector(reviewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reviewButton;
}

//付款按钮
-(UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [[UIButton alloc] initForAutoLayout];
        [_payButton setTitle:@"去支付" forState:UIControlStateNormal];
        [_payButton setTitle:@"去支付" forState:UIControlStateHighlighted];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_payButton setBackgroundColor:UIColorFromRGB(0xe34a51)];
        [_payButton addTarget:self action:@selector(myPayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

#pragma mark--------button action
-(void)reviewAction:(UIButton*)sender
{
    NSLog(@"去评价");
    [self.delegate reviewDelegateAction:sender.tag];
}

-(void)myPayAction:(UIButton*)sender
{
    NSLog(@"去支付");
    [self.delegate customPayActionDelegate:sender.tag];
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
