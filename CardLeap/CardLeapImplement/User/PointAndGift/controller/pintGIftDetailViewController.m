//
//  pintGIftDetailViewController.m
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "pintGIftDetailViewController.h"
#import "ExchangeGiftViewController.h"

@interface pintGIftDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UIView *headerView;//展示头视图
@property (strong,nonatomic)UIImageView *headerImage;//图片
@property (strong,nonatomic)UILabel *pointNumLable;//积分数量
@property (strong,nonatomic)UIButton *ExchangeButton;//兑换按钮
@property (strong,nonatomic)UIWebView *detailWeb;//详情web视图
@end

@implementation pintGIftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self loadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------setUI
-(void)setUI
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view setAlpha:1.0f];
    //头视图
    [self.view addSubview:self.headerView];
    [_headerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_headerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_headerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_headerView autoSetDimension:ALDimensionHeight toSize:220.0f];
    //头视图布局
    [_headerView addSubview:self.headerImage];
    [_headerImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_headerImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_headerImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_headerImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50.0f];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailInfo.img] placeholderImage:[UIImage imageNamed:@"user"]];
    //所需积分
    [_headerView addSubview:self.pointNumLable];
    [_pointNumLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerImage withOffset:10.0f];
    [_pointNumLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_pointNumLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_pointNumLable autoSetDimension:ALDimensionWidth toSize:130.0f];
    _pointNumLable.text = [NSString stringWithFormat:@"%@积分",self.detailInfo.mall_integral];
    //兑换按钮
    [_headerView addSubview:self.ExchangeButton];
    [_ExchangeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerImage withOffset:5.0f];
    [_ExchangeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
    [_ExchangeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_ExchangeButton autoSetDimension:ALDimensionWidth toSize:100.0f];
    if ([self.detailInfo.color integerValue]==1) {
        //可以兑换
        [_ExchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        [_ExchangeButton setTitle:@"立即兑换" forState:UIControlStateHighlighted];
    }else{
        //不可以兑换
        [_ExchangeButton setTitle:self.detailInfo.result forState:UIControlStateNormal];
        [_ExchangeButton setTitle:self.detailInfo.result forState:UIControlStateHighlighted];
        [_ExchangeButton setBackgroundColor:[UIColor lightGrayColor]];
        _ExchangeButton.enabled = NO;
    }
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    [lineImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerView withOffset:0.0f];
    [lineImage setBackgroundColor:[UIColor lightGrayColor]];
    //web页面
    [self.view addSubview:self.detailWeb];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_detailWeb autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerView withOffset:1.0f];
}

#pragma mark-------webview加载url
-(void)loadRequest
{
    //加载网页
    [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailInfo.message_url]]];
}

#pragma mark------get UI
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initForAutoLayout];
    }
    return _headerView;
}

-(UIWebView *)detailWeb
{
    if (!_detailWeb) {
        _detailWeb = [[UIWebView alloc] initForAutoLayout];
        [_detailWeb setBackgroundColor:[UIColor whiteColor]];
    }
    return _detailWeb;
}

-(UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] initForAutoLayout];
    }
    return _headerImage;
}

-(UILabel *)pointNumLable
{
    if (!_pointNumLable) {
        _pointNumLable = [[UILabel alloc] initForAutoLayout];
        _pointNumLable.font = [UIFont systemFontOfSize:17.0f];
        _pointNumLable.textColor = UIColorFromRGB(0xe16c6c);
    }
    return _pointNumLable;
}

-(UIButton *)ExchangeButton
{
    if (!_ExchangeButton) {
        _ExchangeButton = [[UIButton alloc] initForAutoLayout];
        _ExchangeButton.layer.masksToBounds = YES;
        _ExchangeButton.layer.cornerRadius = 4.0f;
        _ExchangeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_ExchangeButton setBackgroundColor:UIColorFromRGB(0xe34a51)];
        [_ExchangeButton addTarget:self action:@selector(ExchangeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ExchangeButton;
}

-(void)ExchangeAction:(UIButton*)sender
{
    NSLog(@"兑换");
    ExchangeGiftViewController *firVC = [[ExchangeGiftViewController alloc] init];
    [firVC setNavBarTitle:@"确认兑换" withFont:14.0f];
    [firVC setHiddenTabbar:YES];
    firVC.info  =  self.detailInfo;
    [self.navigationController pushViewController:firVC animated:YES];
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
