//
//  ShopListViewController.m
//  CardLeap
//
//  Created by lin on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  商家列表（TabBar）

#import "ShopListViewController.h"
#import "CSqlite.h"
#import "UIScrollView+MJRefresh.h"
#import "ShopListInfo.h"
//cell
#import "shopListTableViewCell.h"
#import "ShopDetailViewController.h"
#import "SearchViewController.h"
#import "ORAShopMapsViewController.h"
#import "cateInfo.h"
#import "MXPullDownMenu.h"

@interface ShopListViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MXPullDownMenuDelegate>
{
    //-----使用开启定位------------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    NSString *baidu_late;
    NSString *baidu_lng;
}
@property (strong, nonatomic) UITableView *shopTableview;//商家列表
@property (strong, nonatomic) UIButton *mapButton;//地图按钮
@property (strong, nonatomic) UIButton *searchButton;//搜索按钮
@property (strong, nonatomic) UIButton *backButton;//返回按钮
//-------------数据集合----------------------
@property (strong, nonatomic) NSMutableArray *shopArray;//商家列表数据集合
@property (strong, nonatomic) NSMutableArray *cateList;//分类数组 -- 废弃
@property (strong, nonatomic) NSString *cat_id;//分类id
@property (strong, nonatomic) NSString *area_id;//商圈id
@property (strong, nonatomic) NSString *sort_id;//排序字段
@property (strong, nonatomic) NSString *page;//分页
@property (strong, nonatomic) NSMutableDictionary *pramasDict;
//-------------关于分类----被废弃------------------
@property (strong, nonatomic) NSMutableDictionary *cateDict;
@property (strong, nonatomic) NSMutableDictionary *sortDict;
@property (strong, nonatomic) NSMutableDictionary *areaDict;
@property (strong, nonatomic) NSMutableDictionary *listIdDict;//
//-------------关于分类----------------------
@property (strong, nonatomic) NSMutableArray *cateArray;//存储分类的数组
@property (strong, nonatomic) NSMutableArray *sortArray;//存储排序的数组
@property (strong, nonatomic) NSMutableArray *areaArray;//存储商圈的数组
@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@"正在加载，请稍等" maskType:SVProgressHUDMaskTypeClear];
    [self setUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //    if (![self.is_hidden isEqualToString:@"0"]) {
    //        [self setHiddenTabbar:YES];
    //    }else{
    [self setHiddenTabbar:NO];
    //    }
}

- (void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark------get data from net
-(void)getCateFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"cate_list");
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
    [_cateArray removeAllObjects];
    cateInfo *info0 = [[cateInfo alloc] init];
    info0.cate_name = @"分类";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    [_cateArray addObject:info0];
    
    NSArray *cateArr = [dic objectForKey:@"obj"];
    for (NSDictionary *ele in cateArr) {
        cateInfo *info = [[cateInfo alloc] initWithDictinoary:ele];
        [_cateArray addObject:info];
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
    [_areaArray removeAllObjects];
    cateInfo *info0 = [[cateInfo alloc] init];
    info0.cate_name = @"商圈";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    [_areaArray addObject:info0];
    
    NSArray *cateArr = [dic objectForKey:@"obj"];
    for (NSDictionary *ele in cateArr) {
        cateInfo *info = [[cateInfo alloc] initWithDictinoary:ele];
        [_areaArray addObject:info];
    }
    
    [self addID];
    [self addCateList];
}
#pragma mark-----------存储各种排序分类的id
-(void)addID
{
    [_sortArray removeAllObjects];
    cateInfo *info0 = [[cateInfo alloc] init];
    info0.cate_name = @"排序";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    cateInfo *info = [[cateInfo alloc] init];
    info.cate_name = @"评分最高";
    info.cate_id = @"score";
    info.son = [[NSMutableArray alloc] init];
    cateInfo *info1 = [[cateInfo alloc] init];
    info1.cate_name = @"距离最近";
    info1.cate_id = @"distance";
    info1.son = [[NSMutableArray alloc] init];
    cateInfo *info2 = [[cateInfo alloc] init];
    info2.cate_name = @"评论最多";
    info2.cate_id = @"time";
    info2.son = [[NSMutableArray alloc] init];
    [_sortArray addObjectsFromArray:@[info0,info,info1,info2]];
}

-(void)getDataFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"shop_list");
    [_pramasDict setObject:_cat_id forKey:@"cat_id"];
    [_pramasDict setObject:_page forKey:@"page"];
    [_pramasDict setObject:_area_id forKey:@"area_id"];
    [_pramasDict setObject:_sort_id forKey:@"order"];
    [_pramasDict setObject:baidu_late forKey:@"lat"];
    [_pramasDict setObject:baidu_lng forKey:@"lng"];
    [_pramasDict setObject:url forKey:@"app_key"];
    [_pramasDict setObject:city_id forKey:@"city_id"];
    if (ApplicationDelegate.islogin == NO) {
        [_pramasDict setObject:@"0" forKey:@"u_id"];
    }else{
        [_pramasDict setObject:[UserModel shareInstance].u_id forKey:@"u_id"];
    }
    [Base64Tool postSomethingToServe:url andParams:_pramasDict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",param);
            //-----------------解析------------------
            NSDictionary *dic = (NSDictionary*)param;
            [self parseShopList:dic];
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self.shopTableview headerEndRefreshing];
        [self.shopTableview footerEndRefreshing];
    }];
}

#pragma mark------解析列表数据
-(void)parseShopList :(NSDictionary*)dic
{
    if ([_page isEqualToString:@"1"]) {
        [_shopArray removeAllObjects];
    }
    NSArray *arr = [dic objectForKey:@"obj"];
    for (NSDictionary *dic in arr) {
        ShopListInfo *info = [[ShopListInfo alloc] initWithDictionary:dic];
        [_shopArray addObject:info];
    }
    [self.shopTableview headerEndRefreshing];
    [self.shopTableview footerEndRefreshing];
    //刷新列表
    [self.shopTableview reloadData];
}

#pragma mark------init data
-(void)initData
{
    //---------------下拉分类,暂时使用------------------
    _cateDict = [[NSMutableDictionary alloc] init];
    _areaDict = [[NSMutableDictionary alloc] init];
    _sortDict = [[NSMutableDictionary alloc] init];
    _listIdDict = [[NSMutableDictionary alloc] init];
    
    _areaArray = [[NSMutableArray alloc] init];
    _sortArray = [[NSMutableArray alloc] init];
    _cateArray = [[NSMutableArray alloc] init];
    //-----------------------------------------------
    _shopArray = [[NSMutableArray alloc] init];
    _cateList = [[NSMutableArray alloc] init];
    _pramasDict = [[NSMutableDictionary alloc] init];
    if (self.shop_id == nil) {
        _cat_id = @"0";
    }else{
        _cat_id = self.shop_id;
    }
    _page = @"1";
    _area_id = @"0";
    _sort_id = @"0";
    baidu_late = @"0";
    baidu_lng = @"0";
    [self openLocation];
    //如果未开启定位
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        [self getCateFromNet];
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

#pragma mark------get UI
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

#pragma mark---------上拉 下拉 刷新方法
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    [SVProgressHUD showWithStatus:@"正在加载"];
    _page = @"1";
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    NSLog(@"上拉加载");
    [SVProgressHUD showWithStatus:@"正在加载"];
    int page = [_page intValue]+1;
    _page = [NSString stringWithFormat:@"%d",page];
    [self getDataFromNet];
}

#pragma mark----------map 按钮
-(UIButton *)mapButton
{
    if (!_mapButton) {
        _mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_mapButton setImage:[UIImage imageNamed:@"group_map_no"] forState:UIControlStateNormal];
        [_mapButton setImage:[UIImage imageNamed:@"group_map_sel"] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
        _mapButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, -20);
    }
    return _mapButton;
}
#pragma mark - 返回按钮
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_backButton setImage:[UIImage imageNamed:@"navbar_return_no"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"navbar_return_sel"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(-22, -10, 0, -10);
    }
    return _backButton;
}
#pragma mark--------搜索按钮
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

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark------------跳转到地图界面
-(void)mapAction :(UIButton*)sender
{
    NSLog(@"跳转到地图");
    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"MapStoryboard" bundle:nil];
    ORAShopMapsViewController *firVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"mapView"];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"地图" withFont:14.0f];
    firVC.shopListDic = _pramasDict;
    //    [firVC.navigationItem setTitle:@"商家分布地图"];
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark-------跳转到搜索界面
-(void)searchAction :(UIButton*)sender
{
    NSLog(@"跳转到搜索");
    SearchViewController *firVC = [[SearchViewController alloc] init];
    firVC.u_lat = baidu_late;
    firVC.u_lng = baidu_lng;
    [firVC setHiddenTabbar:YES];
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark------set UI
-(void)setUI
{
    //tableview
    [self.view addSubview:self.shopTableview];
    [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:36.0f];
    if (![self.is_hidden isEqualToString:@"0"]) {
        [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:44.0f];
    }else{
        [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    }
    [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    //right bar
    UIBarButtonItem *mapButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mapButton];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    NSArray *arr = @[backButtonItem,mapButtonItem];
    if ([_is_hidden isEqualToString:@"0"]) {
        self.navigationItem.leftBarButtonItems = arr;
    }else{
        self.navigationItem.leftBarButtonItem   =   mapButtonItem;
    }
    self.navigationItem.rightBarButtonItem  =   searchButtonItem;
    if ([self.is_hidden isEqualToString:@"0"]) {
        [self.navigationItem setHidesBackButton:YES];
    }
    [self setNavBarTitle:@"商家列表" withFont:17.0f];
}

-(void)addCateList
{
    NSArray *testArray;
    testArray = @[ _cateArray,_areaArray,_sortArray ];
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor greenColor]];
    menu.delegate = self;
    CGRect rect = [[UIScreen mainScreen] bounds];
    menu.frame = CGRectMake(0, 0, rect.size.width, 36);
    menu.layer.borderWidth = 0.5;
    menu.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    [self.view addSubview:menu];
    if (self.cate_name!=nil && self.cate_name.length > 0) {
        //设置标题
        [menu setCateTitle:self.cate_name];
    }
#pragma mark --- 11.26 社区服务分类4个字变2个字(未解决)
}

#pragma mark - MXPullDownMenuDelegate 实现代理.
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row selectText:(NSString *)text
{
    NSLog(@"点击了%@",text);
    switch (column) {
        case 0:
            _cat_id = text;
            break;
        case 1:
            _area_id = text;
            break;
        case 2:
            _sort_id = text;
            break;
        default:
            break;
    }
    _page = @"1";
    [self getDataFromNet];
}

#pragma mark-----------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"进入商家详情");
    ShopDetailViewController *firVC = [[ShopDetailViewController alloc] init];
    [firVC setNavBarTitle:@"商家详情" withFont:14.0f];
    ShopListInfo *info = [_shopArray objectAtIndex:indexPath.row];
    firVC.info = info;
    firVC.shop_id = info.shop_id;
    firVC.my_lat = baidu_late;
    firVC.my_lng = baidu_lng;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"index_cell";
    shopListTableViewCell *cell=(shopListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[shopListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //删除cell中原有元素
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    ShopListInfo *info = [_shopArray objectAtIndex:indexPath.row];
    [cell configureCell:info];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shopArray count];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.5;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 2.0f;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
