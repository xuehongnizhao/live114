//
//  IndexTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "IndexTableViewCell.h"

@implementation IndexTableViewCell
@synthesize shop_pic = _shop_pic;
@synthesize shop_name = _shop_name;
@synthesize score = _score;
@synthesize area_name = _area_name;
@synthesize num_estimate = _num_estimate;
@synthesize type = _type;
@synthesize group_pic = _group_pic;
@synthesize oreder_pic = _oreder_pic;
@synthesize spike_pic = _spike_pic;
@synthesize activity_pic = _activity_pic;
@synthesize vip_pic = _vip_pic;
@synthesize rezheng_pic = _rezheng_pic;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)configureCell :(shopInfo*)info
{
    //商铺图片
    //self.layer.borderWidth = 1;
    _shop_pic = [[UIImageView alloc] initForAutoLayout];
    _shop_pic.layer.borderWidth = .5f;
    _shop_pic.layer.borderColor = UIColorFromRGB(0xa7a7a5).CGColor;
    [self.contentView addSubview:_shop_pic];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_pic autoSetDimension:ALDimensionHeight toSize:60.0];
    [_shop_pic autoSetDimension:ALDimensionWidth toSize:87.0f];
    [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.shop_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    
    //商家type
    _oreder_pic = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:_oreder_pic];
    NSLog(@"商家都做什么%@",info.shop_action);
    NSRange rang = [info.shop_action rangeOfString:@"seat"];
    NSRange range = [info.shop_action rangeOfString:@"hotel"];
    int length = (int)rang.length;
    int length1 = (int)range.length;
    if (length != 0 || length1 != 0) {
        [_oreder_pic setImage:[UIImage imageNamed:@"recommend_order"]];
        [_oreder_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_oreder_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_oreder_pic autoSetDimension:ALDimensionWidth toSize:16.0f];
        [_oreder_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:7];
    }else{
        [_oreder_pic setImage:[UIImage imageNamed:@"recommend_order"]];
        [_oreder_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_oreder_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_oreder_pic autoSetDimension:ALDimensionWidth toSize:0.0f];
        [_oreder_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:7];
    }
    
    _take_pic = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:_take_pic];
    rang = [info.shop_action rangeOfString:@"takeout"];
    length = (int)rang.length;
    if (length != 0) {
        CGFloat width = [_oreder_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        
        [_take_pic setImage:[UIImage imageNamed:@"recommend_wai"]];
        [_take_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_take_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_take_pic autoSetDimension:ALDimensionWidth toSize:16.0f];
        if (width == 0) {
            [_take_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_oreder_pic withOffset:0];
        }else{
            [_take_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_oreder_pic withOffset:4];
        }
        
    }else{
        CGFloat width = [_oreder_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_take_pic setImage:[UIImage imageNamed:@"recommend_wai"]];
        [_take_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_take_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_take_pic autoSetDimension:ALDimensionWidth toSize:0.0f];
        if (width == 0) {
            [_take_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_oreder_pic withOffset:0];
        }else{
            [_take_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_oreder_pic withOffset:4];
        }
    }
    _group_pic = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:_group_pic];
    rang = [info.shop_action rangeOfString:@"group"];
    length = (int)rang.length;
    //    _group_pic.layer.borderWidth = 10;
    
#pragma mark --- 2016.4  将团购优惠等图标向下向左移动修改的不好
    if (length != 0) {
        CGFloat width = [_take_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_group_pic setImage:[UIImage imageNamed:@"recommend_tuan"]];
        [_group_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_group_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_group_pic autoSetDimension:ALDimensionWidth toSize:16.0f];
        if (width == 0) {
            [_group_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_take_pic withOffset:0];
        }else{
            [_group_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_take_pic withOffset:4];
        }
    }else{
        CGFloat width = [_take_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_group_pic setImage:[UIImage imageNamed:@"recommend_tuan"]];
        [_group_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_group_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_group_pic autoSetDimension:ALDimensionWidth toSize:0.0f];
        if (width == 0) {
            [_group_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_take_pic withOffset:0];
        }else{
            [_group_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_take_pic withOffset:4];
        }
        
    }
    
    _activity_pic = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:_activity_pic];
    rang = [info.shop_action rangeOfString:@"activity"];
    length = (int)rang.length;
    //_activity_pic.layer.borderWidth = 1;
    if (length!=0) {
        CGFloat width = [_group_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_activity_pic setImage:[UIImage imageNamed:@"recommend_actives"]];
        [_activity_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_activity_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_activity_pic autoSetDimension:ALDimensionWidth toSize:16.0f];
        if (width == 0) {
            [_activity_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_group_pic withOffset:0];
        }else{
            [_activity_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_group_pic withOffset:4];
        }
        
    }else{
        CGFloat width = [_group_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_activity_pic setImage:[UIImage imageNamed:@"recommend_actives"]];
        [_activity_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_activity_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_activity_pic autoSetDimension:ALDimensionWidth toSize:0.0f];
        if (width == 0) {
            [_activity_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_group_pic withOffset:0];
        }else{
            [_activity_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_group_pic withOffset:4];
        }
    }
    
    _spike_pic = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:_spike_pic];
    rang = [info.shop_action rangeOfString:@"spike"];
    length = (int)rang.length;
    //_spike_pic.layer.borderWidth = 1;
    if (length!=0) {
        CGFloat width = [_activity_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_spike_pic setImage:[UIImage imageNamed:@"recommend_Sale"]];
        [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_spike_pic autoSetDimension:ALDimensionWidth toSize:16.0f];
        [_spike_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        if (width == 0) {
            [_spike_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_activity_pic withOffset:0];
        }else{
            [_spike_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_activity_pic withOffset:4];
        }
        
    }else{
        CGFloat width = [_activity_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_spike_pic setImage:[UIImage imageNamed:@"recommend_Sale"]];
        [_spike_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_spike_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_spike_pic autoSetDimension:ALDimensionWidth toSize:0.0f];
        if (width == 0) {
            [_spike_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_activity_pic withOffset:0];
        }else{
            [_spike_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_activity_pic withOffset:4];
        }
    }
    
    _vip_pic = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:_vip_pic];
    rang = [info.shop_action rangeOfString:@"vip"];
    length = (int)rang.length;
    if (length!=0) {
        CGFloat width = [_spike_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_vip_pic setImage:[UIImage imageNamed:@"vicon"]];
        [_vip_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_vip_pic autoSetDimension:ALDimensionWidth toSize:16.0f];
        [_vip_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        if (width == 0) {
            [_vip_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_spike_pic withOffset:0];
        }else{
            [_vip_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_spike_pic withOffset:4];
        }
        
    }else{
        CGFloat width = [_spike_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_vip_pic setImage:[UIImage imageNamed:@"vicon"]];
        [_vip_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_vip_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_vip_pic autoSetDimension:ALDimensionWidth toSize:0.0f];
        if (width == 0) {
            [_vip_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_spike_pic withOffset:0];
        }else{
            [_vip_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_spike_pic withOffset:4];
        }
    }
    
    _rezheng_pic = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:_rezheng_pic];
    rang = [info.shop_action rangeOfString:@"rz"];
    length = (int)rang.length;
    if (length!=0) {
        CGFloat width = [_vip_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_rezheng_pic setImage:[UIImage imageNamed:@"authe"]];
        [_rezheng_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_rezheng_pic autoSetDimension:ALDimensionWidth toSize:16.0f];
        [_rezheng_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        if (width == 0) {
            [_rezheng_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_vip_pic withOffset:0];
        }else{
            [_rezheng_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_vip_pic withOffset:4];
        }
    }else{
        CGFloat width = [_vip_pic systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
        [_rezheng_pic setImage:[UIImage imageNamed:@"authe"]];
        [_rezheng_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35.0f];
        [_rezheng_pic autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_rezheng_pic autoSetDimension:ALDimensionWidth toSize:0.0f];
        if (width == 0) {
            [_rezheng_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_vip_pic withOffset:0];
        }else{
            [_rezheng_pic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_vip_pic withOffset:4];
        }
    }
    
    
    //商铺名称
    _shop_name = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:_shop_name];
    _shop_name.textColor = UIColorFromRGB(indexTitle);
    _shop_name.font = [UIFont systemFontOfSize:15.0];
    _shop_name.text = info.shop_name;
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:7.0f];
    [_shop_name autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-3.0f];
    [_shop_name autoSetDimension:ALDimensionHeight toSize:16.0f];
    //    //评价显示
    _score = [[UIView alloc] initForAutoLayout];
    [self.contentView addSubview:_score];
    [_score autoSetDimension:ALDimensionHeight toSize:13.0f];
    [_score autoSetDimension:ALDimensionWidth toSize:80.0f];
    //_score.layer.borderWidth = 1;
    [_score autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:7.0f];
    [_score autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:8.0f];
    //    [self setScore:_score :info.score];
    //地区名称
    _area_name = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:_area_name];
    //_area_name.layer.borderWidth = 1;
    _area_name.textColor = UIColorFromRGB(addressTitle);
    _area_name.font = [UIFont systemFontOfSize:12.0];
    _area_name.text = info.area_name;
    [_area_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:7.0f];
    [_area_name autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_score withOffset:8.0f];
    [_area_name autoSetDimension:ALDimensionWidth toSize:138.0f];
    [_area_name autoSetDimension:ALDimensionHeight toSize:16.0f];
    //    //评价人数
#pragma mark --- 2016.4 这里将首页推荐商家的评价人数删除了
    _num_estimate = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:_num_estimate];
    _num_estimate.textColor = UIColorFromRGB(reviewTitle);
    //_num_estimate.layer.borderWidth = 1;
    _num_estimate.font = [UIFont systemFontOfSize:12.0];
    //    _num_estimate.text = [NSString stringWithFormat:@"%@评价",info.num];
    [_num_estimate autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_score withOffset:17.0f];
    [_num_estimate autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:33];
    [_num_estimate autoSetDimension:ALDimensionHeight toSize:16.0f];
    [_num_estimate autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13.0f];
    //菜品种类
    _type = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:_type];
    _type.textColor = UIColorFromRGB(reviewTitle);
    _type.textAlignment = NSTextAlignmentRight;
    _type.font = [UIFont systemFontOfSize:12.0];
    _type.text = info.cat_name;
    [_type autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_area_name];
    [_type autoSetDimension:ALDimensionHeight toSize:12.0f];
    [_type autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13.0f];
    [_type autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_area_name withOffset:6.0f];
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
