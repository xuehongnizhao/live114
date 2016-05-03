//
//  Annotaion.h
//  Orange
//
//  Created by mac on 14-2-10.
//  Copyright (c) 2014年 Youdro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotaion : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) int tag;

@end
