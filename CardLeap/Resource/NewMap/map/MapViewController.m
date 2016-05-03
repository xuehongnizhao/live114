//
//  MapViewController.m
//  map
//
//  Created by Gpsye on 12-11-24.
//  Copyright (c) 2012年 Gpsye. All rights reserved.
//

/*
 地图页面，点击一个按钮进入地图页面，之后在页面显示大头针，并添加一个地址的说明就可以了。   会传递给你3个变量，一个经度值*1000000 的longitude，一个纬度值*1000000 的 latitude，还有一个NSString 的地址addr 。使用时你需要 对我给你传递的longitude和 latitude   除以 1000000。还原回他真实的经度和纬度。
 */


#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "shopToAnnotation.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong)NSDictionary *shop;//内部组装
//@property (weak, nonatomic) IBOutlet MKMapView *shopMapView;
@property (strong,nonatomic)MKMapView *shopMapView;;
@property (nonatomic, strong)NSArray *shopAnnotations;
@property (nonatomic, weak)IBOutlet UIButton *locationIndicatorButton;
@property (nonatomic, weak)IBOutlet UIImageView *locationIndicatorArrow;
@property (strong,nonatomic)UIButton *mapButton;
@end

@implementation MapViewController
@synthesize shopMapView = _shopMapView;
@synthesize shop = _shop;
@synthesize shopAnnotations = _shopAnnotations;
@synthesize locationIndicatorArrow = _locationIndicatorArrow;
@synthesize locationIndicatorButton = _locationIndicatorButton;


@synthesize addr = _addr;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

//火星坐标系转换为百度坐标系
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

- (IBAction)findShopInMap:(id)sender {
    MKCoordinateRegion region;
    MKCoordinateSpan theSpan;
    
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.022;
    theSpan.longitudeDelta=0.022;
    region.span=theSpan;
    
    id<MKAnnotation> shopAnnotation = [self.shopAnnotations lastObject];//[ShopToAnnotation annotationForShop:self.shop];
    region.center = shopAnnotation.coordinate;
    
    [self.shopMapView setRegion:region animated:YES];
}

- (void) animateUserArrow
{
    //Determine location of user and center of the map in pixels
    CGPoint user;
    user.x = ((self.shopMapView.userLocation.coordinate.longitude - self.shopMapView.region.center.longitude) / self.shopMapView.region.span.longitudeDelta) * self.shopMapView.frame.size.width;
    user.y = ((self.shopMapView.userLocation.coordinate.latitude - self.shopMapView.region.center.latitude) / self.shopMapView.region.span.latitudeDelta) * self.shopMapView.frame.size.height;
    
    //Define the bounding box for the button
    CGPoint bounds = CGPointMake(self.shopMapView.frame.size.width - 35, self.shopMapView.frame.size.height - 35);
    
    //Assume the center of the map is the origin point at (0,0)
    //Calculate the angle using trig
    float angle = atanf((user.y/user.x));
    if (isnan(angle)){
        angle=0;
    }
    float arrowRotation = 0;
    
    
    CGPoint buttonPosition = CGPointMake(0, 0);
    
    //Determine Quadrant
    if (user.y >= 0) {
        //User is located above center of the screen
        
        if (user.x >= 0) {
            //User is located to the right of the center of the screen
            //TOP RIGHT QUANDRANT
            arrowRotation = 1.57079633 - angle;
            //Determine which value we are aware of
            if (angle < 0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = (bounds.x);
                buttonPosition.y = bounds.y - (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = self.shopMapView.frame.size.height - bounds.y;
                buttonPosition.x = ((bounds.x / 2) + (0.5 * (bounds.y / (tanf(angle)))));
            }
            
        } else if (user.x < 0) {
            //User is located to the left of the center of the screen
            //TOP LEFT QUANDRANT
            arrowRotation = 4.71238898 - angle;
            //Determine which value we are aware of
            if (angle > -0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = self.shopMapView.frame.size.width - bounds.x;
                buttonPosition.y = (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = self.shopMapView.frame.size.height - bounds.y;
                buttonPosition.x = ((bounds.x / 2) + (0.5 * (bounds.y / (tanf(angle)))));
            }
        }
        
    } else if (user.y < 0) {
        //User is located below center of the screen
        
        if (user.x >= 0) {
            //User is located to the right of the center of the screen
            //BOTTOM RIGHT QUANDRANT
            arrowRotation = 1.57079633 - angle;
            //Determine which value we are aware of
            if (angle > -0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = (bounds.x);
                buttonPosition.y = bounds.y - (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = bounds.y;
                buttonPosition.x = ((bounds.x / 2) - (0.5 * (bounds.y / (tanf(angle)))));
            }
            
        } else if (user.x < 0) {
            //User is located to the left of the center of the screen
            //BOTTOM LEFT QUANDRANT
            arrowRotation = 4.71238898 - angle;
            //Determine which value we are aware of
            if (angle < 0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = self.shopMapView.frame.size.width - bounds.x;
                buttonPosition.y = (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = (bounds.y);
                buttonPosition.x = ((bounds.x / 2) - (0.5 * (bounds.y / (tanf(angle)))));
            }
            
        }
    }
    
    //Constrain buttonPosition to bounds
    if (buttonPosition.x > bounds.x) {
        buttonPosition.x = bounds.x;
    } else if (buttonPosition.x < (self.shopMapView.frame.size.width - bounds.x)) {
        buttonPosition.x = (self.shopMapView.frame.size.width - bounds.x);
    }
    
    if (buttonPosition.y > bounds.y) {
        buttonPosition.y = bounds.y;
    } else if (buttonPosition.y < (self.shopMapView.frame.size.height - bounds.y)) {
        buttonPosition.y = (self.shopMapView.frame.size.height - bounds.y);
    }
    
    //Set button position, while accounting for the height of the top UISearchBar and size of the graphic
    buttonPosition.x = (buttonPosition.x - (self.locationIndicatorButton.frame.size.width / 2));
    buttonPosition.y = ((buttonPosition.y /*+ topSearch.frame.size.height*/) - (self.locationIndicatorButton.frame.size.height / 2));
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.locationIndicatorButton.frame = CGRectMake(buttonPosition.x, buttonPosition.y, self.locationIndicatorButton.frame.size.width, self.locationIndicatorButton.frame.size.height);
    [UIView commitAnimations];
    
    
    //Rotate and position arrow
    
    CGPoint arrowPosition = CGPointMake(buttonPosition.x, buttonPosition.y);
    arrowPosition.x += self.locationIndicatorButton.frame.size.width / 2;
    arrowPosition.y += self.locationIndicatorButton.frame.size.height / 2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.locationIndicatorArrow.center = CGPointMake(arrowPosition.x, arrowPosition.y);
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation( arrowRotation );
    [self.locationIndicatorArrow setTransform:rotate];
    
    [UIView commitAnimations];
    
}

- (void) updateLocationIndicator
{
    //Is the user off-screen?
    if (self.shopMapView.userLocationVisible == NO) {
        
        //Enable interaction with the component
        self.locationIndicatorButton.userInteractionEnabled = YES;
        self.locationIndicatorArrow.userInteractionEnabled = YES;
        
        //Fade in the component if necessary
        if (self.locationIndicatorButton.alpha != 1) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.locationIndicatorButton setAlpha:1];
            [self.locationIndicatorArrow setAlpha:1];
            [UIView commitAnimations];
        }
        
        //Update the component's location and rotation
        [self animateUserArrow];
        
    } else {
        
        //Fade out the component if necessary
        if (self.locationIndicatorButton.alpha != 0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.locationIndicatorButton setAlpha:0];
            [self.locationIndicatorArrow setAlpha:0];
            [UIView commitAnimations];
        }
        
        
        //Disable interaction with the component
        self.locationIndicatorButton.userInteractionEnabled = NO;
        self.locationIndicatorArrow.userInteractionEnabled = NO;
        
    }
}
- (IBAction)findUserOnMap:(id)sender {
    if (self.shopMapView.userLocation.location != nil ) {
        
        //Since this method will display the user's location on-screen, we will pre-emptively fade out the component and disable interaction with it
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.locationIndicatorButton setAlpha:0];
        [self.locationIndicatorArrow setAlpha:0];
        [UIView commitAnimations];
        
        self.locationIndicatorButton.userInteractionEnabled = NO;
        self.locationIndicatorArrow.userInteractionEnabled = NO;
        
        MKCoordinateSpan span = self.shopMapView.region.span;
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = self.shopMapView.userLocation.location.coordinate;
        
        [self.shopMapView setRegion:region animated:YES];
        
    } else {
        
        //If the user tapped on the location indicator to access this method, then the user location value should never be nil, but this is here in case this method is called in some other way
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find your location" message:@"No user location could be found, please check your phone settings." delegate:nil cancelButtonTitle:@"Ok." otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark --处理地图annotation刷新和移动到指定区域
////将地图放大到annotation的区域
//- (void)moveToRegion
//{
//    
//    double minLatitude  = 0;
//    double maxLatitude  = 90;
//    double minLongitude = -179;
//    double maxLongitude = 180;
//    
//    if (self.shopAnnotations.count > 0) {
//        
//        // 以第一个为初始比较点
//        ShopToAnnotation *annotation = [self.shopAnnotations lastObject];
//        
//        minLatitude  = annotation.coordinate.latitude;
//        maxLatitude  = annotation.coordinate.latitude;
//        minLongitude = annotation.coordinate.longitude;
//        maxLongitude = annotation.coordinate.longitude;
//        
//        for (ShopToAnnotation *annotation in self.shopAnnotations) {
//            if (annotation.coordinate.latitude  < minLatitude)  minLatitude  = annotation.coordinate.latitude;
//            if (annotation.coordinate.latitude  > maxLatitude)  maxLatitude  = annotation.coordinate.latitude;
//            if (annotation.coordinate.longitude < minLongitude) minLongitude = annotation.coordinate.longitude;
//            if (annotation.coordinate.longitude > maxLongitude) maxLongitude = annotation.coordinate.longitude;
//        }
//    }
//    
//    double latitudeDelta   = (maxLatitude       - minLatitude);
//    double longitudeDelta  = (maxLongitude      - minLongitude);
//    double centerLatitude  = latitudeDelta  / 2 + minLatitude;
//    double centerLongitude = longitudeDelta / 2 + minLongitude;
//    
//    CLLocationCoordinate2D coord = {.latitude = centerLatitude, .longitude = centerLongitude};
//    MKCoordinateSpan        span = {.latitudeDelta = latitudeDelta + 0.012, .longitudeDelta = longitudeDelta + 0.012};
//    MKCoordinateRegion    region = {coord, span};
//    NSLog(@"region.center.latitude=%f, region.center.longitude=%f, span.latitudeDelta=%f, span.longitudeDelta=%f", region.center.latitude, region.center.longitude, span.latitudeDelta, span.longitudeDelta);
//    [self.shopMapView setRegion:region];
//}

- (void)update
{
    if (self.shopMapView.annotations) [self.shopMapView removeAnnotations:self.shopMapView.annotations];
    if (self.shopAnnotations){
        [self.shopMapView addAnnotations:self.shopAnnotations];
        [self findShopInMap:nil];
    }
}

#pragma mark --地理数据转换成annotation

- (void)tranferShopToShopAnnotations:(NSDictionary *)shop{
    id<MKAnnotation> shopAnnotation = [ShopToAnnotation annotationForShop:shop];
    NSMutableArray *shopAnnotations = [NSMutableArray array];
    [shopAnnotations addObject:shopAnnotation];
    self.shopAnnotations = shopAnnotations;
}

#pragma mark --setter & getter

#define MAP_ADDR @"addr"
#define MAP_LATITUDE @"latitude"
#define MAP_LONGITUDE @"longitude"

- (void)setShop:(NSDictionary *)shop{
    if(_shop != shop){
        _shop = shop;
        [self tranferShopToShopAnnotations:shop];
    }
}

- (void)setShopAnnotations:(NSArray *)shopAnnotations{
    if(shopAnnotations != _shopAnnotations){
        _shopAnnotations = shopAnnotations;
        [self update];
    }
}

- (void)setShopMapView:(MKMapView *)shopMapView{
    if(_shopMapView != shopMapView){
        _shopMapView = shopMapView;
        [self update];
    }
}

#pragma mark --验证经纬度是否有效

- (BOOL)isDataValidate{
    float latitude = [self.latitude doubleValue];
    float longitude = [self.longitude doubleValue];
    
    if(latitude<=90 && latitude>=-90 && longitude<=180 && longitude>-180 &&(latitude!=0||longitude!=0)){
        
        return YES;
    }else{
        return NO;
    }
}


-(MKMapView *)shopMapView
{
    if (!_shopMapView) {
        _shopMapView = [[MKMapView alloc] initForAutoLayout];
        _shopMapView.delegate = self;
    }
    return _shopMapView;
}

-(void)addMapView
{
    [self.view addSubview:self.shopMapView];
    [_shopMapView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_shopMapView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopMapView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_shopMapView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mapButton];
}

-(UIButton *)mapButton
{
    if (!_mapButton) {
        _mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
        [_mapButton setTitle:@"导航" forState:UIControlStateNormal];
        [_mapButton setTitle:@"导航" forState:UIControlStateHighlighted];
        _mapButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapAction) forControlEvents:UIControlEventTouchUpInside];
        _mapButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    }
    return _mapButton;
}

-(void)mapAction
{
    //这里跳转高德地图或者百度地图的导航
    
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"使用高德地图导航",@"使用百度地图导航", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

/**
 调用actiondelegate
 选择之后调用到高德或者百度地图
 */
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self goOtherMap:@"使用高德地图导航"];
    }else if(buttonIndex == 1){
        [self goOtherMap:@"使用百度地图导航"];
    }
}


-(void)goOtherMap:(NSString*)title
{
    BOOL hasBaiduMap = NO;
    BOOL hasGaodeMap = NO;
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        hasBaiduMap = YES;
    }else{
        
    }
    
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        hasGaodeMap = YES;
    }else{
        
    }
    
    CGFloat tmp_lat = [self.myLat floatValue];
    CGFloat tmp_lng = [self.myLnt floatValue];
    CGFloat shop_lat = [self.latitude floatValue];
    CGFloat shop_lnt = [self.longitude floatValue];
    if ([@"使用百度地图导航" isEqualToString:title])
    {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",tmp_lat, tmp_lng ,shop_lat,shop_lnt] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        if (hasBaiduMap == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装百度地图客户端" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([@"使用高德地图导航" isEqualToString:title])
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",@"app name",
                                @"IOSCity", @"终点", shop_lat, shop_lnt] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        if (hasGaodeMap == NO) {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装高德地图客户端" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


#pragma mark --生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *topColor;
    
    [self addMapView];
    
    
    if (IOS7) {
        topColor= [UIColor whiteColor];
    } else {
        topColor = [UIColor colorWithRed:0.85 green:0.1 blue:0.0 alpha:1.0];
    }
    self.navigationItem.rightBarButtonItem.tintColor = topColor;
    self.navigationItem.backBarButtonItem.tintColor = topColor;
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(160, 0, 120, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    titleText.textAlignment=NSTextAlignmentCenter;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:@"地图"];
    self.navigationItem.titleView=titleText;
    //百度坐标转火星坐标
    float latitude = [self.latitude doubleValue];
    float longitude = [self.longitude doubleValue];
    double x = longitude - 0.0065, y = latitude - 0.006;
	double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
	double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
	longitude = z * cos(theta);
	latitude = z * sin(theta);
    self.latitude = [NSString stringWithFormat:@"%f",latitude];
    self.longitude = [NSString stringWithFormat:@"%f",longitude];
    
    if([self isDataValidate]){
    
        self.shopMapView.delegate = self;
        self.shopMapView.showsUserLocation = NO;
        
        //组装shop
        NSMutableDictionary *shop = [NSMutableDictionary dictionary];
        [shop setObject:self.addr forKey:MAP_ADDR];
        [shop setObject:self.latitude forKey:MAP_LATITUDE];
        [shop setObject:self.longitude forKey:MAP_LONGITUDE];
        [self setShop:shop];
        
        //Update location indicator
        [self updateLocationIndicator];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"在地图上找不到该商家" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
#pragma mark -mapViewDelegate

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
//    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapTopPlacesVC"];
//    if(!aView){
//        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapTopPlacesVC"];
//        aView.canShowCallout = YES;
//    }
//    aView.annotation = annotation;
//    return aView;
//}
//
////处理点击annotationview
//- (void)mapView:(MKMapView *)sender annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control{
//
//}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self updateLocationIndicator];
}

#pragma mark -shouldAutorotateToInterfaceOrientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
