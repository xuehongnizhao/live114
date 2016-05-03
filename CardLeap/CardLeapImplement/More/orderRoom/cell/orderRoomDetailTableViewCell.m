//
//  orderRoomDetailTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderRoomDetailTableViewCell.h"
#import "AdBannerView.h"
#import "roomInfo.h"

@interface orderRoomDetailTableViewCell()<AdBannerViewDelegate>
{
    AdBannerView *_adBannerView;//轮播
}
@property (strong,nonatomic)UIView *scoreView;
@property (strong,nonatomic)UILabel *scoreLalbe;
@property (strong,nonatomic)UILabel *rev_num_lable;
//---section 2------
@property (strong,nonatomic)UILabel *phone_num_lable;
@property (strong,nonatomic)UILabel *address_lable;

@end

@implementation orderRoomDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confirgureCell:(orderRoomDetailInfo*)info section:(NSInteger)section row:(NSInteger)row
{
    if (section==0) {
        if (row == 0) {
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            NSMutableArray *descArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in info.pic_list) {
                NSString *pic = dic[@"pic"];
                NSString *pic_desc = dic[@"pic_message"];
                [imageArray addObject:pic];
                [descArray addObject:pic_desc];
            }
            NSMutableArray *Images = [[NSMutableArray alloc] init];
            NSMutableArray *Descs = [[NSMutableArray alloc] init];
            for(int i=0;i<[imageArray count];i++)
            {
                //添加图片数组
                UIImageView *imageView = [[UIImageView alloc] init];
                NSLog(@"%@",[imageArray objectAtIndex:i]);
                [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"user"]];
                [Images addObject:imageView];
                //添加Label数组
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor blackColor];
                label.alpha = 0.3;
                label.text = [descArray objectAtIndex:i];
                [Descs addObject:label];
            }
            CGRect rect = [[UIScreen mainScreen] bounds];
            _adBannerView  = [[AdBannerView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 180) Delegate:self andImageViewArray:Images andNameArray:Descs];
            [self.contentView addSubview:_adBannerView];
        }else{
            [self.contentView addSubview:self.scoreView];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
            [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
            [self setScore:_scoreView :info.score];
            [self.contentView addSubview:self.scoreLalbe];
            [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scoreLalbe autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:5.0f];
            [_scoreLalbe autoSetDimension:ALDimensionWidth toSize:30.0f];
            _scoreLalbe.text = [NSString stringWithFormat:@"%@分",info.score];
            [self.contentView addSubview:self.rev_num_lable];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [_rev_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreLalbe withOffset:5.0f];
            _rev_num_lable.text = [NSString stringWithFormat:@"已有%@人评价",info.rev_num];
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }else if (section==1){
        UIImageView *_iconImage = [[UIImageView alloc] initForAutoLayout];
        NSString *icon_desc ;
        if (row == 0) {
            _iconImage.image = [UIImage imageNamed:@"shopdetail_teicon_new"];
            icon_desc = info.shop_tel;
        }else{
            _iconImage.image = [UIImage imageNamed:@"shopdetail_map_new"];
            icon_desc = info.shop_address;
            [self setAccessoryType:UITableViewCellAccessoryNone];
        }
        [self.contentView addSubview:_iconImage];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:20.0f];
        
        [self.contentView addSubview:self.phone_num_lable];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_phone_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:5.0f];
        _phone_num_lable.text = icon_desc;
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if(section==2){
        if (row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"shop_icon"];
            [self.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:20.0f];
            
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(0x484848);
            tmpLable.text = @"商家信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            roomInfo *info_l = [info.goods_list objectAtIndex:row-1];
            //ordre_image
            UIImageView *iconImage = [[UIImageView alloc] initForAutoLayout];
            iconImage.layer.masksToBounds = YES;
            iconImage.layer.cornerRadius = 4.0f;
            [self.contentView addSubview:iconImage];
            iconImage.image = [UIImage imageNamed:@"order_hotelicon"];
            [iconImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [iconImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
            [iconImage autoSetDimension:ALDimensionWidth toSize:30.0f];
            [iconImage autoSetDimension:ALDimensionHeight toSize:30.0f];
            //shop_price
            UILabel *shop_pirce_lable = [[UILabel alloc] initForAutoLayout];
            [self.contentView addSubview:shop_pirce_lable];
            shop_pirce_lable.font = [UIFont systemFontOfSize:15.0f];
            shop_pirce_lable.textColor = UIColorFromRGB(0xd16370);
            shop_pirce_lable.textAlignment = NSTextAlignmentRight;
            [shop_pirce_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:iconImage withOffset:-5.0];
            [shop_pirce_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [shop_pirce_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [shop_pirce_lable autoSetDimension:ALDimensionWidth toSize:60.0f];
            shop_pirce_lable.text = [NSString stringWithFormat:@"￥%@",info_l.goods_price];
            //商家名称
            UILabel *shop_name_lable = [[UILabel alloc] initForAutoLayout];
            [self.contentView addSubview:shop_name_lable];
            shop_name_lable.font = [UIFont systemFontOfSize:15.0];
            shop_name_lable.textColor = UIColorFromRGB(indexTitle);
            shop_name_lable.text = info_l.goods_cate;
            [shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
            [shop_name_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
            [shop_name_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:shop_pirce_lable withOffset:-2.0f];
            //shop_desc
            UILabel *shop_desc_lable = [[UILabel alloc] initForAutoLayout];
            [self.contentView addSubview:shop_desc_lable];
            shop_desc_lable.font = [UIFont systemFontOfSize:13.0f];
            shop_desc_lable.textColor = UIColorFromRGB(reviewTitle);
            shop_desc_lable.text = info_l.goods_desc;
            [shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [shop_desc_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:shop_name_lable withOffset:3.0f];
            [shop_desc_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:shop_pirce_lable withOffset:-5.0f];
            [shop_desc_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
        }
    }
}

-(void)confirgureDetailCell:(orderRoomInfo*)info section:(NSInteger)section row:(NSInteger)row
{
    if (section==0) {
        if (row == 0) {
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            NSMutableArray *descArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in info.pic_list) {
                NSString *pic = dic[@"pic"];
                NSString *pic_desc = dic[@"pic_message"];
                [imageArray addObject:pic];
                [descArray addObject:pic_desc];
            }
            NSMutableArray *Images = [[NSMutableArray alloc] init];
            NSMutableArray *Descs = [[NSMutableArray alloc] init];
            for(int i=0;i<[imageArray count];i++)
            {
                //添加图片数组
                UIImageView *imageView = [[UIImageView alloc] init];
                NSLog(@"%@",[imageArray objectAtIndex:i]);
                [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"user"]];
                [Images addObject:imageView];
                //添加Label数组
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor blackColor];
                label.alpha = 0.3;
                label.text = [descArray objectAtIndex:i];
                [Descs addObject:label];
            }
            CGRect rect = [[UIScreen mainScreen] bounds];
            _adBannerView  = [[AdBannerView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 180) Delegate:self andImageViewArray:Images andNameArray:Descs];
            [self.contentView addSubview:_adBannerView];
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            [self.contentView addSubview:self.scoreView];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
            [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
            [self setScore:_scoreView :info.score];
            [self.contentView addSubview:self.scoreLalbe];
            [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scoreLalbe autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:5.0f];
            [_scoreLalbe autoSetDimension:ALDimensionWidth toSize:30.0f];
            _scoreLalbe.text = [NSString stringWithFormat:@"%@分",info.score];
            [self.contentView addSubview:self.rev_num_lable];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [_rev_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreLalbe withOffset:5.0f];
            _rev_num_lable.text = [NSString stringWithFormat:@"已有%@人评价",info.rev_num];
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }else if (section==1){
        UIImageView *_iconImage = [[UIImageView alloc] initForAutoLayout];
        NSString *icon_desc ;
        if (row == 0) {
            _iconImage.image = [UIImage imageNamed:@"shopdetail_teicon_new"];
            icon_desc = info.shop_tel;
        }else{
            _iconImage.image = [UIImage imageNamed:@"shopdetail_map_new"];
            icon_desc = info.shop_address;
        }
        [self.contentView addSubview:_iconImage];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:20.0f];
        
        [self.contentView addSubview:self.phone_num_lable];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_phone_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:5.0f];
        _phone_num_lable.text = icon_desc;
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if(section==2){
        if (row == 0) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"shop_icon"];
            [self.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:20.0f];
            
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(singleTitle);
            tmpLable.text = @"商家信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else{
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }

}

#pragma mark-------get UI
-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] initForAutoLayout];
    }
    return _scoreView;
}

-(UILabel *)scoreLalbe
{
    if (!_scoreLalbe) {
        _scoreLalbe = [[UILabel alloc] initForAutoLayout];
        _scoreLalbe.font = [UIFont systemFontOfSize:14.0f];
        _scoreLalbe.textColor = UIColorFromRGB(singleTitle);
    }
    return _scoreLalbe;
}

-(UILabel *)rev_num_lable
{
    if (!_rev_num_lable) {
        _rev_num_lable = [[UILabel alloc] initForAutoLayout];
        _rev_num_lable.font = [UIFont systemFontOfSize:14.0f];
        _rev_num_lable.textColor = UIColorFromRGB(singleTitle);
        _rev_num_lable.textAlignment = NSTextAlignmentRight;
    }
    return _rev_num_lable;
}

-(UILabel *)phone_num_lable
{
    if (!_phone_num_lable) {
        _phone_num_lable = [[UILabel alloc] initForAutoLayout];
        _phone_num_lable.font = [UIFont systemFontOfSize:14.0f];
        _phone_num_lable.textColor = UIColorFromRGB(singleTitle);
    }
    return _phone_num_lable;
}

-(UILabel *)address_lable
{
    if (!_address_lable) {
        _address_lable = [[UILabel alloc] initForAutoLayout];
        _address_lable.font = [UIFont systemFontOfSize:14.0f];
        _address_lable.textColor = UIColorFromRGB(singleTitle);
    }
    return _address_lable;
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

#pragma mark-------adBannerViewDelegate
-(void)adBannerView:(AdBannerView *)adBannerView itemIndex:(int)index
{
    NSLog(@"被点击的图片是第%d长",index);
    
}

@end
