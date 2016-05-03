//
//  myOrderRoomCenterTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderRoomCenterTableViewCell.h"

@interface myOrderRoomCenterTableViewCell()
@property (strong,nonatomic)UIImageView *shop_pic;//商家图片
@property (strong,nonatomic)UILabel *shop_name;//商家名称
@property (strong,nonatomic)UILabel *seat_time;//订酒店时间
@property (strong,nonatomic)UILabel *order_status;//订单确认状态
@property (strong,nonatomic)UIView *scoreView;//评分显示view
@property (strong,nonatomic)UIButton *reviewButton;//评价button
@property (strong,nonatomic)UILabel *seat_num;//订房间数量
@end

@implementation myOrderRoomCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confirgureCell:(myOrderRoomCenterInfo*)info row:(NSInteger)row
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
    [_shop_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_shop_name autoSetDimension:ALDimensionHeight toSize:20.0f];
    _shop_name.text = info.shop_name;
    
    //total_price
    [self.contentView addSubview:self.seat_time];
    [_seat_time autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60.0f];
    [_seat_time autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
    [_seat_time autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:5.0f];
    [_seat_time autoSetDimension:ALDimensionHeight toSize:15.0f];
    _seat_time.text = [NSString stringWithFormat:@"%@ %@  %@间",info.begin_time,info.end_time,info.hotel_num];
    
//    //seat_num
//    [self.contentView addSubview:self.seat_num];
//    [_seat_num autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:5.0f];
//    [_seat_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_seat_time withOffset:5.0f];
//    [_seat_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//    _seat_num.text = [NSString stringWithFormat:@"%@间",info.hotel_num];
    
    if ([info.seat_status isEqualToString:@"1"]) {
        [self.contentView addSubview:self.order_status];
        [_order_status autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
        [_order_status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_seat_time withOffset:5.0f];
        [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_order_status autoSetDimension:ALDimensionHeight toSize:20.0f];
        _order_status.text = @"失效订单";
    }else if ([info.seat_status isEqualToString:@"0"] ){
        [self.contentView addSubview:self.order_status];
        [_order_status autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
        [_order_status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_seat_time withOffset:5.0f];
        [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_order_status autoSetDimension:ALDimensionHeight toSize:20.0f];
        _order_status.text = @"商家未确认";
    } else if ([info.seat_status isEqualToString:@"3"]){
        [self.contentView addSubview:self.reviewButton];
        _reviewButton.tag = row;
        [_reviewButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
        [_reviewButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_seat_time withOffset:5.0f];
        [_reviewButton autoSetDimension:ALDimensionHeight toSize:20.0f];
        [_reviewButton autoSetDimension:ALDimensionWidth toSize:60.0f];
    }else if ([info.seat_status isEqualToString:@"4"]){
        [self.contentView addSubview:self.scoreView];
        [_scoreView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
        [_scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_seat_time withOffset:5.0f];
        [_scoreView autoSetDimension:ALDimensionHeight toSize:25.0f];
        [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
        [self setScore:_scoreView :info.score];
    }else if ([info.seat_status isEqualToString:@"2"]){
        [self.contentView addSubview:self.order_status];
        [_order_status autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
        [_order_status autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_seat_time withOffset:5.0f];
        [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_order_status autoSetDimension:ALDimensionHeight toSize:20.0f];
        _order_status.text = @"有效订单";
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

-(UILabel *)seat_time
{
    if (!_seat_time) {
        _seat_time = [[UILabel alloc] initForAutoLayout];
        _seat_time.font = [UIFont systemFontOfSize:13.0f];
        _seat_time.textColor = UIColorFromRGB(addressTitle);
    }
    return _seat_time;
}

-(UILabel *)seat_num
{
    if (!_seat_num) {
        _seat_num = [[UILabel alloc] initForAutoLayout];
        _seat_num.font = [UIFont systemFontOfSize:13.0f];
        _seat_num.textColor = UIColorFromRGB(addressTitle);
    }
    return _seat_num;
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
        [_reviewButton setBackgroundColor:UIColorFromRGB(0xe34b52)];
        [_reviewButton addTarget:self action:@selector(reviewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reviewButton;
}

#pragma mark--------button action
-(void)reviewAction:(UIButton*)sender
{
    NSLog(@"去评价");
    [self.delegate orderRoomAction:sender.tag];
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
