//
//  JsonModel.h
//  CardLeap
//
//  Created by mac on 15/3/17.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tabarItemModel.h"
#import "indexModel.h"

@interface JsonModel : NSObject
+(JsonModel*)shareInstance;
+(UIColor *)colorWithHexString:(NSString *)stringToConvert;
-(void)readJsonFromTxt:(NSString*)fielName;
/**
 app 主色 配色
 */
@property (strong,nonatomic)NSString *indexColor;
@property (strong,nonatomic)NSString *otherColor;
/**
 这里是解析实体类好 还是直接使用数据结构 有待考量
 */
@property (strong,nonatomic) NSArray *modelSwitchArray;

//首页六大模块开关及控制跳转
@property (strong,nonatomic) NSArray *modelUrlArray;
@property (strong,nonatomic) NSString *modelActionArra;

//tabar样式控制
@property (strong,nonatomic) NSArray *tabarViewControlelr;
@property (strong,nonatomic) NSArray *tabarItemSelArray;
@property (strong,nonatomic) NSArray *tabarItemNoArray;
@property (strong,nonatomic) NSArray *tabarItemSelColorArray;
@property (strong,nonatomic) NSArray *tabarItemNoColorArray;
@property (strong,nonatomic) NSArray *tabarItemTextArra;
@property (strong,nonatomic) NSString *tabarBackgroundColor;

//tabarItemArray
@property (strong,nonatomic) NSMutableArray *tabarItemArray;
//indexModelArray
@property (strong,nonatomic) NSMutableArray *indexModelArray;

@end
