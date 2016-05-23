//
//  HighWayViewController.m
//  cityo2o
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "HighWayViewController.h"

@interface HighWayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) UIView *naviView;
@property (strong, nonatomic) UIView *refreshDateView;
@property (strong, nonatomic) UILabel *refreshDateLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableHeadView;

@end

@implementation HighWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self setUI];
}

- (UILabel *)refreshDateLabel{
    if (!_refreshDateLabel) {
        _refreshDateLabel=[[UILabel alloc]initForAutoLayout];
    }
    return _refreshDateLabel;
}
- (UIView *)refreshDateView{
    if (!_refreshDateView) {
        _refreshDateView=[[UIView alloc]initForAutoLayout];
        _refreshDateView.backgroundColor=[UIColor yellowColor];
        [_refreshDateView addSubview:self.refreshDateLabel];
        [_refreshDateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_refreshDateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_refreshDateLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_refreshDateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        _refreshDateLabel.textAlignment=NSTextAlignmentCenter;
        _refreshDateLabel.text=@"asdfsadf";
        
    }
    return _refreshDateView;
}



- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView=[[UIView alloc]initForAutoLayout];
        
    }
    return _tableHeadView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initForAutoLayout];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        //        _tableView.tableHeaderView=
    }
    return _tableView;
}
- (UIView *)naviView{
    if (!_naviView) {
        _naviView=[[UIView alloc]initForAutoLayout];
        _naviView.backgroundColor=[UIColor colorWithRed:0.3594 green:0.9934 blue:0.3348 alpha:1.0];
        [_naviView addSubview:self.dismissButton];
        [_dismissButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [_dismissButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [_dismissButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    }
    return _naviView;
}
- (UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton=[[UIButton alloc]initForAutoLayout];
        [_dismissButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dissmissButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (void)dissmissButtonAction{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (void)setUI{
    
    [self.view addSubview:self.naviView];
    [_naviView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [_naviView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_naviView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_naviView autoSetDimension:ALDimensionHeight toSize:40];
    [self.view addSubview:self.refreshDateView];
    [_refreshDateView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.naviView];
    [_refreshDateView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_refreshDateView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_refreshDateView autoSetDimension:ALDimensionHeight toSize:40];
    [self.view addSubview:self.tableView];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.refreshDateView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
