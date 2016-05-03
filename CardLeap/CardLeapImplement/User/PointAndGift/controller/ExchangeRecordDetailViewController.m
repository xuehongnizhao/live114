//
//  ExchangeRecordDetailViewController.m
//  cityo2o
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ExchangeRecordDetailViewController.h"

@interface ExchangeRecordDetailViewController ()
@property (strong,nonatomic)UIWebView *detailWeb;
@end

@implementation ExchangeRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------set UI
-(void)setUI
{
    [self.view addSubview:self.detailWeb];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}

#pragma mark------get UI
-(UIWebView *)detailWeb
{
    if (!_detailWeb) {
        _detailWeb = [[UIWebView alloc] initForAutoLayout];
        [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    return _detailWeb;
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
