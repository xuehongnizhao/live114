//
//  ReviewListViewController.m
//  CardLeap
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ReviewListViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "reviewInfo.h"
#import "reviewTableViewCell.h"
#import "CateButtonView.h"

@interface ReviewListViewController ()<UITableViewDataSource,UITableViewDelegate,cateButtonDelegate>
{
    NSMutableArray *reviewArray;//评价列表数组
    int page;//分页
    NSString *type;//type类型
}
@property (strong, nonatomic) UITableView *reviewTableview;
@end

@implementation ReviewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    //[self getDataFromNet];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------------getData
-(void)getDataFromNet
{
    NSString *url = connect_url(@"shop_review");
    NSString *shopOrGroupID;// 团购时传group_id，其他情况传shop_id。
    if (self.group_id == nil) {
        shopOrGroupID = self.shop_id;
    }else{
        shopOrGroupID = self.group_id;
    }
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"shop_id":shopOrGroupID,
                           @"rev_type":type,
                           };
    [[LinLoadingView shareInstances:self.view] startAnimation];  //开始转动
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            if (page == 1) {
                [reviewArray removeAllObjects];
            }
            [[LinLoadingView shareInstances:self.view] stopWithAnimation:[param objectForKey:@"message"]];
            NSArray *arr = [param objectForKey:@"obj"];
            if (arr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无评价"];
            }else {
                for (NSDictionary *dic in arr) {
                    reviewInfo *info = [[reviewInfo alloc] initWithDictionary:dic];
                    [reviewArray addObject:info];
                }
            }
            [self.reviewTableview reloadData];
        }else{
            [[LinLoadingView shareInstances:self.view] stopWithAnimation:[param objectForKey:@"message"]];
        }
        [self.reviewTableview footerEndRefreshing];
        [self.reviewTableview headerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [self.reviewTableview footerEndRefreshing];
        [self.reviewTableview headerEndRefreshing];
        [[LinLoadingView shareInstances:self.view] stopWithAnimation:@"网络异常"];
    }];
}

#pragma mark------------初始化 数据
-(void)initData
{
    NSLog(@"shop_id:%@  cate_id:%@  index:%@",self.shop_id,self.cate_id,self.index);
    page = 1;
    reviewArray = [[NSMutableArray alloc] init];
//    type = @"0";
    type = self.index;
}

#pragma mark------------set UI
-(void)setUI
{
//    [self setCateButton];
    [self getDataFromNet];
    [self.view addSubview:self.reviewTableview];
    [_reviewTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_reviewTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_reviewTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_reviewTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    //添加分割线
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_reviewTableview withOffset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    lineImage.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    lineImage.layer.borderWidth = 0.5;
}

#pragma mark-----设置分类按钮
-(void)setCateButton
{
    NSArray *titleArray = @[@"全部",@"团购",@"外卖",@"订酒店",@"订座位"];
    NSArray *tagArray = @[@"0",@"1",@"2",@"3",@"4"];

    CGRect rect = [[UIScreen mainScreen] bounds];
    CateButtonView *cateView = [[CateButtonView alloc] initWithFrame:CGRectMake(5, 5, rect.size.width-10, 30) titleArray:titleArray tagArray:tagArray index:[self.index integerValue]];
    cateView.delegate = self;
    [cateView setIndex:[self.index integerValue]];
    [self.view addSubview:cateView];
}

#pragma mark------------cate delegate
-(void)chooseCateID:(NSInteger)cateID
{
    NSLog(@"do something");
    type = [NSString stringWithFormat:@"%ld",(long)cateID];
    [reviewArray removeAllObjects];
    [self getDataFromNet];
}

#pragma mark------------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"review_cell";
    reviewTableViewCell *cell=(reviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[reviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
//    while ([cell.contentView.subviews lastObject]!= nil) {
//        [[cell.contentView.subviews lastObject]removeFromSuperview];
//    }
    reviewInfo *info = [reviewArray objectAtIndex:indexPath.row];
    [cell configureCell:info];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewArray count];
}

#pragma mark------------get UI
-(UITableView *)reviewTableview
{
    if (!_reviewTableview) {
        _reviewTableview = [[UITableView alloc] initForAutoLayout];
        _reviewTableview.delegate = self;
        _reviewTableview.dataSource = self;
        //_reviewTableview.layer.borderWidth = 1;
        [UZCommonMethod hiddleExtendCellFromTableview:_reviewTableview];
        [_reviewTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_reviewTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _reviewTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _reviewTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _reviewTableview.footerRefreshingText = @"正在刷新，请稍后";
        _reviewTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _reviewTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _reviewTableview.headerRefreshingText = @"马上就出现了";
        if ([_reviewTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_reviewTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_reviewTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_reviewTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _reviewTableview;
}

#pragma mark----------上拉 下拉 方法
-(void)headerBeginRefreshing
{
    NSLog(@"开始下拉刷新");
    page = 1;
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    NSLog(@"开始上拉加载更多");
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
