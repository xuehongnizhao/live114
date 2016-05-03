//
//  SelectBar.h
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectBarDelegate<NSObject>
-(void)selectecButtonTag:(NSInteger) buttonTag;
@end

@interface SelectBar : UIView
@property(nonatomic,assign)id<SelectBarDelegate> delegate;
@end
