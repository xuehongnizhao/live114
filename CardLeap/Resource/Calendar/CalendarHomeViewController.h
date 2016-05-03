//
//  CalendarHomeViewController.h
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

/**
  使用方法：
    CalendarHomeViewController *chvc;
     if (!chvc) {
     chvc = [[CalendarHomeViewController alloc]init];
     chvc.calendartitle = @"飞机";
     //[chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
     [chvc setHotelToDay:365 ToDateforString:@"11"];
     }

     chvc.calendarblock = ^(NSString *model){
     NSLog(@"\n---------------------------");
     NSLog(@"日期区间是%@",model);
     [btn setTitle:model forState:UIControlStateNormal];
     };
     [self.navigationController pushViewController:chvc animated:YES];
 */

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"


@interface CalendarHomeViewController : CalendarViewController

@property (nonatomic, strong) NSString *calendartitle;//设置导航栏标题

- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate;//飞机初始化方法

- (void)setHotelToDay:(int)day ToDateforString:(NSString *)todate;//酒店初始化方法

- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate;//火车初始化方法

@end
