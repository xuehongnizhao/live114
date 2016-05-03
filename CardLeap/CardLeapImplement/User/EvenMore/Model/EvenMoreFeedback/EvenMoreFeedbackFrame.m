//
//  EvenMoreFeedbackFrame.m
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EvenMoreFeedbackFrame.h"

#define padding 10

@implementation EvenMoreFeedbackFrame


- (void)setFeedback:(EvenMoreFeedback *)feedback {
    
    _feedback = feedback;
    
    CGFloat descX = padding * 2;
    CGFloat descY = padding * 0.5;
    CGFloat descW = 240;
    CGFloat descH = 25;
    self.feedbackDescFrame = CGRectMake(descX, descY, descW, descH);
    
    CGFloat timeX = descX;
    CGFloat timeY = CGRectGetMaxY(self.feedbackDescFrame);
    CGFloat timeW = 150;
    CGFloat timeH = descH;
    self.feedbackAddTimeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat returnX = CGRectGetMaxX(self.feedbackAddTimeFrame);
    CGFloat returnY = timeY;
    CGFloat returnW = 120;
    CGFloat returnH = timeH;
    self.feedbackReturenFrame = CGRectMake(returnX, returnY, returnW, returnH);
}


@end
