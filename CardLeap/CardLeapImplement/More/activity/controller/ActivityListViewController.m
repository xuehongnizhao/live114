//
//  ActivityListViewController.m
//  CardLeap
//
//  Created by lin on 1/9/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "ActivityListViewController.h"
#import "activityInfo.h"
#import "AcitvityTableViewCell.h"
#import "MXPullDownMenu.h"
#import "UIScrollView+MJRefresh.h"
#import "cateInfo.h"
#import "ZQFunctionWebController.h"

@interface ActivityListViewController ()<UITableViewDataSource,UITableViewDelegate,MXPullDownMenuDelegate>
{
    int page;
    //-----------------------
    NSMutableArray *activityArray;
    NSMutableArray *cateArray;
    NSMutableArray *areaArray;
    NSMutableArray *sortArray;
    NSString *cate;
    NSString *area;
    NSString *order;
    //-------二级菜单-------------
    MXPullDownMenu *menu;
}
@property (strong, nonatomic) UITableView *activityTableview;
@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getCateFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-------------get data
-(void)getCateFromNet
{
    NSString *url = connect_url(@"activity_cate_list");
    NSDictionary *dic = @{
                          @"app_key":url
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
    info0.cate_name = @"默认排序";
    info0.cate_id = @"0";
    info0.son = [[NSMutableArray alloc] init];
    
    cateInfo *info1 = [[cateInfo alloc] init];
    info1.cate_name = @"最新发布";
    info1.cate_id = @"add_time";
    info1.son = [[NSMutableArray alloc] init];
    cateInfo *info2 = [[cateInfo alloc] init];
    info2.cate_name = @"结束时间";
    info2.cate_id = @"end_time";
    info2.son = [[NSMutableArray alloc] init];
    cateInfo *info3 = [[cateInfo alloc] init];
    info3.cate_name = @"开始时间";
    info3.cate_id = @"begin_time";
    info3.son = [[NSMutableArray alloc] init];
    [sortArray addObjectsFromArray:@[info0,info1,info2,info3]];
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
    [self getDataFromNet];
}


-(void)getDataFromNet
{
    NSString *city_id = [[NSUserDefaults standardUserDefaults] objectForKey:KCityID];
    if (city_id == nil) {
        city_id = @"0";
    }
    NSString *url = connect_url(@"activity_list");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"cat_id":cate,
                           @"area_id":area,
                           @"order":order,
                           @"city_id":city_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if([param[@"code"] integerValue]==200){
            [SVProgressHUD dismiss];
            if (page==1) {
                [activityArray removeAllObjects];
            }
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                activityInfo *info = [[activityInfo alloc] initWithDictionary:dic];
                [activityArray addObject:info];
            }
            [self.activityTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.activityTableview headerEndRefreshing];
        [self.activityTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-------------get UI
-(UITableView *)activityTableview
{
    if (!_activityTableview) {
        _activityTableview = [[UITableView alloc] initForAutoLayout];
        _activityTableview.delegate = self;
        _activityTableview.dataSource = self;
        _activityTableview.separatorInset = UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_activityTableview];
        [_activityTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_activityTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _activityTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _activityTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _activityTableview.footerRefreshingText = @"正在加载，请稍等";
        _activityTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _activityTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _activityTableview.headerRefreshingText = @"正在刷新，请稍等";
        if ([_activityTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_activityTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_activityTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_activityTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _activityTableview;
}

-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    page = 1;
    [self getDataFromNet];
}

-(void)footerBeginRefreshing{
    NSLog(@"上拉加载更多");
    page ++;
    [self getDataFromNet];
}

#pragma mark-------------set UI
-(void)setUI
{
    [self.view addSubview:self.activityTableview];
    [_activityTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_activityTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_activityTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    [_activityTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
}

#pragma mark-------------init data
-(void)initData
{
    page = 1;
    cate = @"0";
    area = @"0";
    order = @"0";
    activityArray = [[NSMutableArray alloc] init];
    //--------二级下拉列表---------
    cateArray = [[NSMutableArray alloc] init];
    areaArray = [[NSMutableArray alloc] init];
    sortArray = [[NSMutableArray alloc] init];
}

#pragma mark-------------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    activityInfo *info = [activityArray objectAtIndex:indexPath.row];
    ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"活动详情" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"活动详情"];
    firVC.url = info.message_url;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"shop_takeout_cell";
    AcitvityTableViewCell *cell=(AcitvityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[AcitvityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    activityInfo *info = [activityArray objectAtIndex:indexPath.row];
    [cell confirgureCell:info];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activityArray count];
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
