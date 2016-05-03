//
//  TextInputViewController.h
//  Orange
//
//  Created by mac on 14-1-27.
//  Copyright (c) 2014年 Youdro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol textInputDelegate <NSObject>

@optional

- (void)doneTextInput:(NSString *)text type:(NSString *)type;
- (void)cancelTextInput;

@end


@interface TextInputViewController : UIViewController

@property (strong, nonatomic) NSString *placeHolderString;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) id<textInputDelegate> delegate;

@end
