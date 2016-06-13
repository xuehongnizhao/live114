//
//  ShopActivityViewController.m
//  CardLeap
//
//  Created by mac on 15/2/4.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ShopActivityViewController.h"
#import "ZQFunctionWebController.h"
#import "AcitvityTableViewCell.h"
#import "activityInfo.h"

@interface ShopActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *activityArray;
}
@property (strong,nonatomic)UITableView *shopActivityTableview;
@end

@implementation ShopActivityViewController

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
    activityArray = [[NSMutableArray alloc] init ];
}

#pragma mark-----get data
-(void)getData
{
    NSString *url = connect_url(@"activity_shop");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"shop_id":self.shop_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                activityInfo *info = [[activityInfo alloc] initWithDictionary:dic];
                [activityArray addObject:info];
            }
            [self.shopActivityTableview reloadData];
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
    [self.view addSubview:self.shopActivityTableview];
    [_shopActivityTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_shopActivityTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_shopActivityTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopActivityTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}

#pragma mark-----get UI
-(UITableView *)shopActivityTableview
{
    if (!_shopActivityTableview) {
        _shopActivityTableview = [[UITableView alloc] initForAutoLayout];
        _shopActivityTableview.delegate = self;
        _shopActivityTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_shopActivityTableview];
        if ([_shopActivityTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_shopActivityTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_shopActivityTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_shopActivityTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _shopActivityTableview;
}
#pragma mark-----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    activityInfo *info = [activityArray objectAtIndex:indexPath.row];
    ZQFunctionWebController *firVC = [[ZQFunctionWebController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:info.activity_name withFont:14.0f];
    firVC.url = info.message_url;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"shop_activity_cell";
    AcitvityTableViewCell *cell=(AcitvityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[AcitvityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    activityInfo *info = [activityArray objectAtIndex:indexPath.row];
    [cell confirgureCell:info];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
