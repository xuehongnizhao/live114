//
//  myPointInfo.h
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myPointInfo : NSObject
@property (strong,nonatomic)NSString *operation;
@property (strong,nonatomic)NSString *pay_point;
@property (strong,nonatomic)NSString *time;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
