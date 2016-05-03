//
//  orderSeatDetailTableViewCellByCC.m
//  cityo2o
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Sky. All rights reserved.
//
//  订座商家详情页面-增加web简介(陈晨修改)

#import "orderSeatDetailTableViewCellByCC.h"
#import "AdBannerView.h"

@interface orderSeatDetailTableViewCellByCC ()<AdBannerViewDelegate>
{
    AdBannerView *_adBannerView;//轮播
}
@property (strong,nonatomic)UIView *scoreView;
@property (strong,nonatomic)UILabel *scoreLalbe;
@property (strong,nonatomic)UILabel *rev_num_lable;
//---section 2------
@property (strong,nonatomic)UILabel *phone_num_lable;
@property (strong,nonatomic)UILabel *address_lable;
//---section 3-----
@property (strong,nonatomic)UILabel *shop_name_lable;
@property (strong,nonatomic)UILabel *shop_desc_lable;

@end

@implementation orderSeatDetailTableViewCellByCC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark-----读取接口
-(void)confirgureCell:(orderSeatDetailInfo*)info  section:(NSInteger)section row:(NSInteger)row
{
    if (section==0) {
        if (row == 0) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
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
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [self.contentView addSubview:self.scoreView];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
            [self setScore:_scoreView :info.score];
            [self.contentView addSubview:self.scoreLalbe];
            [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0f];
            [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scoreLalbe autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:5.0f];
            [_scoreLalbe autoSetDimension:ALDimensionWidth toSize:30.0f];
            _scoreLalbe.text = [NSString stringWithFormat:@"%@分",info.score];
            [self.contentView addSubview:self.rev_num_lable];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            [_rev_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreLalbe withOffset:5.0f];
            _rev_num_lable.text = [NSString stringWithFormat:@"已有%@人评价",info.rev_num];
        }
    }else if (section==1){
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *_iconImage = [[UIImageView alloc] initForAutoLayout];
        NSString *icon_desc ;
        if (row == 0) {
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            _iconImage.image = [UIImage imageNamed:@"shopdetail_teicon_new"];
            icon_desc = info.shop_tel;
        }else{
            [self setAccessoryType:UITableViewCellAccessoryNone];
            _iconImage.image = [UIImage imageNamed:@"shopdetail_map_new"];
            icon_desc = info.shop_address;
        }
        [self.contentView addSubview:_iconImage];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:25.0f];
        
        [self.contentView addSubview:self.phone_num_lable];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_phone_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:5.0f];
        _phone_num_lable.text = icon_desc;
        
    }else if(section==2){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
            tmpLable.textColor = UIColorFromRGB(singleTitle);
            tmpLable.text = @"商家信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else{
            //---user name-------
            [self.contentView addSubview:self.shop_name_lable];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [_shop_name_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
            _shop_name_lable.text = info.shop_name;
            //--shop desc-----
            [self.contentView addSubview:self.shop_desc_lable];
            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [_shop_desc_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
            _shop_desc_lable.text = info.shop_desc;
#pragma mark --- 11.24 订座商家详情简介修改
            //            [self.contentView addSubview:self.shop_desc_lable];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            //            _shop_desc_lable.text = info.shop_desc;
        }
    }
}

#pragma mark-----列表传至
-(void)confirgureDetailCell:(orderSeatInfo*)info  section:(NSInteger)section row:(NSInteger)row
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
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [self.contentView addSubview:self.scoreView];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
            [self setScore:_scoreView :info.score];
            [self.contentView addSubview:self.scoreLalbe];
            [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0f];
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
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:25.0f];
        
        [self.contentView addSubview:self.phone_num_lable];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_phone_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_phone_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:5.0f];
        _phone_num_lable.text = icon_desc;
        
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
            tmpLable.textColor = UIColorFromRGB(singleTitle);
            tmpLable.text = @"商家信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else{
            //---user name-------
            [self.contentView addSubview:self.shop_name_lable];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [_shop_name_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
            _shop_name_lable.text = info.shop_name;
            //--shop desc-----
            [self.contentView addSubview:self.shop_desc_lable];
            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [_shop_desc_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
            _shop_desc_lable.text = info.shop_desc;
#pragma mark --- 11.24 订座商家详情简介修改
            //            [self.contentView addSubview:self.shop_desc_lable];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            //            [_shop_desc_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            //            _shop_desc_lable.text = info.shop_desc;
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

-(UILabel *)shop_name_lable
{
    if (!_shop_name_lable) {
        _shop_name_lable = [[UILabel alloc] initForAutoLayout];
        _shop_name_lable.font = [UIFont systemFontOfSize:15.0f];
        _shop_name_lable.textColor = UIColorFromRGB(indexTitle);
    }
    return _shop_name_lable;
}


-(UILabel *)shop_desc_lable
{
    if (!_shop_desc_lable) {
        _shop_desc_lable = [[UILabel alloc] initForAutoLayout];
        _shop_desc_lable.font = [UIFont systemFontOfSize:13.0f];
        _shop_desc_lable.textColor = UIColorFromRGB(addressTitle);
        _shop_desc_lable.numberOfLines = 0;
    }
    return _shop_desc_lable;
}

#pragma mark-------adBannerViewDelegate
-(void)adBannerView:(AdBannerView *)adBannerView itemIndex:(int)index
{
    NSLog(@"被点击的图片是第%d长",index);
    
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
