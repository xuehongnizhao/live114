//
//  shopTakeoutTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "shopTakeoutTableViewCell.h"

@interface shopTakeoutTableViewCell()
@property (strong, nonatomic) UIImageView *shopImage;
@property (strong, nonatomic) UILabel *shopName;
@property (strong, nonatomic) UIView *scoreView;
@property (strong, nonatomic) UILabel *messageLable;
@end

@implementation shopTakeoutTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell :(shopTakeoutInfo*)info
{
    //商家图片
    [self.contentView addSubview:self.shopImage];
    [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0f];
    [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shopImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
    [_shopImage autoSetDimension:ALDimensionWidth toSize:80.0f];
    [_shopImage sd_setImageWithURL:[NSURL URLWithString:info.shop_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    //商家名称
    [self.contentView addSubview:self.shopName];
    [_shopName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
    [_shopName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shopName autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12.0f];
    [_shopName autoSetDimension:ALDimensionHeight toSize:20.0f];
    _shopName.text = info.shop_name;
    //评分
    [self.contentView addSubview:self.scoreView];
    [_scoreView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
    [_scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopName withOffset:5.0f];
    [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12.0f];
    [_scoreView autoSetDimension:ALDimensionHeight toSize:20.0f];
    [self setScore:_scoreView :info.score];
    //起送价格等
    [self.contentView addSubview:self.messageLable];
    [_messageLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImage withOffset:8.0f];
    [_messageLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_scoreView withOffset:0.0f];
    [_messageLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12.0f];
    [_messageLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    _messageLable.text = [NSString stringWithFormat:@"起送价:%@",info.begin_price];
    //加灰
    if ([info.is_ship isEqualToString:@"1"]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *blankView = [[UIView alloc] initForAutoLayout];
        [self.contentView addSubview:blankView];
        [blankView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
        [blankView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
        [blankView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [blankView autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:0.0f];
        [blankView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

#pragma mark-----------get UI
-(UIImageView *)shopImage
{
    if (!_shopImage) {
        _shopImage = [[UIImageView alloc] initForAutoLayout];
        _shopImage.layer.borderWidth = 0.5;
        _shopImage.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
    }
    return _shopImage;
}

-(UILabel *)shopName
{
    if (!_shopName) {
        _shopName = [[UILabel alloc] initForAutoLayout];
        _shopName.font = [UIFont systemFontOfSize:15.0f];
        _shopName.textColor = UIColorFromRGB(indexTitle);
    }
    return _shopName;
}

-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] initForAutoLayout];
    }
    return _scoreView;
}

-(UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] initForAutoLayout];
        _messageLable.font = [UIFont systemFontOfSize:13.0f];
        _messageLable.textColor = UIColorFromRGB(addressTitle);
    }
    return _messageLable;
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
