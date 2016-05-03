//
//  CityUserFrame.m
//  CardLeap
//
//  Created by songweiping on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUserFrame.h"

#define padding 10

@implementation CityUserFrame



- (void)setCityUser:(CityUser *)cityUser {
    
    _cityUser = cityUser;
    
    CGFloat browseX = padding;
    CGFloat browseY = padding;
    CGFloat browseW = 80;
    CGFloat browseH = 30;
    self.cityUserBrowseFrame = CGRectMake(browseX, browseY, browseW, browseH);
    
    CGFloat strX = browseX;
    CGFloat strY = CGRectGetMaxY(self.cityUserBrowseFrame);
    CGFloat strW = browseW;
    CGFloat strH = browseH;
    self.cityUserStrFrame = CGRectMake(strX, strY, strW, strH);
    
    
    CGFloat imageX = CGRectGetMaxX(self.cityUserBrowseFrame) + padding;
    CGFloat imageY = padding * 2;
    CGFloat imageW = 1;
    CGFloat imageH = browseH + strH - imageY;
    self.cityUserImageFrame = CGRectMake(imageX, imageY, imageW, imageH);
    
    
    CGFloat messX = CGRectGetMaxX(self.cityUserImageFrame) + padding;
    CGFloat messY = 0;
    CGFloat messW = 320 - messX - padding - padding;
    CGFloat messH = 50;
    self.cityUserMessageFrame = CGRectMake(messX, messY, messW, messH);
    
    
    
    CGFloat cateX = messX;
    CGFloat cateY = CGRectGetMaxY(self.cityUserMessageFrame);
    CGFloat cateW = messW / 2 - padding - padding;
    CGFloat cateH = 20;
    self.cityUserCateFrame = CGRectMake(cateX, cateY, cateW, cateH);
    
    
    
    CGFloat timeX = CGRectGetMaxX(self.cityUserCateFrame) + padding;
    CGFloat timeY = cateY;
    CGFloat timeW = 320 - timeX - padding;
    CGFloat timeH = cateH;
    self.cityUserAddTiemFrame = CGRectMake(timeX, timeY, timeW, timeH);
}

@end
