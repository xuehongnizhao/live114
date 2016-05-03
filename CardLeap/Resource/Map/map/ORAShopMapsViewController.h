//
//  ORAShopMapsViewController.h
//  Orange
//
//  Created by mac on 14-2-10.
//  Copyright (c) 2014年 Youdro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//@protocol gotoShopDelegate <NSObject>
//
//-(void)goShop;
//
//@end
/**
 * @brief           商家地图
 *                  显示用户附近的商家，点击地图图标显示简介和评价。点击详情面板进入商家
 * @author          赵作林
 * @version         0.5
 */
@interface ORAShopMapsViewController : BaseViewController
//@property (strong, nonatomic) id<gotoShopDelegate> myDelegate;
//用户当前经纬度
@property (assign, nonatomic) CLLocationCoordinate2D myCoordinate;
//商家分类，用于从上一层传值
@property (assign, nonatomic) NSInteger category;
//标识符，用于区分从哪个界面进入地图界面，以便做相应的调整
@property (strong, nonatomic) NSString *identifer;
//用于获取商家数据的url，同样用于从上一层传值
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) MKUserLocation *myLocation;
- (void)getMyLocation;
@property (nonatomic, strong) NSMutableArray *myData;
@property (strong, nonatomic) NSString *count;
@property (weak ,nonatomic) NSMutableDictionary *shopListDic;
//乐订需求加
@property (strong, nonatomic) NSString *cityID;
@end
