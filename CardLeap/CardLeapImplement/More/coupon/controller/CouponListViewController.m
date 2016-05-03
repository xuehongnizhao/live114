//
//  CouponListViewController.m
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "CouponListViewController.h"
#import "couponInfo.h"
#import "CouponCollectionViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "cateInfo.h"
#import "MXPullDownMenu.h"
#import "CouponDetailViewController.h"
#import "CouPonSearchViewController.h"

@interface CouponListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MXPullDownMenuDelegate,UICollectionViewDelegateFlowLayout>
{
    int page;
    NSString *cate;
    NSString *area;
    NSString *baidu_lat;
    NSString *baidu_lng;
    NSString *order;
    NSMutableArray *couponArray;
    //-----------------------
    NSMutableArray *cateArray;
    NSMutableArray *shopArray;
    NSMutableArray *areaArray;
    NSMutableArray *sortArray;
    //-------二级菜单-------------
    MXPullDownMenu *menu;
    //-----使用开启定位------------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
}
@property (strong, nonatomic) UICollectionView *couponCollectionview;
@property (strong, nonatomic) UIButton *searchButton;
@end

@implementation CouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self openLocation];
    //如果未开启定位
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        [self getCateFromNet];
    }
    //[self getDataListFromNet];
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

#pragma mark-----------get data
#pragma mark---------get cate
-(void)getCateFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"spike_cate_list");
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
            [self getDataListFromNet];
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

    cateInfo *info1 = [[cateInfo alloc] init];
    info1.cate_name = @"距离排序";
    info1.cate_id = @"address";
    info1.son = [[NSMutableArray alloc] init];
    cateInfo *info2 = [[cateInfo alloc] init];
    info2.cate_name = @"剩余数量";
    info2.cate_id = @"num";
    info2.son = [[NSMutableArray alloc] init];
    [sortArray addObjectsFromArray:@[info0,info1,info2]];
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
            cate = text;
            break;
        case 1:
            area = text;
            break;
        case 2:
            order = text;
            break;
        default:
            break;
    }
    page = 1;
    [self getDataListFromNet];
}

#pragma mark-----------set UI
-(void)setUI
{
    [self.view addSubview:self.couponCollectionview];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}
#pragma mark-----------get UI
//创建collection cell
-(UICollectionView *)couponCollectionview
{
    if (!_couponCollectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(100,100);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _couponCollectionview = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _couponCollectionview.backgroundColor = [UIColor whiteColor];
        _couponCollectionview.translatesAutoresizingMaskIntoConstraints = NO;
        [_couponCollectionview registerClass:[CouponCollectionViewCell class] forCellWithReuseIdentifier:@"coupon_cell"];
        _couponCollectionview.scrollEnabled = YES;
        _couponCollectionview.delegate = self;
        _couponCollectionview.dataSource = self;
        [_couponCollectionview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_couponCollectionview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _couponCollectionview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _couponCollectionview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _couponCollectionview.footerRefreshingText = @"正在加载，请稍等";
        _couponCollectionview.headerPullToRefreshText = @"下拉可以刷新了";
        _couponCollectionview.headerReleaseToRefreshText = @"松开马上刷新了";
        _couponCollectionview.headerRefreshingText = @"正在刷新，请稍等";
    }
    return _couponCollectionview;
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

#pragma mark-----------next page and regresh
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    page = 1;
    [locationManager startUpdatingLocation];
}

-(void)footerBeginRefreshing
{
    NSLog(@"上拉加载更多");
    page++;
    [self getDataListFromNet];
}

#pragma mark-----------collection view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"点击进入详情");
    couponInfo *info = [couponArray objectAtIndex:indexPath.row];
    CouponDetailViewController *firVC = [[CouponDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:info.spike_name withFont:14.0f];
    firVC.info = info;
    firVC.message_url = info.message_url;
    firVC.share_url = info.message_url;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [couponArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"coupon_cell";
    CouponCollectionViewCell *cell=(CouponCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    couponInfo *info = [couponArray objectAtIndex:indexPath.row];
    [cell configureCell:info];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(140*LinPercent,167*LinPercent);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 13, 0, 13); // top, left, bottom, right
}

#pragma mark-----------init data
-(void)initData
{
    page = 1;
    cate = @"0";
    area = @"0";
    baidu_lat = @"121.021";
    baidu_lng = @"23.02155";
    order = @"0";
    couponArray = [[NSMutableArray alloc] init];
    //--------二级下拉列表---------
    cateArray = [[NSMutableArray alloc] init];
    areaArray = [[NSMutableArray alloc] init];
    sortArray = [[NSMutableArray alloc] init];
}

#pragma mark-----------get data from net work
-(void)getDataListFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"spike_list");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"cate":cate,
                           @"area":area,
                           @"lng":baidu_lng,
                           @"lat":baidu_lat,
                           @"order":order,
                           @"city_id":city_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            if (page == 1) {
                [couponArray removeAllObjects];
            }
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                couponInfo *info = [[couponInfo alloc] initWithDictionary:dic];
                [couponArray addObject:info];
            }
            [self.couponCollectionview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.couponCollectionview headerEndRefreshing];
        [self.couponCollectionview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self.couponCollectionview headerEndRefreshing];
        [self.couponCollectionview footerEndRefreshing];
    }];
}

#pragma mark------------search action
-(void)searchAction:(UIButton*)sender
{
    NSLog(@"跳转到搜索界面");
    CouPonSearchViewController *firVC = [[CouPonSearchViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    firVC.u_lat = baidu_lat;
    firVC.u_lng = baidu_lng;
    [firVC setNavBarTitle:@"搜索团购" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"搜索团购"];
    [self.navigationController pushViewController:firVC animated:YES];
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
