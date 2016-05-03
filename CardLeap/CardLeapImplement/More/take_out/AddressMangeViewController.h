//
//  AddressMangeViewController.h
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  外卖 - 收货地址管理

#import <UIKit/UIKit.h>

@protocol selectAddressDelegate <NSObject>

-(void)selectAddress :(NSString*)address_str phone:(NSString*)phone_str;

@end

@interface AddressMangeViewController : BaseViewController
@property (strong, nonatomic) id<selectAddressDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *addressArray;
@end
