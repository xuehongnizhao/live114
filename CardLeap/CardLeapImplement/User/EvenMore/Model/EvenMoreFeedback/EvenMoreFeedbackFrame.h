//
//  EvenMoreFeedbackFrame.h
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EvenMoreFeedback;

@interface EvenMoreFeedbackFrame : NSObject

/** 反馈问题的Frame */
@property (assign, nonatomic) CGRect feedbackDescFrame;
/** 反馈时间的Frame */
@property (assign, nonatomic) CGRect feedbackAddTimeFrame;
/** 反馈是否回复的Frame */
@property (assign, nonatomic) CGRect feedbackReturenFrame;
/** 反馈信息数据模型 */
@property (strong, nonatomic) EvenMoreFeedback *feedback;

@end
