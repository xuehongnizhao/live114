//
//  PublicAndPrivateMessageTableViewCell.m
//  CardLeap
//
//  Created by songweiping on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "PublicAndPrivateMessageTableViewCell.h"


#import "PublicAndPrivateMessageFrame.h"
#import "PublicAndPrivateMessage.h"


#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]


@interface PublicAndPrivateMessageTableViewCell()

// ---------------------- UI 控件 ----------------------
/** 公信 / 私信 显示详情的View */
@property (weak, nonatomic) UILabel     *messageDescView;
/** 公信 / 私信 显示时间的View */
@property (weak, nonatomic) UILabel     *messageAddTimeView;
/** 公信 / 私信 显示是否已读状态 */
@property (weak, nonatomic) UIImageView *messageIsReadView;

@end

@implementation PublicAndPrivateMessageTableViewCell


/**
 *  创建一个 PublicAndPrivateMessageTableViewCell 自定义cell
 *
 *  @param  tableView
 *
 *  @return
 */
+ (instancetype) publicAndPrivateMessageWithTableView:(UITableView *)tableView {
    
    static NSString *cellName = @"messageCell";
    PublicAndPrivateMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[PublicAndPrivateMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



/**
 *  重写 cell 初始化方法
 *
 *  @param style
 *  @param reuseIdentifier
 *
 *  @return
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        [self addUI];
    }
    
    return self;
}

/**
 *  添加控件
 */
- (void) addUI {
    
    UILabel *messageDescView = [[UILabel alloc] init];
    messageDescView.font     = SYSTEM_FONT_SIZE(15);
    _messageDescView         = messageDescView;
    [self.contentView addSubview:_messageDescView];
    
    UILabel *messageAddTimeView  = [[UILabel alloc] init];
    messageAddTimeView.font      = SYSTEM_FONT_SIZE(12);
    messageAddTimeView.textColor = Color(170, 170, 170, 255);
    _messageAddTimeView          = messageAddTimeView;
    [self.contentView addSubview:_messageAddTimeView];
    
    UIImageView *messageIsReadView        = [[UIImageView alloc] init];
    messageIsReadView.backgroundColor     = [UIColor redColor];
    messageIsReadView.layer.cornerRadius  = 5 / 1;
    messageIsReadView.layer.masksToBounds = YES;
    _messageIsReadView                    = messageIsReadView;
    [self.contentView addSubview:_messageIsReadView];

}


/**
 *  重写 显示控件的 frame 模型的 set 方法 设置数据和设置frame
 *
 *  @param messageFrame
 */
- (void)setMessageFrame:(PublicAndPrivateMessageFrame *)messageFrame {
    
    _messageFrame = messageFrame;
    
    [self settingData];
    
    [self settingFrame];
}



/**
 *  设置数据
 */
- (void) settingData {
    
    self.messageDescView.text      = self.messageFrame.message.m_desc;
    self.messageAddTimeView.text   = self.messageFrame.message.add_time;
    if ([self.messageFrame.message.is_read isEqualToString:@"1"]) {
        self.messageIsReadView.hidden = YES;
    } else {
        self.messageIsReadView.hidden = NO;
    }
    
}

/**
 *  设置frame
 */
- (void) settingFrame {
    
    self.messageDescView.frame    = self.messageFrame.messageDescViewFrame;
    self.messageAddTimeView.frame = self.messageFrame.messageAddTimeViewFrame;
    self.messageIsReadView.frame  = self.messageFrame.messageIsReadViewFrame;
}



@end
