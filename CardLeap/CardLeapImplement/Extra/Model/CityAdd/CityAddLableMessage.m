//
//  CityAddLableMessage.m
//  CardLeap
//
//  Created by songweiping on 15/1/7.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityAddLableMessage.h"

@implementation CityAddLableMessage


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.isDisplayLable          = NO;
        self.isDisplayPriceImageView = NO;
        self.isDisplayPriceTextView  = NO;
    }
    return self;
}

@end
