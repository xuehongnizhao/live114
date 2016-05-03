//
//  orderRoomTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderRoomTableViewCell.h"

@interface orderRoomTableViewCell()
@property (strong,nonatomic)UIImageView *shop_pic;
@property (strong,nonatomic)UILabel *shop_name;
@property (strong,nonatomic)UILabel *shop_address;
@property (strong,nonatomic)UILabel *rev_num;
@property (strong,nonatomic)UILabel *rev_type;
@property (strong,nonatomic)UIView  *score;
@end

@implementation orderRoomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
/**
 配置商家列表cell各种控件布局
 */
-(void)configureCell:(orderRoomInfo*)info
{
    //---shop picture----
    [self.contentView addSubview:self.shop_pic];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_shop_pic autoSetDimension:ALDimensionWidth toSize:80.0f];
    [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.shop_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    
    //---shop name------
    [self.contentView addSubview:self.shop_name];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_shop_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_shop_name autoSetDimension:ALDimensionHeight toSize:20.0];
    _shop_name.text = info.shop_name;
    //---score---------
    [self.contentView addSubview:self.score];
    [_score autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_score autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:5.0f];
    [_score autoSetDimension:ALDimensionHeight toSize:18.0f];
    [_score autoSetDimension:ALDimensionWidth toSize:80.0f];
    [self setScore:_score :info.score];
    //--shop review number----
    [self.contentView addSubview:self.rev_num];
    [_rev_num autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:5.0f];
    [_rev_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_score withOffset:5.0f];
    [_rev_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_rev_num autoSetDimension:ALDimensionHeight toSize:15.0f];
    _rev_num.text = [NSString stringWithFormat:@"%@评价",info.rev_num];
    //----shop type-----
    [self.contentView addSubview:self.rev_type];
    [_rev_type autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_rev_type autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_score withOffset:5.0f];
    [_rev_type autoSetDimension:ALDimensionWidth toSize:66.0f];
    [_rev_type autoSetDimension:ALDimensionHeight toSize:15.0f];
    _rev_type.text = info.cate_name;
    //---shop address----
    [self.contentView addSubview:self.shop_address];
    [_shop_address autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:8.0f];
    [_shop_address autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_score withOffset:5.0f];
    [_shop_address autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_shop_address autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_rev_type withOffset:-2.0f];
    _shop_address.text = info.shop_address;
}

#pragma mark---------get UI
-(UIImageView *)shop_pic
{
    if (!_shop_pic) {
        _shop_pic = [[UIImageView alloc] initForAutoLayout];
        _shop_pic.layer.borderWidth = 0.5;
        _shop_pic.layer.borderColor = UIColorFromRGB(0xa7a7a5).CGColor;
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

-(UILabel *)shop_address
{
    if (!_shop_address) {
        _shop_address = [[UILabel alloc] initForAutoLayout];
        _shop_address.font = [UIFont systemFontOfSize:13.0f];
        _shop_address.textColor = UIColorFromRGB(addressTitle);
    }
    return _shop_address;
}

-(UILabel *)rev_num
{
    if (!_rev_num) {
        _rev_num = [[UILabel alloc] initForAutoLayout];
        _rev_num.font = [UIFont systemFontOfSize:13.0f];
        _rev_num.textColor = UIColorFromRGB(reviewTitle);
    }
    return _rev_num;
}

-(UILabel *)rev_type
{
    if (!_rev_type) {
        _rev_type = [[UILabel alloc] initForAutoLayout];
        _rev_type.textAlignment = NSTextAlignmentRight;
        _rev_type.font = [UIFont systemFontOfSize:13.0f];
        _rev_type.textColor = UIColorFromRGB(addressTitle);
    }
    return _rev_type;
}

-(UIView *)score
{
    if (!_score) {
        _score = [[UIView alloc] initForAutoLayout];
        //_score.layer.borderWidth = 1;
    }
    return _score;
}

#pragma mark-----------设置星星显示
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
