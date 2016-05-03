//
//  EvenMoreFeedbackCell.m
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EvenMoreFeedbackCell.h"
#import "EvenMoreFeedback.h"
#import "EvenMoreFeedbackFrame.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size];

@interface EvenMoreFeedbackCell()

// ---------------------- UI 控件 ----------------------
/** 显示反馈问题 */
@property (weak, nonatomic) UILabel *feedbackDescView;
/** 显示反馈时间 */
@property (weak, nonatomic) UILabel *feedbackAddTimeView;
/** 显示反馈是否回复 */
@property (weak, nonatomic) UILabel *feedbackReturenView;

@end

@implementation EvenMoreFeedbackCell

/**
 *  创建一个 意见反馈 自定义cell
 *
 *  @param  tableView
 *
 *  @return EvenMoreFeedbackCell
 */
+ (instancetype) evenMoreFeedbackCellWithTableView:(UITableView *)tableView {

    static NSString *cellName = @"moreMessageCell";
    
    EvenMoreFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        
        cell = [[EvenMoreFeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
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
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        [self addUI];
    }
    
    return self;
}


/**
 *  自定义Cell 添加控件
 */
- (void) addUI {
    
    UILabel *feedbackDescView         = [[UILabel alloc] init];
    feedbackDescView.font             = SYSTEM_FONT_SIZE(15);
    _feedbackDescView                 = feedbackDescView;
    [self.contentView addSubview:_feedbackDescView];
    
    UILabel *feedbackAddTimeView      = [[UILabel alloc] init];
    feedbackAddTimeView.font          = SYSTEM_FONT_SIZE(13);
    feedbackAddTimeView.textColor     = Color(180, 180, 180, 255);
    _feedbackAddTimeView              = feedbackAddTimeView;
    [self.contentView addSubview:_feedbackAddTimeView];
    
    UILabel *feedbackReturenView      = [[UILabel alloc] init];
    feedbackReturenView.font          = SYSTEM_FONT_SIZE(13);
    feedbackReturenView.textColor     = Color(180, 180, 180, 255);
    feedbackReturenView.textAlignment = NSTextAlignmentRight;
    _feedbackReturenView              = feedbackReturenView;
    [self.contentView addSubview:_feedbackReturenView];
    
    
}


/**
 *  重写 数据模型 (设置数据，设置frame)
 *
 *  @param feedbackFrame
 */
- (void)setFeedbackFrame:(EvenMoreFeedbackFrame *)feedbackFrame {
    
    _feedbackFrame = feedbackFrame;
    
    [self settingData];
    
    [self settingFrame];
    
}



/**
 *  设置 数据
 */
- (void) settingData {    
    EvenMoreFeedback *feedback    = self.feedbackFrame.feedback;
    self.feedbackDescView.text    = feedback.feed_desc;
    self.feedbackAddTimeView.text = feedback.add_time;
    self.feedbackReturenView.text = feedback.is_return;
}

/**
 *  设置 frame
 */
- (void) settingFrame {
    
    self.feedbackDescView.frame     = self.feedbackFrame.feedbackDescFrame;
    self.feedbackAddTimeView.frame  = self.feedbackFrame.feedbackAddTimeFrame;
    self.feedbackReturenView.frame  = self.feedbackFrame.feedbackReturenFrame;
    
}



@end
