//
//  SJSCTableViewCell.m
//  cityo2o
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "SJSCTableViewCell.h"

@implementation SJSCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setDataList:(NSDictionary *)dataList{
    _dataList=dataList;
    [self.goodsImage sd_setImageWithURL:[_dataList objectForKey:@"shop_img"]];
    self.goodsDescription.text=[_dataList objectForKey:@"shop_des"];
    
    self.price.text=[NSString stringWithFormat:@"￥%@",[_dataList objectForKey:@"shop_dprice"]];
    self.originalPrice.text=[NSString stringWithFormat:@"￥%@",[_dataList objectForKey:@"shop_oprice"]];
    NSUInteger length = [ [NSString stringWithFormat:@"￥%@",[_dataList objectForKey:@"shop_oprice"]]length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[_dataList objectForKey:@"shop_oprice"]]];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(2, length-2)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(2, length-2)];
    [self.originalPrice setAttributedText:attri];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
