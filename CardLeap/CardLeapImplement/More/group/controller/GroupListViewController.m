//
//  GroupListViewController.m
//  CardLeap
//
//  Created by mac on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "GroupListViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MXPullDownMenu.h"
#import "cateInfo.h"
#import "CSqlite.h"
#import "groupInfo.h"
#import "groupListTableViewCell.h"
#import "GroupDetailViewController.h"
#import "GroupMapViewController.h"
#import "GroupSearchViewController.h"

@interface GroupListViewController ()<UITableViewDataSource,UITableViewDelegate,MXPullDownMenuDelegate,CLLocationManagerDelegate>
{
    int page;
    NSString *cate_id;
    NSString *sort_id;
    NSString *area_id;
    NSString *baidu_lat;
    NSString *baidu_lng;
    NSMutableArray *groupArray;
    //-----------------------
    NSMutableArray *cateArray;
    NSMutableArray *areaArray;
    NSMutableArray *sortArray;
    //-------二级菜单----------
    MXPullDownMenu *menu;
    //-----使用开启定位--------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
}
@property (strong,nonatomic)UITableView *groupListTableview;
@property (strong,nonatomic)UIButton *mapButton;
@property (strong,nonatomic)UIButton *searchButton;
@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    //[self getDataFromNet];
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
    NSLog(@"%@",sql);
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


#pragma mark--------init data
-(void)initData
{
    page = 1;
    groupArray = [[NSMutableArray alloc] init];
    cateArray = [[NSMutableArray alloc] init];
    areaArray = [[NSMutableArray alloc] init];
    sortArray = [[NSMutableArray alloc] init];
    cate_id = @"0";
    area_id = @"0";
    sort_id = @"0";
    //----经纬度------
    baidu_lat = @"0";
    baidu_lng = @"0";
}

#pragma mark--------get data
#pragma mark---------get cate
-(void)getCateFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"group_cate");
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
    info0.cate_name = @"排序";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    
    cateInfo *info = [[cateInfo alloc] init];
    info.cate_name = @"评价排序";
    info.cate_id = @"score";
    info.son = [[NSMutableArray alloc] init];
    
    cateInfo *info1 = [[cateInfo alloc] init];
    info1.cate_name = @"距离排序";
    info1.cate_id = @"address";
    info1.son = [[NSMutableArray alloc] init];
    
    cateInfo *info2 = [[cateInfo alloc] init];
    info2.cate_name = @"最新发布";
    info2.cate_id = @"time";
    info2.son = [[NSMutableArray alloc] init];
    
    cateInfo *info3 = [[cateInfo alloc] init];
    info3.cate_name = @"价格升序";
    info3.cate_id = @"now_price_h";
    info3.son = [[NSMutableArray alloc] init];
    
    cateInfo *info4 = [[cateInfo alloc] init];
    info4.cate_name = @"价格降序";
    info4.cate_id = @"now_price_d";
    info4.son = [[NSMutableArray alloc] init];
    
    [sortArray addObjectsFromArray:@[info0,info,info1,info2,info3,info4]];
}

-(void)addCateList
{
    if (menu != nil) {
        [menu removeFromSuperview];
    }
    NSArray *testArray;
    testArray = @[ cateArray,areaArray,sortArray ];
    menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor greenColor]];
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


-(void)getDataFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"group_list");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"cat_id":cate_id,
                           @"area_id":area_id,
                           @"lng":baidu_lng,
                           @"lat":baidu_lat,
                           @"order":sort_id,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"city_id":city_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            if (page == 1) {
                [groupArray removeAllObjects];
            }
            NSArray *tmpArray = param[@"obj"];
            for (NSDictionary *dic in tmpArray) {
                groupInfo *info = [[groupInfo alloc] initWithDictionary:dic];
                [groupArray addObject:info];
            }
            [self.groupListTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"code"]];
        }
        [self.groupListTableview headerEndRefreshing];
        [self.groupListTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark--------set UI
-(void)setUI
{
    [self.view addSubview:self.groupListTableview];
    [_groupListTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:36.0f];
    [_groupListTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_groupListTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_groupListTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    
    //right button
    UIBarButtonItem *mapButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mapButton];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    NSArray *arr = @[searchButtonItem,mapButtonItem];
    self.navigationItem.rightBarButtonItems = arr;
}

#pragma mark--------get UI
-(UIButton *)mapButton
{
    if (!_mapButton) {
        _mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_mapButton setImage:[UIImage imageNamed:@"group_map_no"] forState:UIControlStateNormal];
        [_mapButton setImage:[UIImage imageNamed:@"group_map_sel"] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
        _mapButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -20);
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

-(UITableView *)groupListTableview
{
    if (!_groupListTableview) {
        _groupListTableview = [[UITableView alloc] init];
        _groupListTableview.delegate = self;
        _groupListTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_groupListTableview];
        _groupListTableview.separatorInset = UIEdgeInsetsZero;
        _groupListTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_groupListTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_groupListTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _groupListTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _groupListTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _groupListTableview.footerRefreshingText = @"正在努力加载";
        _groupListTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _groupListTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _groupListTableview.headerRefreshingText = @"正在刷新";
        
        if ([_groupListTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_groupListTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_groupListTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_groupListTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _groupListTableview;
}

#pragma mark--------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    groupInfo *info = [groupArray objectAtIndex:indexPath.row];
    GroupDetailViewController *firVC = [[GroupDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"团购详情" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"团购详情"];
    firVC.group_id = info.group_id;
    firVC.info = info;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"group_cell";
    groupListTableViewCell *cell=(groupListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[groupListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 200, 10)];
    //    view.backgroundColor = [UIColor grayColor];
    //    cell.selectedBackgroundView = view;
    
    groupInfo *info = [groupArray objectAtIndex:indexPath.row];
    [cell confirgureCell:info];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groupArray count];
}

#pragma mark--------action
-(void)mapAction:(UIButton*)sender
{
    NSLog(@"go to map");
    GroupMapViewController *firVC = [[GroupMapViewController alloc] init];
    firVC.category  = cate_id;
    firVC.identifer = area_id;
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"搜索附近团购" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"搜索附近的团购"];
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)searchAction:(UIButton*)sender
{
    NSLog(@"go to search");
    GroupSearchViewController *firVC = [[GroupSearchViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"搜索团购" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"搜索团购"];
    firVC.u_lat = baidu_lat;
    firVC.u_lng = baidu_lng;
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark-------refresh
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    page = 1;
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    NSLog(@"上拉加载");
    page++;
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

@end
