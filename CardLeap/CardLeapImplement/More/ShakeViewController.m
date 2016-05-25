//
//  ShakeViewController.m
//  cityo2o
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 Sky. All rights reserved.
//龙广摇一摇

#import "ShakeViewController.h"
#import <MaMapKit/MAMapKit.h>
#import "HMSegmentedControl.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "UploadConditonViewController.h"
#import "HighWayViewController.h"
@interface ShakeViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL isFirstShake;
    NSString *_annotationImageName;
    UITextField *_textField;
}
@property (strong, nonatomic) UIImageView *firstEntry;
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) HMSegmentedControl *segmentB;
@property (strong, nonatomic) AMapSearchAPI *search;
@property (strong, nonatomic) UIImageView *shakeForService;
@property (strong, nonatomic) UIButton *myLocation;
@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITableView *searchTableVeiw;
@property (strong, nonatomic) UIView *tableHeadView;
@property (strong, nonatomic) NSMutableArray *searchDataList;
@property (strong, nonatomic) UIButton *highwayCondition;
@property (strong, nonatomic) UIButton *uploadCondition;
@property (strong, nonatomic) NSMutableArray *nearbyRoad;

@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setHiddenTabbar:YES];
    [self setUI];

}
- (UIButton *)highwayCondition{
    if (!_highwayCondition) {
        _highwayCondition=[[UIButton alloc]initForAutoLayout];
        [_highwayCondition setImage:[UIImage imageNamed:@"highway_condition"] forState:UIControlStateNormal];
        [_highwayCondition addTarget:self action:@selector(highwayConditionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _highwayCondition;
}
- (UIButton *)uploadCondition{
    if (!_uploadCondition) {
        _uploadCondition=[[UIButton alloc]initForAutoLayout];
        [_uploadCondition setImage:[UIImage imageNamed:@"update_road_condition"] forState:UIControlStateNormal];
        [_uploadCondition addTarget:self action:@selector(uploadConditionAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _uploadCondition;
}
- (NSMutableArray *)searchDataList{
    if (!_searchDataList) {
        _searchDataList=[NSMutableArray array];
    }
    return _searchDataList;
}
- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _textField=[[UITextField alloc]initForAutoLayout];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.returnKeyType =UIReturnKeyDone;
        _textField.placeholder=@"搜地点、查路况";
        _textField.textAlignment=NSTextAlignmentCenter;
        _textField.delegate=self;
        [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        UIButton *dissMissSearchView=[[UIButton alloc]initForAutoLayout];
        [dissMissSearchView addTarget:self action:@selector(dissMissSearchViewAction2) forControlEvents:UIControlEventTouchUpInside];
        [dissMissSearchView setImage:[UIImage imageNamed:@"back_shake"] forState:UIControlStateNormal];
        _tableHeadView=[[UIView alloc]initForAutoLayout];
        [_tableHeadView addSubview:dissMissSearchView];
        [dissMissSearchView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [dissMissSearchView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [dissMissSearchView autoSetDimensionsToSize:CGSizeMake(40, 40)];
        [_tableHeadView addSubview:_textField];
        [_textField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [_textField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [_textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [_textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:dissMissSearchView withOffset:5];
        
    }
    return _tableHeadView;
}
- (UITableView *)searchTableVeiw{
    if (!_searchTableVeiw) {
        _searchTableVeiw=[[UITableView alloc]initForAutoLayout];
        _searchTableVeiw.delegate=self;
        _searchTableVeiw.dataSource=self;
        
    }
    return _searchTableVeiw;
}
- (UIView *)searchView{
    if (!_searchView) {
        _searchView=[[UIView alloc]initForAutoLayout];
        _searchView.backgroundColor=[UIColor whiteColor];
        [_searchView addSubview:self.tableHeadView];
        [_tableHeadView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [_tableHeadView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_tableHeadView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_tableHeadView autoSetDimension:ALDimensionHeight toSize:50];
        [_searchView addSubview:self.searchTableVeiw];
        [_searchTableVeiw autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_searchTableVeiw autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_searchTableVeiw autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_searchTableVeiw autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_tableHeadView];
        
    }
    return _searchView;
}
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"coupon_search_no"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    }
    return _rightItem;
}
- (UIButton *)myLocation{
    if (!_myLocation) {
        _myLocation=[[UIButton alloc]initForAutoLayout];
        [_myLocation addTarget:self action:@selector(goToMyLocation) forControlEvents:UIControlEventTouchUpInside];
        [_myLocation setImage:[UIImage imageNamed:@"my_location"] forState:UIControlStateNormal];
    }
    return _myLocation;
}
- (UIImageView *)shakeForService{
    if (!_shakeForService) {
        _shakeForService=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shakeEntry"]];
    }
    return _shakeForService;
}
- (NSMutableArray *)nearbyRoad{
    if (!_nearbyRoad) {
        _nearbyRoad=[NSMutableArray array];
    }
    return _nearbyRoad;
}
- (AMapSearchAPI *)search{
    if (!_search) {
        //配置用户Key
        [AMapSearchServices sharedServices].apiKey = GaoDeKey;
        
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        
    }
    return _search;
}
- (HMSegmentedControl *)segmentB{
    if (!_segmentB) {
        NSArray *imageList=@[[UIImage imageNamed:@"park"],[UIImage imageNamed:@"gas_station"],[UIImage imageNamed:@"vehicle_servicing"],[UIImage imageNamed:@"special_offers"]];
        _segmentB=[[HMSegmentedControl alloc]initWithSectionImages:imageList sectionSelectedImages:nil];
        [_segmentB setSelectedSegmentIndex:3 animated:NO];
        _segmentB.selectionIndicatorLocation=HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentB.backgroundColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0];
        [_segmentB addTarget:self action:@selector(segmetBAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentB;
}
- (MAMapView *)mapView{
    if (!_mapView) {
        [MAMapServices sharedServices].apiKey = GaoDeKey;
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.delegate = self;
        _mapView.showTraffic=YES;
        _mapView.showsScale=NO;
        _mapView.showsCompass=NO;
        _mapView.showsUserLocation=YES;
        _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.logoCenter=CGPointMake(100, 10);
        [self goToMyLocation];
        
    }
    return _mapView;
}
- (UIImageView *)firstEntry{
    if (!_firstEntry) {
        _firstEntry=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shakeEntry"]];
    }
    return _firstEntry;
}

- (void)getNearbyRoad{
    [self searchPOI:@"道路" requestTypes:@"地名地址信息"];
}
- (void)uploadConditionAction{
    UploadConditonViewController *uploadVC=[[UploadConditonViewController alloc]init];
    
    uploadVC.nearbyRoad=self.nearbyRoad;
        [self.navigationController pushViewController:uploadVC animated:NO];
}
- (void)highwayConditionAction{

    HighWayViewController *highwayVC=[[HighWayViewController alloc]init];
    [self.navigationController pushViewController:highwayVC animated:NO];
} 
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchPOI:textField.text requestTypes:@""];
    [textField resignFirstResponder];
    return YES;
}
- (void)textDidChange:(UITextField *)textField{
    [self searchPOI:textField.text requestTypes:@""];
}
- (void)dissMissSearchViewAction{
    self.navigationController.navigationBarHidden=NO;
    [self.view sendSubviewToBack:self.searchView];
    [_textField resignFirstResponder];
}
- (void)dissMissSearchViewAction2{
    self.navigationController.navigationBarHidden=NO;
    [self.view sendSubviewToBack:self.searchView];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [_textField resignFirstResponder];
}
- (void)rightItemAction{
    self.navigationController.navigationBarHidden=YES;
    [self.view bringSubviewToFront:self.searchView];
    [self searchPOI:@"车" requestTypes:@""];
    
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    _firstEntry.frame=CGRectZero;
    _shakeForService.frame=CGRectZero;
    self.navigationController.navigationBarHidden=NO;
}
/**
 *  @author zq, 16-05-11 13:05:36
 *
 *  添加大头针
 *
 *  @param coordinate2D 中心点
 *  @param title        标题
 *  @param subtitle     位置信息
 */
- (void)addAnnotation:(CLLocationCoordinate2D)coordinate2D with:(NSString *)title and:(NSString *)subtitle{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate =coordinate2D;
    pointAnnotation.title = title;
    pointAnnotation.subtitle = subtitle;
    
    [_mapView addAnnotation:pointAnnotation];
}
/**
 *  @author zq, 16-05-23 09:05:52
 *
 // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
 // POI的类型共分为20种大类别，分别为：
 // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
 // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
 // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
 *
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:_annotationImageName];
        annotationView.canShowCallout=YES;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
- (void)goToMyLocation{
    float zoomLevel = 0.01;
    MACoordinateRegion region = MACoordinateRegionMake(_mapView.userLocation.location.coordinate,MACoordinateSpanMake(zoomLevel, zoomLevel));
    region.center = _mapView.userLocation.location.coordinate;
    [self.mapView setRegion:region];
}
- (void)segmetBAction:(HMSegmentedControl*)sender{
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.navigationController.navigationBarHidden=YES;
    self.shakeForService.frame=self.view.bounds;
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self searchPOI:@"停车场" requestTypes:@"汽车服务"];
            _annotationImageName=@"park_red";
            break;
        case 1:
            [self searchPOI:@"加油站" requestTypes:@"汽车服务"];
            _annotationImageName=@"gas_station_red";
            break;
        case 2:
            [self searchPOI:@"维修站" requestTypes:@"汽车服务|汽车维修"];
            _annotationImageName=@"vehicle_servicing_red";
            break;
        case 3:
            _annotationImageName=@"special_offers";
            break;
        default:
            break;
    }
    
}
- (void)searchPOI:(NSString *)keyword requestTypes:(NSString *)types{
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
    request.keywords = keyword;
    request.types = types;
    request.sortrule = 0;
    request.requireExtension = YES;    
    //发起周边搜索
    [self.search AMapPOIAroundSearch: request];
}
- (void)addAnnotationWithArray:(NSArray *)annotations{
    if (annotations.count==0) return;
        for (AMapPOI *poi in annotations) {
            [self addAnnotation:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude) with:poi.name and:poi.address];
        }
    
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    [self.searchDataList removeAllObjects];

    for (AMapPOI *poi in response.pois) {
        [self.searchDataList addObject:poi];
        [self.searchTableVeiw reloadData];
    }
    if ([request.types isEqualToString:@"地名地址信息"]) {
        for (AMapPOI *poi in response.pois) {
            [self.nearbyRoad addObject:poi.name];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
        
    }
    AMapPOI *poi=self.searchDataList[indexPath.row];
    cell.textLabel.text=poi.name;
    cell.detailTextLabel.text= poi.address;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchDataList.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mapView removeAnnotations:self.mapView.annotations];
    AMapPOI *poi=self.searchDataList[indexPath.row];
    _annotationImageName=@"searchLocation";
    [self addAnnotation:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude) with:poi.name and:poi.address];
    [self dissMissSearchViewAction];
}
- (void)setUI{
    self.title=@"摇一摇路况";
    [self.view addSubview:self.searchView];
    [_searchView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_searchView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_searchView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_searchView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    self.view.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.mapView];
    _mapView.frame=self.view.bounds;
    [self.view addSubview: self.segmentB];
    [_segmentB autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_segmentB autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_segmentB autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_segmentB autoSetDimension:ALDimensionHeight toSize:40];

    [self.view addSubview:self.myLocation];
    [_myLocation autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [_myLocation autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [_myLocation autoSetDimensionsToSize:CGSizeMake(30, 30)];
    self.navigationItem.rightBarButtonItem=self.rightItem;
    [self.view addSubview:self.highwayCondition];
    [_highwayCondition autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segmentB withOffset:10];
    [_highwayCondition autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [_highwayCondition autoSetDimensionsToSize:CGSizeMake(60, 60)];
    [self.view addSubview:self.uploadCondition];
    [_uploadCondition autoSetDimensionsToSize:CGSizeMake(80, 80)];
    [_uploadCondition autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.5];
    [_uploadCondition autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    
    [self.view addSubview:self.shakeForService];
    [self.view addSubview:self.firstEntry];
    _firstEntry.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //这里的传值要注意  当搜索引擎没有初始化出来之前 搜索是搜索不到的
    [self getNearbyRoad];
}

@end
