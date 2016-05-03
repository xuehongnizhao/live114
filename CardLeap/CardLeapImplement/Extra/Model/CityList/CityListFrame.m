//
//  CityListFrame.m
//  CardLeap
//
//  Created by songweiping on 14/12/27.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityListFrame.h"

@implementation CityListFrame


/**
 *  重写模型数据的set方法 给控件设置frame
 *
 *  @param cityList
 */
- (void)setCityList:(CityList *)cityList {
    
    _cityList = cityList;
    
    CGFloat padding = 10;
    
    // 设置图片的位置
    CGFloat picX = padding;
    CGFloat picY = padding;
    CGFloat picW = 100;
    CGFloat picH = 80;
    _messagePicFrame = CGRectMake(picX, picY, picW, picH);
    
    // 设置名称的位置
    CGFloat nameX = CGRectGetMaxX(_messagePicFrame) + padding;
    CGFloat nameY = picY;
    CGFloat nameW = 320 - CGRectGetWidth(_messagePicFrame) - 30;
    CGFloat nameH = 20;
    _messageNameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    // 设置简介的位置
    CGFloat descX = nameX;
    CGFloat descY = CGRectGetMaxY(_messageNameFrame) + padding;
    CGFloat descW = nameW;
    CGFloat descH = nameH;
    _messageDescFrame = CGRectMake(descX, descY, descW, descH);
    
    // 设置价格的位置
    CGFloat priceX = descX;
    CGFloat priceY = CGRectGetMaxY(_messageDescFrame) + padding;
    CGFloat priceW = descW / 3;
    CGFloat priceH = descH;
    _messagePriceFrame = CGRectMake(priceX, priceY, priceW, priceH);
    
    // 设置时间的位置
    CGFloat timeX = CGRectGetMaxX(_messagePriceFrame) + 2;
    CGFloat timeY = priceY;
    CGFloat timeW = 320 - timeX;
    CGFloat timeH = priceH;
    _messageTimeFrame = CGRectMake(timeX, timeY, timeW, timeH);

}


@end
