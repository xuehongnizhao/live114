//
//  ReplyViewController.m
//  CardLeap
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ReplyViewController.h"
#import "ReplyInfo.h"
#import "ReplyTableViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "LinFriendCircleDetailController.h"
@interface ReplyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *replyTableview;
@property (strong, nonatomic) NSMutableArray *replyArray;
@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) UIButton *clearButton;
@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getData];
}

#pragma mark-----设置UI
-(void)setUI
{
    [self.view addSubview:self.replyTableview];
    [self.replyTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [self.replyTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [self.replyTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [self.replyTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.clearButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}

#pragma mark-----获取数据
-(void)getData
{
    NSString *post_url = connect_url(@"com_read_list");
    NSDictionary *dic = @{
                          @"app_key":post_url,
                          @"u_id":[UserModel shareInstance].u_id,
                          @"is_read":self.is_read,
                          @"page":_page
                          };
    //[SVProgressHUD showWithStatus:@"正在获取回复列表" maskType:SVProgressHUDMaskTypeClear];
    [[LinLoadingView shareInstances:self.view] startAnimation];
    [Base64Tool postSomethingToServe:post_url andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param){
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            //[SVProgressHUD dismiss];
            [[LinLoadingView shareInstances:self.view]stopWithAnimation:[param objectForKey:@"message"]];
            if ([_page isEqualToString:@"1"]) {
                [_replyArray removeAllObjects];
            }
            //数据封装 reload
            NSArray *array = [param objectForKey:@"obj"];
            //判断是否有回复  如果没有则显示样式发生改变
            if ([array count]>0) {
                for (NSDictionary *dict in array) {
                    ReplyInfo *info = [[ReplyInfo alloc] initWithDictionary:dict];
                    [_replyArray addObject:info];
                }
            }else{
                if([_page integerValue] == 1 && [array count]==0){
                    //添加列表为空的样式图
                    
                    UIImageView *blank_message_iamge = [[UIImageView alloc] initForAutoLayout];
                    blank_message_iamge.image=[UIImage imageNamed:@"nomessages"];
                    [self.view addSubview:blank_message_iamge];
                    //                    [blank_message_iamge autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
                    //                    [blank_message_iamge autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
                    //                    [blank_message_iamge autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
                    //                    [blank_message_iamge autoSetDimension:ALDimensionHeight toSize:200.0f];
                    [blank_message_iamge autoAlignAxis:ALAxisVertical toSameAxisOfView:self.replyTableview];
                    [blank_message_iamge autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.replyTableview];
                    //                    [blank_message_iamge autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH - 20];
                    //                    [blank_message_iamge autoSetDimension:ALDimensionHeight toSize:SCREEN_HEIGHT - 50];
                    
                    self.replyTableview.userInteractionEnabled = NO;
                }
            }
            [self.replyTableview reloadData];
        }else{
            [[LinLoadingView shareInstances:self.view]stopWithAnimation:[param objectForKey:@"message"]];
            //[SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
        [self.replyTableview footerEndRefreshing];
        [self.replyTableview headerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [[LinLoadingView shareInstances:self.view]stopWithAnimation:@"网络不给力"];
        //[SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark-----初始化数据
-(void)initData
{
    _replyArray = [[NSMutableArray alloc] init];
    _page = @"1";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHiddenTabbar:YES];
}

#pragma mark---------tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"index_cell";
    ReplyTableViewCell *cell=(ReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!=nil) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    ReplyInfo *info = [_replyArray objectAtIndex:indexPath.row];
    [cell configureCell:info];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyInfo *info = [_replyArray objectAtIndex:indexPath.row];
    if (info.reply_text.length > 28) {
        CGFloat height = 75.0 + ((info.reply_text.length-28)/14+1)*15.0f;
        return height;
    }
    return 75.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击进入详情");
    ReplyInfo *info = [_replyArray objectAtIndex:indexPath.row];
    NSLog(@"帖子id是%@",info.com_id);
    LinFriendCircleDetailController *firVC = [[LinFriendCircleDetailController alloc] init];
    [firVC setNavBarTitle:@"发现详情" withFont:14.0f];
    firVC.com_id = info.com_id;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_replyArray count];
}

#pragma mark--------button action
-(void)clearActino:(UIButton*)sender
{
    NSLog(@"清空");
    NSString *url = connect_url(@"com_q");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"u_id":[UserModel shareInstance].u_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if([param[@"code"] integerValue]==200){
            [_replyArray removeAllObjects];
            [self.replyTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark--------get 各种控件
-(UIButton *)clearButton
{
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
        [_clearButton setTitle:@"清空" forState:UIControlStateHighlighted];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_clearButton addTarget:self action:@selector(clearActino:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

-(UITableView *)replyTableview
{
    if (!_replyTableview) {
        _replyTableview = [[UITableView alloc] initForAutoLayout];
        _replyTableview.delegate = self;
        _replyTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_replyTableview];
        [_replyTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_replyTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _replyTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _replyTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _replyTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _replyTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _replyTableview.headerRefreshingText = @" ";
    }
    return _replyTableview;
}

#pragma mark----------分页及刷新
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    int page = [_page intValue];
    page ++;
    _page = [NSString stringWithFormat:@"%d",page];
    [self getData];
}

-(void)footerBeginRefreshing
{
    NSLog(@"上拉加载下一页");
    _page = @"1";
    [self getData];
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
