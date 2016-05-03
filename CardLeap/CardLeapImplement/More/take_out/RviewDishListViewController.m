//
//  RviewDishListViewController.m
//  CardLeap
//
//  Created by lin on 1/6/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "RviewDishListViewController.h"
#import "UserReviewViewController.h"
#import "reviewDishInfo.h"
#import "myOrderViewController.h"

@interface RviewDishListViewController ()<UITableViewDataSource,UITableViewDelegate,finishDelegate>
{
    NSMutableArray *linDishArray;
}
@property (strong, nonatomic) UITableView *dishListTablview;
@end

@implementation RviewDishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self initData];
    [self getDataFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---------init data
-(void)initData
{
    linDishArray = [[NSMutableArray alloc] init];
}

#pragma mark---------get Data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"review_no_list");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"order_id":self.order_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            NSArray *tmpArray = [param objectForKey:@"obj"];
            for (NSDictionary *dic in tmpArray) {
                reviewDishInfo *info = [[reviewDishInfo alloc] initWithDictinoary:dic];
                [linDishArray addObject:info];
            }
            [self.dishListTablview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark---------set UI
-(void)setUI
{
    [self.view addSubview:self.dishListTablview];
    [_dishListTablview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_dishListTablview autoPinEdgeToSuperviewEdge:ALEdgeLeft  withInset:0.0f];
    [_dishListTablview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_dishListTablview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
}

#pragma mark---------get UI
-(UITableView *)dishListTablview
{
    if (!_dishListTablview) {
        _dishListTablview = [[UITableView alloc] initForAutoLayout];
        _dishListTablview.delegate = self;
        _dishListTablview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_dishListTablview];
    }
    return _dishListTablview;
}

#pragma mark---------tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_review_cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    reviewDishInfo *info = [linDishArray objectAtIndex:indexPath.row];
    NSString *title = info.take_name;
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = UIColorFromRGB(singleTitle);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [linDishArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    reviewDishInfo *info = [linDishArray objectAtIndex:indexPath.row];
    UserReviewViewController *firVC = [[UserReviewViewController alloc] init];
    firVC.delegate = self;
    [firVC setNavBarTitle:@"菜品评价" withFont:14.0f];
    firVC.info = info;
    firVC.order_id = self.order_id;
    firVC.index = indexPath.row;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)finishDelegateAction:(NSInteger)index
{
    [linDishArray removeObjectAtIndex:index];
    [self.dishListTablview reloadData];
    if (linDishArray.count == 0) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[myOrderViewController class]] == YES) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
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
