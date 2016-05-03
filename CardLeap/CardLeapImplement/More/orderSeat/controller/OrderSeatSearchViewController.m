//
//  OrderSeatSearchViewController.m
//  CardLeap
//
//  Created by mac on 15/2/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "OrderSeatSearchViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "orderSeatInfo.h"
#import "orderSeatTableViewCell.h"
#import "orderSeatDetailViewController.h"

@interface OrderSeatSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISearchBar* searchBar;
@property (strong, nonatomic) UITableView *LinGroupTableView;
@end

@implementation OrderSeatSearchViewController
{
    //当前页数
    NSString* currentPage;
    
    //是否加载更能多
    BOOL isMore;
    
    //搜索到的数据源
    NSMutableArray* postDataSourceArray;
    
    //历史记录数据
    NSMutableArray* historyArray;
    
    //显示那种列表
    BOOL isShowHistory;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置返回按钮
    [self setBackButtonAndSearchButton];
    //添加刷新控件
    //[self setupRefresh];
    [self initDataSourceAndOther];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    //初始化搜索条
    [self initSearchBar];
}

#pragma mark 初始化相应属性
-(void)initDataSourceAndOther
{
    isMore=NO;
    currentPage=@"1";
    postDataSourceArray=[[NSMutableArray alloc]init];
    historyArray=[[NSMutableArray alloc]init];
    
    [historyArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"seat_history"]];
    //判断是否显示的历史记录
    isShowHistory=YES;
    [self.view addSubview:self.LinGroupTableView];
    [_LinGroupTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_LinGroupTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_LinGroupTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_LinGroupTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_searchBar removeFromSuperview];
    [SVProgressHUD dismiss];
}
#pragma mark-------get tableview
-(UITableView *)LinGroupTableView
{
    if (!_LinGroupTableView) {
        _LinGroupTableView = [[UITableView alloc] initForAutoLayout];
        _LinGroupTableView.delegate = self;
        _LinGroupTableView.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_LinGroupTableView];
    }
    return _LinGroupTableView;
}
#pragma mark 添加刷新控件
/**
 *  添加刷新控件
 *
 *  @param isFromButton 是否来自按钮的相应，如果是则不自动刷新
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_LinGroupTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // [_PostTableView headerEndRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_LinGroupTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _LinGroupTableView.headerPullToRefreshText = @"下拉可以刷新了";
    _LinGroupTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _LinGroupTableView.headerRefreshingText = @" ";
    
    _LinGroupTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _LinGroupTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _LinGroupTableView.footerRefreshingText = @" ";
    
}

/**
 *  下拉刷新
 */
#pragma mark 下拉刷新
-(void)headerRereshing
{
    NSLog(@"下拉刷新");
    currentPage=@"1";
    isMore=NO;
    [self searchPost];
    
}
/**
 *  上拉加载更多
 */
#pragma mark 上拉加载更多
-(void)footerRereshing
{
    NSLog(@"上拉加载更多");
    int page=[currentPage intValue]+1;
    currentPage=[NSString stringWithFormat:@"%d",page];
    isMore=YES;
    [self searchPost];
    
}

#pragma mark 设置返回按钮和搜索按钮
-(void)setBackButtonAndSearchButton
{
    //    UIButton* leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //    leftButton.frame=CGRectMake(0, 0, 44, 44);
    //    [leftButton setImage:[UIImage imageNamed:@"news_back_no"] forState:UIControlStateNormal];
    //    [leftButton setImage:[UIImage imageNamed:@"news_back_no"] forState:UIControlStateSelected];
    //    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    //    [leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    
    UIButton* rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 44*LinPercent, 30);
    rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -40);
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    rightButton.layer.borderWidth = 1;
    rightButton.layer.borderColor = UIColorFromRGB(0xcd4a56).CGColor;
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 3.0f;
    //[rightButton setImage:[UIImage imageNamed:@"search_search"] forState:UIControlStateNormal];
    //[rightButton setImage:[UIImage imageNamed:@"search_search"] forState:UIControlStateSelected];
    
    [rightButton addTarget:self action:@selector(searchPost) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  获取搜索所需列表数据
 */
-(void)searchPost
{
    NSLog(@"搜索关键字");
    if (![_searchBar.text isEqualToString:@""])
    {
        //搜索后显示搜索cell
        isShowHistory=NO;
        
        //收起键盘
        [_searchBar resignFirstResponder];
        
        //添加刷新控件
        [self setupRefresh];
        if (historyArray.count!=0)
        {
            if (![historyArray containsObject:_searchBar.text])
            {
                NSLog(@"成功添加历史记录");
                [historyArray addObject:_searchBar.text];
            }
            else
            {
                NSLog(@"已有该数据");
            }
        }
        else
        {
            [historyArray addObject:_searchBar.text];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:@"seat_history"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        if (![_u_lat isEqualToString:@"0"] && ![_u_lng isEqualToString:@"0"])
        {
            [SVProgressHUD showWithStatus:@"搜索中..." maskType:SVProgressHUDMaskTypeBlack];
            NSString *city_id = [[NSUserDefaults standardUserDefaults]objectForKey:KCityID];
            if (city_id == nil) {
                city_id = @"0";
            }
            NSString *url = SEARCH_SEAT_POST;
            NSDictionary* dict=@{
                                 @"app_key":url,
                                 @"area_id":@"0",
                                 @"cat_id":@"0",
                                 @"lng":_u_lng,
                                 @"lat":_u_lat,
                                 @"order":@"distance",
                                 @"page":currentPage,
                                 @"like":_searchBar.text,
                                 @"city_id":city_id
                                 };
            
            [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                if ([[param objectForKey:@"code"] integerValue]==200)
                {
                    [SVProgressHUD dismiss];
                    //字典数组转换模型数组
                    NSLog(@"%@",[param objectForKey:@"obj"]);
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    NSArray *tmpArr = [param objectForKey:@"obj"];
                    for (NSDictionary *dic in tmpArr) {
                        orderSeatInfo *info = [[orderSeatInfo alloc] initWithDictionary:dic];
                        [array addObject:info];
                    }
                    //NSArray* themePostArr=[index_Recommend_info objectArrayWithKeyValuesArray:[param objectForKey:@"obj"]];
                    //封装数据
                    //精选主题页面添加
                    if (isMore)
                    {
                        [postDataSourceArray addObjectsFromArray:array];
                        [_LinGroupTableView footerEndRefreshing];
                    }
                    else
                    {
                        [postDataSourceArray removeAllObjects];
                        [postDataSourceArray addObjectsFromArray:array];
                        [_LinGroupTableView headerEndRefreshing];
                    }
                    if (postDataSourceArray.count!=0)
                    {
                        [_LinGroupTableView reloadData];
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:@"暂无该类信息"];
                        [_LinGroupTableView reloadData];
                    }
                    
                }
                else
                {
                    NSLog(@"搜索帖子数据异常");
                }
            } andErrorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"暂无该类信息"];
            }];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"定位失败无法搜索"];
            [_LinGroupTableView reloadData];
            
        }
    }
    else
    {
        NSLog(@"输入错误");
    }
    
}

#pragma mark 初始化搜索条
-(void)initSearchBar
{
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(38, 7, 220*LinPercent, 30)];
    _searchBar.delegate=self;
    _searchBar.tintColor=[UIColor blueColor];
    _searchBar.placeholder=@"输入搜索关键字...";
    _searchBar.keyboardType=UIKeyboardTypeDefault;
    [_searchBar becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:_searchBar];
}


#pragma mark tableViewDelegateAndDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowHistory)
    {
        if (indexPath.row<historyArray.count)
        {
            static NSString *CellIdentifier = @"history";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.font=[UIFont systemFontOfSize:18];
            if (historyArray.count!=0)
            {
                cell.textLabel.text=[historyArray objectAtIndex:historyArray.count-1-indexPath.row];
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor=[UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"delete";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier];
            }
            cell.backgroundColor=UIColorFromRGB(0xf8f8f8);
            cell.textLabel.font=[UIFont systemFontOfSize:18];
            cell.textLabel.text=@"清除历史记录";
            cell.imageView.image=[UIImage imageNamed:@"shop_searchclear"];
            cell.textLabel.textAlignment=NSTextAlignmentRight;
            cell.textLabel.textColor=[UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
            return cell;
        }
        
    }
    else
    {
        static NSString *simpleTableIdentifier=@"search_seat_cell";
        orderSeatTableViewCell *cell=(orderSeatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell==nil)
        {
            cell = [[orderSeatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
        }
        while ([cell.contentView.subviews lastObject]!= nil) {
            [[cell.contentView.subviews lastObject]removeFromSuperview];
        }
        orderSeatInfo *info = [postDataSourceArray objectAtIndex:indexPath.row];
        //[cell configureCell:info];
        [cell confirgure:info];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowHistory)
    {
        return 40;
    }
    else
    {
        return 80;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isShowHistory)
    {
        if (historyArray.count==0)
        {
            return 0;
        }
        else
        {
            return historyArray.count+1;
        }
    }
    else
    {
        return postDataSourceArray.count;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowHistory)
    {
        if (indexPath.row<historyArray.count)
        {
            _searchBar.text=[historyArray objectAtIndex:historyArray.count-indexPath.row-1];
        }
        else
        {
            [historyArray removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:@"seat_history"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_LinGroupTableView reloadData];
        }
    }
    else
    {
        NSLog(@"跳转到商家详情");
        orderSeatDetailViewController *firVC = [[orderSeatDetailViewController alloc] init];
        [firVC setNavBarTitle:@"商家详情" withFont:14.0f];
//        [firVC.navigationItem setTitle:@"商家详情"];
        orderSeatInfo *info = [postDataSourceArray objectAtIndex:indexPath.row];
        firVC.info = info;
        firVC.shop_id = info.shop_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //如果是常用板块则显示section列表
    if (isShowHistory)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isShowHistory)
    {
        return @"历史记录";
    }
    else
    {
        return @" ";
    }
    
}
/**
 *  重新设置sectionView 更改相应属性
 *
 *  @param tableView 所对应tableView
 *  @param section   每个section
 *
 *  @return 返回所需View
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isShowHistory)
    {
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor =UIColorFromRGB(0xafafaf) ;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 22)];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text=@"历史记录";
        [myView addSubview:titleLabel];
        return myView;
    }
    else
    {
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isShowHistory)
    {
        return 22;
    }
    else
    {
        return 0;
    }
}



#pragma mark searchBar代理方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"键盘搜索");
    [self searchPost];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
        NSLog(@"heiheihei");
        isShowHistory=YES;
        [postDataSourceArray removeAllObjects];
        //tableView取消刷新控件
        [_LinGroupTableView removeHeader];
        [_LinGroupTableView removeFooter];
        [_LinGroupTableView reloadData];
    }
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
