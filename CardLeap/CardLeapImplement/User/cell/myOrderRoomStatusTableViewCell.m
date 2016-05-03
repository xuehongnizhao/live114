//
//  myOrderRoomStatusTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderRoomStatusTableViewCell.h"

@interface myOrderRoomStatusTableViewCell()
@property (strong,nonatomic)UILabel *shop_name;//订房间详情按钮
@property (strong,nonatomic)UILabel *seat_time;//订房间详细信息时间
@property (strong,nonatomic)UILabel *order_status;//订房间状态
@property (strong,nonatomic)UIView *scoreView;//评分view
@property (strong,nonatomic)UIButton *reviewButton;//评价button
@property (strong,nonatomic)UILabel *seat_num;//数量
@property (strong,nonatomic)UILabel *user_name;//用户姓名
@property (strong,nonatomic)UILabel *user_tel;//用户电话
@end

@implementation myOrderRoomStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)confirgureCell :(myOrderRoomCenterInfo*)info row:(NSInteger)row section:(NSInteger)section
{
    if (section == 0) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([info.seat_status isEqualToString:@"0"]) {
            [self.contentView addSubview:self.order_status];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
            _order_status.text = @"商家未确认";
        }else if ([info.seat_status isEqualToString:@"1"]) {
            [self.contentView addSubview:self.order_status];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
            _order_status.text = @"失效订单";
        }else if ([info.seat_status isEqualToString:@"3"]){
            [self.contentView addSubview:self.reviewButton];
            _reviewButton.tag = row;
            [_reviewButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_reviewButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_reviewButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_reviewButton autoSetDimension:ALDimensionWidth toSize:80.0f];
        }else if ([info.seat_status isEqualToString:@"4"]){
            [self.contentView addSubview:self.scoreView];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
            [self setScore:_scoreView :info.score];
        }else if ([info.seat_status isEqualToString:@"2"]){
            [self.contentView addSubview:self.order_status];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
            [_order_status autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
            _order_status.text = @"有效订单";
        }
    }else{
        if (row == 0) {
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [self.contentView addSubview:self.shop_name];
            [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
            _shop_name.text = info.shop_name;
        }else if (row == 1){
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self.contentView addSubview:self.seat_time];
            [_seat_time autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_seat_time autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_seat_time autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_seat_time autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f];
            _seat_time.text = [NSString stringWithFormat:@"%@-%@",info.begin_time,info.end_time];
            
        }else if (row == 3){
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self.contentView addSubview:self.user_name];
            [_user_name autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [_user_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_user_name autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_user_name autoSetDimension:ALDimensionWidth toSize:100.0f];
            _user_name.text = info.use_name;
            
            [self.contentView addSubview:self.user_tel];
            _user_tel.textAlignment = NSTextAlignmentRight;
            [_user_tel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_user_tel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_user_tel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_user_tel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_user_name withOffset:5.0f];
            _user_tel.text = info.hotel_tel;
        }else if (row == 2){
            UILabel *room_type = [[UILabel alloc] initForAutoLayout];
            room_type.textColor = UIColorFromRGB(singleTitle);
            room_type.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:room_type];
            room_type.text = info.goods_cate;
            [room_type autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [room_type autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [room_type autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [room_type autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f];
            
            
            [self.contentView addSubview:self.seat_num];
            _seat_num.textAlignment = NSTextAlignmentRight;
            [_seat_num autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_seat_num autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_seat_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
            [_seat_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:room_type withOffset:5.0f];
            _seat_num.text = [NSString stringWithFormat:@"%@间",info.hotel_num];
        }
    }
}

#pragma mark------get UI
-(UILabel *)user_tel
{
    if (!_user_tel) {
        _user_tel = [[UILabel alloc] initForAutoLayout];
        _user_tel.font = [UIFont systemFontOfSize:14.0f];
        _user_tel.textColor = UIColorFromRGB(singleTitle);
    }
    return _user_tel;
}

-(UILabel *)user_name
{
    if (!_user_name) {
        _user_name = [[UILabel alloc] initForAutoLayout];
        _user_name.font = [UIFont systemFontOfSize:14.0f];
        _user_name.textColor = UIColorFromRGB(singleTitle);
    }
    return _user_name;
}

-(UILabel *)shop_name
{
    if (!_shop_name) {
        _shop_name = [[UILabel alloc] initForAutoLayout];
        _shop_name.font = [UIFont systemFontOfSize:14.0f];
        _shop_name.textColor = UIColorFromRGB(singleTitle);
    }
    return _shop_name;
}

-(UILabel *)seat_time
{
    if (!_seat_time) {
        _seat_time = [[UILabel alloc] initForAutoLayout];
        _seat_time.font = [UIFont systemFontOfSize:14.0f];
        _seat_time.textColor = UIColorFromRGB(singleTitle);
    }
    return _seat_time;
}

-(UILabel *)seat_num
{
    if (!_seat_num) {
        _seat_num = [[UILabel alloc] initForAutoLayout];
        _seat_num.font = [UIFont systemFontOfSize:14.0f];
        _seat_num.textColor = UIColorFromRGB(singleTitle);
    }
    return _seat_num;
}

-(UILabel *)order_status
{
    if (!_order_status) {
        _order_status = [[UILabel alloc] initForAutoLayout];
        _order_status.font = [UIFont systemFontOfSize:14.0f];
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
    [self.delegate go2RoomReviewAction];
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
