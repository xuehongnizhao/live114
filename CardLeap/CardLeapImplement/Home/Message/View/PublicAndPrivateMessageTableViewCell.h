//
//  PublicAndPrivateMessageTableViewCell.h
//  CardLeap
//
//  Created by songweiping on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PublicAndPrivateMessageFrame;
@class PublicAndPrivateMessage;

@interface PublicAndPrivateMessageTableViewCell : UITableViewCell


+ (instancetype) publicAndPrivateMessageWithTableView:(UITableView *)tableView;



/** 显示控件的frame模型(frame 包含数据模型) */
@property (strong, nonatomic) PublicAndPrivateMessageFrame *messageFrame;


@end
