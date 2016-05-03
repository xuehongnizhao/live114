//
//  shopToAnnotation.m
//  map
//
//  Created by Gpsye on 12-11-24.
//  Copyright (c) 2012年 Gpsye. All rights reserved.
//

#import "shopToAnnotation.h"

@interface ShopToAnnotation ()
@property (nonatomic, strong)NSString *titleStr;
@property (nonatomic, strong)NSString *subTitle;
@end

@implementation ShopToAnnotation
@synthesize shop = _shop;
@synthesize titleStr = _titleStr;
@synthesize subTitle = _subTitle;

+ (id<MKAnnotation>)annotationForShop:(NSDictionary *)shop{
    ShopToAnnotation *annotation = [[ShopToAnnotation alloc] init];
    annotation.shop = shop;
    
    NSString *str = [shop objectForKey:@"addr"];
    NSArray *strArray = [str componentsSeparatedByString:@" "];
    if([strArray count] > 4){
        NSRange range = [str rangeOfString:[strArray objectAtIndex:2]];
        annotation.titleStr = [str substringToIndex:range.location];
        annotation.subTitle = [str substringFromIndex:range.location];
    }else{
        annotation.titleStr = str;
    }
//    NSLog(@"annotation.titleStr is %@", annotation.titleStr);
//    NSLog(@"annotation.subTitle is %@", annotation.subTitle);
    return annotation;
}

- (NSString *)title{
    return _titleStr;
}
- (NSString *)subtitle{
    return _subTitle;
}

- (CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.shop objectForKey:@"latitude"] doubleValue];
    
    coordinate.longitude = [[self.shop objectForKey:@"longitude"] doubleValue];
//    NSLog(@"lat=%f,lon= %f",coordinate.latitude,coordinate.longitude);
    return coordinate;
}

@end
