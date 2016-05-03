//
//  choosePickerView.h
//  CardLeap
//
//  Created by mac on 15/1/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseTimeDelegate <NSObject>
-(void)confirmDelegate :(NSString*)date time:(NSString*)time count:(NSString*)count year:(NSString*)year;
-(void)cancelActionDelegate;
@end

@interface choosePickerView : UIView
@property (strong,nonatomic)id<chooseTimeDelegate> delegate;
@property (strong,nonatomic)NSArray *timeArray;
@property (strong,nonatomic)NSArray *countArray;
@property (strong,nonatomic)NSArray *dateArray;
@property (strong,nonatomic)NSArray *yearArray;
-(void)initWithArray :(NSArray*)timeArray CountArray:(NSArray*)countArray dateArray:(NSArray*)dateArray year:(NSArray*)years;
@end
