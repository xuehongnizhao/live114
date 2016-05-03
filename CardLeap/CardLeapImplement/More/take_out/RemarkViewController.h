//
//  RemarkViewController.h
//  CardLeap
//
//  Created by lin on 1/5/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  外卖 - 备注信息

#import <UIKit/UIKit.h>

@protocol finishDelegate <NSObject>

-(void)finishActionDelegate :(NSString*)remarkStr;

@end

@interface RemarkViewController : BaseViewController
@property (nonatomic ,strong) NSString * noteString;// 备注
@property (strong, nonatomic) id<finishDelegate> delegate;
@end
