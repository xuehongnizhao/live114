//
//  ORAShopMapsViewController.m
//  Orange
//
//  Created by mac on 14-2-10.
//  Copyright (c) 2014年 Youdro. All rights reserved.
//

#import "ORAShopMapsViewController.h"
#import "UIImageView+WebCache.h"
//#import "AppDelegate.h"
#import "UZCommonMethod.h"
#import "Annotaion.h"
#import "JPSThumbnailAnnotation.h"
//#import "EnjoyOneShopViewController.h"
#import "DLStarRatingControl.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
//#import "TuanGouInfo.h"
#import  "ShopListInfo.h"
#import "ShopDetailViewController.h"

#define x_pi   (3.14159265358979324 * 3000.0 / 180.0)
#define IPHONE5 															\
([UIScreen instancesRespondToSelector:@selector(currentMode)] ?             \
CGSizeEqualToSize(CGSizeMake(640, 1136),                                    \
[[UIScreen mainScreen] currentMode].size) : NO)                             \

static NSString *pageCount = @"10";

@interface ORAShopMapsViewController ()<MKMapViewDelegate>
{
    NSMutableArray *shopArray;
    int page;
    double baidu_lat;
    double baidu_lng;
    BOOL is_hiden;
}
//UI
@property (strong, nonatomic) MKMapView *mapView;
//@property (weak, nonatomic) IBOutlet MKMapView   *mapView;
@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIView *shopPanel;
@property (strong, nonatomic) UIView *thumbView;
@property (strong, nonatomic) UIImageView *thumbImageView;
@property (strong, nonatomic) UILabel *shopNameLabel;
@property (strong, nonatomic) UIImageView *pointsImageView;
@property (strong, nonatomic) UILabel *distanceLabel;

//@property (weak, nonatomic) IBOutlet UIView      *shopPanel;        /*!< 弹出的详情面板*/
//@property (weak, nonatomic) IBOutlet UIView      *thumbView;        /*!< 面板中，缩略图背景 */
//@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;   /*!< 面板中，缩略图 */
//@property (weak, nonatomic) IBOutlet UILabel     *shopNameLabel;    /*!< 面板中，商家名称 */
//@property (weak, nonatomic) IBOutlet UIImageView *pointsImageView;  /*!< 面板中，积分图 */
//@property (weak, nonatomic) IBOutlet UILabel     *distanceLabel;    /*!< 面板中，距离 */
@property (strong, nonatomic) UIButton *myLocationButton;
//@property (weak, nonatomic) IBOutlet UIButton    *myLocationButton;
//以下为地图中的操作面板
@property (strong, nonatomic) UIView *operationView;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic) UIView *myLevel;
//@property (weak, nonatomic) IBOutlet UIView      *operationView;
//@property (weak, nonatomic) IBOutlet UIButton    *leftButton;
//@property (weak, nonatomic) IBOutlet UIButton    *rightButton;
//@property (weak, nonatomic) IBOutlet UILabel     *descriptionLabel;
//@property (weak, nonatomic) IBOutlet UIView *level;
//@property (weak, nonatomic) IBOutlet UIView *myLevel;

// DATA
//用于存放从网络中获取的商家信息
@property (strong, nonatomic) NSArray *shops;
/*!< 地图中注释的数据 */
@property (strong, nonatomic) NSArray *annotations;                 /*!< 地图中注释的数据 */

// SUPPORT
@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) UITapGestureRecognizer *tapGes;       /*!< 单击手势对象 */

@end

@implementation ORAShopMapsViewController
@synthesize myLocation;
@synthesize identifer;
@synthesize url;
@synthesize myData;
@synthesize count;
- (UIView *)coverView
{
    if (!_coverView) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        _coverView = [[UIView alloc] initWithFrame:frame];
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    return _coverView;
}

- (NSString*)fuckNULL:(NSObject*)obj;
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]]){
        return @"";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    }else{
        return [NSString stringWithFormat:@"%@",obj];
    }
}

-(NSString*)getId:(NSDictionary *)dic
{
    return [self fuckNULL:dic[@"id"]];
}

-(NSString*)getPic:(NSDictionary *)dic
{
    
    return [self fuckNULL:dic[@"pic"]];
    
}

-(NSString*)getName:(NSDictionary *)dic
{
    return [self fuckNULL:dic[@"name"]];
}

-(NSString*)getDistance:(NSDictionary *)dic
{
    return  [self fuckNULL:dic[@"distance"]];
}

-(NSString*)getScore:(NSDictionary *)dic
{
    return  [self fuckNULL:dic[@"score"]];
}

-(NSString*)getLat:(NSDictionary *)dic
{
    return  [self fuckNULL:dic[@"lat"]];
}

-(NSString*)getLng:(NSDictionary *)dic
{
    return  [self fuckNULL:dic[@"lng"]];
}

//该方法作用是在商家信息面板中画评价积分
- (void)setupStartsWithFrame:(CGRect)frame
                      rating:(NSInteger)rating
             fractionalOrNot:(BOOL)fracional
                  andEnabled:(BOOL)enabled
{
    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:frame
                                                                                 andStars:5
                                                                             isFractional:fracional];
    customNumberOfStars.userInteractionEnabled = enabled;
    customNumberOfStars.backgroundColor = [UIColor clearColor];
    customNumberOfStars.rating = rating;//可以设置星星数量。。 0.5- 5.0
    [_myLevel addSubview:customNumberOfStars];
}

#pragma mark - Functions

- (void)removeTheCoverView
{
    [self.coverView removeFromSuperview];
}
//设置商家pane中显示的值
- (void)settingShopPane:(NSDictionary *)dic
{
    self.shopPanel.layer.borderColor = UIColorFromRGB(0xe1e0de).CGColor;
    self.shopPanel.layer.borderWidth = 0.3;
    self.shopNameLabel.layer.masksToBounds = YES;
    self.shopNameLabel.layer.cornerRadius = 4.0f;
    NSString *imageURLStr = [NSString stringWithFormat:@"%@",[self getPic:dic]];
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholderImage:nil];
    self.shopNameLabel.text = [self getName:dic];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@m",[self getDistance:dic]] ;
    //NSInteger starNumber = [[self getScore:dic] integerValue] ;
    //[self setStar:[self getScore:dic] ];
    //CGRect frame = CGRectMake(0, 0, self.myLevel.frame.size.width, self.myLevel.frame.size.height);
    //[self setupStartsWithFrame:frame rating:starNumber fractionalOrNot:YES andEnabled:NO];
}
//设置星星
-(void)setStar :(NSString*)score
{
    //判断星星数量
    int scores = [score floatValue]*2;
    for (int n=0; n<5; n++) {
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(19*n,3, 15, 15);
        NSString *starName;
        //判断每一颗星星
        if (scores>(n+1)*2) {
            //有星星
            starName = @"home_allstar";
        }else{
            //判断没有星星 还是半颗星星
            if (scores == (n+1)*2-1) {
                //半颗星星
                starName = @"home_starhalf";
            }else{
                //没有星星
                starName = @"home_star";
            }
        }
        [imageview setImage:[UIImage imageNamed:starName]];
        [self.myLevel addSubview:imageview];
    }
}

//设置用户操作view中的数据值
- (void)settingOperationView
{
    NSInteger beginPage = (page-1) * [pageCount integerValue] + 1;
    NSInteger endPage = beginPage + 9;
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"第%ld-%ld家",beginPage,endPage];
    
    if (page <= 1) {
        [self.leftButton setEnabled:NO];
    }else{
        [self.leftButton setEnabled:YES];
    }
    
    if (self.annotations.count < [pageCount integerValue]) {
        [self.rightButton setEnabled:NO];
    }else{
        [self.rightButton setEnabled:YES];
    }
}
//显示商家信息pane
- (void)showShopPane:(NSInteger)shopID
{
    self.shopPanel.hidden = NO;
    [self addGesture:self.shopPanel];
    
    self.shopPanel.tag = shopID;
    ShopListInfo *info = self.shops[shopID];
    //self.thumbView.layer.borderColor = [Color(184, 184, 184, 1.0) CGColor];
    self.thumbView.layer.borderWidth = 0.3;
    NSString *imageURLStr = info.shop_pic;
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholderImage:nil];
    self.shopNameLabel.text = info.shop_name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",info.distace];
    NSLog(@"%@m",self.distanceLabel.text);
    NSLog(@"%@",self.shopNameLabel.text);
    //NSInteger score = [[self getScore:dic] integerValue] / 2;
    [self setStar:info.score ];
    //    CGRect frame = CGRectMake(0, 0, self.myLevel.frame.size.width, self.myLevel.frame.size.height);
    //    [self setupStartsWithFrame:frame rating:score fractionalOrNot:YES andEnabled:NO];
}
//隐藏商家信息pane
- (void)hiddenShopPane:(NSInteger)shopID
{
    self.shopPanel.hidden = YES;
    [self.shopPanel removeGestureRecognizer:self.tapGes];
}
//给pane添加点击事件方法
- (void)addGesture:(UIView *)view
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(gotoShop:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    self.tapGes = tapGes;
    [view addGestureRecognizer:tapGes];
}
//获取用户当前位置
- (void)getMyLocation
{
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(self.myLocation.coordinate,
                                                       MKCoordinateSpanMake(zoomLevel, zoomLevel));
    
    //    //坐标的转换
    //    double latitude = self.myLocation.coordinate.latitude ;
    //    double longtitude = self.myLocation.coordinate.longitude;
    //    double baiDuLat , baiDuLng;
    //    double x = longtitude, y = latitude;
    //    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    //    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    //    baiDuLng = z * cos(theta) + 0.0065;
    //    baiDuLat = z * sin(theta) + 0.006;
    //CLLocationCoordinate2D *tempLocation ;
    //    NSLog(@"我的经纬度是 ---------%f-----------%f",latitude,longtitude);
    region.center = self.myLocation.location.coordinate;
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:NO];
    [self removeTheCoverView];
    [SVProgressHUD dismiss];
}

/**
 *	@brief	生成新样式的标注点,依赖第三方库JPSThumbnail
 *
 *	@return	返回标注点数组
 */
- (NSArray *)generateAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:3];
    
    int i = 0;
    for (ShopListInfo *info in self.shops) {
        
        JPSThumbnail *oneThumbnail = [[JPSThumbnail alloc] init];
        NSString *imageURL = info.shop_pic;
        oneThumbnail.image = imageURL;
        CGFloat latitude = [info.shop_lat floatValue];
        CGFloat longtitude = [info.shop_lng floatValue];
        //百度坐标系转换为火星坐标系
        double x = longtitude - 0.0065, y = latitude - 0.006;
        double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
        double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
        longtitude = z * cos(theta);
        latitude = z * sin(theta);
        oneThumbnail.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
        JPSThumbnailAnnotation *annotation = [[JPSThumbnailAnnotation alloc] initWithThumbnail:oneThumbnail];
        annotation.tag = i++;
        [annotations addObject:annotation];
    }
    self.annotations = annotations;
    NSLog(@"the anotations is %@",self.annotations);
    
    return annotations;
}

#pragma mark Net work

/**
 *	@brief	根据当前位置，请求到附近的商铺信息.请求成功后更新界面上的数据Ω
 */
- (void)getLocationsFromNetwork :(double)lng :(double)lat
{
    //暂时被废弃了
}

#pragma mark - Actions
//点击pane跳转至商家商品列表界面
- (IBAction)gotoShop:(id)sender
{
    
    UIView *view = [sender view];
    ShopListInfo *info = self.shops[view.tag];
    ShopDetailViewController *firVC = [[ShopDetailViewController alloc] init];
    [firVC setNavBarTitle:@"如e商家" withFont:14.0f];
    [firVC setHiddenTabbar:YES];
    firVC.info = info;
    firVC.shop_id = info.shop_id;
    [self.navigationController pushViewController:firVC animated:YES];
}

- (IBAction)gotoMyLocation:(UIButton *)sender
{
    [self getMyLocation];
}

//地图商家翻页---前一页
- (IBAction)prevPageAction:(UIButton *)sender
{
    if (page>1) {
        page --;
        [self getLocationsFromNetwork:baidu_lng :baidu_lat];
    }
    [self settingOperationView];
}

//地图商家翻页---下一页
- (IBAction)nextPageAction:(UIButton *)sender
{
    if (self.annotations.count < [pageCount integerValue]) {
        [self.rightButton setEnabled:NO];
    }else{
        page ++;
        [self settingOperationView];
        [self getLocationsFromNetwork:baidu_lng :baidu_lat];
    }
}

#pragma mark - Map view delegate
//定位用户代理方法
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    if (!self.myLocation) {
        [SVProgressHUD showWithStatus:@"定位您的位置..."];
    }
}
//更新用户信息代理方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.myLocation) {
        [SVProgressHUD showWithStatus:@"定位门店位置..."];
        self.myLocation = userLocation;
        double latitude = self.myLocation.location.coordinate.latitude;
        double longitude = self.myLocation.location.coordinate.longitude;
        //转换百度坐标获取位置
        double lat = latitude;
        double lng = longitude;
        double baiDuLat , baiDuLng;
        double x = lng, y = lat;
        double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
        double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
        baiDuLng = z * cos(theta) + 0.0065;
        baiDuLat = z * sin(theta) + 0.006;
        baidu_lng = baiDuLng;
        baidu_lat = baiDuLat;
        if (latitude !=0 && longitude!=0) {
            [self getMyLocation];
            [self getLocationsFromNetwork:baiDuLng :baiDuLat];
        }
    }
}
//地图中显示商家信息代理方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}
//标注点点击处理事件
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        JPSThumbnailAnnotationView *thumbnailView = (JPSThumbnailAnnotationView *)view;
        
        //[thumbnailView setImage:[UIImage imageNamed:@"store_map_smallimg_sel.png"]];
        [thumbnailView setColor:@"1"];
        NSInteger tag = thumbnailView.tag;
        [self showShopPane:tag];
        is_hiden = NO;
    }
}

//释放点击地图标注点按钮
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (is_hiden == NO) {
        JPSThumbnailAnnotationView *thumbnailView = (JPSThumbnailAnnotationView *)view;
        [thumbnailView setColor:@"2"];
        [self hiddenShopPane:0];
        is_hiden = YES;
    }
    //    mapView.centerCoordinate.latitude;
    //    mapView.centerCoordinate.longitude;
}

/**
 计算zoom级别
 */
#define MERCATOR_RADIUS 85445659.44705395
- (int)getZoomLevel:(MKMapView*)linMapView {
    return 21-round(log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * linMapView.bounds.size.width)));
}

//我们可以写一个MKMapView的委托方法打印出zoom level
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if ([self.shops count]>0) {
        NSLog(@"zoom level %d", [self getZoomLevel:mapView]);
        NSLog(@"the late and the lng is %f and %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
        NSLog(@"the distance is %f",[Base64Tool LantitudeLongitudeDist:baidu_lng other_Lat:baidu_lat self_Lon:mapView.centerCoordinate.longitude self_Lat:mapView.centerCoordinate.latitude]);
        if ([Base64Tool LantitudeLongitudeDist:baidu_lng other_Lat:baidu_lat self_Lon:mapView.centerCoordinate.longitude self_Lat:mapView.centerCoordinate.latitude]>1000) {
            baidu_lat = mapView.centerCoordinate.latitude;
            baidu_lng = mapView.centerCoordinate.longitude;
            [self getShopList:baidu_lat lng:baidu_lng];
        }
    }else{
        //当前位置未搜索出任何商家时候 变换位置走接口
        baidu_lat = mapView.centerCoordinate.latitude;
        baidu_lng = mapView.centerCoordinate.longitude;
        [self getShopList:baidu_lat lng:baidu_lng];
    }
}

/**
 获取商家列表
 */
-(void)getShopList:(float)lat lng:(float)lng
{
    NSString *tmp_url  = connect_url(@"shop_list");
    //    NSDictionary *dict = @{
    //                           @"app_key":tmp_url,
    //                           @"lat":[NSString stringWithFormat:@"%f",lat],
    //                           @"lng":[NSString stringWithFormat:@"%f",lng],
    //                           @"zoom":[NSString stringWithFormat:@"%d",[self getZoomLevel:_mapView]]
    //                           };
    [Base64Tool postSomethingToServe:tmp_url andParams:_shopListDic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            shopArray = [[NSMutableArray alloc] init];
            //封装数据
            NSArray *arr = [param objectForKey:@"obj"];
            for (NSDictionary *dict in arr) {
                ShopListInfo *info = [[ShopListInfo alloc] initWithDictionary:dict];
                [shopArray addObject:info];
            }
            self.shops = shopArray;
            [self.mapView removeAnnotations:self.annotations];
            [self.mapView addAnnotations:[self generateAnnotations]];
            [self settingOperationView];
            [self.mapView reloadInputViews];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 1;
    baidu_lat = 0.0;
    baidu_lng = 0.0;
    is_hiden = YES;
    [self setUI];
    self.shopPanel.hidden = YES;
    [self.view insertSubview:self.coverView aboveSubview:self.mapView];
}

-(void)setUI
{
    [self.view addSubview:self.mapView];
    [_mapView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_mapView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_mapView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_mapView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    _mapView.showsUserLocation=YES;
    _mapView.userTrackingMode = MKUserTrackingModeNone;
    //设置操作面板
    [self.view addSubview:self.shopPanel];
    [_shopPanel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3.0f];
    [_shopPanel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_shopPanel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_shopPanel autoSetDimension:ALDimensionHeight toSize:80.0f];
    //------商家信息显示-------
    [_shopPanel addSubview:self.thumbView];
    [_thumbView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_thumbView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
    [_thumbView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
    [_thumbView autoSetDimension:ALDimensionWidth toSize:70.0f];
    [_thumbView addSubview:self.thumbImageView];
    [_thumbImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2.0f];
    [_thumbImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2.0f];
    [_thumbImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.0f];
    [_thumbImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2.0f];
    //-----name----
    [_shopPanel addSubview:self.shopNameLabel];
    [_shopNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
    [_shopNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [_shopNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_thumbView withOffset:5.0f];
    [_shopNameLabel autoSetDimension:ALDimensionHeight toSize:18.0f];
    //-----评价-------
    [_shopPanel addSubview:self.myLevel];
    [_myLevel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_thumbView withOffset:5.0f];
    [_myLevel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopNameLabel withOffset:3.0f];
    [_myLevel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_myLevel autoSetDimension:ALDimensionHeight toSize:20.0f];
    //距离
    UIImageView *iconImage = [[UIImageView alloc] initForAutoLayout];
    [_shopPanel addSubview:iconImage];
    [iconImage setImage:[UIImage imageNamed:@"city_mapicon"]];
    [iconImage autoSetDimension:ALDimensionHeight toSize:15.0f];
    [iconImage autoSetDimension:ALDimensionWidth toSize:15.0f];
    [iconImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_thumbView withOffset:5.0f];
    [iconImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_myLevel withOffset:5.0f];
    
    [_shopPanel addSubview:self.distanceLabel];
    [_distanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImage withOffset:5.0f];
    [_distanceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_myLevel withOffset:5.0f];
    [_distanceLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_distanceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    
    //-----点击光标----------
    UIImageView *clickImage = [[UIImageView alloc] initForAutoLayout];
    [_shopPanel addSubview:clickImage];
    [clickImage setImage:[UIImage imageNamed:@"more_details"]];
    [clickImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [clickImage autoSetDimension:ALDimensionHeight toSize:15.0f];
    [clickImage autoSetDimension:ALDimensionWidth toSize:15.0f];
    [clickImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30.0f];
    
    //------operation view-------
    [self.view addSubview:self.operationView];
    [_operationView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.5f];
    [_operationView autoPinEdgeToSuperviewEdge:ALEdgeLeft  withInset:5.5f];
    [_operationView autoSetDimension:ALDimensionWidth toSize:40.0f];
    [_operationView autoSetDimension:ALDimensionHeight toSize:40.0f];
}
#pragma mark---------click action
-(void)clickAction :(UIButton*)sender
{
    
}
#pragma mark--------get UI
-(UIView *)operationView
{
    if (!_operationView) {
        _operationView = [[UIView alloc] initForAutoLayout];
        _operationView.backgroundColor = [UIColor whiteColor];
        _operationView.layer.borderWidth = 1;
        _operationView.layer.borderColor = UIColorFromRGB(0xd5d4d3).CGColor;
        //添加buttons and lable
        [_operationView addSubview:self.myLocationButton];
        [_myLocationButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:7.5f];
        [_myLocationButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.5f];
        [_myLocationButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7.5f];
        [_myLocationButton autoSetDimension:ALDimensionWidth toSize:25.0f];
        
    }
    return _operationView;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initForAutoLayout];
        [_leftButton setImage:[UIImage imageNamed:@"shop_mapleftarrow"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"shop_mapleftarrow"] forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(prevPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initForAutoLayout];
        [_rightButton setImage:[UIImage imageNamed:@"shop_maprightarrow"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"shop_maprightarrow"] forState:UIControlStateHighlighted];
        [_rightButton addTarget:self action:@selector(nextPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(UIButton *)myLocationButton
{
    if (!_myLocationButton) {
        _myLocationButton = [[UIButton alloc] initForAutoLayout];
        [_myLocationButton setImage:[UIImage imageNamed:@"city_mapicon"] forState:UIControlStateNormal];
        [_myLocationButton setImage:[UIImage imageNamed:@"city_mapicon"] forState:UIControlStateHighlighted];
        [_myLocationButton addTarget:self action:@selector(gotoMyLocation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myLocationButton;
}

-(UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initForAutoLayout];
        _descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = UIColorFromRGB(singleTitle);
        _descriptionLabel.text = @"正在搜索商家";
    }
    return _descriptionLabel;
}

-(UIView *)shopPanel
{
    if (!_shopPanel) {
        _shopPanel = [[UIView alloc] initForAutoLayout];
        _shopPanel.layer.borderWidth = 1;
        _shopPanel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _shopPanel.backgroundColor = [UIColor whiteColor];
    }
    return _shopPanel;
}

-(UIView *)thumbView
{
    if (!_thumbView) {
        _thumbView = [[UIView alloc] initForAutoLayout];
    }
    return _thumbView;
}

-(UIImageView *)thumbImageView
{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] initForAutoLayout];
    }
    return _thumbImageView;
}

-(UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] initForAutoLayout];
        _shopNameLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _shopNameLabel;
}

-(UIView *)myLevel
{
    if (!_myLevel) {
        _myLevel = [[UIView alloc] initForAutoLayout];
        //_myLevel.layer.borderWidth = 1;
    }
    return _myLevel;
}

-(UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initForAutoLayout];
        _distanceLabel.font = [UIFont systemFontOfSize:12.0f];
        _distanceLabel.textColor = UIColorFromRGB(0xa6a6a6);
    }
    return _distanceLabel;
}

-(MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initForAutoLayout];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)viewDidAppear:(BOOL)animated
{
    //    self.mapView.showsUserLocation = YES;
    //    self.mapView.userTrackingMode = MKUserTrackingModeNone;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.mapView = nil;
    [SVProgressHUD dismiss];
    self.mapView.showsUserLocation = NO;
}

- (void)dealloc
{
    self.mapView = nil;
    self.shops = nil;
    self.annotations = nil;
    self.myLocation = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)changePositions
{
    if (IPHONE5 == NO) {
        CGRect rect = self.myLocationButton.frame;
        rect.origin.y = 420;
        self.myLocationButton.frame = rect;
        
        CGRect viewRect = self.operationView.frame;
        viewRect.origin.y = 420 ;
        self.operationView.frame = viewRect;
    }
}

-(void)viewDidLayoutSubviews
{
    //[self changePositions];
}
@end
