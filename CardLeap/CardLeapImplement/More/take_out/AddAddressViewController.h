//
//  AddAddressViewController.h
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  外卖 - 添加收获地址

#import <UIKit/UIKit.h>

@protocol addAddressDelegate <NSObject>

-(void)addAddressDelegate;

@end

@interface AddAddressViewController : BaseViewController
@property (strong, nonatomic) id<addAddressDelegate> delegate;
@end
