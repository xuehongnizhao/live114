//
//  CitySelectViewConstroller.m
//  CardLeap
//
//  Created by songweiping on 14/12/29.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CitySelectViewConstroller.h"

#import "RDVTabBarController/RDVTabBarController.h"
#import "MJExtension.h"
#import "UIScrollView+MJRefresh.h"

#import "CityTableViewCell.h"
#import "CityInfoViewController.h"

#import "CityListFrame.h"
#import "CityList.h"


@interface CitySelectViewConstroller () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

/** 显示数据的tableView */
@property (weak, nonatomic)   UITableView       *tableView;

/** 显示的数据 */
@property (strong, nonatomic) NSMutableArray    *cityList;

/** 用户输入查询信息 */
@property (strong, nonatomic) NSString          *like;

/** 分页数 */
@property (assign, nonatomic)  int page;

/** 是否下拉刷新 */
@property (assign, nonatomic)  BOOL isMore;

/**搜索框*/
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation CitySelectViewConstroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page   = 1;
    self.isMore = YES;
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  页面 当前页面 即将出现时 调用
 *
 *  @param animated
 */
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 隐藏 当前页面的 tabBar
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

/**
 *  页面 当前页面 即将消失时 调用
 *
 *  @param animated
 */
- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 显示出 上个页面的 tabBar
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    //移除searchBar
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];
}

#pragma mark -----  添加控件
- (void) setUI {
    [self settingNav];
    [self tableView];
}

- (void) settingNav {
//    self.navigationItem.titleView = [self searchBar];
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

/**
 *  添加搜索栏
 *
 *  @return UISearchBar
 */
- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar  = [[UISearchBar alloc]initWithFrame:CGRectMake(38, 7, 280*LinPercent, 30)];
        _searchBar.placeholder   = @"名称搜索";
        [_searchBar becomeFirstResponder];
        _searchBar.delegate      = self;
    }
    return _searchBar;
}

/**
 *  添加 tableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc] init];
        
        CGFloat tableViewX = self.view.frame.origin.x;
        CGFloat tableViewY = self.view.frame.origin.y;
        CGFloat tableViewW = self.view.frame.size.width;
        CGFloat tableViewH = self.view.frame.size.height - 64;
        tableView.frame    = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
        tableView.dataSource   = self;
        tableView.delegate     = self;
        tableView.rowHeight    = 100;
        [tableView addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        
        [tableView addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        tableView.headerRefreshingText = @"加载数据中...";
        tableView.footerRefreshingText = @"加载数据中...";
        
        tableView.scrollEnabled   = NO;
        tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [UZCommonMethod hiddleExtendCellFromTableview:_tableView];
        _tableView = tableView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



#pragma mark ----- tableView dataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cityList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityTableViewCell *cell = [CityTableViewCell cellWithTableView:tableView];
    CityListFrame *cityFrame = self.cityList[indexPath.row];
    cell.cityListFrame = cityFrame;
    return cell;
}


#pragma mark ----- UITableView delegate

/**
 *  点击跳转详情
 *
 *  @param      tableView
 *  @param      indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityListFrame *cityFrame     = self.cityList[indexPath.row];
    CityInfoViewController *info = [[CityInfoViewController alloc] init];
    info.m_id                    = cityFrame.cityList.m_id;
    [self.navigationController pushViewController:info animated:YES];
}



#pragma mark ----- UISearchBar delegate
/**
 *  点击 searchBar 开始搜索
 *
 *  @param searchBar
 */
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {


    self.page   = 1;                    // 清楚分页
    self.isMore = YES;                  // 默认下拉刷新
    self.tableView.scrollEnabled  = NO; // tableView 禁止滑动
    // 隐藏 cell 的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.cityList.count != 0) {
        [self.cityList removeAllObjects];
        [self.tableView reloadData];
    }
}

/**
 *  点击搜索 按钮
 *  @param searchBar
 */
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.like = searchBar.text;                 // 获取用户输入信息
    [self getData];                             // 获取数据
    self.tableView.scrollEnabled = YES;         // tableView 可以滑动
    [UZCommonMethod hiddleExtendCellFromTableview:self.tableView];
    [searchBar resignFirstResponder];           // 关闭键盘
    
}



#pragma mark ----- 数据处理

/**
 *  网络获取数据
 */
- (void) getData {
    
    // 分页 数量
    NSString *type = [NSString stringWithFormat:@"%i", self.page];
    NSString *url  = connect_url(@"city_like_list");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"like":self.like,
                           @"page":type
                           };
    
    [SVProgressHUD showSuccessWithStatus:@"获取数据中..."];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        
        if ([param[@"code"] isEqualToString:@"200"]) {
            // 数据处理 移除 手尾 刷新控件
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            NSMutableArray *array = param[@"obj"];
            if (array.count != 0) {
                [SVProgressHUD showSuccessWithStatus:param[@"message"]];
                self.cityList =  [self selectListDataTreatment:array];
            } else {
                [SVProgressHUD showErrorWithStatus:@"没有数据啦！"];
            }
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}


/**
 *  数据处理 (字典转模型数据)
 *
 *  @param      param
 *
 *  @return     NSMutableArray
 */
- (NSMutableArray *) selectListDataTreatment:(NSMutableArray *)param {
    
    NSMutableArray *typeArray = [NSMutableArray array];

    if (!self.isMore) {
        typeArray = self.cityList;
    } else {
        [typeArray removeAllObjects];
    }
    
    for (NSDictionary *dict in param) {
        CityList *cityList = [CityList objectWithKeyValues:dict];
        CityListFrame *cityFrame = [[CityListFrame alloc] init];
        cityFrame.cityList = cityList;
        [typeArray addObject:cityFrame];
    }
    return typeArray;
}

/**
 *  下拉刷新
 */
- (void) headerBeginRefreshing {
    self.page   = 1;
    self.isMore = YES;
    [self getData];
}


/**
 * 上拉加载更多
 */
- (void)footerBeginRefreshing {
    self.page++;
    self.isMore = NO;
    [self getData];
}


@end
