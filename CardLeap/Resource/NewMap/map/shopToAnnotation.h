//
//  shopToAnnotation.h
//  map
//
//  Created by Gpsye on 12-11-24.
//  Copyright (c) 2012年 Gpsye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ShopToAnnotation : NSObject <MKAnnotation>
@property (nonatomic, strong)NSDictionary *shop;
+ (id<MKAnnotation>)annotationForShop:(NSDictionary *)shop;
@end
