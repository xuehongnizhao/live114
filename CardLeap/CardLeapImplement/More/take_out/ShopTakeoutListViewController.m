//
//  ShopTakeoutListViewController.m
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ShopTakeoutListViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "shopTakeoutInfo.h"
#import "shopTakeoutTableViewCell.h"
#import "cateInfo.h"
#import "MXPullDownMenu.h"
#import "CSqlite.h"
#import "ShopTakeOutViewController.h"
#import "LocationListViewController.h"
#import "ShopTakeOutMapViewController.h"
#import "ShopTakeOutSearchViewController.h"

@interface ShopTakeoutListViewController ()<UITableViewDataSource,UITableViewDelegate,MXPullDownMenuDelegate,CLLocationManagerDelegate,locationDelegate>
{
    NSMutableArray *cateArray;
    NSMutableArray *shopArray;
    NSMutableArray *areaArray;
    NSMutableArray *sortArray;
    NSString *cate_id;
    NSString *area_id;
    NSString *sort_id;
    int page;
    //-----使用开启定位------------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    NSString *baidu_late;
    NSString *baidu_lng;
    //-------二级菜单-------------
    MXPullDownMenu *menu;
    
    UILabel *hintLable;//定位标签
}
@property (strong, nonatomic) UIButton *mapButton;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UITableView *shopTableview;
@property (strong, nonatomic) UIView *locateView;
@end

@implementation ShopTakeoutListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initData];
    [self setUI];
    [self openLocation];
    //如果未开启定位
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        [self getCateFromNet];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#define x_pi              (3.14159265358979324 * 3000.0 / 180.0)
#pragma mark------转换坐标
-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    NSLog(sql);
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
    [locationManager stopUpdatingLocation]; // 关闭定位
    CLLocationCoordinate2D mylocation = newLocation.coordinate;//手机GPS
    NSString *u_lat = [[NSString alloc]initWithFormat:@"%lf",mylocation.latitude];
    NSString *u_lng = [[NSString alloc]initWithFormat:@"%lf",mylocation.longitude];
    NSLog(@"未经过转换的经纬度是%@---%@",u_lat,u_lng);
    mylocation = [self zzTransGPS:mylocation];
    baidu_late = [[NSString alloc]initWithFormat:@"%lf",mylocation.latitude];
    baidu_lng = [[NSString alloc]initWithFormat:@"%lf",mylocation.longitude];
    double lat = [baidu_late floatValue];
    double lng = [baidu_lng floatValue];
    double baiDuLat , baiDuLng;
    double x = lng, y = lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    baiDuLng = z * cos(theta) + 0.0065;
    baiDuLat = z * sin(theta) + 0.006;
    baidu_late = [NSString stringWithFormat:@"%f",baiDuLat];
    baidu_lng = [NSString stringWithFormat:@"%f",baiDuLng];
    //保存
    [[NSUserDefaults standardUserDefaults]setObject:u_lat forKey:@"u_lat"];
    [[NSUserDefaults standardUserDefaults]setObject:u_lng forKey:@"u_lng"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //获取列表
    [self getCateFromNet];
}
// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [locationManager stopUpdatingLocation]; // 关闭定位
    NSLog(@"定位失败");
    //获取列表
    [self getCateFromNet];
}

#pragma mark---------initData
-(void)initData
{
    page = 1;
    shopArray = [[NSMutableArray alloc] init];
    cateArray = [[NSMutableArray alloc] init];
    areaArray = [[NSMutableArray alloc] init];
    sortArray = [[NSMutableArray alloc] init];
    cate_id = @"0";
    area_id = @"0";
    sort_id = @"0";
    //----经纬度------
    baidu_late = @"0";
    baidu_lng = @"0";
}

#pragma mark---------get cate
-(void)getCateFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"yz_take_cate");
    NSDictionary *dic = @{
                          @"app_key":url,
                          @"city_id":city_id
                          };
    [Base64Tool postSomethingToServe:url andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            //------------解析------------
            NSDictionary *dict = (NSDictionary*)param;
            [self parseCateDic:dict];
            [self getAreaFromNet];
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-----解析商家分类
-(void)parseCateDic :(NSDictionary*)dic
{
    [cateArray removeAllObjects];
    cateInfo *info0 = [[cateInfo alloc] init];
    info0.cate_name = @"分类";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    [cateArray addObject:info0];
    
    NSArray *cateArr = [dic objectForKey:@"obj"];
    for (NSDictionary *ele in cateArr) {
        cateInfo *info = [[cateInfo alloc] initWithDictinoary:ele];
        [cateArray addObject:info];
    }
}

-(void)getAreaFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"area_list");
    NSDictionary *dic = @{
                          @"app_key":url,
                          @"city_id":city_id
                          };
    [Base64Tool postSomethingToServe:url andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            //------------解析------------
            NSDictionary *dict = (NSDictionary*)param;
            [self parseAreaDic:dict];
            [self getDataFromNet];
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark------解析商圈分类
-(void)parseAreaDic :(NSDictionary*)dic
{
    [areaArray removeAllObjects];
    cateInfo *info0 = [[cateInfo alloc] init];
    info0.cate_name = @"商圈";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    [areaArray addObject:info0];
    
    NSArray *cateArr = [dic objectForKey:@"obj"];
    for (NSDictionary *ele in cateArr) {
        cateInfo *info = [[cateInfo alloc] initWithDictinoary:ele];
        [areaArray addObject:info];
    }
    [self addID];
    [self addCateList];
}

#pragma mark-----------存储各种排序分类的id
-(void)addID
{
    [sortArray removeAllObjects];
    cateInfo *info0 = [[cateInfo alloc] init];
    info0.cate_name = @"默认排序";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    cateInfo *info = [[cateInfo alloc] init];
    info.cate_name = @"销量排序";
    info.cate_id = @"num";
    info.son = [[NSMutableArray alloc] init];
    cateInfo *info1 = [[cateInfo alloc] init];
    info1.cate_name = @"评价排序";
    info1.cate_id = @"score";
    info1.son = [[NSMutableArray alloc] init];
    cateInfo *info2 = [[cateInfo alloc] init];
    info2.cate_name = @"添加时间";
    info2.cate_id = @"add_time";
    info2.son = [[NSMutableArray alloc] init];
    [sortArray addObjectsFromArray:@[info0,info,info1,info2]];
}

-(void)addCateList
{
    if (menu != nil) {
        [menu removeFromSuperview];
    }
    NSArray *testArray;
    testArray = @[ cateArray,areaArray,sortArray ];
    menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor redColor]];
    menu.delegate = self;
    CGRect rect = [[UIScreen mainScreen] bounds];
    menu.frame = CGRectMake(0, 0, rect.size.width, 36);
    menu.layer.borderWidth = 0.5;
    menu.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    [self.view addSubview:menu];
}

#pragma mark---------分类点击代理
#pragma mark - MXPullDownMenuDelegate 实现代理.
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row selectText:(NSString *)text
{
    //    NSLog(@"%d -- %d-----and text:%@", column, row ,text);
    //    NSString *str = [_listIdDict objectForKey:text];
    NSLog(@"点击了%@",text);
    switch (column) {
        case 0:
            cate_id = text;
            break;
        case 1:
            area_id = text;
            break;
        case 2:
            sort_id = text;
            break;
        default:
            break;
    }
    page = 1;
    [self getDataFromNet];
}

#pragma mark---------get data
-(void)getDataFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"takeout_list");
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:cate_id forKey:@"take_id"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [paramDic setObject:area_id forKey:@"area_id"];
    [paramDic setObject:sort_id forKey:@"order"];
    [paramDic setObject:baidu_late forKey:@"lat"];
    [paramDic setObject:baidu_lng forKey:@"lng"];
    [paramDic setObject:url forKey:@"app_key"];
    [paramDic setObject:city_id forKey:@"city_id"];
    [Base64Tool postSomethingToServe:url andParams:paramDic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            [SVProgressHUD dismiss];
            if (page == 1) {
                [shopArray removeAllObjects];
            }
            //------------解析------------
            NSArray *array = [param objectForKey:@"obj"];
            for (NSDictionary *dict in array) {
                shopTakeoutInfo *info = [[shopTakeoutInfo alloc] initWithDic:dict];
                [shopArray addObject:info];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
        [self.shopTableview reloadData];
        [self.shopTableview headerEndRefreshing];
        [self.shopTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark---------set UI
-(void)setUI
{
    [self.view addSubview:self.shopTableview];
    [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:36.0f];
    [self.view addSubview:self.locateView];
    [_locateView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_locateView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_locateView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_locateView autoSetDimension:ALDimensionHeight toSize:30.0f];
    [self setLoaction];
    
    //right button
    UIBarButtonItem *mapButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mapButton];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    NSArray *arr = @[searchButtonItem,mapButtonItem];
    self.navigationItem.rightBarButtonItems = arr;
}

-(void)setLoaction
{
    UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
    [imageView setImage:[UIImage imageNamed:@"group_map_no"]];
    [_locateView addSubview:imageView];
    hintLable = [[UILabel alloc] initForAutoLayout];
    [_locateView addSubview:hintLable];
    hintLable.font = [UIFont systemFontOfSize:12.0f];
    hintLable.textColor = [UIColor whiteColor];
    hintLable.text = @"点击可查看历史定位记录或切换位置";
    hintLable.textAlignment = NSTextAlignmentCenter;
    [hintLable autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [hintLable autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:hintLable withOffset:0.0f];
    [imageView autoSetDimension:ALDimensionHeight toSize:18.0f];
    [imageView autoSetDimension:ALDimensionWidth toSize:18.0f];
}

#pragma mark---------get UI

#pragma mark----------map 按钮
-(UIButton *)mapButton
{
    if (!_mapButton) {
        _mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_mapButton setImage:[UIImage imageNamed:@"group_map_no"] forState:UIControlStateNormal];
        [_mapButton setImage:[UIImage imageNamed:@"group_map_sel"] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
        _mapButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    }
    return _mapButton;
}

-(UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_searchButton setImage:[UIImage imageNamed:@"coupon_search_no"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"coupon_search_sel"] forState:UIControlStateHighlighted];
        [_searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    }
    return _searchButton;
}

#pragma mark------------button action
-(void)mapAction :(UIButton*)sender
{
    NSLog(@"跳转到地图");
    ShopTakeOutMapViewController *firVC = [[ShopTakeOutMapViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"地图" withFont:14.0f];
    firVC.category      = cate_id;
    firVC.identifer     = area_id;
//    [firVC.navigationItem setTitle:@"搜索附近外卖"];
    [self.navigationController pushViewController:firVC animated:YES];
//    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"MapStoryboard" bundle:nil];
//    ORAShopMapsViewController *firVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"mapView"];
//    [firVC setHiddenTabbar:YES];
//    [firVC.navigationItem setTitle:@"商家分布地图"];
//    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)searchAction :(UIButton*)sender
{
    NSLog(@"跳转到搜索");
    ShopTakeOutSearchViewController *firVC = [[ShopTakeOutSearchViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    firVC.u_lng = baidu_lng;
    firVC.u_lat = baidu_late;
    [self.navigationController pushViewController:firVC animated:YES];
//    SearchViewController *firVC = [[SearchViewController alloc] init];
//    firVC.u_lat = baidu_late;
//    firVC.u_lng = baidu_lng;
//    [firVC setHiddenTabbar:YES];
//    [self.navigationController pushViewController:firVC animated:YES];
}


-(UITableView *)shopTableview
{
    if (!_shopTableview) {
        _shopTableview = [[UITableView alloc] initForAutoLayout];
        _shopTableview.delegate = self;
        _shopTableview.dataSource = self;
        [_shopTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_shopTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _shopTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _shopTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _shopTableview.footerRefreshingText = @" ";
        _shopTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _shopTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _shopTableview.headerRefreshingText = @" ";
        [UZCommonMethod hiddleExtendCellFromTableview:_shopTableview];
        if ([_shopTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_shopTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_shopTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_shopTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _shopTableview;
}

#pragma mark---------上拉 下拉
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    [SVProgressHUD showWithStatus:@"正在加载"];
    page = 1;
    [locationManager startUpdatingLocation]; // 开始定位
}

-(void)footerBeginRefreshing
{
    NSLog(@"上拉加载");
    [SVProgressHUD showWithStatus:@"正在加载"];
    page++;
    [self getDataFromNet];
}

-(UIView *)locateView
{
    if (!_locateView) {
        _locateView = [[UIView alloc] initForAutoLayout];
        _locateView.backgroundColor = [UIColor lightGrayColor];
        _locateView.userInteractionEnabled = YES;
        [_locateView setAlpha:0.9];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jump2locatinoView)];
        [_locateView addGestureRecognizer:gesture];
    }
    return _locateView;
}

#pragma mark---------跳转location 界面
-(void)jump2locatinoView
{
    NSLog(@"跳转到定位界面");
    LocationListViewController *firVC = [[LocationListViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    firVC.delegate = self;
    [firVC setNavBarTitle:@"定位您当前位置" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"定位您当前的位置"];
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)locationCurrentPostion:(locatinoInfo *)info
{
    //--------------------------------
    hintLable.text = info.location_name;
    //--------------------------------
    NSString *currentPos = info.location_name;
    NSString *lng = info.location_lng;
    NSString *lat = info.location_lat;
    //--------------刷新列表------------
    page = 1;
    baidu_late = lat;
    baidu_lng = lng;
    [self getDataFromNet];
}

#pragma mark---------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    shopTakeoutInfo *info = [shopArray objectAtIndex:indexPath.row];
    if ([info.is_ship isEqualToString:@"2"]) {
        ShopTakeOutViewController *firVC = [[ShopTakeOutViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:info.shop_name withFont:14.0f];
//        [firVC.navigationItem setTitle:info.shop_name];
        firVC.info = info;
        firVC.shop_id = info.shop_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"shop_takeout_cell";
    shopTakeoutTableViewCell *cell=(shopTakeoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[shopTakeoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    shopTakeoutInfo *info = [shopArray objectAtIndex:indexPath.row];
    [cell configureCell:info];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shopArray count];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
