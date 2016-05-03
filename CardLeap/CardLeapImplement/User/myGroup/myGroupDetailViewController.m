
//
//  myGroupDetailViewController.m
//  CardLeap
//
//  Created by mac on 15/2/2.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  我的团购

#import "myGroupDetailViewController.h"
#import "ReviewListViewController.h"
#import "GroupDetailViewController.h"
#import "myGroupDetailTableViewCell.h"
#import "GroupReviewViewController.h"
#import "payAlipayWebViewController.h"
#import "myGroupPayBackViewController.h"
#import "UpdateGroupViewController.h"

@interface myGroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,
                                        myGroupDetailCellDelegate,GroupRefreshDelegate,
                                        completeDelegate,UIWebViewDelegate>
{
    CGFloat height_web;
    BOOL isFirst;
}
@property (strong,nonatomic) UITableView *myGroupDetailTableview;
@end

@implementation myGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getHeight];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------get webview height
-(void)getHeight
{
    height_web = 0;
    isFirst = NO;
    UIWebView *tmpWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 600, SCREEN_WIDTH, 100)];
    [self.view addSubview:tmpWeb];
    tmpWeb.backgroundColor = [UIColor clearColor];
    tmpWeb.delegate = self;
    NSString *urlString = self.info.group_url;
    [tmpWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    height_web = [height_str floatValue];
    if (isFirst == NO) {
        isFirst = YES;
        UIWebView *tmpWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 600, SCREEN_WIDTH, 100)];
        [self.view addSubview:tmpWeb];
        tmpWeb.delegate = self;
        NSString *urlString = self.info.group_url;
        [tmpWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }else{
        [self.myGroupDetailTableview reloadData];
        self.myGroupDetailTableview.scrollEnabled = YES;
        [webView removeFromSuperview];
        webView = nil;
    }
}

#pragma mark-------set UI
-(void)setUI
{
    [self.view addSubview:self.myGroupDetailTableview];
    [_myGroupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myGroupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_myGroupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_myGroupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
}

#pragma mark-------get UI
-(UITableView *)myGroupDetailTableview
{
    if (!_myGroupDetailTableview) {
        _myGroupDetailTableview = [[UITableView alloc] initForAutoLayout];
        _myGroupDetailTableview.delegate = self;
        _myGroupDetailTableview.dataSource = self;
        _myGroupDetailTableview.scrollEnabled = NO;
        [UZCommonMethod hiddleExtendCellFromTableview:_myGroupDetailTableview];
        if ([_myGroupDetailTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myGroupDetailTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_myGroupDetailTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myGroupDetailTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myGroupDetailTableview;
}

#pragma mark-------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        GroupDetailViewController *firVC = [[GroupDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        firVC.group_id = self.info.group_id;
        [firVC setNavBarTitle:self.info.group_name withFont:14.0f];
//        [firVC.navigationItem setTitle:self.info.group_name];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if (section == 1) {
        NSLog(@"跳转到评价列表 或者 去评价 或者 不跳转");
        if ([self.info.status integerValue]==2) {
            //该去评价了
            GroupReviewViewController *firVC = [[GroupReviewViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:@"团购评价" withFont:14.0f];
//            [firVC.navigationItem setTitle:@"团购评价"];
            firVC.info = self.info;
            firVC.delegate = self;
            [self.navigationController pushViewController:firVC animated:YES];
            
        }else if ([self.info.status integerValue]==3){
            ReviewListViewController *firVC = [[ReviewListViewController alloc] init];
            firVC.shop_id = self.info.shop_id;
            firVC.cate_id = @"1";
            firVC.index = @"1";
            firVC.group_id = self.info.group_id;
            [firVC setNavBarTitle:@"评价" withFont:14.0f];
            [firVC.navigationItem setTitle:@"评价"];
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }
    //        if(row == 0){
    //            NSLog(@"拨打电话");
    //            NSLog(@"拨打电话");
    //            NSString *telePhone = detailInfo.shop_tel;
    //            NSArray *array = [telePhone componentsSeparatedByString:@","];
    //            if ([array count]==1) {
    //                NSString *num = [array objectAtIndex:0];
    //                [UZCommonMethod callPhone:num superView:self.view];
    //            }else{
    //                NSString *tel_one = [array objectAtIndex:0];
    //                NSString *tel_two = [array objectAtIndex:1];
    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系商家" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:tel_one,tel_two,nil];
    //                alert.tag = 2;
    //                [alert show];
    //            }
    //        }else{
    //
    //        }
    //    }else{
    //        roomInfo *goods_info = [detailInfo.goods_list objectAtIndex:row-1];
    //        orderRoomSubmitViewController *firVC = [[orderRoomSubmitViewController alloc] init];
    //        [firVC setHiddenTabbar:YES];
    //        [firVC.navigationItem setTitle:@"提交订单"];
    //        firVC.info = detailInfo;
    //        firVC.goods_info = goods_info;
    //        [self.navigationController pushViewController:firVC animated:YES];
    //    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat height = 0.0;
    switch (section) {
        case 0:
            
            if (row == 0) {
                height = 90;
            }else if(row == 1){
                if ([self.info.status integerValue]==1 || [self.info.status integerValue]==4 ||[self.info.status integerValue]==5 ) {
                    height = height_web;
                }else if ([self.info.status integerValue]==0){
                    height = 50;
                }
            }else if(row == 2){
                if ([self.info.status integerValue]==0) {
                    height = height_web;
                }else{
                    height = 50;
                }
                
            }
            
            break;
        case 1:
            if (row == 0) {
                height = 40;
            }else{
                height = height_web;
            }
            break;
        case 2:
            
            if([self.info.status integerValue] == 1 || [self.info.status integerValue] == 4 || [self.info.status integerValue] == 5)
            {
                if (row == 0 ) {
                    height = 40;
                }else {
                    NSString *detail = self.info.group_desc;
                    if (detail.length < 30) {
                        height += 20.0f;
                    }else{
                        height += (detail.length/30+1)*20;
                    }
                }
            }else{
                height = 40.0f;
            }
            
            //暂定
            break;
        case 3:
            //暂定
            if ([self.info.status integerValue] == 2 || [self.info.status integerValue] == 3) {
                if (row == 0) {
                    height = 40.0f;
                }else{
                    NSString *detail = self.info.group_desc;
                    if (detail.length < 30) {
                        height += 20.0f;
                    }else{
                        height += (detail.length/30+1)*20;
                    }
                }
            }else{
                if (row == 0) {
                    height = 40.0f;
                }else{
                    height = 40.0f;
                }
            }
            break;
        case 4:
            height = 40.0f;
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"my_group_detail_cell";
    myGroupDetailTableViewCell *cell=(myGroupDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myGroupDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [cell confirgureCell:self.info section:section row:row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count;
    switch (section) {
        case 0:
            if ([self.info.status integerValue]==0) {
                count = 3;
            }else if ([self.info.status integerValue]==1){
                count = 3;
            }else if ([self.info.status integerValue]==2){
                count = 1;
            }else if ([self.info.status integerValue]==3){
                count = 1;
            }else if ([self.info.status integerValue]==4){
                count = 2;
            }else if ([self.info.status integerValue]==5){
                count = 2;
            }
            break;
        case 1:
            if ([self.info.status integerValue]==2){
                count = 2;
            }else if ([self.info.status integerValue]==3){
                count = 2;
            }
            break;
        case 2:
            count = 1;
            if ([self.info.status integerValue]==2 || [self.info.status integerValue]==3) {
                count = 1;
            }else{
                count = 2;
            }
            break;
        case 3:
            if ([self.info.status integerValue]==2 || [self.info.status integerValue]==3) {
                count = 2;
            }else if ([self.info.status integerValue]==1) {
                count = 6;
            }else {
                count = 5;
            }
            break;
        case 4:
            if ([self.info.status integerValue]==2) {
                count = 5;
            }
            if ([self.info.status integerValue]==3) {
                count = 5;
            }
            break;
        default:
            break;
    }
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.info.status integerValue]==0) {
        return 1;
    }else if([self.info.status integerValue]==1){
        return 1;
    }else if([self.info.status integerValue]==2){
        return 2;
    }else if([self.info.status integerValue]==3){
        return 2;
    }else if([self.info.status integerValue]==4){
        return 1;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        //return 40.0f;
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }

    return 7.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark-----cell delegate
-(void)orderActionDelegate:(NSInteger)index
{
    if (index == 0) {
        //去付款
        //更新支付宝订单状态
        UpdateGroupViewController *firVC = [[UpdateGroupViewController alloc] init];
        [firVC setNavBarTitle:@"提交订单" withFont:14.0f];
        firVC.myUpdateInfo = self.info;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if (index == 1){
        //退款
        NSString *url = connect_url(@"group_back");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"order_id":self.info.order_id
                               };
        [SVProgressHUD showWithStatus:@"正在提交申请" maskType:SVProgressHUDMaskTypeClear];
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                //退款成功  修改状态  然后跳转页面
                [SVProgressHUD dismiss];
                self.info.status = @"4";
                [self.myGroupDetailTableview reloadData];
                //跳转
                myGroupPayBackViewController *firVC = [[myGroupPayBackViewController alloc] init];
                [firVC setHiddenTabbar:YES];
                [firVC setNavBarTitle:@"退款成功" withFont:14.0f];
//                [firVC.navigationItem setTitle:@"退款成功"];
                firVC.info=self.info;
                [self.navigationController pushViewController:firVC animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }
}

-(void)refreshAction
{
    NSLog(@"评价回来刷新");
    self.info.status = @"3";
    [_myGroupDetailTableview reloadData];
}

-(void)completeAction
{
    NSLog(@"支付完成跳转回");
    
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
