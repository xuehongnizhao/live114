//
//  SJSCTableViewCell.h
//  cityo2o
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJSCTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goodsDescription;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (copy, nonatomic) NSDictionary *dataList;

@end
