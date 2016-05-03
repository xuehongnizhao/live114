//
//  ShopDishTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/29/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ShopDishTableViewCell.h"

@interface ShopDishTableViewCell()
{
    NSInteger myRow;
}
@property (strong, nonatomic) UIImageView *shop_pic;
@property (strong, nonatomic) UILabel *shop_name;
@property (strong, nonatomic) UIView *shop_score;
@property (strong, nonatomic) UILabel *shop_count;
@property (strong, nonatomic) UIView *operateView;
@property (strong, nonatomic) UILabel *singlePriceLable;
//add and sub button
@property (strong, nonatomic) UIButton *subButton;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UILabel *cashLable;

@property (strong, nonatomic) takeoutDishInfo *myInfo;
@end

@implementation ShopDishTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)configureCell :(takeoutDishInfo*)info index:(NSInteger)row
{
    _myInfo = info;
    myRow = row;
    //操作
    [self.contentView addSubview:self.operateView];
    //    _operateView.layer.borderWidth = 1;
    [_operateView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2.0f];
    [_operateView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_operateView autoSetDimension:ALDimensionHeight toSize:30.0f];
    [_operateView autoSetDimension:ALDimensionWidth toSize:100.0f];
    
    [_operateView addSubview:self.subButton];
    [_subButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2.0f];
    [_subButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.0f];
    [_subButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_subButton autoSetDimension:ALDimensionWidth toSize:30.0];
    
    [_operateView addSubview:self.cashLable];
    [_cashLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2.0f];
    [_cashLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.0f];
    [_cashLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_subButton withOffset:0.0f];
    [_cashLable autoSetDimension:ALDimensionWidth toSize:40.0];
    _cashLable.text = [NSString stringWithFormat:@"%0.2f",info.count * [info.take_price floatValue]];
    if (info.count==0) {
        _subButton.hidden = YES;
        _cashLable.hidden = YES;
    }else{
        _subButton.hidden = NO;
        _cashLable.hidden = NO;
    }
    [_operateView addSubview:self.addButton];
    [_addButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_cashLable withOffset:0.0f];
    [_addButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2.0f];
    [_addButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.0f];
    [_addButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    [_addButton setTitle:@"+" forState:UIControlStateHighlighted];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_addButton setTitleColor:UIColorFromRGB(0xc43a40)forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _addButton.layer.borderWidth = 0.5;
    _addButton.layer.borderColor = UIColorFromRGB(0xc43a40).CGColor;
    
    //外卖图片
    [self.contentView addSubview:self.shop_pic];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_shop_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_shop_pic autoSetDimension:ALDimensionWidth toSize:55.0f];
    [_shop_pic sd_setImageWithURL:[NSURL URLWithString:info.take_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    _shop_pic.tag = row;
    _shop_pic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myDidselectImage:)];
    [_shop_pic addGestureRecognizer:tapGesture];
    
    //外卖名称
    [self.contentView addSubview:self.shop_name];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_shop_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_shop_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:5.0f];
    [_shop_name autoSetDimension:ALDimensionHeight toSize:18.0f];
    _shop_name.text = info.take_name;
    
    //销售量
    [self.contentView addSubview:self.shop_count];
    //    _shop_count.layer.borderWidth = 1;
    [_shop_count autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:5.0f];
    [_shop_count autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name withOffset:3.0f];
    [_shop_count autoSetDimension:ALDimensionHeight toSize:18.0f];
    [_shop_count autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_operateView withOffset:-2.0f];
    _shop_count.text = [NSString stringWithFormat:@"月售:%@份",info.pay_num];
    
    //单价
    [self.contentView addSubview:self.singlePriceLable];
    //    _singlePriceLable.layer.borderWidth =1;
    [_singlePriceLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pic withOffset:5.0f];
    [_singlePriceLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_count withOffset:2.0f];
    [_singlePriceLable autoSetDimension:ALDimensionHeight toSize:18.0f];
    [_singlePriceLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_operateView withOffset:-2.0f];
    _singlePriceLable.text = [NSString stringWithFormat:@"￥%@",info.take_price];
    
}

-(void)myDidselectImage:(UITapGestureRecognizer*)sender
{
    NSLog(@"%ld",(long)myRow);
    
    [self.delegate didselectImage:myRow];
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

#pragma mark-----------action
-(void)subAction:(UIButton*)sender
{
    _myInfo.count --;
    if (_myInfo.count == 0) {
        sender.hidden = YES;
        _cashLable.hidden = YES;
    }
    _cashLable.text = [NSString stringWithFormat:@"%0.2f",_myInfo.count * [_myInfo.take_price floatValue]];
    [self.delegate subAction:_myInfo dishCell:self];
}

-(void)addAction:(UIButton*)sender
{
    _subButton.hidden = NO;
    _cashLable.hidden = NO;
    _myInfo.count ++;
    NSLog(@"%f",[_myInfo.take_pic floatValue]);
    _cashLable.text = [NSString stringWithFormat:@"%0.2f",_myInfo.count * [_myInfo.take_price floatValue]];
    [self.delegate addAction:_myInfo dishCell:self btn:sender];
}

#pragma mark-----------get UI
-(UIButton *)subButton
{
    if (!_subButton) {
        _subButton = [[UIButton alloc] initForAutoLayout];
        [_subButton setImage:[UIImage imageNamed:@"order_duction"] forState:UIControlStateNormal];
        [_subButton setImage:[UIImage imageNamed:@"order_duction"] forState:UIControlStateHighlighted];
        [_subButton addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

-(UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [[UIButton alloc] initForAutoLayout];
        [_addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

-(UILabel *)cashLable
{
    if (!_cashLable) {
        _cashLable = [[UILabel alloc] initForAutoLayout];
        _cashLable.textColor = [UIColor lightGrayColor];
        _cashLable.font = [UIFont systemFontOfSize:12.0f];
        _cashLable.textAlignment = NSTextAlignmentCenter;
    }
    return _cashLable;
}

-(UILabel *)singlePriceLable
{
    if (!_singlePriceLable) {
        _singlePriceLable = [[UILabel alloc] initForAutoLayout];
        _singlePriceLable.textColor = UIColorFromRGB(0x888888);
        _singlePriceLable.font = [UIFont systemFontOfSize:10.0f];
        _singlePriceLable.textAlignment = NSTextAlignmentLeft;
    }
    return _singlePriceLable;
}

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
        _shop_name.textColor = UIColorFromRGB(0x4b4b4b);
        _shop_name.font = [UIFont systemFontOfSize:12.0f];
    }
    return _shop_name;
}

-(UIView *)shop_score
{
    if (!_shop_score) {
        _shop_score = [[UIView alloc] initForAutoLayout];
    }
    return _shop_score;
}

-(UILabel *)shop_count
{
    if (!_shop_count) {
        _shop_count = [[UILabel alloc] initForAutoLayout];
        _shop_count.textColor = UIColorFromRGB(0x888888);
        _shop_count.font = [UIFont systemFontOfSize:12.0f];
    }
    return _shop_count;
}

-(UIView *)operateView
{
    if (!_operateView) {
        _operateView = [[UIView alloc] initForAutoLayout];
        //_operateView.layer.borderWidth = 1;
    }
    return _operateView;
}
@end
