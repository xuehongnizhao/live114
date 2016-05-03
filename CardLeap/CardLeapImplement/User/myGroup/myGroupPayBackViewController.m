//
//  myGroupPayBackViewController.m
//  CardLeap
//
//  Created by mac on 15/2/3.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myGroupPayBackViewController.h"
#import "myGroupDetailViewController.h"
#import "myGroupDetailViewController.h"
//退款页面
@interface myGroupPayBackViewController ()
@property (strong,nonatomic) UIButton *checkOrderButton;//查看订单按钮
@property (strong,nonatomic) UIView *hintView;//背景view
@end

@implementation myGroupPayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----set UI
-(void)setUI
{
    [self.view addSubview:self.hintView];
    [_hintView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_hintView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_hintView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_hintView autoSetDimension:ALDimensionHeight toSize:100.0f];
    
    //-------hint message---------------
    UILabel *one_lable = [[UILabel alloc] initForAutoLayout];
    one_lable.font = [UIFont systemFontOfSize:15.0f];
    one_lable.textColor = UIColorFromRGB(0x444444);
    [_hintView addSubview:one_lable];
    [one_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [one_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [one_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    //[one_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
    //one_lable.layer.borderWidth = 1;
    one_lable.text = @"温馨提示";
    
    UILabel *two_lable = [[UILabel alloc] initForAutoLayout];
    two_lable.font = [UIFont systemFontOfSize:14.0f];
    two_lable.textColor = UIColorFromRGB(0x4f4f4f);
    [_hintView addSubview:two_lable];
    //two_lable.layer.borderWidth = 1;
    [two_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [two_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [two_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:one_lable withOffset:3.0f];
    [two_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
    two_lable.text = @"申请成功";
    
    UILabel *three_lable = [[UILabel alloc] initForAutoLayout];
    three_lable.font = [UIFont systemFontOfSize:14.0f];
    three_lable.textColor = UIColorFromRGB(0x4f4f4f);
    [_hintView addSubview:three_lable];
    //three_lable.layer.borderWidth = 1;
    [three_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [three_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [three_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:two_lable withOffset:3.0f];
    [three_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
    three_lable.text = @"退款将于1-10个工作日内退还至您的账户";
    
    
    UIImageView *imageLine = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:imageLine];
    [imageLine setBackgroundColor:[UIColor lightGrayColor]];
    [imageLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [imageLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [imageLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_hintView withOffset:0.0f];
    [imageLine autoSetDimension:ALDimensionHeight toSize:0.5f];
    
    [self.view addSubview:self.checkOrderButton];
    [_checkOrderButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_checkOrderButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_checkOrderButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageLine withOffset:10.0f];
    [_checkOrderButton autoSetDimension:ALDimensionHeight toSize:40.0f];
}

#pragma mark-----get UI
-(UIView *)hintView
{
    if (!_hintView) {
        _hintView = [[UIView alloc] initForAutoLayout];
    }
    return _hintView;
}

-(UIButton *)checkOrderButton
{
    if (!_checkOrderButton) {
        _checkOrderButton = [[UIButton alloc] initForAutoLayout];
        _checkOrderButton.layer.masksToBounds = YES;
        _checkOrderButton.layer.cornerRadius = 4.0f;
        [_checkOrderButton setTitle:@"查看订单" forState:UIControlStateNormal];
        [_checkOrderButton setTitle:@"查看订单" forState:UIControlStateHighlighted];
        [_checkOrderButton setBackgroundColor:UIColorFromRGB(0x76c4d0)];
        _checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_checkOrderButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkOrderButton;
}

#pragma mark-----button action
-(void)checkAction:(UIButton*)sender
{
    NSLog(@"查看订单");
    myGroupDetailViewController *firVC = [[myGroupDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"订单详情" withFont:14.0f];
    [firVC.navigationItem setTitle:@"订单详情"];
    firVC.info = self.info;
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
