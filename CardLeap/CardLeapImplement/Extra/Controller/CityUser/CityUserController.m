//
//  CityUserController.m
//  CardLeap
//
//  Created by songweiping on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUserController.h"

//---------- 跳转控制器 ----------
#import "CityInfoViewController.h"
#import "CityUpdateViewController.h"
#import "CityAddController.h"



//---------- 三方框架   ----------
#import "MJExtension.h"
#import "UIScrollView+MJRefresh.h"


//---------- 自定义Cell ----------
#import "CityUserViewCell.h"

//---------- 数据模型   ----------
#import "CityUser.h"
#import "CityUserFrame.h"
#import "CityAddMessage.h"
#import "CityUserMessage.h"
#import "ExtraViewController.h"

@interface CityUserController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>


@property (weak, nonatomic)   UITableView    *cityUserTableView;
@property (strong,nonatomic) UIButton *leftButton;
@property (strong, nonatomic) NSMutableArray *cityUserArray;
@property (copy, nonatomic)   NSString       *m_id;
@property (assign, nonatomic) int            page;
@property (strong, nonatomic) CityAddMessage *cityMessage;

@end

@implementation CityUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    [self initUI];
    
    [self getUserCityData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ----- 添加控件
/**
 *  初始化 控件
 */
- (void) initUI {
    [self settingNavigation];
    
    [self cityUserTableView];
    //这里需要自定义返回
    if (self.identifier!=nil) {
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
        self.navigationItem.leftBarButtonItem = leftBar;
    }
}

/**
 *  设置 导航栏
 */
- (void) settingNavigation {
    
    [self setHiddenTabbar:YES];
    self.navigationItem.title = @"我的发布";
}

/**
 *  添加一个tableView
 *
 *  @return     UITableView
 */
- (UITableView *)cityUserTableView {
    
    if (_cityUserTableView == nil) {
        
        UITableView *cityUserTableView = [[UITableView alloc] init];
        CGFloat cityUserX  = self.view.frame.origin.x;
        CGFloat cityUserY  = self.view.frame.origin.y;
        CGFloat cityUserW  = self.view.frame.size.width;
        CGFloat cityUserH  = self.view.frame.size.height - 64;
        cityUserTableView.frame = CGRectMake(cityUserX, cityUserY, cityUserW, cityUserH);
        cityUserTableView.dataSource = self;
        cityUserTableView.delegate   = self;
        
        
        [cityUserTableView addHeaderWithTarget:self action:@selector(upLoad)];
        [cityUserTableView addFooterWithTarget:self action:@selector(downRefresh)];
        cityUserTableView.headerRefreshingText = @"正在刷新数据...";
        cityUserTableView.footerRefreshingText = @"正在加载数据...";
    
        [UZCommonMethod hiddleExtendCellFromTableview:cityUserTableView];
        cityUserTableView.rowHeight  = 80;
        _cityUserTableView = cityUserTableView;
        if ([_cityUserTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_cityUserTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_cityUserTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_cityUserTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        [self.view addSubview:_cityUserTableView];
    }
    return _cityUserTableView;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];\
        [_leftButton setImage:[UIImage imageNamed:@"navbar_return_no"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"navbar_return_sel"] forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(myBackActino:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(-20, -25, 0, 0);
    }
    return _leftButton;
}

#pragma mark-----自定义返回
-(void)myBackActino:(UIButton*)sender
{
    NSArray *subViews = self.navigationController.viewControllers;
    for (BaseViewController *obj in subViews) {
        if ([obj isKindOfClass:[ExtraViewController class]]) {
            ExtraViewController *friVC1=(ExtraViewController *)obj;
            [friVC1 setHiddenTabbar:NO];
            [self.navigationController popToViewController:friVC1 animated:YES];
        }
    }
}

#pragma mark ----- 数据处理
/**
 *  获取数据
 */
- (void) getUserCityData {
    
    NSString  *page = [NSString stringWithFormat:@"%i", self.page];
    UserModel *user = [UserModel shareInstance];
    NSString  *u_id = user.u_id;
    NSString  *url  = connect_url(@"my_city");

    NSDictionary *dict = @{@"app_key":url,
                           @"u_id"   :u_id,
                           @"page"   :page
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] isEqualToString:@"200"]) {
            
            [self.cityUserTableView headerEndRefreshing];
            [self.cityUserTableView footerEndRefreshing];
            NSMutableArray *array = param[@"obj"];
            if (array.count != 0) {
                self.cityUserArray = [self cityUserDataTreatment:array];
            } else {
                //[SVProgressHUD showErrorWithStatus:@"没有数据啦！"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.cityUserTableView reloadData];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}


/**
 *  数据处理
 *
 *  @param      param
 *
 *  @return     NSMutableArray
 */
- (NSMutableArray *) cityUserDataTreatment:(NSArray *) param {

    NSMutableArray *array = [NSMutableArray array];
    
    if (self.page != 1) {
        array = self.cityUserArray;
    }
    
    for (NSDictionary *dict in param) {
        CityUser *cityUser           = [CityUser cityUserWithDict:dict];
        CityUserFrame *cityUserFrame = [[CityUserFrame alloc] init];
        cityUserFrame.cityUser       = cityUser;
        [array addObject:cityUserFrame];
    }
    return array;
}


#pragma mark ----- UITableView dataSource


/**
 *  返回 tableView的分组
 *  @param tableView
 *
 *  @return
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/**
 *  返回列表中显示多少个组数据
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityUserArray.count;
    
}

/**
 *  显示每个Cell 的样式和 位置
 *
 *  @param  tableView
 *  @param  indexPath
 *  @return cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityUserViewCell *cell = [CityUserViewCell cityUserCellWithTableView:tableView];
    
    cell.cityUserFrame     = self.cityUserArray[indexPath.row];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}


#pragma mark ----- UITableView  Delegate 
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIActionSheet *actionShett = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"详情", @"修改", @"刷新", nil];
    
    actionShett.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionShett showInView:self.view];
    
    CityUserFrame *cityUserFrame = self.cityUserArray[indexPath.row];
    self.m_id  = cityUserFrame.cityUser.m_id;
}


#pragma mark ----- UIActionSheet Delegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 删除
    if (buttonIndex == 0) {
        [self deleteCityUser];
    }
    
    // 详情
    if (buttonIndex == 1) {
        [self toCityInfo];
    }
    
    // 修改
    if (buttonIndex == 2) {
        
        [self toUpdateCityUser];
    }
    
    // 刷新
    if (buttonIndex == 3) {
        [self updateCityAddTimeUser];
    }
}



#pragma mark ----- 点击之后的操作
/**
 *  删除
 */
- (void) deleteCityUser {
    self.page          = 1;
    NSString *url      = connect_url(@"my_city_del");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"m_id"   :self.m_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        NSLog(@"%@", param);
        if ([param[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            [self getUserCityData];
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力！"];
    }];
}


/**
 *  跳转修改页面
 */
- (void) toUpdateCityUser {
    
    
    NSArray *cityAddress       = userDefault(@"cityAddress");
    NSArray *cityCate          = userDefault(@"cityCates");
    CityUpdateViewController *cityUpdate = [[CityUpdateViewController alloc] init];
    cityUpdate.cityAddress     = cityAddress;
    cityUpdate.cityCates       = cityCate;
    cityUpdate.m_id            = self.m_id;
//    cityUpdate.cityAddMessage  = self.cityMessage;
    [self.navigationController pushViewController:cityUpdate animated:YES];
    
}

/**
 *  跳转详情
 */
- (void) toCityInfo {
    
    CityInfoViewController *cityInfo = [[CityInfoViewController alloc] init];
    cityInfo.m_id = self.m_id;
    [self.navigationController pushViewController:cityInfo animated:YES];
}


/**
 *  点击刷新
 */
- (void) updateCityAddTimeUser {

    self.page          = 1;
    NSString *url      = connect_url(@"refresh_city");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"m_id"   :self.m_id,
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        
        if ([param[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            [self getUserCityData];
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力！"];
    }];
}


/**
 *  上拉下载更多数据
 */
- (void) upLoad {
    self.page = 1;
    [self getUserCityData];
}

/**
 *  下拉刷新数据
 */
- (void) downRefresh {
    self.page++;
    [self getUserCityData];
}


@end
