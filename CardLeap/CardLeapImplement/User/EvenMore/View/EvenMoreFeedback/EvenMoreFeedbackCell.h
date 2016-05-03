//
//  EvenMoreFeedbackCell.h
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EvenMoreFeedbackFrame;

@interface EvenMoreFeedbackCell : UITableViewCell

/** 反馈信息显示的Frame数据模型 */
@property (strong, nonatomic) EvenMoreFeedbackFrame *feedbackFrame;

+ (instancetype) evenMoreFeedbackCellWithTableView:(UITableView *)tableView;

@end
