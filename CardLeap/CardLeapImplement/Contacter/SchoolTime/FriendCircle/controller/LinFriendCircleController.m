//
//  LinFriendCircleController.m
//  EnjoyDQ
//
//  Created by lin on 14-8-14.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "CSqlite.h"
#import "LinFriendCircleController.h"
#import "LinFriendCircleInfo.h"
#import "LinFriendCircleCell.h"
//#import "LinDataMgr.h"
#import "LinFriendCircleDetailController.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "SDImageCache.h"
#import "base64Tool.h"
#import "SendViewController.h"
#import "CellViewMgrController.h"
#import "VoiceRecorderBase.h"
#import "VoiceConverter.h"
#import "ListViewController.h"
#import "UserModel.h"
#import "UIScrollView+MJRefresh.h"
#import "LoginViewController.h"
#import "ReplyViewController.h"
#import "YYAnimationIndicator.h"

#define URL @"http://api.dianping.com/v1/metadata/get_categories_with_deals?appkey=4123794720&sign=C1C7F4F1C1F08FDB0C9E8B09AD7D3F90F93E2F18"
#define BUTTON_WIDTH 54.0
#define BUTTON_SEGMENT_WIDTH 51.0
#define CAP_WIDTH 5.0

@interface LinFriendCircleController ()<ActionDeletedelegate,CLLocationManagerDelegate>
{
    //NSMutableArray *friendCircleList;
    NSMutableDictionary *dic;
    int page;
    int isloaddate;
    //===========
    OHAttributedLabel *t_OHAttributedLabel;
    OHAttributedLabel*  textLabelEx ;
    MarkupParser *wk_markupParser;
    //===========
    CellViewMgrController *cellArray;
    int selectRow;//点击第几行
    MHTabBarController* tabBarController;
    NSMutableDictionary *sortDic;
    NSMutableDictionary *cateDic;
    NSString *url;//接口url
    NSMutableDictionary *cateIdDictionary;//获取分类id的字典
    NSString *u_id;
    NSString *cat_id;
    NSArray* segmentControlTitles;//导航按钮名字
    UIButton *allButton;//all按钮
    UIButton *classButton;//我的班级按钮
    UIButton *createButton;//创建帖子按钮
    //-----使用开启定位------------
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    NSString *baidu_late;
    NSString *baidu_lng;
    //------是否有新回复-----------
    BOOL is_reply;
    NSString *count;
    YYAnimationIndicator *indicator;
    UIButton *newsListButton;//新消息按钮
}

@end
static NSMutableDictionary* g_nsdicemojiDict = nil;
@implementation LinFriendCircleController
@synthesize FriendTableview = _FriendTableview;
@synthesize friendCircleList = _friendCircleList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(LinFriendCircleController*)shareInstance
{
    static LinFriendCircleController* user=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        user =[[self alloc]init];
    });
    return user;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, 320, 43)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    // Do any additional setup after loading the view.
    [self createTableview];
    [self initData];
    [UZCommonMethod hiddleExtendCellFromTableview:_FriendTableview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReviewList) name:@"NEEDUPDATAE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addReply:) name:@"ISNEWREPLY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"STARTRELOAD" object:nil];
    [self setButton];
    //[self loading];
    //如果未开启定位
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        [self getDataFromNetwork];
    }
}
#pragma mark-----loading
-(void)loading
{
    indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-40, 80, 80)];
    [indicator setLoadText:@"正在加载..."];
    [self.view addSubview:indicator];
}
#pragma mark-----新回复
-(void)addReply :(NSNotification*)notification
{
    is_reply = YES;
    count = [NSString stringWithFormat:@"%@",notification.object];
    [_FriendTableview reloadData];
}
#pragma mark-----addTableview
-(void)createTableview
{
    _FriendTableview = [[UITableView alloc] initForAutoLayout];
    _FriendTableview.delegate = self;
    _FriendTableview.dataSource = self;
    _FriendTableview.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_FriendTableview];
    [_FriendTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_FriendTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_FriendTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:44.0f];
    [_FriendTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
}
-(void)setButton
{
    //全部按钮
    allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 74, 30)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:allButton.frame ];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [allButton addSubview:imageView];
    [allButton setTitle:@"附近" forState:UIControlStateNormal];
    [allButton setTitleColor:UIColorFromRGB(0xe84848) forState:UIControlStateNormal];
    allButton.titleLabel.text = @"附近";
    allButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [allButton addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
    //我的班级
    classButton = [[UIButton alloc] initWithFrame:CGRectMake(76, 0, 73, 30)];
    UIImageView *ClassImageView = [[UIImageView alloc] initWithFrame:allButton.frame ];
    [ClassImageView setBackgroundColor:UIColorFromRGB(0xe84848)];
    [classButton addSubview:ClassImageView];
    [classButton setTitle:@"我的" forState:UIControlStateNormal];
    classButton.titleLabel.text = @"我的";
    classButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [classButton addTarget:self action:@selector(classAction) forControlEvents:UIControlEventTouchUpInside];
    //titleView
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    //加按钮
    [view  addSubview:classButton];
    [view  addSubview:allButton];
    view.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = view;
}
#pragma mark----全部按钮方法
-(void)allAction
{
    for (id obj in allButton.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView* iv=(UIImageView*)obj;
            [iv setBackgroundColor:[UIColor whiteColor]];
        }
    }
    for (id obj in classButton.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView* iv=(UIImageView*)obj;
            [iv setBackgroundColor:UIColorFromRGB(0xe84848)];
        }
    }
    [classButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [allButton setTitleColor:UIColorFromRGB(0xe84848) forState:UIControlStateNormal];
    u_id = @"0";
    _friendCircleList = [[NSMutableArray alloc] init];
    page = 1;
    [self getDataFromNetwork];
}
#pragma mark----我的班级按钮方法
-(void)classAction
{
    if (ApplicationDelegate.islogin == YES) {
        for (id obj in allButton.subviews) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView* iv=(UIImageView*)obj;
                [iv setBackgroundColor:UIColorFromRGB(0xe84848)];
            }
        }
        for (id obj in classButton.subviews) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView* iv=(UIImageView*)obj;
                [iv setBackgroundColor:[UIColor whiteColor]];
            }
        }
        [classButton setTitleColor: UIColorFromRGB(0xe84848) forState:UIControlStateNormal];
        [allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        u_id = [UserModel shareInstance].u_id;
        _friendCircleList = [[NSMutableArray alloc] init];
        page = 1;//page初始化
        [self getDataFromNetwork];
    }else{
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//搜索班级
        NSLog(@"暂定跳转");
    }else{//创建班级
        NSLog(@"暂定跳转");
    }
}

-(void)refreshList
{
    page = 1;
    [self getDataFromNetwork];
}

-(void)viewWillAppear:(BOOL)animated
{
    newsListButton.userInteractionEnabled = YES;
    [self setHiddenTabbar:NO];
}

-(void)initData
{
    [self setNavBarTitle:@"发现" withFont:14.0f];
    is_reply = NO;
    _friendCircleList = [[NSMutableArray alloc] init ];
    page = 1;
    isloaddate = 0;
    //初始化下拉控件
    [self initRefresh];
    [self setCreateBtn];
    selectRow = 0;
    //加下拉列表框
    sortDic = [[NSMutableDictionary alloc] init];
    cateDic = [[NSMutableDictionary alloc] init];
    cateIdDictionary = [[NSMutableDictionary alloc] init];
    u_id = @"0";
    cat_id = @"0";
    [self openLocation];
    baidu_late = @"0";
    baidu_lng = @"0";
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
    [self getDataFromNetwork];
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"定位失败");
    [locationManager stopUpdatingLocation]; // 关闭定位
    //获取列表
    [self getDataFromNetwork];
}

#pragma mark----获取校园时光分类
-(void)getCateFromNet
{
    NSString *urls = connect_url(@"com_cat_list");//@"/community/ac_com/com_cat_list";//
    NSDictionary *dict = @{@"app_key": urls};
    [Base64Tool postSomethingToServe:urls andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSLog(@"%@",param);
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            //数据封装
            NSArray *arr = [param objectForKey:@"obj"];
            NSArray *array = [[NSArray alloc] init];
            for (NSDictionary *tempDic in arr) {
                NSString *cate_id = [tempDic objectForKey:@"cat_id"];
                NSString *cat_name = [tempDic objectForKey:@"cat_name"];
                [cateDic setObject:array forKey:cat_name];
                [cateIdDictionary setObject:cate_id forKey:cat_name];
            }
            [self getDataFromNetwork];
            [self addTabbar];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

//添加下拉列表框
-(void)addTabbar
{
    if (tabBarController != nil) {
        tabBarController.isPush = @"1";
        [tabBarController deleteObserver];
        [tabBarController removeFromParentViewController];
    }
    //下拉列表分类数据加载
    //ListViewController* lvc=[[ListViewController alloc]initWithURL:URL];
    ListViewController* lvc1=[[ListViewController alloc]initWithURL:URL];
    //假数据
    //将排序的数据模型封装好 便于向下一级传
    //lvc.datadic = sortDic;
    lvc1.datadic= cateDic;
    //lvc.title=@"全部";
    lvc1.title=@"分类";
    NSArray* arr=@[lvc1];
    tabBarController=[[MHTabBarController alloc]initWithFrame:CGRectMake(0, 63, 320, 250+44)];
    tabBarController.normalImageArray=@[@""];
    tabBarController.selectedImageArray=@[@""];
    tabBarController.delegate=self;
    tabBarController.viewControllers=arr;
    tabBarController.view.userInteractionEnabled=YES;
    [self.view addSubview:tabBarController.view];
}

-(void)subViewController:(UIViewController *)subViewController SelectedCell:(NSString *)selectedText
{
    //处理TAB_NO1 条件
    if(tabBarController.viewControllers[0]==subViewController){
        NSString *selectText = ((ListViewController *)subViewController).selectedText;
 
        if (![selectText isEqual: @"分类"]) {
            NSLog(@"选择了%@选项",selectText);
            cat_id = [cateIdDictionary objectForKey:selectText];
        }
        else{
            cat_id = @"0";
        }
        page =1;
        _friendCircleList = [[NSMutableArray alloc] init];
        [SVProgressHUD showWithStatus:@"努力加载中..."];
        [self getDataFromNetwork];
    }
}

-(void)setCreateBtn
{
    NSMutableArray *items = [NSMutableArray array];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setImage:LoadNormalImage(@"found_release_no") forState:UIControlStateNormal];
    [rightButton setImage:LoadNormalImage(@"found_release_sel")  forState:UIControlStateHighlighted];
    [rightButton addTarget:self
                    action:@selector(LincreateCommunication)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -15);
    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [items addObject:collectionItem];
    self.navigationItem.rightBarButtonItems = items;
    //消息列表按钮
    newsListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsListButton setFrame:CGRectMake(0, 0, 40, 40)];
    [newsListButton setImage:LoadNormalImage(@"found_news_no") forState:UIControlStateNormal];
    [newsListButton setImage:LoadNormalImage(@"found_news_sel")  forState:UIControlStateHighlighted];
    [newsListButton addTarget:self
                       action:@selector(go2List:)
          forControlEvents:UIControlEventTouchUpInside];
    newsListButton.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 10);
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc] initWithCustomView:newsListButton];
    self.navigationItem.leftBarButtonItem = listItem;
}



#pragma mark------消息俩表 和 创建帖子界面
-(void)go2List:(UIButton*)sender
{
    if (sender.state==UIControlStateHighlighted) {
        sender.userInteractionEnabled = NO;
        [self performSelector:@selector(pushSomething) withObject:nil afterDelay:0];
    }else{
    }
}

-(void)pushSomething
{
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        if (is_reply == YES) {
            is_reply = NO;
            count = @"0";
            [_FriendTableview reloadData];
        }
        NSLog(@"去消息列表");
        ReplyViewController *firVC = [[ReplyViewController alloc] init];
        [firVC setNavBarTitle:@"回复消息列表" withFont:14.0f];
        firVC.is_read = @"1";
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(void)LincreateCommunication
{
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"由于您未对本程序开启定位，暂时无法使用发帖功能，可以到设置中去开启" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        tabBarController.isPush = @"0";
        if (ApplicationDelegate.islogin == NO) {
            NSLog(@"跳转到登录页面");
            LoginViewController *firVC = [[LoginViewController alloc] init];
            [firVC setNavBarTitle:@"登录" withFont:14.0f];
            [self.navigationController pushViewController:firVC animated:YES];
        }else{
            SendViewController * svc=[[SendViewController alloc]init];
            [svc setHiddenTabbar:YES];
            svc.u_lat = baidu_late;
            svc.u_lng = baidu_lng;
            [svc setNavBarTitle:@"创建" withFont:14.0f];
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
}

-(void)getDataFromNetwork
{
    url = connect_url(@"com_list");
    //url = @"/community/ac_com/com_get_list";
    dic = [[NSMutableDictionary alloc] init];
    [dic setObject:url forKey:@"app_key"];
    [dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dic setObject:baidu_lng forKey:@"lng"];
    [dic setObject:baidu_late forKey:@"lat"];
    [dic setObject:u_id forKey:@"u_id"];
    
    //[SVProgressHUD showWithStatus:@"很快很快的..."];
    NSLog(@"%@",dic);
    BOOL is_base64 = [IS_USE_BASE64 boolValue];
    [[LinLoadingView shareInstances:self.view] startAnimation];  //开始转动
    [Base64Tool postSomethingToServe:url andParams:dic isBase64:is_base64 CompletionBlock:^(id param) {
        if (page == 1) {
            _friendCircleList = [[NSMutableArray alloc] init];
        }
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            //[indicator stopAnimationWithLoadText:[param objectForKey:@"message"] withType:YES];//加载成功
            NSArray *array = [param objectForKey:@"obj"];
            NSLog(@"%@",array);
            if ([array count]==0) {
                isloaddate =1;
            }
            for (NSDictionary *dict in array) {
                LinFriendCircleInfo *info = [[LinFriendCircleInfo alloc] initWithDictionary:dict];
                [_friendCircleList addObject:info];
            }
            cellArray = [[CellViewMgrController alloc] initWithDictionary:_friendCircleList];
            cellArray.delegate = self;
            [_FriendTableview reloadData];
            [[LinLoadingView shareInstances:self.view] stopWithAnimation:[param objectForKey:@"message"]];  //停止转动
        }else{
            NSLog(@"%@",[param objectForKey:@"message"]);
            [[LinLoadingView shareInstances:self.view] stopWithAnimation:[param objectForKey:@"message"]];  //停止转动
        }
        [_FriendTableview headerEndRefreshing];
        [_FriendTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [[LinLoadingView shareInstances:self.view] stopWithAnimation:@"网络不给力"];  //停止转动
        //[indicator stopAnimationWithLoadText:@"网络不给力" withType:YES];//加载成功
        //[SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark----删除方法
-(void)deleteAction:(int)index
{
    NSLog(@"列表开始删除帖子了 索引是%d",index);
    LinFriendCircleInfo *info = [_friendCircleList objectAtIndex:index];
    NSString *com_id = info.com_id;
    [_friendCircleList removeObjectAtIndex:index];
    cellArray = [[CellViewMgrController alloc] initWithDictionary:_friendCircleList];
    cellArray.delegate = self;
    [_FriendTableview reloadData];
    [self deleteCommunication:com_id];
}
#pragma mark-----删除帖子接口
-(void)deleteCommunication :(NSString*)com_id
{
    NSString *delete_url = connect_url(@"com_del");
    NSString *uid = [UserModel shareInstance].u_id;
    NSString *session_key = [UserModel shareInstance].session_key;
    NSDictionary *dict = @{
                           @"com_id":com_id,
                           @"u_id":uid,
                           @"session_key":session_key,
                           @"app_key":delete_url
                           };
    [Base64Tool postSomethingToServe:delete_url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力，稍后重试"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)lengthOfStr :(NSString*)str
{
    NSString *string = nil;
    NSLog(@"%@",str );
    NSLog(@"%d",str.length);
    NSInteger stringLength = str.length;
    if (stringLength == 0) {
        return 0;
    }
    if ( stringLength >= FACE_NAME_LEN ) {
        string = [str substringFromIndex:stringLength - FACE_NAME_LEN];
        NSRange range = [string rangeOfString:FACE_NAME_HEAD];
        if ( range.location == 0 ) {
            
            string = [str substringToIndex:
                      [str rangeOfString:FACE_NAME_HEAD
                                         options:NSBackwardsSearch].location];
            return 2+[self length_str:string];
        }
        else {
            char c=[str characterAtIndex:stringLength-1];
            if ((c>'a'&&c<'z')||(c>='A'&&c<='Z'))
            {
                string = [str substringToIndex:stringLength - 1];
                return 0.5+[self length_str:string];
                //NSLog(@"字母为%c",c);
            }else{
                string = [str substringToIndex:stringLength - 1];
                return 1+[self length_str:string];
            }
        }
    }
    else {
        char c=[str characterAtIndex:0];
        if ((c>'a'&&c<'z')||(c>='A'&&c<='Z'))
        {
            
            string = [str substringToIndex:stringLength - 1];
            return 0.5+[self length_str:string];
            //NSLog(@"字母为%c",c);
        }else{
            string = [str substringToIndex:stringLength - 1];
            return 1+[self length_str:string];
        }
        //return str.length;
    }
    //return 0;
}

-(CGFloat)length_str:(NSString*)string
{
    NSString *text = string;
    NSString *regex_emoji = @"\\<[a-zA-Z0-9\\u4e00-\\u9fa5]+\\>";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count])
    {
        for (NSString *str in array_emoji)
        {
            NSRange range = [text rangeOfString:str];
            NSString *replaceStr = @"$";
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:replaceStr];
        }
    }
    CGFloat length = 0;
    for (int i=0;i<text.length;i++) {
        char c=[text characterAtIndex:i];
        if ((c>'a'&&c<'z')||(c>='A'&&c<='Z'))
        {
            length += 0.5;
        }else{
            length += 1;
        }
    }
    return length;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LinFriendCircleCell";
    UITableViewCell *cell = nil;
    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[LinFriendCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UILabel class]] ) {
            [view removeFromSuperview];
        }
    }
    if (is_reply) {
        if (indexPath.row == 0) {
            UILabel *lable = [[UILabel alloc] initForAutoLayout];
            [cell addSubview:lable];
            lable.text = [NSString stringWithFormat:@"您有%@条未读消息",count];
            lable.numberOfLines = 0;
            lable.font = [UIFont systemFontOfSize:13.0f];
            lable.backgroundColor = [UIColor lightGrayColor];
            lable.layer.masksToBounds = YES;
            lable.layer.cornerRadius = 15.0f;
            lable.textAlignment = NSTextAlignmentCenter;
            [lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [lable autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [lable autoSetDimension:ALDimensionWidth toSize:200.0f];
        }else{
            NSInteger count1 = indexPath.row-1;
            UIView *cellView = [cellArray ImageLayout:count1];
            [cell addSubview:cellView];
        }
    }else{
        int count1 = indexPath.row;
        UIView *cellView = [cellArray ImageLayout:count1];
        [cell addSubview:cellView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%d",[_friendCircleList count]);
    if (is_reply) {
       return [_friendCircleList count] + 1;
    }else{
        return [_friendCircleList count];
    }
}

/*
 cell要做自适应 
 每个cell的高度都不同 
 所以在返回高度之前先调用
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (is_reply) {
        NSLog(@"%d",indexPath.row);
        if (indexPath.row == 0) {
            return 40;
        }else{
            CGFloat height  = 100;
            NSLog(@"%f",height);
            height = [[cellArray.heightsOfCells objectAtIndex:indexPath.row-1] floatValue];
            return height;
        }
    }else{
        CGFloat height  = 100;
        NSLog(@"%f",height);
        height = [[cellArray.heightsOfCells objectAtIndex:indexPath.row] floatValue];
        return height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (is_reply) {
        if (indexPath.row == 0) {
            is_reply = NO;
            count = @"0";
            [tableView reloadData];
            NSLog(@"进入回复列表");
            ReplyViewController *firVC = [[ReplyViewController alloc] init];
            [firVC setNavBarTitle:@"回复列表" withFont:14.0f];
//            [firVC.navigationItem setTitle:@"回复列表"];
            firVC.is_read = @"0";
            [self.navigationController pushViewController:firVC animated:YES];
        }else{
            //点击进入帖子详情
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            selectRow = indexPath.row;
            LinFriendCircleInfo *info = [_friendCircleList objectAtIndex:indexPath.row-1];
            LinFriendCircleDetailController *firVC = [[LinFriendCircleDetailController alloc] init];
            //传递至详情 不需要加载可以显示
            firVC.com_id = info.com_id;
            firVC.detailInfo =info;
            //存储语音
            if (![info.com_voice isEqualToString:@""]) {
                NSString *urlStr = info.com_voice;
                urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url_voice = [[NSURL alloc]initWithString:urlStr];
                NSData * audioData = [NSData dataWithContentsOfURL:url_voice];
                //NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath = [VoiceRecorderBase getPathByFileName:@"temp" ofType:@"amr"];
                NSLog(@"filePath ==== %@",filePath);
                [audioData writeToFile:filePath atomically:NO];
                //NSString *wavPath =[VoiceRecorderBase getPathByFileName:@"fuck" ofType:@"wav"];
            }
            [self.navigationController pushViewController:firVC animated:YES];
            NSLog(@"进入帖子详情");
        }
    }else{
        //点击进入帖子详情
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        selectRow = indexPath.row;
        LinFriendCircleInfo *info = [_friendCircleList objectAtIndex:indexPath.row];
        LinFriendCircleDetailController *firVC = [[LinFriendCircleDetailController alloc] init];
        [firVC setNavBarTitle:@"发现详情" withFont:14.0f];
//        [firVC.navigationItem setTitle:@"发现详情"];
        //传递至详情 不需要加载可以显示
        firVC.com_id = info.com_id;
        firVC.detailInfo =info;
        //存储语音
        if (![info.com_voice isEqualToString:@""]) {
            NSString *urlStr = info.com_voice;
            urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url_voice = [[NSURL alloc]initWithString:urlStr];
            NSData * audioData = [NSData dataWithContentsOfURL:url_voice];
            //NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [VoiceRecorderBase getPathByFileName:@"temp" ofType:@"amr"];
            NSLog(@"filePath ==== %@",filePath);
            [audioData writeToFile:filePath atomically:NO];
            //NSString *wavPath =[VoiceRecorderBase getPathByFileName:@"fuck" ofType:@"wav"];
        }
        [self.navigationController pushViewController:firVC animated:YES];
        NSLog(@"进入帖子详情");
    }
}

-(void)updateReviewList
{
    NSArray *temp_review_list = [[NSUserDefaults standardUserDefaults] objectForKey:@"reviewList"];
    NSLog(@"更新后的回复列表%@",temp_review_list);
    LinFriendCircleInfo *info = [_friendCircleList objectAtIndex:selectRow];
    NSLog(@"传来的array之前是什么%@",info.com_list);
    //info.review_num = [NSString stringWithFormat:@"%d",[info.com_list count]];
    if ([info.com_list count]<5) {
        info.com_list = temp_review_list;
        NSLog(@"传来的array之后是什么%@",info.com_list);
        cellArray = [[CellViewMgrController alloc] initWithDictionary:_friendCircleList];
        [_FriendTableview reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FriendCircleDetail"]) {
        NSIndexPath *index = [self.FriendTableview indexPathForSelectedRow];
        LinFriendCircleDetailController *firVC = segue.destinationViewController;
        LinFriendCircleInfo *info = [_friendCircleList objectAtIndex:index.row];
        firVC.com_id = info.com_id;
    }
}

//初始化下拉控件
-(void)initRefresh{
    [_FriendTableview addFooterWithTarget:self action:@selector(footerRereshings)];
    [_FriendTableview addHeaderWithTarget:self action:@selector(headerRereshings)];
    
    //设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _FriendTableview.headerPullToRefreshText = @"下拉可以刷新了";
    _FriendTableview.headerReleaseToRefreshText = @"松开马上刷新了";
    _FriendTableview.headerRefreshingText = @" ";
    
    _FriendTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _FriendTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _FriendTableview.footerRefreshingText = @" ";
}

/**
 *  下拉刷新
 */
#pragma mark------下拉刷新
-(void)headerRereshings
{
    page = 1;
    //[dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self getDataFromNetwork];
}
/**
 *  上拉加载更多
 */
#pragma mark-------上拉加载更多
-(void)footerRereshings
{
    page=page+1;
    //[dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self getDataFromNetwork];
}

////更新数据,在上拉加载的时候调用
//-(void)nextPage{
//    page=page+1;
//    [dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
//    [self getDataFromNetwork];
//}
//
////更新数据,在xia拉刷新的时候调用
//-(void)startRefresh
//{
//    page = 1;
//    [dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
//    [self getDataFromNetwork];
//}

#pragma mark 添加引导页
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //[self buildIntro];
}

#pragma mark---尺寸适配
-(void)changeSize{
    if (IS_HEIGHT_GTE_568 == 0) {
        CGRect rect = _FriendTableview.frame;
        rect.size.height = 387;
        _FriendTableview.frame = rect;
    }
}

-(void)viewDidLayoutSubviews
{
    [self changeSize];
}
//显示简介
-(void)show{

}
@end
