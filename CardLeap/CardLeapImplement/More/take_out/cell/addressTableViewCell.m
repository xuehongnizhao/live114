//
//  addressTableViewCell.m
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "addressTableViewCell.h"

@interface addressTableViewCell()
@property (strong, nonatomic) UILabel *addressLable;
@property (strong, nonatomic) UILabel *phoneLable;
@property (strong, nonatomic) UIButton *selectButton;
@end

@implementation addressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(userAddressInfo*)info row:(NSInteger)row
{
    [self.contentView addSubview:self.addressLable];
    CGFloat height = (float)(info.as_address.length / 20 + 1)*18.0f;
    [_addressLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    [_addressLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_addressLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:66.0f];
    [_addressLable autoSetDimension:ALDimensionHeight toSize:height];
    _addressLable.text = info.as_address;
    
    [self.contentView addSubview:self.phoneLable];
    [_phoneLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_phoneLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_addressLable withOffset:5.0f];
    [_phoneLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:66.0f];
    [_phoneLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    _phoneLable.text = info.as_tel;
    
    [self.contentView addSubview:self.selectButton];
    _selectButton.tag = row;
    [_selectButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    //[_selectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_addressLable withOffset:10.0f];
    [_selectButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    [_selectButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_selectButton autoSetDimension:ALDimensionWidth toSize:40.0f];
    if ([info.is_default isEqualToString:@"1"]) {
        [_selectButton setImage:[UIImage imageNamed:@"adreess_sel"] forState:UIControlStateNormal];
    }else{
        [_selectButton setImage:[UIImage imageNamed:@"adreess_no"] forState:UIControlStateNormal];
    }
}

#pragma mark-----------get UI
-(UILabel *)addressLable
{
    if (!_addressLable) {
        _addressLable = [[UILabel alloc] initForAutoLayout];
        _addressLable.textColor = UIColorFromRGB(0x484848);
        _addressLable.font = [UIFont systemFontOfSize:13.0f];
    }
    return _addressLable;
}

-(UILabel *)phoneLable
{
    if (!_phoneLable) {
        _phoneLable = [[UILabel alloc] initForAutoLayout];
        _phoneLable.textColor = UIColorFromRGB(0x484848);
        _phoneLable.numberOfLines = 1;
        _phoneLable.font = [UIFont systemFontOfSize:13.0f];
    }
    return _phoneLable;
}

-(UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] initForAutoLayout];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

#pragma mark----------click action
-(void)selectAction:(UIButton*)sender
{
    NSLog(@"点击了对号按钮");
    [self.delegate selectActionDelegate:sender];
}
@end
