//
//  shopTakeDetailTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/30/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "shopTakeDetailTableViewCell.h"

@interface shopTakeDetailTableViewCell()
//---------shop message-----------------
@property (strong, nonatomic) UIImageView *shop_pic;
@property (strong, nonatomic) UILabel *shop_name;
@property (strong, nonatomic) UIView *scoreView;
@property (strong, nonatomic) UILabel *score_num;
@property (strong, nonatomic) UILabel *review_num;
@end

@implementation shopTakeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confirgureCell :(shopTakeCateInfo*)info sectino:(NSInteger)section row:(NSInteger)row
{

    if (section == 0) {
        //-----图片------
        [self.contentView addSubview:self.shop_pic];
        [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop  withInset:10.0f];
        [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_shop_pic autoSetDimension:ALDimensionWidth toSize:86.0f];
        [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.shop_pic] placeholderImage:[UIImage imageNamed:@"user"]];
        //-----商家名称------
        [self.contentView addSubview:self.shop_name];
        [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_shop_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:5.0f];
        [_shop_name autoSetDimension:ALDimensionHeight toSize:25.0f];
        _shop_name.text = info.shop_name;
        //-----星星---------
        [self.contentView addSubview:self.scoreView];
        [_scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:5.0f];
        [_scoreView autoSetDimension:ALDimensionWidth toSize:88.0f];
        [_scoreView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:5.0f];
        [_scoreView autoSetDimension:ALDimensionHeight toSize:20.0f];
        [self setScore:_scoreView score:info.score];
        //-----份数---------
//        [self.contentView addSubview:self.score_num];
//        [_score_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:5.0f];
//        [_score_num autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:1.0f];
//        [_score_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//        [_score_num autoSetDimension:ALDimensionHeight toSize:25.0f];
//        _score_num.text = [NSString stringWithFormat:@"%@分",info.score];
        //-----评价数量-------
        [self.contentView addSubview:self.review_num];
        [_review_num autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_scoreView withOffset:5.0f];
        [_review_num autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_review_num autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:5.0f];
        [_review_num autoSetDimension:ALDimensionHeight toSize:25.0f];
        _review_num.text = [NSString stringWithFormat:@"%@",info.shop_address];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (section == 1){
        
        UIImageView *imageLine = [[UIImageView alloc] initForAutoLayout];
        imageLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:imageLine];
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGFloat width = rect.size.width;
        [imageLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
        [imageLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
        [imageLine autoSetDimension:ALDimensionWidth toSize:1.0f];
        [imageLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:width/3.0];
        
        UIImageView *imageLine1 = [[UIImageView alloc] initForAutoLayout];
        imageLine1.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:imageLine1];
        [imageLine1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
        [imageLine1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
        [imageLine1 autoSetDimension:ALDimensionWidth toSize:1.0f];
        [imageLine1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageLine withOffset:width/3.0f];
        
        CGFloat blankWidth = (SCREEN_WIDTH/3.0-50-2)/2.0;
        
        //添加标注
        UILabel *reciveLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:reciveLable];
        reciveLable.backgroundColor = UIColorFromRGB(0x28b582);
        reciveLable.textColor = [UIColor whiteColor];
        reciveLable.font = [UIFont systemFontOfSize:11.0];
        reciveLable.text = @"起送价格";
        reciveLable.textAlignment = NSTextAlignmentCenter;
        [reciveLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [reciveLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:blankWidth];
        [reciveLable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [reciveLable autoSetDimension:ALDimensionWidth toSize:50.0f];
        
        UILabel *acceptLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:acceptLable];
        acceptLable.textColor = UIColorFromRGB(singleTitle);
        acceptLable.font = [UIFont systemFontOfSize:13.0];
        acceptLable.text = [NSString stringWithFormat:@"%@元",info.begin_price];
        acceptLable.textAlignment = NSTextAlignmentCenter;
        [acceptLable autoAlignAxis:ALAxisVertical toSameAxisOfView:reciveLable];
        [acceptLable autoSetDimension:ALDimensionWidth toSize:50.0f];
        [acceptLable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [acceptLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:reciveLable withOffset:5.0f];
        
        //送餐速度
        UILabel *speedLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:speedLable];
        speedLable.backgroundColor = UIColorFromRGB(0xfb6f4c);
        speedLable.textColor = [UIColor whiteColor];
        speedLable.font = [UIFont systemFontOfSize:11.0];
        speedLable.text = @"送餐速度";
        speedLable.textAlignment = NSTextAlignmentCenter;
        [speedLable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [speedLable autoSetDimension:ALDimensionWidth toSize:50.0f];
        [speedLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [speedLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageLine withOffset:blankWidth];
        
        UILabel *takeSpeedLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:takeSpeedLable];
        takeSpeedLable.textColor = UIColorFromRGB(singleTitle);
        takeSpeedLable.font = [UIFont systemFontOfSize:13.0];
        takeSpeedLable.text = [NSString stringWithFormat:@"%@分钟",info.shipping];
        takeSpeedLable.textAlignment = NSTextAlignmentCenter;
        [takeSpeedLable autoAlignAxis:ALAxisVertical toSameAxisOfView:speedLable];
        [takeSpeedLable autoSetDimension:ALDimensionWidth toSize:50.0f];
        [takeSpeedLable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [takeSpeedLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:speedLable withOffset:5.0f];
        
        //及时送达
        UILabel *timeLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:timeLable];
        timeLable.backgroundColor = UIColorFromRGB(0x7fb1ee);
        timeLable.textColor = [UIColor whiteColor];
        timeLable.font = [UIFont systemFontOfSize:11.0];
        timeLable.text = @"送餐费";
        timeLable.textAlignment = NSTextAlignmentCenter;
        [timeLable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [timeLable autoSetDimension:ALDimensionWidth toSize:50.0f];
        [timeLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [timeLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageLine1 withOffset:blankWidth];
        
        UILabel *inTimeLable = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:inTimeLable];
        inTimeLable.textColor = UIColorFromRGB(singleTitle);
        inTimeLable.font = [UIFont systemFontOfSize:13.0];
        inTimeLable.text = [NSString stringWithFormat:@"%@元",info.ship_price];
        inTimeLable.textAlignment = NSTextAlignmentCenter;
        [inTimeLable autoAlignAxis:ALAxisVertical toSameAxisOfView:timeLable];
        [inTimeLable autoSetDimension:ALDimensionWidth toSize:50.0f];
        [inTimeLable autoSetDimension:ALDimensionHeight toSize:20.0f];
        [inTimeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:timeLable withOffset:5.0f];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (section == 2){
        UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
        tmpLable.font = [UIFont systemFontOfSize:14.0f];
        tmpLable.textColor = UIColorFromRGB(singleTitle);
        [self.contentView addSubview:tmpLable];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [tmpLable autoSetDimension:ALDimensionWidth toSize:120.0f];
        tmpLable.text = @"评价";
        
        UILabel *reviewNum = [[UILabel alloc] initForAutoLayout];
        reviewNum.font = [UIFont systemFontOfSize:14.0f];
        reviewNum.textColor = UIColorFromRGB(singleTitle);
        reviewNum.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:reviewNum];
        [reviewNum autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [reviewNum autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [reviewNum autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [reviewNum autoSetDimension:ALDimensionWidth toSize:150.0f];
        reviewNum.text = [NSString stringWithFormat:@"已有%@人评价",info.review_num];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if (section == 3){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            UIImageView *iconImage = [[UIImageView alloc] initForAutoLayout];
            [iconImage setImage:[UIImage imageNamed:@"navbusiness_sel"]];
            [self.contentView addSubview:iconImage];
            [iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [iconImage autoSetDimension:ALDimensionWidth toSize:25.0f];
            
            UILabel *noticeLable = [[UILabel alloc] initForAutoLayout];
            [self.contentView addSubview:noticeLable];
            noticeLable.font = [UIFont systemFontOfSize:14.0f];
            noticeLable.textColor = UIColorFromRGB(singleTitle);
            noticeLable.text = @"餐厅公告";
            [noticeLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImage withOffset:8.0f];
            [noticeLable autoSetDimension:ALDimensionWidth toSize:150.0f];
            [noticeLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [noticeLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        }else{
            UILabel *noticeMessageLable = [[UILabel alloc] initForAutoLayout];
            [self.contentView addSubview:noticeMessageLable];
            noticeMessageLable.font = [UIFont systemFontOfSize:14.0f];
            noticeMessageLable.textColor = [UIColor lightGrayColor];
            noticeMessageLable.numberOfLines = 0;
            noticeMessageLable.text = info.shop_take_desc;
            [noticeMessageLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [noticeMessageLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [noticeMessageLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            //[noticeMessageLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        }
    }
}

#pragma mark-----------get UI
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
        _shop_name.textColor = UIColorFromRGB(indexTitle);
        _shop_name.font = [UIFont systemFontOfSize:15.0];
    }
    return _shop_name;
}

-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] initForAutoLayout];
    }
    return _scoreView;
}

-(UILabel *)score_num
{
    if (!_score_num) {
        _score_num = [[UILabel alloc] initForAutoLayout];
        //_score_num.layer.borderWidth = 1;
        _score_num.textColor = UIColorFromRGB(reviewTitle);
        _score_num.font = [UIFont systemFontOfSize:13.0f];
    }
    return _score_num;
}

-(UILabel *)review_num
{
    if (!_review_num) {
        _review_num = [[UILabel alloc] initForAutoLayout];
        _review_num.textColor = UIColorFromRGB(addressTitle);
        _review_num.font = [UIFont systemFontOfSize:13.0f];
    }
    return _review_num;
}

#pragma mark-----------设置星星显示
-(void)setScore:(UIView *)score score:(NSString*)count
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
