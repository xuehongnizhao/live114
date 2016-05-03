//
//  ShopTakeOutMapViewController.h
//  CardLeap
//
//  Created by mac on 15/2/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ShopTakeOutMapViewController : BaseViewController
//@property (strong, nonatomic) id<gotoShopDelegate> myDelegate;
//用户当前经纬度
@property (assign, nonatomic) CLLocationCoordinate2D myCoordinate;
//商家分类，用于从上一层传值
@property (strong, nonatomic) NSString * category;
//标识符，用于区分从哪个界面进入地图界面，以便做相应的调整
@property (strong, nonatomic) NSString * identifer;
//用于获取商家数据的url，同样用于从上一层传值
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) MKUserLocation *myLocation;
- (void)getMyLocation;
@property (nonatomic, strong) NSMutableArray *myData;
@property (strong, nonatomic) NSString *count;

//乐订需求加
@property (strong, nonatomic) NSString *cityID;
@end
