//
//  orderSeatSuccessTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderSeatSuccessTableViewCell.h"

@interface orderSeatSuccessTableViewCell()
@property (strong,nonatomic)UILabel *shop_name;
@property (strong,nonatomic)UILabel *seat_time;
@property (strong,nonatomic)UILabel *order_status;
@property (strong,nonatomic)UIView *scoreView;
@property (strong,nonatomic)UIButton *reviewButton;
@property (strong,nonatomic)UILabel *seat_num;
@property (strong,nonatomic)UILabel *user_name;
@property (strong,nonatomic)UILabel *user_tel;
@end

@implementation orderSeatSuccessTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(orderSeatSuccessInfo*)info row:(NSInteger)row
{
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
        _seat_time.text = [NSString stringWithFormat:@"%@  %@",info.ri,info.fen];
        
        [self.contentView addSubview:self.seat_num];
        _seat_num.textAlignment = NSTextAlignmentRight;
        [_seat_num autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_seat_num autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_seat_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
        [_seat_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_seat_time withOffset:5.0f];
        _seat_num.text = [NSString stringWithFormat:@"%@人",info.seat_num];
    }else if (row == 2){
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
        _user_tel.text = info.seat_tel;
    }
}

#pragma mark------get UI
-(UILabel *)user_tel
{
    if (!_user_tel) {
        _user_tel = [[UILabel alloc] initForAutoLayout];
        _user_tel.font = [UIFont systemFontOfSize:13.0f];
        _user_tel.textColor = [UIColor lightGrayColor];
    }
    return _user_tel;
}

-(UILabel *)user_name
{
    if (!_user_name) {
        _user_name = [[UILabel alloc] initForAutoLayout];
        _user_name.font = [UIFont systemFontOfSize:13.0f];
        _user_name.textColor = [UIColor lightGrayColor];
    }
    return _user_name;
}

-(UILabel *)shop_name
{
    if (!_shop_name) {
        _shop_name = [[UILabel alloc] initForAutoLayout];
        _shop_name.font = [UIFont systemFontOfSize:14.0f];
        _shop_name.textColor = UIColorFromRGB(0x484848);
    }
    return _shop_name;
}

-(UILabel *)seat_time
{
    if (!_seat_time) {
        _seat_time = [[UILabel alloc] initForAutoLayout];
        _seat_time.font = [UIFont systemFontOfSize:13.0f];
        _seat_time.textColor = [UIColor lightGrayColor];
    }
    return _seat_time;
}

-(UILabel *)seat_num
{
    if (!_seat_num) {
        _seat_num = [[UILabel alloc] initForAutoLayout];
        _seat_num.font = [UIFont systemFontOfSize:13.0f];
        _seat_num.textColor = [UIColor lightGrayColor];
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




@end
