//
//  payAlipayWebViewController.h
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  completeDelegate<NSObject>
-(void)completeAction;
@end

@interface payAlipayWebViewController : BaseViewController
@property (strong,nonatomic)id<completeDelegate> delegate;
@property (strong,nonatomic)NSString *pay_url;
@property (strong,nonatomic)NSString *pass_code;
@end
