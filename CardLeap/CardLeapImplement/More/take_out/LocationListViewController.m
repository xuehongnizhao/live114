//
//  LocationListViewController.m
//  CardLeap
//
//  Created by lin on 1/6/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "LocationListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CSqlite.h"


@interface LocationListViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *locationArray ;
    //-----使用开启定位------------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    NSString *baidu_late;
    NSString *baidu_lng;
    //-----当前位置----------------
    //locatinoInfo *info;
    BOOL is_location;
}
@property (strong, nonatomic) UITableView *locationTableview;
@end

@implementation LocationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self openLocation];
    //如果未开启定位
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        [SVProgressHUD showErrorWithStatus:@"您未开启定位"];
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
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mylocation.latitude longitude:mylocation.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *mark=[placemark objectAtIndex:0];
         NSString *title = [NSString stringWithFormat:@"%@",mark.name];//获取subtitle的信息;
         NSString *subTitle = [NSString stringWithFormat:@"%@%@%@",mark.subLocality,mark.thoroughfare,mark.subThoroughfare];
         NSString *myLocation = [NSString stringWithFormat:@"%@",subTitle];
         NSDictionary *locationDic = @{
                                       @"location_name":myLocation,
                                       @"location_lng":baidu_lng,
                                       @"locatino_lat":baidu_late
                                       };
         NSMutableArray *array = [[NSMutableArray alloc] init ];
         [array addObject:locationDic];
         NSArray *tmpArray = userDefault(@"LocatinoHistory");
         if (tmpArray != nil) {
             if ([tmpArray count]>4) {
                 for (int i=0; i<=3; i++) {
                     NSDictionary *dic = [tmpArray objectAtIndex:i];
                     [array addObject:dic];
                 }
             }else{
                 [array addObjectsFromArray:tmpArray];
             }
         }
         [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"LocatinoHistory"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         NSArray *tmpArray1 = userDefault(@"LocatinoHistory");
        //-------读取历史记录--------------------------
         [locationArray removeAllObjects];
         for (NSDictionary *dic in tmpArray1) {
             locatinoInfo *info  = [[locatinoInfo alloc] initWithDictionary:dic];
             [locationArray addObject:info];
         }


        is_location = YES;
          [locationManager stopUpdatingLocation]; // 关闭定位
         [self.locationTableview reloadData];
     } ];
}
// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [locationManager stopUpdatingLocation]; // 关闭定位
    NSLog(@"定位失败");
    //获取列表
}


#pragma mark-------------get UI
-(UITableView *)locationTableview
{
    if (!_locationTableview) {
        _locationTableview = [[UITableView alloc] init];
        _locationTableview.delegate = self;
        _locationTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_locationTableview];
    }
    return _locationTableview;
}
#pragma mark-------------set UI
-(void)setUI
{
    [self.view addSubview:self.locationTableview];
    [_locationTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_locationTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_locationTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_locationTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
}

#pragma mark-------------init data
-(void)initData
{
    is_location = NO;
    locationArray = [[NSMutableArray alloc] init];
    //-------读取历史记录--------------------------
    NSArray *tmpArray1 = userDefault(@"LocatinoHistory");
    //-------读取历史记录--------------------------
    if (tmpArray1!=nil) {
        for (NSDictionary *dic in tmpArray1) {
            locatinoInfo *info  = [[locatinoInfo alloc] initWithDictionary:dic];
            [locationArray addObject:info];
        }
    }
}

#pragma mark-------------tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }else{
        return 30.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *historyView = [[UIView alloc] init];
    historyView.backgroundColor = [UIColor lightGrayColor];
    UILabel *historyLable = [[UILabel alloc] initForAutoLayout];
    [historyView addSubview:historyLable];
    [historyLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [historyLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [historyLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [historyLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    historyLable.font = [UIFont systemFontOfSize:13.0f];
    historyLable.text = @"定位历史记录";
    historyLable.textColor = UIColorFromRGB(0x484848);
    return historyView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击返回");
    locatinoInfo *info = [locationArray objectAtIndex:indexPath.row];
    [self.delegate locationCurrentPostion:info];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [locationArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"location_address_cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    if (indexPath.section == 0) {
        if ([locationArray count]==0 || is_location == NO) {
            cell.textLabel.text = @"正在获取您当前位置。。。";
        }else{
            locatinoInfo *info = [locationArray objectAtIndex:indexPath.row];
            cell.textLabel.text = info.location_name;
        }

    }else{
        locatinoInfo *info = [locationArray objectAtIndex:indexPath.row];
        cell.textLabel.text = info.location_name;
//        cell.backgroundColor = [UIColor lightGrayColor];
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//        cell.contentView.layer.borderWidth = 1;
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.layer.masksToBounds = YES;
//        cell.layer.cornerRadius = 4.0;
//        UILabel *lalbe = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
//        lalbe.text = @"00";
//        [cell.contentView addSubview:lalbe];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
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
