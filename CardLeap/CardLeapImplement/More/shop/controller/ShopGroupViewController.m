//
//  ShopGroupViewController.m
//  CardLeap
//
//  Created by mac on 15/2/4.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ShopGroupViewController.h"
#import "groupInfo.h"
#import "GroupDetailViewController.h"
#import "groupListTableViewCell.h"

@interface ShopGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *groupArray;
    int page;
}
@property (strong,nonatomic)UITableView *shopGroupTableview;
@end

@implementation ShopGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----init data
-(void)initData
{
    groupArray  = [[NSMutableArray alloc] init];
}

#pragma mark-----get data
-(void)getData
{
    NSString *url = connect_url(@"group_shop");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"shop_id":self.shop_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                groupInfo *info = [[groupInfo alloc] initWithDictionary:dic];
                [groupArray addObject:info];
            }
            [self.shopGroupTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-----set UI
-(void)setUI
{
    [self.view addSubview:self.shopGroupTableview];
    [_shopGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_shopGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_shopGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}
#pragma mark-----get UI
-(UITableView *)shopGroupTableview
{
    if (!_shopGroupTableview) {
        _shopGroupTableview = [[UITableView alloc] initForAutoLayout];
        _shopGroupTableview.delegate = self;
        _shopGroupTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_shopGroupTableview];
        if ([_shopGroupTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_shopGroupTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_shopGroupTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_shopGroupTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _shopGroupTableview;
}

#pragma mark-----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    groupInfo *info = [groupArray objectAtIndex:indexPath.row];
    GroupDetailViewController *firVC = [[GroupDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"团购详情" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"团购详情"];
    firVC.group_id = info.group_id;
    //firVC.info = info;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"group_cell";
    groupListTableViewCell *cell=(groupListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[groupListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    groupInfo *info = [groupArray objectAtIndex:indexPath.row];
    [cell confirgureCell:info];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groupArray count];
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
