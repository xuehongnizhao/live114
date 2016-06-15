//
//  HomeViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "HomeViewController.h"
#import "HomeNavigationView.h"
#import "UIScrollView+MJRefresh.h"
#import "AdBannerView.h"
#import "SLCoverFlowView.h"
#import "SLCoverView.h"
//解析类
#import "cateModel.h"
#import "littleCateModel.h"
#import "slideModel.h"
//分类button
#import "cateButton.h"
#import "littleCateButton.h"
#import "shopInfo.h"
//cell
#import "IndexTableViewCell.h"
#import "CommendView.h"
//just test
#import "LoginViewController.h"
#import "CSqlite.h"
#import "CarouselInfo.h"
//messge
#import "MessageViewController.h"
#import "ShopTakeoutListViewController.h"
#import "UserReviewViewController.h"
#import "LocationListViewController.h"
#import "CouponListViewController.h"
#import "ActivityListViewController.h"
#import "OrderSeatViewController.h"
#import "orderRoomListViewController.h"
#import "GroupListViewController.h"
#import "UZGuideViewController.h"
#import "ShopDetailViewController.h"
#import "ShopListViewController.h"
#import "SearchViewController.h"
//幻灯片跳转类
#import "GroupDetailViewController.h"
#import "ShopTakeOutViewController.h"
#import "CouponDetailViewController.h"
#import "orderSeatDetailViewController.h"
#import "orderRoomDetailViewController.h"
#import "ZQFunctionWebController.h"

//城市选择
#import "HomeSelectedCityViewController.h"
#import "CityModule.h"

//服务分类模型和行业分类模型
#import "linHangyeModel.h"
#import "linServicemodel.h"
#import "linHangyeButtonView.h"
#import "linHangyeCommendView.h"
#import "SkyServerCenterView.h"
#import "MJExtension.h"
#import "ccDisplayModel.h"
//--------新添加分类跳转web-----
#import "ZQFunctionWebController.h"
//新轮播
#import "SkyBannerView.h"
//行业专区 View
#import "IndustryZoneView.h"

#import "AppUpdatesController.h" // 更新APP web页
#define AppVersion @"AppVersion" //APP版本号

@interface HomeViewController ()<UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate,
SLCoverFlowViewDataSource,
AdBannerViewDelegate,
littleCateDelegate,
CommendViewDelegate,
CLLocationManagerDelegate,
GoSearchDelegate,
HomeSelectedCityViewControllerDelegate,
SkyServerCenterViewDelegate,
linHangyeCommendViewDelegate>
{
    UIButton *_messageButton;//暂时被废弃
    UIButton *_appNameButton;//暂时被废弃
    
    
    AdBannerView *_adBannerView;//轮播
    
    //    UIView *_shopListView;
    UIImageView *hintImage;
    //获取的首页数据
    NSMutableDictionary *indexDic;
    NSMutableArray *slideArray;//幻灯片数组
    NSMutableArray *cateArray;//六个大分类数组
    NSMutableArray *littleCateArray;//分页小分类数组
    NSMutableArray *urlArray;//轮播图片数组
    NSMutableArray *descArray;//轮播描述数组
    NSMutableArray *billboardsArray;//中部广告轮播数组
    NSMutableArray *descBillboardsArray;//中部广告描述数组
    NSMutableArray *industryArray;//中介model数组
    NSMutableArray *shopArray;//商家推荐数组
    NSMutableDictionary *fullScreenDict;//全屏广告字典
    NSString *moreDisplayUrl;//商品展示 更多按钮连接的URL
    int page;//首页分页
    //-----使用开启定位------------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    NSString *baidu_lat;
    NSString *baidu_lng;
    NSMutableArray *CarouseArray;//幻灯片 数组？
    HomeNavigationView *navigationView;
}
@property (strong,nonatomic)UIView *shopListView;//商家列表view
@property (strong,nonatomic)CommendView *faceView;//滑动页 分类多页按钮
@property (strong,nonatomic)UITableView *indexTableview;//主页tableview
@property (strong,nonatomic)UIView *cateView;//六个分类按钮
@property (strong,nonatomic)UIScrollView *myScrollView;//轮播
@property (strong,nonatomic)UIView   * serverView;//服务view
@property (strong,nonatomic)IndustryZoneView   * industryView;//行业View
@property (nonatomic, strong) UIView * commodityDisplayView;//商品展示View
@property (nonatomic, strong) UIView * billboardsView;

@property (strong ,nonatomic) UIImageView * advertisementImgView;//
//首页全屏广告持续时间
@property (nonatomic, strong) NSTimer     * timer;
@property (nonatomic, strong) UIImageView * fullScreenImage; //全屏imageView
@property (nonatomic)         BOOL      showAdvertising;    //是否展示全屏广告
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置引导页
    self.showAdvertising = YES;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:everLaunch]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:everLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UZGuideViewController show];
        self.showAdvertising = NO;
    }
    // Do any additional setup after loading the view.
    [self initData];
    //获取当前网络状况
    [self getTheWebCon];
    [self setNavigationBar];
    
    //做数据处理
    [self setUI];
    [self openLocation];
    [self getDataFromNet];//获取网络数据
}


//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnLexiangHint:) name:NOTIFICATION_RIGHT_NEW_MESSAGE object:nil];
/*
 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ROOT_NEW_MESSAGE object:msg];
 */

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置进入城市选择
    if (![[NSUserDefaults standardUserDefaults] boolForKey:isShowCityChose]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isShowCityChose];
        [[NSUserDefaults standardUserDefaults] synchronize];
        HomeSelectedCityViewController* hvc=[[HomeSelectedCityViewController alloc]init];
        hvc.isFirstShow=YES;
        hvc.delegate = self;
        [self.navigationController pushViewController:hvc animated:YES];
    }
    
    if (self.showAdvertising) {
        if (!self.fullScreenImage) {
            self.fullScreenImage = [[UIImageView alloc] initWithFrame:self.view.window.bounds];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            
            button.frame = CGRectMake(SCREEN_WIDTH - 80, 40, 60, 30);
            
            button.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [button setTitle:@"跳 过" forState:UIControlStateNormal];
            
            button.layer.cornerRadius   =   5;
            
            [button addTarget:self action:@selector(removeFullScreen) forControlEvents:UIControlEventTouchUpInside];
            
            [self.fullScreenImage addSubview:button];
            
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoFullScreen)];
            [self.fullScreenImage addGestureRecognizer:gesture];
            self.fullScreenImage.userInteractionEnabled = YES;
            [self getfullScreenFromNet];//本地可能存储 从网络获取后 刷新页面
        }
    }else{
        self.showAdvertising = YES;
    }
}

- (void) removeFullScreen {
    [self delayMethod];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)delayMethod { //隐藏广告
    self.fullScreenImage.hidden = YES;
    // 检查APP更新
    [self checkVersion];
}
//点击全屏广告
- (void) gotoFullScreen {
    self.fullScreenImage.hidden = YES;
    ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
    firVC.url = fullScreenDict[@"a_url"];
    firVC.title = @"详情";
    [self.navigationController pushViewController:firVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHiddenTabbar:NO];
    [[HomeNavigationView shareInstance] setlogoButtonEnabel];
}

#pragma mark-----------收到通知
- (void)UnLexiangHint:(NSNotification*)notification
{
    NSLog(@"NOTIFICATION_RIGHT_NEW_MESSAGE");
    [self addRightHint];
}

/**
 这个添加提醒暂时不用
 现在navigation里面的button按钮
 全部在HomeNavigationView里面添加
 */
#pragma mark------添加右侧信息提醒
-(void)addRightHint
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"RIGHTHINT"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    hintImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    [hintImage setBackgroundColor:[UIColor redColor]];
    [[self messageButton] addSubview:hintImage];
}

#pragma mark-------移除提醒添加
-(void)removeHint
{
    if ([userDefault(@"RIGHTHINT") isEqualToString:@"YES"]) {
        [hintImage removeFromSuperview];
    }
}

#pragma mark------定位功能
-(void)openLocation
{
    m_sqlite = [[CSqlite alloc]init];
    [m_sqlite openSqlite];
    
    if([CLLocationManager locationServicesEnabled])
    {
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

#define x_pi (3.14159265358979324 * 3000.0 / 180.0)
#pragma mark------转换坐标
-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    // NSLog(sql);
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
    }
    yGps.latitude = yGps.latitude + offLat*0.0001;
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
    CLLocationCoordinate2D mylocation = newLocation.coordinate;//手机GPS
    NSString *u_lat = [[NSString alloc]initWithFormat:@"%lf",mylocation.latitude];
    NSString *u_lng = [[NSString alloc]initWithFormat:@"%lf",mylocation.longitude];
    NSLog(@"未经过转换的经纬度是%@---%@",u_lat,u_lng);
    mylocation = [self zzTransGPS:mylocation];
    baidu_lat = [[NSString alloc]initWithFormat:@"%lf",mylocation.latitude];
    baidu_lng = [[NSString alloc]initWithFormat:@"%lf",mylocation.longitude];
    double lat = [baidu_lat floatValue];
    double lng = [baidu_lng floatValue];
    double baiDuLat , baiDuLng;
    double x = lng, y = lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    baiDuLng = z * cos(theta) + 0.0065;
    baiDuLat = z * sin(theta) + 0.006;
    baidu_lat = [NSString stringWithFormat:@"%f",baiDuLat];
    baidu_lng = [NSString stringWithFormat:@"%f",baiDuLng];
    [locationManager stopUpdatingLocation]; // 关闭定位
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"定位失败");
}

#pragma mark------初始化数据
-(void)initData
{
    slideArray      = [[NSMutableArray alloc] init];
    cateArray       = [[NSMutableArray alloc] init];
    littleCateArray = [[NSMutableArray alloc] init];
    urlArray        = [[NSMutableArray alloc] init];
    descArray       = [[NSMutableArray alloc] init];
    billboardsArray = [[NSMutableArray alloc] init];
    descBillboardsArray = [[NSMutableArray alloc] init];
    shopArray       = [[NSMutableArray alloc] init];
    CarouseArray    = [[NSMutableArray alloc] init];
    fullScreenDict  = [[NSMutableDictionary alloc] init];
    page = 1;
}

/**
 首页数据先从ud里面读取 然后再读取网络
 获取成功之后则重新加载 需要刷新数据
 */
-(void)freshData
{
    slideArray      = [[NSMutableArray alloc] init];
    cateArray       = [[NSMutableArray alloc] init];
    littleCateArray = [[NSMutableArray alloc] init];
    urlArray        = [[NSMutableArray alloc] init];
    descArray       = [[NSMutableArray alloc] init];
    billboardsArray = [[NSMutableArray alloc] init];
    descBillboardsArray = [[NSMutableArray alloc] init];
    CarouseArray    = [[NSMutableArray alloc] init];
    fullScreenDict  = [[NSMutableDictionary alloc] init];
    page = 1;
}

#pragma mark - 获取首页服务中心分类

-(void)getServerCateFromNetwork
{
    NSDictionary* dict=@{
                         @"app_key":connect_url(index_cate),
                         };
    [Base64Tool postSomethingToServe:connect_url(index_cate) andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            NSLog(@"paramsdfas:%@",param[@"obj"]);
            NSArray* moduleArray=[linServicemodel objectArrayWithKeyValuesArray:param[@"obj"]];
            
            if (moduleArray.count!=0)
            {
                self.serverView=[self createServerViewWithModuleArray:moduleArray];
                //存储到UD当中
                [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"CenterInfo"];
                [self getcommodityDisplayFromNetwork];
                [self setIndexTableviewHeaderView];
            }
        }
    } andErrorBlock:^(NSError *error) {
    }];
}
#pragma mark --- 2016.4 设置生活服务区图标大小和分布
-(UIView*)createServerViewWithModuleArray:(NSArray*) moduleArray
{
    UIView* serverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    serverView.backgroundColor=[UIColor whiteColor];
    
    //添加标题label
    UILabel* serverLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    serverLabel.text=@"生活服务";
    [serverView addSubview:serverLabel];
    //设置分多少行多少列展示
    SkyServerCenterView* centerView=[SkyServerCenterView initViewWithXib:5 andRow:2];
    centerView.frame=CGRectMake(0, 30, SCREEN_WIDTH, 150);
    // centerView.layer.borderWidth=1.f;
    centerView.delegate=self;
    [centerView setButtonViewWithModuleArray:moduleArray];
    //    centerView.ColumnOfTagButton = 4;
    //    centerView.RowOfTagButton = 1;
    
    [serverView addSubview:centerView];
    
    return serverView;
}


-(void)serverCenterClickButtonToPushViewController:(linServicemodel *)module
{
    if ([module.index_type integerValue]==0)
    {
        //跳网页
        ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
        firVC.url = module.i_url;
        firVC.title = module.index_name;
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        //打电话
        [UZCommonMethod callPhone:module.i_tel superView:self.view];
    }
}

#pragma mark - 获取首页商品展示分类
- (void) getcommodityDisplayFromNetwork
{
    NSDictionary* dict=@{
                         @"app_key":connect_url(@"goods_list"),
                         };
    [Base64Tool postSomethingToServe:connect_url(@"goods_list") andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            NSLog(@"paramsdfas:%@",param[@"obj"]);
            NSArray* moduleArray=[ccDisplayModel objectArrayWithKeyValuesArray:param[@"obj"]];
            if (moduleArray.count!=0)
            {
                self.commodityDisplayView =  [self createDisplayViewWithModuleArray:moduleArray];
            }
            //存储到UD当中
            [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"CommodityDisplayInfo"];
            [self getcommodityDisplayMore];
            [self getBillboardsViewFromNetwork];
        }
    } andErrorBlock:^(NSError *error) {
    }];
}
//获取查看更多按钮的url
- (void) getcommodityDisplayMore
{
    NSDictionary *dict = @{
                           @"app_key" :connect_url(@"more_url"),
                           };
    
    [Base64Tool postSomethingToServe:connect_url(@"more_url") andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            NSLog(@"paramsdfas:%@",param[@"obj"]);
            NSDictionary *urlDict = param[@"obj"];
            [self addMoreButton:urlDict[@"message_url"]];
        }
    } andErrorBlock:^(NSError *error) {
    }];
    
}

-(void) addMoreButton:(NSString *)url
{
    NSLog(@"url :%@",url);
    moreDisplayUrl = url;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 30)];
    button.titleLabel.font  =   [UIFont systemFontOfSize:14];
    [button setTitle:@"查看更多" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xb4b4b4) forState:UIControlStateNormal];
    UIImageView *moreImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_displayMore"]];
    moreImage.backgroundColor = [UIColor clearColor];
    moreImage.frame         = CGRectMake(75, 0, 25, 30);
    [button addSubview:moreImage];
    [button addTarget:self action:@selector(moreDisplay) forControlEvents:UIControlEventTouchUpInside];
    [self.commodityDisplayView addSubview:button];
    [self setIndexTableviewHeaderView];
}

-(void) moreDisplay{
    NSLog(@"点击了查看更多");
    ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
    firVC.url   = moreDisplayUrl;
    firVC.title = @"精品推荐";
    [self.navigationController pushViewController:firVC animated:YES];
}

-(UIView*)createDisplayViewWithModuleArray:(NSArray*) moduleArray
{
    UIView* serverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    serverView.backgroundColor=[UIColor whiteColor];
    
    //添加标题label
    UILabel* serverLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    serverLabel.text=@"精品推荐";
    [serverView addSubview:serverLabel];
    UIView * grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, SCREEN_HEIGHT, 0.5)];
    grayLine.backgroundColor    =   UIColorFromRGB(0xe4e4e4);
    [serverView addSubview:grayLine];
    
    SkyServerCenterView* centerView=[SkyServerCenterView initViewWithXib:4 andRow:1];
    centerView.frame=CGRectMake(0, 30, SCREEN_WIDTH, 120);
    // centerView.layer.borderWidth=1.f;
    centerView.delegate=self;
    [centerView setDisplayButtonViewWithModuleArray:moduleArray];
    centerView.ColumnOfTagButton = 4;
    centerView.RowOfTagButton = 1;
    
    [serverView addSubview:centerView];
    
    return serverView;
}

-(void)disPlayCenterClickButtonToPushViewController:(ccDisplayModel *)module
{
    ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
    firVC.url = module.url;
    firVC.title = module.goods_name;
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark - 获取首页中部广告栏
- (void) getBillboardsViewFromNetwork
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSDictionary *dict = @{
                           @"app_key":connect_url(@"advertisement_index"),
                           @"city_id":city_id
                           };
    [Base64Tool postSomethingToServe:connect_url(@"advertisement_index") andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            billboardsArray = [NSMutableArray array];
            descBillboardsArray = [NSMutableArray array];
            NSLog(@"paramsdfas:%@",param[@"obj"]);
            for (NSDictionary *dict in param[@"obj"]) {
                [billboardsArray addObject:dict[@"a_pic"]];
                [descBillboardsArray addObject:dict[@"a_url"]];
            }
            self.billboardsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LinHeightPercent*145)];
            //            self.billboardsView.layer.borderColor = [UIColor blueColor].CGColor;
            //            self.billboardsView.layer.borderWidth = 1;
            //存储到UD当中
            [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"BillboardsInfo"];
            [self setIndexTableviewHeaderView];
        }
    } andErrorBlock:^(NSError *error) {
    }];
}

#pragma mark - 获取首页行业专区分类
-(void)getIndustryFromNetwork
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CenterInfo"])
    {
        NSDictionary* dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"CenterInfo"];
        NSArray* moduleArray=[linServicemodel objectArrayWithKeyValuesArray:dict[@"obj"]];
        self.serverView=[self createServerViewWithModuleArray:moduleArray];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"IndustryInfo"])
        {
            NSDictionary* dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"IndustryInfo"];
            NSArray* moduleArray=[linServicemodel objectArrayWithKeyValuesArray:dict[@"obj"]];
            self.industryView.moduleArray   =   moduleArray;
            self.industryView.delegate      =   self;
            //            self.industryView=[self crateIndustryViewFromNetwork:moduleArray];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CommodityDisplayInfo"]) {
            NSDictionary* param = [[NSUserDefaults standardUserDefaults] objectForKey:@"CommodityDisplayInfo"];
            //这应该写商品展示 对数据的处理
            NSArray* moduleArray=[ccDisplayModel objectArrayWithKeyValuesArray:param[@"obj"]];
            if (moduleArray.count!=0)
            {
                self.commodityDisplayView =  [self createDisplayViewWithModuleArray:moduleArray];
            }
            //
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BillboardsInfo"]) {
            NSDictionary* param = [[NSUserDefaults standardUserDefaults] objectForKey:@"BillboardsInfo"];
            billboardsArray = [NSMutableArray array];
            descBillboardsArray = [NSMutableArray array];
            for (NSDictionary *dict in param[@"obj"]) {
                [billboardsArray addObject:dict[@"a_pic"]];
                [descBillboardsArray addObject:dict[@"a_url"]];
            }
        }
        [self setIndexTableviewHeaderView];
    }
    
    
    NSDictionary* dict=@{
                         @"app_key":connect_url(index_cate_hy),
                         };
    
    [Base64Tool postSomethingToServe:connect_url(index_cate_hy) andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            
            NSArray* moduleArray=[linHangyeModel objectArrayWithKeyValuesArray:param[@"obj"]];
            industryArray = [moduleArray copy];
            //            linHangyeModel *model = (linHangyeModel *)[industryArray objectAtIndex:0];
            if (moduleArray.count!=0)
            {
                //                self.industryView=[self crateIndustryViewFromNetwork:moduleArray];
                //                [self.industryView createIndustryView:moduleArray];
                self.industryView.moduleArray   =   moduleArray;
                self.industryView.delegate      =   self;
                //存储到UD当中
                [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"IndustryInfo"];
                [self getServerCateFromNetwork];
                [self setIndexTableviewHeaderView];
            }
        }
    } andErrorBlock:^(NSError *error) {
    }];
}

//-----------弃用方法----------------
-(UIView*)crateIndustryViewFromNetwork:(NSArray*) moduleArray
{
    UIView* industryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    industryView.backgroundColor=[UIColor whiteColor];
    
    //添加标题label
    UILabel* serverLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    serverLabel.text=@"如意专区";
    
    [industryView addSubview:serverLabel];
    
    linHangyeCommendView* centerView=[linHangyeCommendView initViewWithXib];
    centerView.frame=CGRectMake(0, 30, SCREEN_WIDTH, 220);
    centerView.delegate=self;
    [centerView setIndustryButtonViewWithModuleArray:moduleArray];
    
    [industryView addSubview:centerView];
    
    return industryView;
}

//点击“行业专区”调用
-(void)linHangyeclikButtonToPushViewController:(linHangyeModel *)module
{
    if ([module.index_type integerValue]==0)
    {
        //跳网页
        //跳网页
        ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
        firVC.url = module.i_url;
        firVC.title = module.index_name;
        [self.navigationController pushViewController:firVC animated:YES];
    }
    else
    {
        //打电话
        [UZCommonMethod callPhone:module.i_tel superView:self.view];
    }
}
#pragma mark - 获取全屏广告数据
/**
 * 获取全屏广告数据
 */
- (void) getfullScreenFromNet
{
    NSDictionary* dict=@{
                         @"app_key":connect_url(@"advertisement"),
                         };
    
    [Base64Tool postSomethingToServe:connect_url(@"advertisement") andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            fullScreenDict = param[@"obj"];
            NSURL *url = [NSURL URLWithString:fullScreenDict[@"a_pic"]];
            [self.fullScreenImage sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.view.window addSubview:self.fullScreenImage];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
                //                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }];
            
        }
    } andErrorBlock:^(NSError *error) {
    }];
    
}

#pragma mark------获取网络数据
-(void)getDataFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSDictionary *dic = @{
                          @"app_key":index_data,
                          @"city_id":city_id
                          };
    [Base64Tool postSomethingToServe:index_data andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        indexDic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)param];
        NSLog(@"获取的数据为:%@",indexDic);
        //如果距离上次更新时间超过4小时 更新ud的数据
        //解析数据 做显示
        if ([self isRefresh:0]) {
            [[NSUserDefaults standardUserDefaults] setObject:indexDic forKey:@"indexData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self parseData:indexDic];
        //读取列表
        [self getShopListFromNet];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark------获取网络列表
-(void)getShopListFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSDictionary *dic = @{
                          @"app_key":shop_list,
                          @"page":[NSString stringWithFormat:@"%d",page],
                          @"city_id":city_id
                          };
    [Base64Tool postSomethingToServe:shop_list andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        // NSLog(@"%@",param);
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)param] ;
            if ([self isRefresh:1]) {
                [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"ShopList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self parseShopList:dict];
            //[[self indexTableview] reloadData];
            [self.indexTableview headerEndRefreshing];
            [self.indexTableview footerEndRefreshing];
        }else{
            [self.indexTableview headerEndRefreshing];
            [self.indexTableview footerEndRefreshing];
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [self.indexTableview headerEndRefreshing];
        [self.indexTableview footerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark------解析time
-(BOOL)isRefresh :(NSInteger)index
{
    /**
     0:代表判断刷新幻灯片等分类的刷新
     1:代表shoplist的刷新
     */
    if (index == 0) {
        if (userDefault(@"freshTime")==nil) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%f", a];
            [[NSUserDefaults standardUserDefaults]setObject:timeString forKey:@"freshTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return YES;
        }else{
            NSString *timeStr = userDefault(@"freshTime");
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%f", a];
            //判断距离上次时间隔了多久
            if ([timeString longLongValue]-[timeStr longLongValue]>=3600*4) {
                return YES;
            }
        }
    }else{
        if (userDefault(@"freshTimeShop")==nil) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%f", a];
            [[NSUserDefaults standardUserDefaults]setObject:timeString forKey:@"freshTimeShop"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return YES;
        }else{
            NSString *timeStr = userDefault(@"freshTimeShop");
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%f", a];
            //判断距离上次时间隔了多久
            if ([timeString longLongValue]-[timeStr longLongValue]>=3600*4) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark------解析列表数据
-(void)parseShopList :(NSDictionary*)dic
{
    NSArray *arr = [dic objectForKey:@"obj"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        shopInfo *info = [[shopInfo alloc] initWithDictionary:dic];
        [array addObject:info];
    }
    if (userDefault(@"ShopList")!=nil && page == 1) {
        [shopArray removeAllObjects];
        [shopArray addObjectsFromArray:array];
    }else{
        [shopArray addObjectsFromArray:array];
    }
    //刷新列表
    [self.indexTableview reloadData];
}

/**
 这里做了headerview 上添加无数个乱七八糟的东西的方法
 需要计算每个小模块的高度 防止显示出现异常
 */
#pragma mark------解析数据，封装 ----
-(void)parseData :(NSDictionary*)dict
{
    if (userDefault(@"indexData") != nil) {
        [self freshData];
    }
    //首页幻灯片解析
    [CarouseArray removeAllObjects];
    NSArray *tempArray = [[dict objectForKey:@"obj"] objectForKey:@"slide_list"];
    for (NSDictionary *tempDict in tempArray) {
        //解析数据
        CarouselInfo *info = [[CarouselInfo alloc] initWithDictionary:tempDict];
        [CarouseArray addObject:info];
        
        NSString *url = [tempDict objectForKey:@"top_pic"];
        NSString *name = @"";
        [urlArray addObject:url];
        [descArray addObject:name];
        slideModel *model = [[slideModel alloc] initWithDictionary:tempDict];
        [slideArray addObject:model];
    }
    //六个大分类数据解析
    NSArray *tempCateArray = [[dict objectForKey:@"obj"] objectForKey:@"cate"];
    for (NSDictionary *dic in tempCateArray) {
        cateModel *element = [[cateModel alloc] initWithDictionary:dic];
        [cateArray addObject:element];
    }
    //分页小分类数据解析
    NSArray *tempLittleArray = [[dict objectForKey:@"obj"] objectForKey:@"cate_list"];
    for (NSDictionary *littleDic in tempLittleArray) {
        littleCateModel *element = [[littleCateModel alloc] initWithDictionary:littleDic];
        [littleCateArray addObject:element];
    }
    
    //    //重新显示列表
    [self setupAdBannerView:urlArray andLabelName:descArray];
    if ([cateArray count]>0) {
        /**
         测试使用 减少button数量 计算高度问题
         [cateArray removeObjectAtIndex:0];
         [cateArray removeObjectAtIndex:0];
         */
        [self setCateButton:cateArray];
    }
    //获取首页服务分类
    [self getIndustryFromNetwork];
    
}
/**
 设置tableHeaderView 重新计算view的高度 设置view的显示
 */
#pragma mark 2016.4设置各模块高度
-(void)setIndexTableviewHeaderView
{
    UIView *myView = [self.indexTableview viewWithTag:101];
    while ([myView.subviews lastObject]!=nil) {
        [[myView.subviews lastObject] removeFromSuperview];
    }
    // 社区服务 高度
    CGFloat faceViewHeight = 190*LinHeightPercent;//这里按屏幕比率设置高度  以4.0屏幕为例
    CGFloat adbanderHeight = 150*LinHeightPercent;
    CGFloat commenViewHeihgt = 120*LinHeightPercent;
    //服务中心高度
    CGFloat serverViewHeight = 170;
    //商品展示高度
    CGFloat commodityDisplayViewHeight = 150;
    //中部广告栏
    CGFloat billboardsViewHeight = 100;
    //商业专区高度（改这个参数，需要同时修改IndustryZoneView.m中宏ViewHeight的值）
    CGFloat industryViewHeight= 220*LinHeightPercent;
    
    CGFloat view_height = faceViewHeight + adbanderHeight + commodityDisplayViewHeight + billboardsViewHeight + commenViewHeihgt +serverViewHeight + industryViewHeight + 50 + 30 + 45;
    if ([cateArray count]>4) {
        view_height += 60*LinHeightPercent;
    }else if ([cateArray count]<3){
        view_height -= 60*LinHeightPercent;
    }else if ([cateArray count]==0){
        view_height -= 120*LinHeightPercent;
    }
    myView.frame = CGRectMake(0, 0, 320, view_height);
    
    //显示数据
    [myView setBackgroundColor:UIColorFromRGB(0xf3f3f3)];
    [self addBanderView:adbanderHeight pView:myView ViewY:0];

    
    //添加服务中心view
    CGRect frame=self.serverView.frame;
    frame.origin.y=adbanderHeight;
    self.serverView.frame=frame;
    [myView addSubview:self.serverView];
    
    //添加行业专区View
    
    CGRect industryFrame=self.industryView.frame;
    industryFrame.origin.y=adbanderHeight+serverViewHeight+5;
    industryFrame.size.height = industryViewHeight;
    self.industryView.frame=industryFrame;
    [myView addSubview:self.industryView];
    //添加商品展示区//commodityDisplayViewHeight
    CGRect commodityDisplayFrame    = self.commodityDisplayView.frame;
    commodityDisplayFrame.origin.y  = adbanderHeight+serverViewHeight+industryViewHeight+5+5;
    commodityDisplayFrame.size.height = commodityDisplayViewHeight;
    self.commodityDisplayView.frame = commodityDisplayFrame;
    [myView addSubview:self.commodityDisplayView];
    
    //添加中部广告栏
    CGRect billboardsFrame  =   self.billboardsView.frame;
    billboardsFrame.origin.y    =   adbanderHeight+serverViewHeight +industryViewHeight + commodityDisplayViewHeight +5 +5 +5;
    billboardsFrame.size.height =   billboardsViewHeight;
    self.billboardsView.frame   =   billboardsFrame;
    [myView addSubview:self.billboardsView];
    
    [self addBillboardsView:billboardsViewHeight pView:myView ViewY:billboardsFrame.origin.y];
    
    //这里需要重新设置headerView 否则显示尺寸调整不显示出来
    self.indexTableview.tableHeaderView = myView;
    
    CGFloat cateHeight = industryViewHeight+adbanderHeight+commodityDisplayViewHeight+serverViewHeight+billboardsViewHeight+50;
    //add categray
    [myView addSubview:self.cateView];
    if ([cateArray count]>4) {
        commenViewHeihgt += 60*LinHeightPercent;
    }else if ([cateArray count]<3){
        commenViewHeihgt -= 60*LinHeightPercent;
    }else if ([cateArray count]==0){
        commenViewHeihgt -= 120*LinHeightPercent;
    }
    [_cateView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_cateView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_cateView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:cateHeight];
    [_cateView autoSetDimension:ALDimensionHeight toSize:commenViewHeihgt];
    //--------------------------------------------
    UILabel *titleLinlable = [[UILabel alloc] initForAutoLayout];
    titleLinlable.textAlignment = NSTextAlignmentLeft;
    //    titleLinlable.font = [UIFont systemFontOfSize:15.0f];
    [titleLinlable setBackgroundColor:[UIColor whiteColor]];
    [myView addSubview:titleLinlable];
    [titleLinlable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [titleLinlable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [titleLinlable autoSetDimension:ALDimensionHeight toSize:30.0f];
    [titleLinlable autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.cateView withOffset:0.0f];
    titleLinlable.text = @"  优惠活动";
    //--------------------------------------------
    //分割线-1
    UIImageView *lineImage1 = [[UIImageView alloc] initForAutoLayout];
    [lineImage1 setBackgroundColor:UIColorFromRGB(0xc3c3c3)];
    [myView addSubview:lineImage1];
    [lineImage1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_cateView withOffset:-0.5];
    [lineImage1 autoSetDimension:ALDimensionHeight toSize:0.5f];
    //    //scrollView
    [myView addSubview:self.faceView];
    [_faceView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_faceView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_faceView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_cateView withOffset:35.0f];
    [_faceView autoSetDimension:ALDimensionHeight toSize:faceViewHeight];
    [_faceView setButtonView:littleCateArray];
    //--------------------------------------------
    UILabel *titleSkylable = [[UILabel alloc] initForAutoLayout];
    titleSkylable.textAlignment = NSTextAlignmentLeft;
    //    titleSkylable.font = [UIFont systemFontOfSize:15.0f];
    [titleSkylable setBackgroundColor:[UIColor whiteColor]];
    [myView addSubview:titleSkylable];
    [titleSkylable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [titleSkylable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [titleSkylable autoSetDimension:ALDimensionHeight toSize:30.0f];
    [titleSkylable autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_faceView withOffset:0.0f];
    titleSkylable.text = @"  社区服务";
    
    //--------------------------------------------
    //分割线-2
    UIImageView *lineImage2 = [[UIImageView alloc] initForAutoLayout];
    [lineImage2 setBackgroundColor:UIColorFromRGB(0xc3c3c3)];
    [myView addSubview:lineImage2];
    [lineImage2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_faceView withOffset:-0.5];
    [lineImage2 autoSetDimension:ALDimensionHeight toSize:0.5f];
    //分割线-3
    UIImageView *lineImage3 = [[UIImageView alloc] initForAutoLayout];
    [lineImage3 setBackgroundColor:UIColorFromRGB(0xc3c3c3)];
    [myView addSubview:lineImage3];
    [lineImage3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_faceView withOffset:0.5];
    [lineImage3 autoSetDimension:ALDimensionHeight toSize:0.5f];
    //商家列表lable
    [myView addSubview:self.shopListView];
    [_shopListView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_shopListView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopListView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_faceView withOffset:5.0f];
    [_shopListView autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    UILabel *shopName = [[UILabel alloc] initForAutoLayout];
    while (_shopListView.subviews.lastObject!=nil) {
        [_shopListView.subviews.lastObject removeFromSuperview];
    }
    [_shopListView addSubview:shopName];
    shopName.text = @"推荐商家";
    shopName.textColor = UIColorFromRGB(indexTitle);
    //    shopName.font = [UIFont systemFontOfSize:15.0f];
    [shopName autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_shopListView];
    [shopName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0f];
    //分割线-4
    UIImageView *lineImage4 = [[UIImageView alloc] initForAutoLayout];
    [lineImage4 setBackgroundColor:UIColorFromRGB(0xc3c3c3)];
    [myView addSubview:lineImage4];
    [lineImage4 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage4 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage4 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:[self shopListView] withOffset:-0.5];
    [lineImage4 autoSetDimension:ALDimensionHeight toSize:0.5f];
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [lineImage setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
    [myView addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[self shopListView] withOffset:-0.5];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
}

#pragma mark------设置首页显示
-(void)setUI
{
    [self.view addSubview:self.indexTableview];
    [_indexTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_indexTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_indexTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_indexTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:44.0f];
    //如果ud里面有数据 则读取出去 设置界面 然后继续访问接口
    indexDic = userDefault(@"indexData");
    if (indexDic != nil) {
        //数据解析 显示数据
        [self parseData:indexDic];
        if (userDefault(@"ShopList")!=nil) {
            NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)userDefault(@"ShopList")];
            [self parseShopList:dict];
        }
    }
}

#pragma mark------获取当前网络环境
-(void)getTheWebCon
{
    /*
     判断当前网络环境
     */
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            NSLog(@"无网络");
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"移动网络");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"wifi");
            break;
    }
}

#pragma mark---------私信页面
-(void)go2MyMessage :(UIButton*)btn
{
    [self removeHint];
    NSLog(@"跳转我的消息页面");
    MessageViewController *firVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark--------setLeftButton and RightButton
-(UIButton*)messageButton
{
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_news_no"]];
        [image setFrame:CGRectMake(0, 0, 10, 10)];
        [_messageButton addSubview:image];
        [_messageButton addTarget:self action:@selector(go2MyMessage:) forControlEvents:UIControlEventTouchUpInside];
        _messageButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    return _messageButton;
}

#pragma mark--------设置navigation首页显示
-(void)setNavigationBar
{
    navigationView = [HomeNavigationView shareInstance];
    [navigationView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];//191：21
    navigationView.delegate = self;
    self.navigationItem.titleView = navigationView;
    NSString *cityName = userDefault(KCityNAME);
    if (cityName!=nil) {
        [navigationView setCityName:[NSString stringWithFormat:@"%@﹀",cityName]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

#pragma mark--------tableview and delegate
-(UITableView*)indexTableview
{
    if (!_indexTableview) {
        _indexTableview = [[UITableView alloc] initForAutoLayout];
        [_indexTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_indexTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _indexTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _indexTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _indexTableview.footerRefreshingText = @"正在加载更多的商家";
        _indexTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _indexTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _indexTableview.headerRefreshingText = @"正在刷新，请稍等";
        [UZCommonMethod hiddleExtendCellFromTableview:_indexTableview];
        [_indexTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        _indexTableview.separatorInset = UIEdgeInsetsZero;
        _indexTableview.delegate = self;
        _indexTableview.dataSource = self;
        //设置cell分割线的显示
        if ([_indexTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_indexTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_indexTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_indexTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 510)];
        headerView.tag = 101;
        headerView.backgroundColor = [UIColor whiteColor];
        _indexTableview.tableHeaderView = headerView;
    }
    return _indexTableview;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"shop_cell";
    IndexTableViewCell *cell=(IndexTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[IndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    //设置分割线长度--兼容ios7 ios8
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    while ([cell.contentView.subviews lastObject]!=nil) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    shopInfo *info = [shopArray objectAtIndex:indexPath.row];
    [cell configureCell:info];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  NSLog(@"点击了商家");
    shopInfo *info = [shopArray objectAtIndex:indexPath.row];
    ShopDetailViewController *firVC = [[ShopDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    firVC.shop_id = info.shop_id;
    firVC.my_lat = baidu_lat;
    firVC.my_lng = baidu_lng;
    firVC.message_url = info.message_url;
    [firVC.navigationItem setTitle:@"如e商家"];
    [self.navigationController pushViewController:firVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [shopArray count];
    NSLog(@"the num of shopArray is %ld",count);
    return count;
}
#pragma mark---------刷新
-(void)headerBeginRefreshing
{
    //NSLog(@"下拉刷新");
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    //NSLog(@"上拉加载");
    page ++;
    [self getShopListFromNet];
}

#pragma mark---------轮播
-(UIScrollView*)myScrollView
{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initForAutoLayout];
        _myScrollView.backgroundColor = [UIColor whiteColor];
        _myScrollView.scrollEnabled = NO;
    }
    return _myScrollView;
}
#pragma mark---------设置轮播
- (void)setupAdBannerView:(NSArray *)urlArry andLabelName:(NSArray *)labelNameArray
{
    //移除上一个视图的iamgeview
    while ([[[self myScrollView] subviews] lastObject] != nil) {
        [(UIView*)[[[self myScrollView] subviews] lastObject]  removeFromSuperview];  //删除并进行重新分配
    }
    SkyBannerView* bannerView = [[SkyBannerView alloc] init];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    bannerView.layer.borderWidth = 1;
    if ([urlArray count]>0) {
        [bannerView setPictureUrls:urlArray andTitles:urlArry];
        bannerView.tapHandler=^(SkyBannerView* bannerView,NSInteger index){
            NSLog(@"Has taped imageView at index :%ld",index);
            CarouselInfo *info = [CarouseArray objectAtIndex:index];
            [self parseInfo:info];
        };
    }
    [[self myScrollView]  addSubview:bannerView];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [bannerView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:[self myScrollView]   withMultiplier:1.0];
}

-(void)addBanderView:(CGFloat)height pView:(UIView*)view ViewY:(CGFloat)y;
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0 , y, SCREEN_WIDTH, height)];
    [view addSubview:tmpView];
    //移除上一个视图的iamgeview
    //    while ([[[self myScrollView] subviews] lastObject] != nil) {
    //        [(UIView*)[[[self myScrollView] subviews] lastObject]  removeFromSuperview];  //删除并进行重新分配
    //    }
    SkyBannerView* bannerView = [[SkyBannerView alloc] init];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    if ([urlArray count]>0) {
        [bannerView setPictureUrls:urlArray andTitles:descArray];
        bannerView.tapHandler=^(SkyBannerView* bannerView,NSInteger index){
            NSLog(@"Has taped imageView at index :%ld",index);
            CarouselInfo *info = [CarouseArray objectAtIndex:index];
            [self parseInfo:info];
        };
    }
    [tmpView  addSubview:bannerView];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [bannerView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:tmpView   withMultiplier:1.0];
}

-(void)addBillboardsView:(CGFloat)height pView:(UIView*)view ViewY:(CGFloat)y;
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, height)];
    [view addSubview:tmpView];
    SkyBannerView* bannerView = [[SkyBannerView alloc] init];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    if ([billboardsArray count]>0) {
        [bannerView setPictureUrls:billboardsArray andTitles:descBillboardsArray];
        bannerView.tapHandler=^(SkyBannerView* bannerView,NSInteger index){
            NSLog(@"在这写中部广告栏的点击逻辑处理 :%ld",index);
            NSString *url = [descBillboardsArray objectAtIndex:index];
            ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
            [firVC setHiddenTabbar:YES];
            
            [firVC setNavBarTitle:@"详情" withFont:14.0f];
            firVC.url = url;
            [self.navigationController pushViewController:firVC animated:YES];
        };
    }
    [tmpView  addSubview:bannerView];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [bannerView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [bannerView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:tmpView   withMultiplier:1.0];
}

#pragma mark-------设置分类
-(void)setCateButton :(NSMutableArray*)array
{
    while ([self.cateView.subviews lastObject]!=nil) {
        [[_cateView.subviews lastObject] removeFromSuperview];
    }
    //计算count
    NSLog(@"[array count]=%lu",(unsigned long)[array count]);
    NSInteger count = [array count]/2;
    if ([array count]%2!=0) {
        count += 1;
    }
    UIView *cate = [[UIView alloc] initForAutoLayout];
    cate.layer.borderWidth = 0.25;
    cate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_cateView addSubview:cate];
    [cate autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [cate autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [cate autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [cate autoSetDimension:ALDimensionHeight toSize:60.0f*LinHeightPercent];
    
    //加水平分割线1
    
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    [viewArray addObject:cate];
    for (int i = 1; i<count; i++) {
        UIView *tempView = [[UIView alloc] initForAutoLayout];
        tempView.layer.borderWidth = 0.25;
        tempView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_cateView addSubview:tempView];
        [viewArray addObject:tempView];
    }
    [viewArray autoMatchViewsDimension:ALDimensionHeight];
    [viewArray autoMatchViewsDimension:ALDimensionWidth];
    [viewArray autoAlignViewsToAxis:ALAxisVertical];
    UIView* preview=nil;
    for (UIView* view in viewArray )
    {
        if (preview)
        {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:preview withOffset:0.0f];
        }
        preview=view;
    }
    
    //添加button 布局
    for (int i = 0 ; i<[array count];i++) {
        cateButton *btn = [[cateButton alloc] initForAutoLayout];
        UIView *view = [viewArray objectAtIndex:i/2];
        //计算宽度
        CGFloat width = SCREEN_WIDTH;
        [view addSubview:btn];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
        [btn autoSetDimension:ALDimensionWidth toSize:(width-2)/2.0f];
        
        if (i%2==0) {
            [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        }else{
            [btn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        }
        [btn setUI:[array objectAtIndex:i]];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //添加分割线 --- 垂直
    UIImageView *verticalImage = [[UIImageView alloc] initForAutoLayout];
    [_cateView addSubview:verticalImage];
    [verticalImage setBackgroundColor:[UIColor lightGrayColor]];
    [verticalImage autoAlignAxis:ALAxisVertical toSameAxisOfView:_cateView];
    [verticalImage autoSetDimension:ALDimensionWidth toSize:0.5];
    [verticalImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [verticalImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:3.0f];
}

#pragma mark-------分类按钮点击事件
-(void)clickButton :(UIButton*)sender
{
    //  NSLog(@"点击了第%ld个btn",(long)sender.tag);
    cateModel *model = [cateArray objectAtIndex:sender.tag-1];
    if ([model.cate_type isEqualToString:@"takeout"]) {
        ShopTakeoutListViewController *firVC = [[ShopTakeoutListViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"外卖" withFont:17.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([model.cate_type isEqualToString:@"group"]) {
        GroupListViewController *firVC = [[GroupListViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"团购" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }if ([model.cate_type isEqualToString:@"spike"]) {
        CouponListViewController *firVC = [[CouponListViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"优惠券" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }if ([model.cate_type isEqualToString:@"seat"]) {
        OrderSeatViewController *firVC  = [[OrderSeatViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"订座位商家" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }if ([model.cate_type isEqualToString:@"hotel"]) {
        orderRoomListViewController *firVC = [[orderRoomListViewController alloc] init];
        [firVC setNavBarTitle:@"预定酒店" withFont:14.0f];
        [firVC setHiddenTabbar:YES];
        [self.navigationController pushViewController:firVC animated:YES];
    }if ([model.cate_type isEqualToString:@"activity"]) {
        ActivityListViewController *firVC = [[ActivityListViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"商家活动" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

#pragma mark-------adBannerViewDelegate
-(void)adBannerView:(AdBannerView *)adBannerView itemIndex:(int)index
{
    // NSLog(@"被点击的图片是第%d长",index);
    CarouselInfo *info = [CarouseArray objectAtIndex:index];
    [self parseInfo:info];
}

#pragma mark---------parse CarouseInfo
-(void)parseInfo:(CarouselInfo*)info
{
    if ([info.type integerValue] == 1) {//团购
        GroupDetailViewController *firVC = [[GroupDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"团购详情" withFont:14.0f];
        firVC.group_id = info.goods_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([info.type integerValue] == 2) {//优惠券
        CouponDetailViewController *firVC = [[CouponDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"优惠券详情" withFont:14.0f];
        firVC.message_url = info.top_desc;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([info.type integerValue] == 3) {//订座位
        orderSeatDetailViewController *firVC = [[orderSeatDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"商家订座" withFont:14.0f];
        firVC.shop_id = info.goods_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([info.type integerValue] == 4) {//订酒店
        orderRoomDetailViewController *firVC = [[orderRoomDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"预定酒店" withFont:14.0f];
        firVC.shop_id = info.goods_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([info.type integerValue] == 5) {//活动
        ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"商家订座" withFont:14.0f];
        firVC.url = info.top_desc;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([info.type integerValue] == 6) {//外卖
        ShopTakeOutViewController *firVC = [[ShopTakeOutViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"订外卖" withFont:14.0f];
        firVC.shop_id = info.goods_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        NSLog(@"跳转到web详情页面");
        ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
        [firVC setHiddenTabbar:YES];
        
        [firVC setNavBarTitle:@"详情" withFont:14.0f];
        firVC.url = info.top_desc;
        [self.navigationController pushViewController:firVC animated:YES];
    }
}
#pragma mark --------- 推荐专区
- (IndustryZoneView *) industryView
{
    if(!_industryView) {
        _industryView = [[IndustryZoneView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220*LinHeightPercent)];
        _industryView.delegate = self;
    }
    return _industryView;
}

#pragma mark---------分类view
-(UIView*)cateView
{
    if (!_cateView) {
        _cateView = [[UIView alloc] initForAutoLayout];
        _cateView.backgroundColor = [UIColor whiteColor];
    }
    return _cateView;
}

//#pragma mark---------滚动分类view
//-(SLCoverFlowView*)coverFlowView
//{
//    if (!_coverFlowView) {
//        _coverFlowView = [[SLCoverFlowView alloc] initForAutoLayout];
//        _coverFlowView.backgroundColor = [UIColor grayColor];
//        _coverFlowView.delegate = self;
//        _coverFlowView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        CGRect rect = [[UIScreen mainScreen] bounds];
//        _coverFlowView.coverSize = CGSizeMake(rect.size.width, 150);
//        _coverFlowView.coverSpace = 0.0;
//        _coverFlowView.coverAngle = 0.0;
//        _coverFlowView.coverScale = 1.0;
//    }
//    return _coverFlowView;
//}
//
//#pragma mark--------分类页面代理 分类页数量和显示
//- (NSInteger)numberOfCovers:(SLCoverFlowView *)coverFlowView {
//    NSInteger count = [littleCateArray count]/8;
//    if ([littleCateArray count]%8!=0) {
//        count += 1;
//    }
//    return count;
//}
//
//- (SLCoverView *)coverFlowView:(SLCoverFlowView *)coverFlowView coverViewAtIndex:(NSInteger)index {
//    float width = coverFlowView.frame.size.width;
//    float height = coverFlowView.frame.size.height;
//    SLCoverView *view = [[SLCoverView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
//    //添加分类button
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    float blankWidth = (rect.size.width - 20*2 - 35*4)/3.0;
//    for (int i = 0+index*8; i<[littleCateArray count]; i++) {
//        int n = i % 8;
//        int x_pos = 120+n%4*blankWidth;
//        int y_pos = 8 + n/4*60;
//        littleCateButton *myButton = [[littleCateButton alloc] init];
//        [myButton setFrame:CGRectMake(x_pos, y_pos, 35, 55)];
//        //myButton.layer.borderWidth = 1;
//        myButton.delegate = self;
//        [myButton setUI:[littleCateArray objectAtIndex:i]];
//        [view addSubview:myButton];
//    }
//    view.backgroundColor = [UIColor whiteColor];
//    if (index == 0) {
//        view.backgroundColor = [UIColor redColor];
//    }else if(index == 1){
//        view.backgroundColor = [UIColor blueColor];
//    }else{
//        view.backgroundColor = [UIColor purpleColor];
//    }
//    return view;
//}

#pragma clickButtonForlittle
-(void)clickAction:(NSInteger)index
{
    NSLog(@"点击了%ld",(long)index);
}

-(UIView*)shopListView
{
    if (!_shopListView) {
        _shopListView = [[UIView alloc] initForAutoLayout];
        _shopListView.backgroundColor = [UIColor whiteColor];
    }
    return _shopListView;
}

-(CommendView*)faceView
{
    if (!_faceView) {
        _faceView = [[CommendView alloc] initForAutoLayout];
        _faceView.backgroundColor = [UIColor whiteColor];
        _faceView.delegate =self;
    }
    return _faceView;
}

-(void)clikButtonToPushViewController:(littleCateModel *)module
{
    NSLog(@"点击的按钮为%@----%@",module.cat_name,module.cat_id);
    ShopListViewController *firVC = [[ShopListViewController alloc] init];
    //    [firVC setHiddenTabbar:YES];
    firVC.is_hidden = @"0";
    [firVC setNavBarTitle:@"商家" withFont:14.0f];
    firVC.shop_id = module.cat_id;
    firVC.cate_name = module.cat_name;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)goSeachShop:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"实现代理跳转到搜索页面的方法");
        SearchViewController *firVC = [[SearchViewController alloc] init];
        firVC.u_lat = baidu_lat;
        firVC.u_lng = baidu_lng;
        [firVC setHiddenTabbar:YES];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if(index == 1){
        NSLog(@"跳转我的消息页面");
        MessageViewController *firVC = [[MessageViewController alloc] init];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if(index == 2){
        NSLog(@"主页在这里跳转多城市");
        HomeSelectedCityViewController* hscvc=[[HomeSelectedCityViewController alloc]init];
        hscvc.delegate=self;
        [self.navigationController pushViewController:hscvc animated:YES];
    }else{
        [UZCommonMethod callPhone:@"0451114" superView:self.view];
    }
}

#pragma mark - HomeSelectedCityViewController Delegate
-(void)homeSelectedCityViewController:(HomeSelectedCityViewController *)homeSelectedCityViewController currentCityName:(NSString *)cityName currentCityID:(NSString *)ciytID
{
    [navigationView setCityName:[NSString stringWithFormat:@"%@﹀",cityName]];
    [[NSUserDefaults standardUserDefaults] setObject:ciytID forKey:KCityID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //做刷新逻辑
    [self getDataFromNet];
}

-(void)choseTheCity:(NSString *)cityName
{
    NSLog(@"1111");
}

-(void)choseTheCityModule:(CityModule *)module
{
    [navigationView setCityName:[NSString stringWithFormat:@"%@﹀",module.city_name]];
    [[NSUserDefaults standardUserDefaults] setObject:module.city_id forKey:KCityID];
    [[NSUserDefaults standardUserDefaults] setObject:module.city_name forKey:KCityNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //做刷新逻辑
    [self getDataFromNet];
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - 检查更新APP
#pragma mark-------检测更新
-(void)checkVersion
{
    NSString *cr_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *net_version = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_v"] ;
    if ([self NeedUpdates:net_version CrVersion:cr_version] == YES) {
        NSString *is_update = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"is_update"] ;
        NSString *hintStr = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_desc"] ;
        if ([is_update intValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"强制版本更新" message:hintStr delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:hintStr delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:@"暂时不要了", nil];
            alert.tag = 1;
            [alert show];
        }
    }
}

- (NSDictionary * ) NSStringtoDictionary:(NSString *)string{
    
    NSArray *array = [string componentsSeparatedByString:@"."];
    if (array.count != 3) {
        [SVProgressHUD showErrorWithStatus:@"版本号格式有误！！！"];
        return [NSDictionary new];
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:array forKeys:@[@"1",@"2",@"3"]];
    return dict;
}
// 将版本号1、2、3位 分别比较。确定是否需要更新。 是：YES 不需要：NO
- (BOOL) NeedUpdates:(NSString *)netVersion CrVersion:(NSString *)crVersion
{
    NSDictionary * netDict = [self NSStringtoDictionary:netVersion];
    NSDictionary * crDict = [self NSStringtoDictionary:crVersion];
    if ([[netDict objectForKey:@"1"] integerValue]>[[crDict objectForKey:@"1"] integerValue]) {
        return YES;
    }
    if ([[netDict objectForKey:@"2"] integerValue]>[[crDict objectForKey:@"2"] integerValue]) {
        return YES;
    }
    if ([[netDict objectForKey:@"3"] integerValue]>[[crDict objectForKey:@"3"] integerValue]) {
        return YES;
    }
    return NO;
}


#pragma mark-------alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSString *downLoadUrl = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_download"] ;
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoadUrl]];
            AppUpdatesController * appUpdates = [[AppUpdatesController alloc] init];
            appUpdates.webURL = downLoadUrl;
            [appUpdates setNavBarTitle:@"更新APP" withFont:15.0f];
            [self.navigationController pushViewController:appUpdates animated:NO];
        }
    }
}
- (NSInteger)numberOfCovers:(SLCoverFlowView *)coverFlowView{
    return 0;
}
- (SLCoverView *)coverFlowView:(SLCoverFlowView *)coverFlowView coverViewAtIndex:(NSInteger)index{
    return nil;
}
@end
