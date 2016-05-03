//
//  CityListViewController.m
//  CardLeap
//
//  Created by songweiping on 14/12/22.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityListViewController.h"


#import "UIScrollView+MJRefresh.h"
#import "MJExtension.h"
#import "RDVTabBarController/RDVTabBarController.h"

#import "CityInfoViewController.h"
#import "CityTableViewCell.h"
#import "OneCateController.h"
#import "TwoCateController.h"
#import "LoginViewController.h"
#import "CityAddController.h"
#import "CityAddMessage.h"

#import "CityListFrame.h"
#import "CityList.h"

#import "cateInfo.h"
#import "MXPullDownMenu.h"


@interface CityListViewController () <UITableViewDataSource, UITableViewDelegate,MXPullDownMenuDelegate>
{
    NSString *son_cate_id;
}

// ---------------------- UI 控件 ----------------------
/** 列表显示的TableView */
@property (strong, nonatomic)   UITableView     *cityTableView;

// ---------------------- 数据展示 ----------------------
/** 显示分类数组 */
@property (strong, nonatomic)   NSMutableArray *cateArray;
/** 显示地区分类数据 */
@property (strong, nonatomic)   NSMutableArray *addressArray;
/** 列表显示的数据 */
@property (strong, nonatomic)   NSMutableArray  *cityListArray;

// ---------------------- 检索条件 ----------------------
/** 分页 */
@property (assign, nonatomic)   int page;
/** 地区ID */
@property (copy, nonatomic)     NSString *a_id;

@end

@implementation CityListViewController


#pragma mark ----- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化数据
    [self initData];
    
    // 添加UI控件
    [self initUI];
    
    // 网络获取数据
    [self getCateFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}



#pragma mrak ----- 数据初始化
- (void) initData {

//    areaArray      = [[NSMutableArray alloc] init];
    self.page         = 1;
    self.a_id         = @"0";
    son_cate_id       = @"0";
    self.cateArray    = [NSMutableArray array];
    self.addressArray = [NSMutableArray array];
}


#pragma mark @@@@ ----> 初始化UI控件

/**
 *   初始化UI 控件
 */
- (void) initUI {
    [self settingNav];
    [self cityTableView];
}

/**
 *  导航栏
 */
- (void) settingNav {
    
    
    self.navigationItem.title      = self.cat_name;
    
    // 发布按钮
    UIBarButtonItem *addCityButton = [[UIBarButtonItem alloc] initWithCustomView:[self insertButton]];
    
    self.navigationItem.rightBarButtonItem = addCityButton;
}


/**
 *  添加按钮
 *
 *  @return UIButton
 */
- (UIButton *) insertButton {
    
    UIButton    *insertButton = [[UIButton alloc] init];
    [insertButton setFrame:CGRectMake(0, 0, 40, 40)];
    [insertButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
    [insertButton setImage:[UIImage imageNamed:@"city_release_no"]  forState:UIControlStateNormal];
    [insertButton setImage:[UIImage imageNamed:@"city_release_sel"]  forState:UIControlStateHighlighted];
    [insertButton addTarget:self action:@selector(toAddCity) forControlEvents:UIControlEventTouchUpInside];
    
    return insertButton;
}

/**
 *  重写 tableView gat方法
 *
 *  初始化控件
 *  @return UITableView
 */
- (UITableView *)cityTableView {
    
    if (_cityTableView == nil) {
        UITableView *cityTableView = [[UITableView alloc] init];
        
        CGFloat tableViewX = self.view.frame.origin.x;
        CGFloat tableViewY = self.view.frame.origin.y + 40;
        CGFloat tableViewW = self.view.frame.size.width;
        CGFloat tableViewH = self.view.frame.size.height - 104;
        
        cityTableView.frame      = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
        
        cityTableView.dataSource = self;
        cityTableView.delegate   = self;
        
        // 上拉
        [cityTableView addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        
        // 下拉
        [cityTableView addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        
        cityTableView.headerRefreshingText    = @"正在刷新数据...";
        
        cityTableView.footerRefreshingText    = @"正在加载数据...";
        
        cityTableView.backgroundColor = Color(255, 255, 255, 255);
        
        // 隐藏不显示 的cell
        [UZCommonMethod hiddleExtendCellFromTableview:cityTableView];
        [self.view addSubview:cityTableView];
        _cityTableView = cityTableView;
    }
    return  _cityTableView;
}



#pragma mark--------get cate from net
-(void)getCateFromNet
{
    [self parseCateArray:self.cityCateArray];
    [self getAddressFromNet];
}
#pragma mark-----解析商家分类
-(void)parseCateArray :(NSArray *)param
{
    [self.cateArray removeAllObjects];
    for (NSDictionary *ele in param) {
        cateInfo *info = [[cateInfo alloc] initWithDictinoary:ele];
        [self.cateArray addObject:info];
    }
}

-(void)getAddressFromNet
{
    [self parseAddressArray:self.cityAddress];
    [self getCityListData];
}

#pragma mark------解析商圈分类
-(void) parseAddressArray :(NSArray *)param
{
    [self.addressArray removeAllObjects];
    cateInfo *info0 = [[cateInfo alloc] init];
    info0.cate_name = @"地区";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    [self.addressArray addObject:info0];

    for (NSDictionary *ele in param) {
        cateInfo *info = [[cateInfo alloc] initWithDictinoary:ele];
        [self.addressArray addObject:info];
    }
    [self addCateList];
}

/**
 * 添加分类列表
 */
-(void)addCateList
{
    NSArray *testArray;
    testArray = @[self.cateArray, self.addressArray];
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor greenColor]];
    menu.delegate = self;
    CGRect rect = [[UIScreen mainScreen] bounds];
    menu.frame = CGRectMake(0, 0, rect.size.width, 36);
    menu.layer.borderWidth = 0.5;
    menu.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    [menu setCateTitle:self.cat_name];
    [self.view addSubview:menu];
}

#pragma mark - MXPullDownMenuDelegate 实现代理.
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row selectText:(NSString *)text
{
    //NSLog(@"%d -- %d-----and text:%@", column, row ,text);
    //NSString *str = [_listIdDict objectForKey:text];
    switch (column) {
        case 0:
            self.c_id = text;
            BOOL is_first = NO;
            NSLog(@"分类信息数组是%@",self.cateArray);
            for (cateInfo *info in self.cateArray) {
                if (info.cate_id == text) {
                    if ([info.son count]==0) {
                        is_first = YES;
                        break;
                    }
                }
            }
            //判断
            if (is_first) {
                self.c_id = text;
                son_cate_id = @"0";
            }else{
                self.c_id = @"0";
                son_cate_id = text;
            }
            break;
        case 1:
            self.a_id = text;
            break;
        default:
            break;
    }
    self.page = 1;
    if (self.cityListArray.count != 0) {
        [self.cityListArray removeAllObjects];
    }
    
    [self getCityListData];
}

#pragma  mark -----  点击跳转 发布
- (void) toAddCity {
    if (ApplicationDelegate.islogin) {
        
        CityAddMessage *message    = [[CityAddMessage alloc] init];
        message.cityOneCateId      = self.c_id;
        message.cityOneCateName    = self.cat_name;
        if (self.cityTwoCate.count == 0) {
            CityAddController *cityAdd = [[CityAddController alloc] init];
            cityAdd.cityAddress        = self.cityAddress;
            cityAdd.cityAddMessage     = message;
            [self.navigationController pushViewController:cityAdd animated:YES];
        } else {
         
            TwoCateController *twoCate = [[TwoCateController alloc] init];
            twoCate.cityAddMessage     = message;
            twoCate.cateMessage        = self.cityTwoCate;
            twoCate.cityAddress        = self.cityAddress;
            [self.navigationController pushViewController:twoCate animated:YES];
        }
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark @@@@ ----> 数据源方法(UITableViewDataSource)
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
    return self.cityListArray.count;
}

/**
 *  显示每个Cell 的样式和 位置
 *
 *  @param  tableView
 *  @param  indexPath
 *  @return cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建自定义的Cell
    CityTableViewCell *cell = [CityTableViewCell cellWithTableView:tableView];
   
    // 设置 显示的数据
    cell.cityListFrame = self.cityListArray[indexPath.row];
    
    return cell;
}

#pragma mark @@@@ ----> 代理方法(UITableViewDelegate)
/**
 *  点击跳转详情
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityListFrame *cityFrame         = self.cityListArray[indexPath.row];
    CityInfoViewController *cityInof = [[CityInfoViewController alloc] init];
    cityInof.m_id                    = cityFrame.cityList.m_id;
    [self.navigationController pushViewController:cityInof animated:YES];
}

/**
 *
 *  返回每个cell 的 高度
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


#pragma mark @@@@ ---> 数据处理刷新


/**
 *  服务器获取数据
 */
- (void) getCityListData {
    //[SVProgressHUD showSuccessWithStatus:@"数据加载中..."];
    
    NSLog(@"%@", self.c_id);
    NSLog(@"%@", self.a_id);
    // 分页参数
    NSString *type = [NSString stringWithFormat:@"%d", self.page];
    NSString *url =  connect_url(@"city_message_list");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"cat_id" :self.c_id,
                           @"a_id"   :self.a_id,
                           @"son_cate_id":son_cate_id,
                           @"page"   :type
                           };
    
    // 网络获取数据
    [[LinLoadingView shareInstances:self.view] startAnimation];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        
        if ([param[@"code"] isEqualToString:@"200"]) {
            
            // 数据处理 移除 手尾 刷新控件
            [self.cityTableView headerEndRefreshing];
            [self.cityTableView footerEndRefreshing];
            
            
            NSMutableArray *array = param[@"obj"];
            if (array.count != 0) {
                [SVProgressHUD dismiss];
                [[LinLoadingView shareInstances:self.view] stopWithAnimation:@"加载成功"];
                self.cityListArray = [self cityListDataTreatment:array];
            } else {
                [[LinLoadingView shareInstances:self.view] stopWithAnimation:@"没有数据"];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
        // 刷新表格数据
        [_cityTableView reloadData];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}


/**
 *  网络 获取的数据处理 字典数据 转换成模型数据
 *
 *  @param   param   字典数据数组
 *
 *  @return  array   数据模型数组
 */
- (NSMutableArray *)cityListDataTreatment:(NSArray *)param {
    
    
    NSMutableArray *array = [NSMutableArray array];
    
    // 加载更多数据
    if (self.page != 1) {
        array = self.cityListArray;
    }
    
    // 数据处理
    for (NSDictionary *dic in param) {
        CityList *cityList          = [CityList objectWithKeyValues:dic];
        CityListFrame *cityFrame    = [[CityListFrame alloc] init];
        cityFrame.cityList          = cityList;
        [array addObject:cityFrame];
    }
    return array;
}

/**
 *  下拉刷新
 */
- (void) headerBeginRefreshing {
    self.page   = 1;
    [self getCityListData];
}


/**
 * 上拉加载更多
 */
- (void)footerBeginRefreshing {
    self.page++;
    [self getCityListData];
}

@end
