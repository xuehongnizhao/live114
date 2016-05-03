//
//  reviewTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "reviewTableViewCell.h"

@interface reviewTableViewCell()
//----------------用户评论----------------------
@property (strong, nonatomic) UILabel *userNameLable;
@property (strong, nonatomic) UILabel *scoreText;
@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UILabel *typeLable;
@property (strong, nonatomic) UIView *score;
@end

@implementation reviewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark-----------set cell UI
-(void)configureCell  :(reviewInfo*)shopInfo
{
    //用户名
    [self.contentView addSubview:self.userNameLable];
    [_userNameLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_userNameLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_userNameLable autoSetDimension:ALDimensionWidth toSize:200];
    [_userNameLable autoSetDimension:ALDimensionHeight toSize:15.0];
    _userNameLable.text = shopInfo.user_name;
    //评价fen数
    [self.contentView addSubview:self.score];
    [_score autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
    [_score autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3.0f];
    [_score autoSetDimension:ALDimensionWidth toSize:100];
    [_score autoSetDimension:ALDimensionHeight toSize:20.0];
    [self setScore:_score :shopInfo.score];
    //评价
    [self.contentView addSubview:self.scoreText];
    [_scoreText autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
    [_scoreText autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_scoreText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_userNameLable withOffset:3.0f];
    _scoreText.text = shopInfo.review_text;
    //评价时间
    [self.contentView addSubview:self.timeLable];
    [_timeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_scoreText withOffset:5.0f];
    [_timeLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_timeLable autoSetDimension:ALDimensionWidth toSize:100.0f];
    [_timeLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
    _timeLable.text = [Base64Tool fuckNULL:shopInfo.add_time];
    //评价类型
    [self.contentView addSubview:self.typeLable];
    [_typeLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_timeLable withOffset:15.0f];
    [_typeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_scoreText withOffset:5.0f];
    [_typeLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
    [_typeLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    _typeLable.text = [Base64Tool fuckNULL:shopInfo.type];
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

/**
 以下是用户评价部分
 */
-(UILabel *)userNameLable
{
    if (!_userNameLable) {
        _userNameLable = [[UILabel alloc] initForAutoLayout];
        _userNameLable.font = [UIFont systemFontOfSize:12.0f];
        _userNameLable.textColor = UIColorFromRGB(addressTitle);
    }
    return _userNameLable;
}

-(UIView *)score
{
    if (!_score) {
        _score = [[UIView alloc] initForAutoLayout];
    }
    return _score;
}

-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] initForAutoLayout];
        _timeLable.textColor = UIColorFromRGB(reviewTitle);
        //_timeLable.layer.borderWidth = 1;
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

@end
