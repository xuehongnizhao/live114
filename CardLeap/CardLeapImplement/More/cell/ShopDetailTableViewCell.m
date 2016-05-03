//
//  ShopDetailTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/23/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ShopDetailTableViewCell.h"

@interface ShopDetailTableViewCell()
//----------------商家信息显示----------------------
@property (strong, nonatomic) UIImageView *shopImage;
@property (strong, nonatomic) UILabel *shopName;
@property (strong, nonatomic) UILabel *shopDesc;
@property (strong, nonatomic) UIView *scoreView;
@property (strong, nonatomic) UILabel *review_num;
//----------------电话地址------------------------
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *messagelable;
//----------------商家服务-------------------------
@property (strong, nonatomic) UILabel *numLable;
//----------------用户评论-------------------------
@property (strong, nonatomic) UILabel *userNameLable;
@property (strong, nonatomic) UILabel *scoreText;
@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UILabel *typeLable;
@property (strong, nonatomic) UIView *score;

@end

@implementation ShopDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark----------配置商家cell显示

-(void)configureCell :(NSInteger)index sectino:(NSInteger)section info:(shopDetailInfo*)shopInfo
{
    if (section == 0) {
        //商家图片
        [self.contentView addSubview:self.shopImage];
        [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0f];
        [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_shopImage autoSetDimension:ALDimensionWidth toSize:104.0f];
        [_shopImage sd_setImageWithURL:[NSURL URLWithString:shopInfo.shop_pic] placeholderImage:[UIImage imageNamed:@"user"]];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        _shopImage.userInteractionEnabled = YES;
        [_shopImage addGestureRecognizer:singleRecognizer];
        //商家名称
#pragma mark --- 2016.4 商家名称自动换行
        [self.contentView addSubview:self.shopName];
        [_shopName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
        [_shopName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0f];
        [_shopName autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_shopName autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        _shopName.text = shopInfo.shop_name;
        _shopName.font=[UIFont systemFontOfSize:20];
#pragma mark --- 11.25 删除商家描述，商家名称改为2行文本
        //        //商家描述
        //        [self.contentView addSubview:self.shopDesc];
        //        [_shopDesc autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
        //        [_shopDesc autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopName withOffset:7.0f];
        //        [_shopDesc autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        //        [_shopDesc autoSetDimension:ALDimensionHeight toSize:20.0f];
        //        _shopDesc.text = shopInfo.shop_brief;
        //评价星星
#pragma mark --- 2016.4 删除星星视图
        //        [self.contentView addSubview:self.scoreView];
        //        [_scoreView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
        //        [_scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopName withOffset:6.0f];
        //        [_scoreView autoSetDimension:ALDimensionWidth toSize:100.0f];
        //        [_scoreView autoSetDimension:ALDimensionHeight toSize:40.0f];
        //        [self setScore:_scoreView :shopInfo.socre];
        //评价数量
        //        [self.contentView addSubview:self.review_num];
        //        [_review_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:3.0f];
        //        [_review_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        //        [_review_num autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopName withOffset:5.0f];
        //        [_review_num autoSetDimension:ALDimensionHeight toSize:20.0f];
        //        _review_num.text = [NSString stringWithFormat:@"%@人评价",shopInfo.num];
    }else if (section == 1){
        
        [self.contentView addSubview:self.iconImage];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.5f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.5f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:20.0f];
        //电话或者地址
        [self.contentView addSubview:self.messagelable];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_messagelable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:15.0f];
        self.textLabel.textColor = UIColorFromRGB(singleTitle);
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        if (index == 0) {
            // 商家电话
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            //            self.imageView.image = [UIImage imageNamed:@"shopdetail_teicon_new"];
            //            self.textLabel.text = shopInfo.shop_tel;
            _iconImage.image = [UIImage imageNamed:@"shopdetail_teicon_new"];
            _messagelable.text = shopInfo.shop_tel;
        }else if(index == 1){
            // 商家地址
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            //            self.imageView.image = [UIImage imageNamed:@"shopdetail_map_new"];
            //            self.textLabel.text = shopInfo.shop_address;
            _iconImage.image = [UIImage imageNamed:@"shopdetail_map_new"];
            _messagelable.text = shopInfo.shop_address;
        }else if(index==2){
            // 商家详情
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            _iconImage.image = [UIImage imageNamed:@"shopdetail_about"];
            _messagelable.text = @"商家详情";
        }else if(index==3){
            // 360度全景展示
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            _iconImage.image = [UIImage imageNamed:@"360-quanjing"];
            _messagelable.text = @"360度全景展示";
        }else{
            //评价
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            _iconImage.image = [UIImage imageNamed:@"comment"];
            _messagelable.text = @"评价";
        }
    }
    
#pragma mark --- 2016.4 弃用评价星星视图首页详情展示单独弹窗展示
    else if (section == 2){
        
        NSString *icon_name;
        NSString *msgText;
        NSString *numText;
        
        NSArray *arr = [shopInfo.shop_action componentsSeparatedByString:@","];
        arr = [self clearArray:arr];
        NSString *shop_icon = [arr objectAtIndex:index];
        if ([shop_icon isEqualToString:@"group"]) {
            icon_name = @"shopdetail_takecar_new";
            msgText = @"查看团购";
            numText = shopInfo.group_num;
        }else if ([shop_icon isEqualToString:@"seat"]){
            icon_name = @"shopdetail_seat_new";
            msgText = @"预定座位";
            numText = @"";
        }else if ([shop_icon isEqualToString:@"hotel"]){
            icon_name = @"shopdetail_orderzw_new";
            msgText = @"预定酒店";
            numText = @"";
        }else if ([shop_icon isEqualToString:@"takeout"]){
            icon_name = @"shopdetail_wmicon_new";
            msgText = @"外  卖";
            numText = @"";
        }else if ([shop_icon isEqualToString:@"spike"]){
            icon_name = @"shopdetail_yhqicon_new";
            msgText = @"优惠券";
            numText = shopInfo.spike_num;
        }else if ([shop_icon isEqualToString:@"activity"]){
            icon_name = @"shopdetail_playicon_new";
            msgText = @"活  动";
            numText = shopInfo.event_num;
        }
        
        //光标
        [self.contentView addSubview:self.iconImage];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.5f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.5f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:20.0f];
        _iconImage.image = [UIImage imageNamed:icon_name];
        //标签
        [self.contentView addSubview:self.messagelable];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_messagelable autoSetDimension:ALDimensionWidth toSize:120.0f];
        [_messagelable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:15.0f];
        _messagelable.text = msgText;
        //数量
        [self.contentView addSubview:self.numLable];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        [_numLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_messagelable withOffset:15.0f];
        _numLable.text = numText;
    }
    /*
     //    }else{
     //        if (index == 0) {
     //            UILabel *sectionLalbe = [[UILabel alloc] initForAutoLayout];
     //            [self.contentView addSubview:sectionLalbe];
     //            [sectionLalbe autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.0f];
     //            [sectionLalbe autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
     //            [sectionLalbe autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
     //            [sectionLalbe autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
     //            sectionLalbe.font = [UIFont systemFontOfSize:14.0f];
     //            sectionLalbe.text = @"评价";
     //            sectionLalbe.textColor = UIColorFromRGB(singleTitle);
     //        }else if(index == 6){
     //            UILabel *checkEstimateLable = [[UILabel alloc] initForAutoLayout];
     //            [self.contentView addSubview:checkEstimateLable];
     //            checkEstimateLable.textColor = UIColorFromRGB(singleTitle);
     //            checkEstimateLable.font = [UIFont systemFontOfSize:14.0f];
     //            [checkEstimateLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
     //            [checkEstimateLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
     //            [checkEstimateLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
     //            [checkEstimateLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
     //            checkEstimateLable.textAlignment = NSTextAlignmentCenter;
     //            checkEstimateLable.text = [NSString stringWithFormat:@"查看全部评价(%@)",shopInfo.num];
     //        }else{
     //            [self setAccessoryType:UITableViewCellAccessoryNone];
     //            //用户名
     //            [self.contentView addSubview:self.userNameLable];
     //            [_userNameLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
     //            [_userNameLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
     //            [_userNameLable autoSetDimension:ALDimensionWidth toSize:200];
     //            [_userNameLable autoSetDimension:ALDimensionHeight toSize:15.0];
     //            _userNameLable.text = [[shopInfo.review_index objectAtIndex:index-1] objectForKey:@"user_nickname"];
     //            //评价fen数
     //            [self.contentView addSubview:self.score];
     //            [_score autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4.0];
     //            [_score autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3.0f];
     //            [_score autoSetDimension:ALDimensionWidth toSize:100];
     //            [_score autoSetDimension:ALDimensionHeight toSize:20.0];
     ////            [self setScore:_score :[[shopInfo.review_index objectAtIndex:index-1] objectForKey:@"score"]];
     //            //评价
     //            [self.contentView addSubview:self.scoreText];
     //            [_scoreText autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
     //            [_scoreText autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
     //            [_scoreText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_userNameLable withOffset:2.0f];
     //            _scoreText.text = [[shopInfo.review_index objectAtIndex:index-1] objectForKey:@"rev_text"];
     //            //评价时间
     //            [self.contentView addSubview:self.timeLable];
     //            [_timeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_scoreText withOffset:3.0f];
     //            [_timeLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
     //            [_timeLable autoSetDimension:ALDimensionWidth toSize:100.0f];
     //            [_timeLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
     //            _timeLable.text = [Base64Tool fuckNULL:[[shopInfo.review_index objectAtIndex:index-1] objectForKey:@"add_time"]];
     //            //评价类型
     //            [self.contentView addSubview:self.typeLable];
     //            [_typeLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_timeLable withOffset:30.0f];
     //            [_typeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_scoreText withOffset:5.0f];
     //            [_typeLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
     //            [_typeLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
     //            _typeLable.text = [Base64Tool fuckNULL:[[shopInfo.review_index objectAtIndex:index-1] objectForKey:@"rev_type"]];
     //        }
     */
    //    }
}
#pragma mark-----------单机手势
-(void)SingleTap :(UITapGestureRecognizer*)gesture
{
    NSLog(@"点击去相册列表");
    [self.delegate clickAction];
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

#pragma mark-----------get UI
/**
 以下是商家的信息的显示基本设置
 */
-(UIImageView *)shopImage
{
    if (!_shopImage) {
        _shopImage = [[UIImageView alloc] initForAutoLayout];
        _shopImage.layer.borderWidth = 0.5;
        _shopImage.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
        _shopImage.layer.masksToBounds = YES;
        _shopImage.layer.cornerRadius = 4.0f;
    }
    return _shopImage;
}

-(UILabel *)shopName
{
    if (!_shopName) {
        _shopName = [[UILabel alloc] initForAutoLayout];
        _shopName.font = [UIFont systemFontOfSize:15.0f];
        _shopName.textColor = UIColorFromRGB(indexTitle);
        _shopName.numberOfLines = 2;
    }
    return _shopName;
}

-(UILabel *)shopDesc
{
    if (!_shopDesc) {
        _shopDesc = [[UILabel alloc] initForAutoLayout];
        _shopDesc.font = [UIFont systemFontOfSize:13.0f];
        _shopDesc.textColor = UIColorFromRGB(addressTitle);
    }
    return _shopDesc;
}

-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] initForAutoLayout];
        //_scoreView.layer.borderWidth = 1;
    }
    return _scoreView;
}

-(UILabel *)review_num
{
    if (!_review_num) {
        _review_num = [[UILabel alloc] initForAutoLayout];
        //_review_num.layer.borderWidth =1;
        _review_num.font = [UIFont systemFontOfSize:13.0f];
        _review_num.textColor = UIColorFromRGB(reviewTitle);
    }
    return _review_num;
}
/**
 以下是商家的电话地址
 */
-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initForAutoLayout];
    }
    return _iconImage;
}

-(UILabel *)messagelable
{
    if (!_messagelable) {
        _messagelable = [[UILabel alloc] initForAutoLayout];
        _messagelable.textColor = UIColorFromRGB(singleTitle);
        _messagelable.font = [UIFont systemFontOfSize:14.0f];
    }
    return _messagelable;
}
/**
 以下是商家服务 复用上两个
 */
-(UILabel *)numLable
{
    if (!_numLable) {
        _numLable = [[UILabel alloc] initForAutoLayout];
        _numLable.font = [UIFont systemFontOfSize:12.0f];
        _numLable.textColor = [UIColor lightGrayColor];
        _numLable.textAlignment = NSTextAlignmentRight;
    }
    return _numLable;
}
/**
 以下是用户评价部分
 */
-(UILabel *)userNameLable
{
    if (!_userNameLable) {
        _userNameLable = [[UILabel alloc] initForAutoLayout];
        _userNameLable.font = [UIFont systemFontOfSize:13.0f];
        _userNameLable.textColor = UIColorFromRGB(addressTitle);
    }
    return _userNameLable;
}

-(UIView *)score
{
    if (!_score) {
        _score = [[UIView alloc] initForAutoLayout];
        //_score.layer.borderWidth = 1;
    }
    return _score;
}

-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] initForAutoLayout];
        _timeLable.textColor = UIColorFromRGB(reviewTitle);
        _timeLable.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLable;
}

-(UILabel *)scoreText
{
    if (!_scoreText) {
        _scoreText = [[UILabel alloc] initForAutoLayout];
        _scoreText.font = [UIFont systemFontOfSize:14.0];
        _scoreText.textColor = UIColorFromRGB(indexTitle);
        _scoreText.numberOfLines = 0;
    }
    return _scoreText;
}

-(UILabel *)typeLable
{
    if (!_typeLable) {
        _typeLable = [[UILabel alloc] initForAutoLayout];
        _typeLable.font = [UIFont systemFontOfSize:12.0f];
        _typeLable.textColor = UIColorFromRGB(reviewTitle);
    }
    return _typeLable;
}
#pragma mark-----当未获取详情数据时候
-(void)configureCellForMin :(NSInteger)index sectino:(NSInteger)section info:(ShopListInfo*)shopInfo
{
    if (section==0) {
        [self.contentView addSubview:self.shopImage];
        [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0f];
        [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_shopImage autoSetDimension:ALDimensionWidth toSize:104.0f];
        [_shopImage sd_setImageWithURL:[NSURL URLWithString:shopInfo.shop_pic] placeholderImage:[UIImage imageNamed:@"user"]];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        _shopImage.userInteractionEnabled = YES;
        [_shopImage addGestureRecognizer:singleRecognizer];
        //商家名称
        [self.contentView addSubview:self.shopName];
        [_shopName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
        [_shopName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0f];
        [_shopName autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_shopName autoSetDimension:ALDimensionHeight toSize:40.0f];
        _shopName.text = shopInfo.shop_name;
#pragma mark --- 11.25 删除商家描述，商家名称改为2行文本
        //商家描述
        //        [self.contentView addSubview:self.shopDesc];
        //        [_shopDesc autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
        //        [_shopDesc autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopName withOffset:7.0f];
        //        [_shopDesc autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        //        [_shopDesc autoSetDimension:ALDimensionHeight toSize:20.0f];
        //        _shopDesc.text = shopInfo.shop_brief;
        //评价星星
        //        [self.contentView addSubview:self.scoreView];
        //        [_scoreView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
        //        [_scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopName withOffset:6.0f];
        //        [_scoreView autoSetDimension:ALDimensionWidth toSize:100.0f];
        //        [_scoreView autoSetDimension:ALDimensionHeight toSize:40.0f];
        //        [self setScore:_scoreView :shopInfo.score];
        //评价数量
        //        [self.contentView addSubview:self.review_num];
        //        [_review_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:3.0f];
        //        [_review_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        //        [_review_num autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopName withOffset:5.0f];
        //        [_review_num autoSetDimension:ALDimensionHeight toSize:20.0f];
        //        _review_num.text = [NSString stringWithFormat:@"%@人评价",shopInfo.num];
    }else if (section == 1){
        
        [self.contentView addSubview:self.iconImage];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.5f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.5f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:20.0f];
        //电话或者地址
        [self.contentView addSubview:self.messagelable];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_messagelable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:15.0f];
        self.textLabel.textColor = UIColorFromRGB(singleTitle);
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        if (index == 0) {
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            _iconImage.image = [UIImage imageNamed:@"shopdetail_teicon_new"];
            _messagelable.text = shopInfo.shop_tel;
        }else if(index == 1){
            [self setAccessoryType:UITableViewCellAccessoryNone];
            _iconImage.image = [UIImage imageNamed:@"shopdetail_map_new"];
            _messagelable.text = shopInfo.shop_address;
        }else {
            // 商家详情
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            _iconImage.image = [UIImage imageNamed:@"shopdetail_about"];
            _messagelable.text = @"商家详情";
        }
    }else if (section == 2){
        NSString *icon_name;
        NSString *msgText;
        NSString *numText;
        
        NSArray *arr = [shopInfo.shop_action componentsSeparatedByString:@","];
        arr = [self clearArray:arr];
        NSString *shop_icon = [arr objectAtIndex:index];
        if ([shop_icon isEqualToString:@"group"]) {
            icon_name = @"shopdetail_takecar_new";
            msgText = @"查看团购";
            numText = shopInfo.group_num;
        }else if ([shop_icon isEqualToString:@"seat"]){
            icon_name = @"shopdetail_seat_new";
            msgText = @"预定座位";
            numText = @"";
        }else if ([shop_icon isEqualToString:@"hotel"]){
            icon_name = @"shopdetail_orderzw_new";
            msgText = @"预定酒店";
            numText = @"";
        }else if ([shop_icon isEqualToString:@"takeout"]){
            icon_name = @"shopdetail_wmicon_new";
            msgText = @"外  卖";
            numText = @"";//shopInfo.takeout_num
        }else if ([shop_icon isEqualToString:@"spike"]){
            icon_name = @"shopdetail_yhqicon_new";
            msgText = @"优惠券";
            numText = shopInfo.spike_num;
        }else if ([shop_icon isEqualToString:@"activity"]){
            icon_name = @"shopdetail_playicon_new";
            msgText = @"活  动";
            numText = shopInfo.activity_num;
        }
        //光标
        [self.contentView addSubview:self.iconImage];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.5f];
        [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.5f];
        [_iconImage autoSetDimension:ALDimensionWidth toSize:20.0f];
        _iconImage.image = [UIImage imageNamed:icon_name];
        //标签
        [self.contentView addSubview:self.messagelable];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_messagelable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_messagelable autoSetDimension:ALDimensionWidth toSize:120.0f];
        [_messagelable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:15.0f];
        _messagelable.text = msgText;
        //数量
        [self.contentView addSubview:self.numLable];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        [_numLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_messagelable withOffset:15.0f];
        _numLable.text = numText;
    }
}

-(NSArray*)clearArray:(NSArray*)tmpArray
{
    NSMutableArray *myArray=[[NSMutableArray alloc] init];
    for (NSString *title in tmpArray) {
        if (![title isEqualToString:@"vip"] && ![title isEqualToString:@"rz"]) {
            [myArray addObject:title];
        }
    }
    NSArray *resultArray = [myArray copy];
    return resultArray;
}

@end
