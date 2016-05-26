//
//  HomeSelectedCityHeaderView.m
//  WeiBang
//
//  Created by songweipng on 15/3/18.
//  Copyright (c) 2015年 songweipng. All rights reserved.
//

#import "HomeSelectedCityHeaderView.h"

// ---------------------- 框架工具类 ----------------------
#import "UIButton+WeiBang.h"            // 微榜UIButton分类
// ---------------------- 框架工具类 ----------------------

#import <CoreLocation/CoreLocation.h>
#import "CSqlite.h"

@interface HomeSelectedCityHeaderView ()<CLLocationManagerDelegate>
{
    BOOL is_location;
}

// ---------------------- UI 控件 ----------------------
/** 显示定位城市名称 */
@property (strong, nonatomic) UILabel  *homeSelectedCityTitleView;


/*!
 *  @author Sky
 *
 *  @brief  定位按钮
 */
@property (strong,nonatomic) UIActivityIndicatorView* indicatorView;

@end


@implementation HomeSelectedCityHeaderView
{
    //-----使用开启定位------------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    NSString *baidu_late;
    NSString *baidu_lng;
    
    //已定位城市
    NSString* locationCity;
}

/**
 *  重写初始化方法
 *
 *  @param  frame
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addUI];
        
        is_location = YES;
        
        //如果未开启定位
        if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
            [SVProgressHUD showErrorWithStatus:@"您未开启定位"];
        }
    }
    return self;
}

/**
 尚未获取到城市列表时不能开启定位
 */
-(void)openLoaction
{
    [self openLocation];
}

#pragma mark------定位功能
-(void)openLocation
{
    m_sqlite = [[CSqlite alloc]init];
    [m_sqlite openSqlite];
    
    if([CLLocationManager locationServicesEnabled])
    {
        [SVProgressHUD showWithStatus:@"定位城市" ];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter=0.5;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation]; // 开始定位
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [locationManager requestAlwaysAuthorization];
        }
    }
}
#define x_pi              (3.14159265358979324 * 3000.0 / 180.0)
#pragma mark------转换坐标
-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    //NSLog(sql);
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
    }
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
}
#pragma mark------定位delegate
// 定位成功时调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"定位成功");
    [SVProgressHUD dismiss];
    if (is_location) {
        [locationManager stopUpdatingLocation]; // 关闭定位
        [NSThread sleepForTimeInterval:1];
        CLLocationCoordinate2D mylocation = newLocation.coordinate;//手机GPS
        NSString *u_lat = [[NSString alloc]initWithFormat:@"%lf",mylocation.latitude];
        NSString *u_lng = [[NSString alloc]initWithFormat:@"%lf",mylocation.longitude];
        NSLog(@"未经过转换的经纬度是%@---%@",u_lat,u_lng);
        //获取列表
        CLLocation *location = [[CLLocation alloc] initWithLatitude:mylocation.latitude longitude:mylocation.longitude];
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error)
         {
             CLPlacemark *mark=[placemark objectAtIndex:0];
             //         NSString *title = [NSString stringWithFormat:@"%@",mark.name];//获取subtitle的信息;
             //         NSString *subTitle = [NSString stringWithFormat:@"%@%@%@",mark.subLocality,mark.thoroughfare,mark.subThoroughfare];
             //
             locationCity=mark.locality;
             
             //停止转动并且将城市名称显示到按钮上
             [self.indicatorView stopAnimating];
             [self.homeSelectedCityDescView setTitle:mark.locality forState:UIControlStateNormal];
             [self.homeSelectedCityDescView setUserInteractionEnabled:YES];
             NSLog(@"城市名称:%@",mark.locality);
             [SVProgressHUD dismiss];
             /*!
              *  @author Sky
              *
              *  @brief  通过代理方法来确定是否可点击
              */
             if (is_location) {
                 if ([self.delegate respondsToSelector:@selector(homeSelectedCityHeaderView:cityName:cityID:)]) {
                     [self.delegate homeSelectedCityHeaderView:self cityName:mark.locality cityID:self.cityID];
                 }
             }
             [locationManager stopUpdatingLocation]; // 关闭定位
         } ];
    }
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [locationManager stopUpdatingLocation]; // 关闭定位
    NSLog(@"定位失败");
    [SVProgressHUD dismiss];
    //获取列表
    //停止转动并且将城市名称显示到按钮上
    [self.indicatorView stopAnimating];
    [self.homeSelectedCityDescView setTitle:@"未获取" forState:UIControlStateNormal];
    [self.homeSelectedCityDescView setUserInteractionEnabled:NO];
}

/**
 *  关闭定位
 */
-(void)stopLocation
{
    [locationManager stopUpdatingLocation]; // 关闭定位
    is_location = NO;
}

/**
 *  添加控件
 */
- (void) addUI {
    [self addSubview:self.homeSelectedCityDescView];
    [self addSubview:self.homeSelectedCityTitleView];
    [self.homeSelectedCityDescView addSubview:self.indicatorView];
}


/**
 *  重写 城市名称 的数据方法 设置 数据 和 控件的布局
 *
 *  @param currentCityName
 */
- (void)setCurrentCityName:(NSString *)currentCityName {
    _currentCityName = currentCityName;
    [self settingData];
    [self settingUIAutoLayout];
}

/**
 *  设置数据
 */
- (void) settingData  {
    
    [self.homeSelectedCityDescView setTitle:self.currentCityName forState:UIControlStateNormal];
    [self.homeSelectedCityDescView setTitle:self.currentCityName forState:UIControlStateHighlighted];
    self.homeSelectedCityTitleView.text = @"当前定位城市";
}


/**
 *  设置控件的布局
 */
- (void) settingUIAutoLayout {
    
    
    [self.homeSelectedCityDescView autoPinEdgeToSuperviewEdge:ALEdgeTop       withInset:5];
    [self.homeSelectedCityDescView autoPinEdgeToSuperviewEdge:ALEdgeBottom    withInset:5];
    [self.homeSelectedCityDescView autoPinEdgeToSuperviewEdge:ALEdgeRight    withInset:20];
    [self.homeSelectedCityDescView autoSetDimension:ALDimensionWidth toSize:60];
    
    
    [self.homeSelectedCityTitleView autoPinEdgeToSuperviewEdge:ALEdgeTop    withInset:5];
    [self.homeSelectedCityTitleView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [self.homeSelectedCityTitleView autoPinEdgeToSuperviewEdge:ALEdgeLeft   withInset:20];
    [self.homeSelectedCityTitleView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.homeSelectedCityDescView withOffset:-10];
    
    
    [self.indicatorView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.indicatorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.indicatorView autoSetDimensionsToSize:CGSizeMake(20, 20)];
    

}

#pragma mark ----- 初始化UI控件
- (UILabel *)homeSelectedCityTitleView {
    
    if (!_homeSelectedCityTitleView) {
        _homeSelectedCityTitleView = [[UILabel alloc] initForAutoLayout];
        _homeSelectedCityTitleView.font = [UIFont systemFontOfSize:12];
        
    }
    return _homeSelectedCityTitleView;
}

- (UIButton *)homeSelectedCityDescView {
    
    if (!_homeSelectedCityDescView) {
        _homeSelectedCityDescView = [[UIButton alloc] initForAutoLayout];
        [_homeSelectedCityDescView settingSubmitButton:_homeSelectedCityDescView backgroundColor:[UIColor whiteColor] setTitle:@"" fontSize:12 fontColor:[UIColor grayColor] target:self action:@selector(clickButton:) buttonTag:0];
        
        _homeSelectedCityDescView.layer.borderWidth=1.f;
        _homeSelectedCityDescView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _homeSelectedCityDescView.layer.cornerRadius=5.f;
        
        _homeSelectedCityDescView.userInteractionEnabled=NO;

    }
    return _homeSelectedCityDescView;
}

-(UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
        
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}


#pragma mark ----- HomeSelectedCityHeaderViewDelegate
/**
 *  点击定位当前城市绑定方法
 *
 *  @param button
 */
- (void) clickButton:(UIButton *)button {
    
//    if ([self.delegate respondsToSelector:@selector(homeSelectedCityHeaderView:cityName:cityID:)]) {
//        [self.delegate homeSelectedCityHeaderView:self cityName:self.currentCityName cityID:self.cityID];
//    }
    [self.delegate clickButtonPopController];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
