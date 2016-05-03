//
//  myCollectionCenterViewController.m
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myCollectionCenterViewController.h"
#import "myCollectionInfo.h"
#import "myCollectionTableViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "ShopDetailViewController.h"

@interface myCollectionCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    int page;//分页
    NSMutableArray *myCollectionArray;//我的收藏数组
}
@property (strong,nonatomic)UITableView *myCollectionTableview;
@end

@implementation myCollectionCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getDataFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------init data
-(void)initData
{
    page = 1;
    myCollectionArray = [[NSMutableArray alloc] init];
}

#pragma mark-------set UI
-(void)setUI
{
    [self.view addSubview:self.myCollectionTableview];
    [_myCollectionTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_myCollectionTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_myCollectionTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myCollectionTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"测试" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
//    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"测试1" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [alert show];
    }
}

#pragma mark-------get data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"my_collection");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"u_id":[UserModel shareInstance].u_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            if (page == 1) {
                [myCollectionArray removeAllObjects];
            }
            NSArray *tmpArray = param[@"obj"];
            for (NSDictionary *dic in tmpArray) {
                myCollectionInfo *info = [[myCollectionInfo alloc] initWithDictionary:dic];
                NSLog(@"info %@",info.shop_id);
                [myCollectionArray addObject:info];
            }
            [self.myCollectionTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.myCollectionTableview headerEndRefreshing];
        [self.myCollectionTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-------get UI
-(UITableView *)myCollectionTableview
{
    if (!_myCollectionTableview) {
        _myCollectionTableview = [[UITableView alloc] initForAutoLayout];
        _myCollectionTableview.delegate=self;
        _myCollectionTableview.dataSource=self;
        [UZCommonMethod hiddleExtendCellFromTableview:_myCollectionTableview];
        [_myCollectionTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_myCollectionTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _myCollectionTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _myCollectionTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _myCollectionTableview.footerRefreshingText = @"正在加载";
        _myCollectionTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _myCollectionTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _myCollectionTableview.headerRefreshingText = @"马上回来";
        if ([_myCollectionTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myCollectionTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_myCollectionTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myCollectionTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myCollectionTableview;
}

#pragma mark-------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----%ld",(long)indexPath.section);
    myCollectionInfo *info = [myCollectionArray objectAtIndex:indexPath.section];
    ShopDetailViewController *firVC = [[ShopDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:info.shop_name withFont:14.0f];
//    [firVC.navigationItem setTitle:info.shop_name];
    firVC.shop_id = info.shop_id;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [myCollectionArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_collection_cell";
    myCollectionTableViewCell *cell=(myCollectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    myCollectionInfo *info = [myCollectionArray objectAtIndex:indexPath.section];
    //NSLog(@"info %@ ------%d",info.shop_id,indexPath.section);
    [cell confirgureCell:info];
    cell.showsReorderControl = YES;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    NSLog(@"去删除");
    myCollectionInfo *info = [myCollectionArray objectAtIndex:indexPath.row];
    [self deleteAction:info];
}

//以下方法可以不是必须要实现，添加如下方法可实现特定效果：
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//实现Cell可上下移动，调换位置，需要实现UiTableViewDelegate中如下方法：

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//当两个Cell对换位置后
- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    [myCollectionArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark-------delete action
-(void)deleteAction :(myCollectionInfo*)info
{
    //先做删除
    NSString *url = connect_url(@"shop_collection");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"collection":@"1",
                           @"shop_id":info.shop_id,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"session_key":[UserModel shareInstance].session_key
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            NSLog(@"删除成功");
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
    //移除数组
    [myCollectionArray removeObject:info];
    [self.myCollectionTableview reloadData];
}

#pragma mark-------refresh action
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    page = 1;
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    NSLog(@"上拉加载更多");
    page ++;
    [self getDataFromNet];
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
