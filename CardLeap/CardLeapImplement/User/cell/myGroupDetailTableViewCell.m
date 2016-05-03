//
//  myGroupDetailTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/2/2.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myGroupDetailTableViewCell.h"

@interface myGroupDetailTableViewCell()
//----section 0--------
@property (strong,nonatomic)UIImageView *shop_pic;//商家图片
@property (strong,nonatomic)UILabel *shop_name_lable;//商家名称
@property (strong,nonatomic)UILabel *shop_address_lable;//商家地址
@property (strong,nonatomic)UILabel *price_lable;//价格

@property (strong,nonatomic)UIButton *payButton;//支付button
//----section 1--------
@property (strong,nonatomic)UILabel *end_time_lable;//截至时间
@property (strong,nonatomic)UILabel *pass_code_lable;//-----
@property (strong,nonatomic)UILabel *status_lable;//--------

@property (strong,nonatomic)UIView *scroeView;//------------

//----section 2--------
@property (strong,nonatomic)UILabel *detail_message_lable;
//----sectoin 3--------
@property (strong,nonatomic)UITextField *order_num_T;
@property (strong,nonatomic)UITextField *pay_time_T;
@property (strong,nonatomic)UITextField *order_count_T;
@property (strong,nonatomic)UITextField *total_price_T;
//----pay back----------
@property (strong,nonatomic)UIButton *payBackButton;
//----web view----------
@property (strong,nonatomic)UIWebView *detailWeb;
@end

@implementation myGroupDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confirgureCell:(myGroupInfo*)info section:(NSInteger)section row:(NSInteger)row
{
    if (section == 0) {
        if (row == 0) {
            [self.contentView addSubview:self.shop_pic];
            [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_shop_pic autoSetDimension:ALDimensionWidth toSize:88.0f];
            [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.group_pic] placeholderImage:[UIImage imageNamed:@"user"]];
            
            [self.contentView addSubview:self.shop_name_lable];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_shop_name_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_shop_name_lable autoSetDimension:ALDimensionHeight toSize:22.0f];
            _shop_name_lable.text = info.group_name;
            
            [self.contentView addSubview:self.shop_address_lable];
            [_shop_address_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:10.0f];
            [_shop_address_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
            [_shop_address_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_shop_address_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
            _shop_address_lable.text = info.group_brief;//[NSString stringWithFormat:@"[%@] %@",info.];
            
            [self.contentView addSubview:self.price_lable];
            [_price_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_address_lable withOffset:10.0f];
            [_price_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:5.0f];
            [_price_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_price_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
            _price_lable.text = [NSString stringWithFormat:@"￥%@",info.grab_price];
            
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else if (row == 1){
            if ([info.status integerValue]==1||[info.status integerValue]==4||[info.status integerValue]==5) {
                //显示web
                [self.contentView addSubview:self.detailWeb];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                NSString *urlString = info.group_url;
                [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            }else{
                [self setBackgroundColor:UIColorFromRGB(0xf3f3f3)];
                [self.contentView addSubview:self.payButton];
                [_payButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [_payButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [_payButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_payButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            }
        }else{
            if ([info.status integerValue]==0) {
                //显示web
                [self.contentView addSubview:self.detailWeb];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
                [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                NSString *urlString = info.group_url;
                [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            }else{
                [self setAccessoryType:UITableViewCellAccessoryNone];
                self.backgroundColor = UIColorFromRGB(0xf3f3f3);
                [self.contentView addSubview:self.payBackButton];
                [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            }

        }
    }else if (section == 1){
        if (row == 0) {
            UILabel *hintMessage = [[UILabel alloc] initForAutoLayout];
            hintMessage.font = [UIFont systemFontOfSize:14.0f];
            hintMessage.textColor = UIColorFromRGB(0x484848);
            [self.contentView addSubview:hintMessage];
            [hintMessage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [hintMessage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [hintMessage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            //[hintMessage autoSetDimension:ALDimensionWidth toSize:40.0f];
            hintMessage.text = @"评价:";
            
            [self.contentView addSubview:self.scroeView];
            [_scroeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.0f];
            [_scroeView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scroeView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:hintMessage withOffset:5.0f];
            [_scroeView autoSetDimension:ALDimensionWidth toSize:80.0f];
            [self setScore:_scroeView :info.score];
            
            if ([info.status integerValue] != 3) {
                UILabel *hintMessage1 = [[UILabel alloc] initForAutoLayout];
                hintMessage1.font = [UIFont systemFontOfSize:14.0f];
                hintMessage1.textColor = UIColorFromRGB(0x484848);
                hintMessage1.textAlignment = NSTextAlignmentRight;
                [self.contentView addSubview:hintMessage1];
                [hintMessage1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [hintMessage1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [hintMessage1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
                [hintMessage1 autoSetDimension:ALDimensionWidth toSize:80.0f];
                hintMessage1.text = @"去评价";
                
                [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }else{
            [self.contentView addSubview:self.detailWeb];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
            NSString *urlString = info.group_url;
            [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        }
    }else if (section == 2){//-------section >= 2 之后的代码无用了------
        if ([info.status integerValue]==2 || [info.status integerValue]==3) {
            if (row == 0) {
                UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
                imageView.image = [UIImage imageNamed:@"person_coupon"];
                [self.contentView addSubview:imageView];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [imageView autoSetDimension:ALDimensionWidth toSize:25.0f];
                
                UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
                tmpLable.font = [UIFont systemFontOfSize:14.0f];
                tmpLable.textColor = UIColorFromRGB(0x484848);
                tmpLable.text = @"团购券";
                [self.contentView addSubview:tmpLable];
                [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [tmpLable autoSetDimension:ALDimensionWidth toSize:60.0f];
                
                [self.contentView addSubview:self.end_time_lable];
                [_end_time_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [_end_time_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [_end_time_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
                [_end_time_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tmpLable withOffset:3.0f];
                _end_time_lable.text = [NSString stringWithFormat:@"有效期至:%@",info.group_endtime];
            }
        }else if ([info.status integerValue]==1 || [info.status integerValue]==4 || [info.status integerValue]==5){
            if (row == 0) {
                UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
                imageView.image = [UIImage imageNamed:@"city_deticon"];
                [self.contentView addSubview:imageView];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [imageView autoSetDimension:ALDimensionWidth toSize:25.0f];
                
                UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
                tmpLable.font = [UIFont systemFontOfSize:14.0f];
                tmpLable.textColor = UIColorFromRGB(0x484848);
                tmpLable.text = @"详细信息";
                [self.contentView addSubview:tmpLable];
                [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            }else{
                [self.contentView addSubview:self.detail_message_lable];
                [_detail_message_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_detail_message_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
                [_detail_message_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                _detail_message_lable.text = info.group_desc;
            }
        }
    }else if (section == 3){
        if ([info.status integerValue]==2 || [info.status integerValue]==3) {
            if (row == 0) {
                UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
                imageView.image = [UIImage imageNamed:@"city_deticon"];
                [self.contentView addSubview:imageView];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [imageView autoSetDimension:ALDimensionWidth toSize:25.0f];
                
                UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
                tmpLable.font = [UIFont systemFontOfSize:14.0f];
                tmpLable.textColor = UIColorFromRGB(0x484848);
                tmpLable.text = @"详细信息";
                [self.contentView addSubview:tmpLable];
                [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            }else{
                [self.contentView addSubview:self.detail_message_lable];
                [_detail_message_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_detail_message_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
                [_detail_message_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                _detail_message_lable.text = info.group_desc;
            }
        }else{
            if (row == 0) {
                UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
                imageView.image = [UIImage imageNamed:@"order_deticon"];
                [self.contentView addSubview:imageView];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [imageView autoSetDimension:ALDimensionWidth toSize:25.0f];
                
                UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
                tmpLable.font = [UIFont systemFontOfSize:14.0f];
                tmpLable.textColor = UIColorFromRGB(0x484848);
                tmpLable.text = @"订单详情";
                [self.contentView addSubview:tmpLable];
                [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            }else if (row == 1){
                [self.contentView addSubview:self.order_num_T];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _order_num_T.text = info.order_id;
            }else if (row == 2){
                [self.contentView addSubview:self.pay_time_T];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _pay_time_T.text = info.add_time;
            }else if (row == 3){
                [self.contentView addSubview:self.order_count_T];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _order_count_T.text = info.grab_num;
            }else if (row == 4){
                [self.contentView addSubview:self.total_price_T];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _total_price_T.text = info.grab_price;
            }
            if ([info.status integerValue]==1) {
                if (row == 5) {
                    self.backgroundColor = UIColorFromRGB(0xf3f3f3);
                    [self.contentView addSubview:self.payBackButton];
                    [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                    [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                    [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                    [_payBackButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
                }
            }
        }
    }else if (section == 4){
        if (YES) {
            if (row == 0) {
                UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
                imageView.image = [UIImage imageNamed:@"order_deticon"];
                [self.contentView addSubview:imageView];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [imageView autoSetDimension:ALDimensionWidth toSize:25.0f];
                
                UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
                tmpLable.font = [UIFont systemFontOfSize:14.0f];
                tmpLable.textColor = UIColorFromRGB(0x484848);
                tmpLable.text = @"订单详情";
                [self.contentView addSubview:tmpLable];
                [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
                [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            }else if (row == 1){
                [self.contentView addSubview:self.order_num_T];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_order_num_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _order_num_T.text = info.order_id;
            }else if (row == 2){
                [self.contentView addSubview:self.pay_time_T];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_pay_time_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _pay_time_T.text = info.add_time;
            }else if (row == 3){
                [self.contentView addSubview:self.order_count_T];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_order_count_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _order_count_T.text = info.grab_num;
            }else if (row == 4){
                [self.contentView addSubview:self.total_price_T];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
                [_total_price_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
                _total_price_T.text = info.grab_price;
            }
        }
    }
}

#pragma mark------get UI
-(UIWebView *)detailWeb
{
    if(!_detailWeb){
        _detailWeb = [[UIWebView alloc] initForAutoLayout];
        _detailWeb.userInteractionEnabled = NO;
    }
    return _detailWeb;
}

//-----group message-----
-(UILabel *)end_time_lable
{
    if (!_end_time_lable) {
        _end_time_lable = [[UILabel alloc] initForAutoLayout];
        _end_time_lable.font = [UIFont systemFontOfSize:14.0f];
        _end_time_lable.textColor = UIColorFromRGB(0xa8a8a8);
        _end_time_lable.textAlignment = NSTextAlignmentRight;
    }
    return _end_time_lable;
}

-(UILabel *)pass_code_lable
{
    if (!_pass_code_lable) {
        _pass_code_lable = [[UILabel alloc] initForAutoLayout];
        _pass_code_lable.textColor = UIColorFromRGB(0x484848);
        _pass_code_lable.font = [UIFont systemFontOfSize:14.0f];
    }
    return _pass_code_lable;
}

-(UILabel *)status_lable
{
    if (!_status_lable) {
        _status_lable = [[UILabel alloc] initForAutoLayout];
        _status_lable.font = [UIFont systemFontOfSize:14.0f];
        _status_lable.textColor = UIColorFromRGB(0x76c4d0);
        _status_lable.textAlignment = NSTextAlignmentRight;
    }
    return _status_lable;
}

-(UIView *)scroeView
{
    if (!_scroeView) {
        _scroeView = [[UIView alloc] initForAutoLayout];
    }
    return _scroeView;
}

//-----shop message------
-(UIImageView *)shop_pic
{
    if (!_shop_pic) {
        _shop_pic = [[UIImageView alloc] initForAutoLayout];
        _shop_pic.layer.borderWidth = 0.5;
        _shop_pic.layer.borderColor = UIColorFromRGB(0xd1cec5).CGColor;
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

-(UILabel *)shop_address_lable
{
    if (!_shop_address_lable) {
        _shop_address_lable = [[UILabel alloc] initForAutoLayout];
        _shop_address_lable.font = [UIFont systemFontOfSize:13.0f];
        _shop_address_lable.textColor = UIColorFromRGB(addressTitle);
    }
    return _shop_address_lable;
}

-(UILabel *)price_lable
{
    if (!_price_lable) {
        _price_lable = [[UILabel alloc] initForAutoLayout];
        _price_lable.font = [UIFont systemFontOfSize:13.0f];
        _price_lable.textColor = UIColorFromRGB(0xdf5c64);
    }
    return _price_lable;
}

-(UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [[UIButton alloc] initForAutoLayout];
        _payButton.layer.masksToBounds = YES;
        _payButton.layer.cornerRadius = 4.0f;
        [_payButton setTitle:@"立即付款" forState:UIControlStateNormal];
        [_payButton setTitle:@"立即付款" forState:UIControlStateHighlighted];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_payButton setBackgroundColor:UIColorFromRGB(0x76c4d0)];
        [_payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

-(UIButton *)payBackButton
{
    if (!_payBackButton) {
        _payBackButton = [[UIButton alloc] initForAutoLayout];
        _payBackButton.layer.masksToBounds = YES;
        _payBackButton.layer.cornerRadius = 4.0f;
        [_payBackButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [_payBackButton setTitle:@"申请退款" forState:UIControlStateHighlighted];
        [_payBackButton setBackgroundColor:UIColorFromRGB(0x76c4d0)];
        [_payBackButton addTarget:self action:@selector(payBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBackButton;
}

-(UILabel *)detail_message_lable
{
    if (!_detail_message_lable) {
        _detail_message_lable = [[UILabel alloc] initForAutoLayout];
        _detail_message_lable.font = [UIFont systemFontOfSize:13.0f];
        _detail_message_lable.textColor = UIColorFromRGB(0xa8a8a8);
    }
    return _detail_message_lable;
}

-(UITextField *)order_num_T
{
    if (!_order_num_T) {
        _order_num_T = [[UITextField alloc] initForAutoLayout];
        _order_num_T.userInteractionEnabled = NO;
        //_order_num_T.placeholder = @"请输入真实姓名";
        //_connect_name_T.keyboardType=UIKeyboardTypeNumberPad;
        _order_num_T.leftViewMode = UITextFieldViewModeAlways;
        //_connect_name_T.borderStyle=UITextBorderStyleRoundedRect;
        _order_num_T.textColor = [UIColor lightGrayColor];
        _order_num_T.font = [UIFont systemFontOfSize:14.0f];
        [_order_num_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 80, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"订单号码:";
        //        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        //        passImage.frame = CGRectMake(30, 3, 20, 20);
        _order_num_T.leftView = leftLable;
    }
    return _order_num_T;
}

-(UITextField *)pay_time_T
{
    if (!_pay_time_T) {
        _pay_time_T = [[UITextField alloc] initForAutoLayout];
        _pay_time_T.userInteractionEnabled = NO;
        //_order_num_T.placeholder = @"请输入真实姓名";
        //_connect_name_T.keyboardType=UIKeyboardTypeNumberPad;
        _pay_time_T.leftViewMode = UITextFieldViewModeAlways;
        //_connect_name_T.borderStyle=UITextBorderStyleRoundedRect;
        _pay_time_T.textColor = [UIColor lightGrayColor];
        _pay_time_T.font = [UIFont systemFontOfSize:14.0f];
        [_pay_time_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 80, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"付款时间:";
        //        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        //        passImage.frame = CGRectMake(30, 3, 20, 20);
        _pay_time_T.leftView = leftLable;
    }
    return _pay_time_T;
}

-(UITextField *)order_count_T
{
    if (!_order_count_T) {
        _order_count_T = [[UITextField alloc] initForAutoLayout];
        _order_count_T.userInteractionEnabled = NO;
        //_order_num_T.placeholder = @"请输入真实姓名";
        //_connect_name_T.keyboardType=UIKeyboardTypeNumberPad;
        _order_count_T.leftViewMode = UITextFieldViewModeAlways;
        //_connect_name_T.borderStyle=UITextBorderStyleRoundedRect;
        _order_count_T.textColor = [UIColor lightGrayColor];
        _order_count_T.font = [UIFont systemFontOfSize:14.0f];
        [_order_count_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 80, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"数      量:";
        //        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        //        passImage.frame = CGRectMake(30, 3, 20, 20);
        _order_count_T.leftView = leftLable;
    }
    return _order_count_T;
}

-(UITextField *)total_price_T
{
    if (!_total_price_T) {
        _total_price_T = [[UITextField alloc] initForAutoLayout];
        _total_price_T.userInteractionEnabled = NO;
        //_order_num_T.placeholder = @"请输入真实姓名";
        //_connect_name_T.keyboardType=UIKeyboardTypeNumberPad;
        _total_price_T.leftViewMode = UITextFieldViewModeAlways;
        //_connect_name_T.borderStyle=UITextBorderStyleRoundedRect;
        _total_price_T.textColor = [UIColor lightGrayColor];
        _total_price_T.font = [UIFont systemFontOfSize:14.0f];
        [_total_price_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 80, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"总      价:";
        //        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        //        passImage.frame = CGRectMake(30, 3, 20, 20);
        _total_price_T.leftView = leftLable;
    }
    return _total_price_T;
}

#pragma mark------button action
-(void)payAction:(UIButton*)sender
{
    NSLog(@"去付款");
    [self.delegate orderActionDelegate:0];
}

-(void)payBackAction:(UIButton*)sender
{
    NSLog(@"申请退款");
    [self.delegate orderActionDelegate:1];
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
