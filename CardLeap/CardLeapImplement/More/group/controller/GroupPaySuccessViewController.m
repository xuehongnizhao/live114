//
//  GroupPaySuccessViewController.m
//  CardLeap
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "GroupPaySuccessViewController.h"
#import "GroupListViewController.h"
#import "GroupCheckCodeViewController.h"
#import "LoginViewController.h"
#import "GroupDetailViewController.h"

@interface GroupPaySuccessViewController ()
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *successLalbe;
@property (strong, nonatomic) UIButton *backShopButton;
@property (strong, nonatomic) UIButton *checkOrderButton;
@end

@implementation GroupPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.iconImage removeFromSuperview];
//    [self.successLalbe removeFromSuperview];
//    [self.backShopButton removeFromSuperview];
//    [self.checkOrderButton removeFromSuperview];
}

#pragma mark---------set UI
-(void)setUI
{
    [self.navigationItem setHidesBackButton:YES];
    
    [self.view addSubview:self.iconImage];
    //_iconImage.layer.borderWidth = 1;
    [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:60.0f];
    [_iconImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_iconImage autoSetDimension:ALDimensionHeight toSize:100.0f];
    [_iconImage autoSetDimension:ALDimensionWidth toSize:100.0f];
    _iconImage.layer.borderWidth = 1;
    
    [self.view addSubview:self.successLalbe];
    //_successLalbe.layer.borderWidth = 1;
    [_successLalbe autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_successLalbe autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_iconImage withOffset:5.0f];
    [_successLalbe autoSetDimension:ALDimensionWidth toSize:150.0f];
    [_successLalbe autoSetDimension:ALDimensionHeight toSize:30.0f];
    
    UIView *buttonView = [[UIView alloc] initForAutoLayout];
    //buttonView.layer.borderWidth = 1;
    [self.view addSubview:buttonView];
    [buttonView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [buttonView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [buttonView autoSetDimension:ALDimensionHeight toSize:50.0f];
    [buttonView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_successLalbe withOffset:12.0f];
    
    [buttonView addSubview:self.backShopButton];
    [buttonView addSubview:self.checkOrderButton];
    [_backShopButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_backShopButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_backShopButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_backShopButton autoSetDimension:ALDimensionWidth toSize:120.0f];
    
    [_checkOrderButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_checkOrderButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_checkOrderButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_checkOrderButton autoSetDimension:ALDimensionWidth toSize:120.0f];
    //[_backShopButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_checkOrderButton withOffset:-20.0f];
    //[_checkOrderButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_backShopButton withOffset:20.0f];
}

#pragma mark---------get UI
-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initForAutoLayout];
        [_iconImage setImage:[UIImage imageNamed:@"order_sucess"]];
    }
    return _iconImage;
}

-(UILabel *)successLalbe
{
    if (!_successLalbe) {
        _successLalbe = [[UILabel alloc] initForAutoLayout];
        _successLalbe.textColor = [UIColor lightGrayColor];
        _successLalbe.font = [UIFont systemFontOfSize:14.0f];
        _successLalbe.text = @"订单提交成功";
        _successLalbe.textAlignment = NSTextAlignmentCenter;
    }
    return _successLalbe;
}

-(UIButton *)backShopButton
{
    if (!_backShopButton) {
        _backShopButton = [[UIButton alloc] initForAutoLayout];
        _backShopButton.layer.masksToBounds = YES;
        _backShopButton.layer.cornerRadius = 4.0f;
        [_backShopButton setTitle:@"继续浏览" forState:UIControlStateNormal];
        [_backShopButton setTitle:@"继续浏览" forState:UIControlStateHighlighted];
        [_backShopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backShopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_backShopButton addTarget:self action:@selector(backToShop:) forControlEvents:UIControlEventTouchUpInside];
        [_backShopButton setBackgroundColor:UIColorFromRGB(0xe44e55)];
        _backShopButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _backShopButton;
}

-(UIButton *)checkOrderButton
{
    if (!_checkOrderButton) {
        _checkOrderButton = [[UIButton alloc] initForAutoLayout];
        _checkOrderButton.layer.masksToBounds = YES;
        _checkOrderButton.layer.cornerRadius = 4.0f;
        [_checkOrderButton setTitle:@"查看凭证" forState:UIControlStateNormal];
        [_checkOrderButton setTitle:@"查看凭证" forState:UIControlStateHighlighted];
        [_checkOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_checkOrderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_checkOrderButton addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_checkOrderButton setBackgroundColor:UIColorFromRGB(0x81c8d6)];
        _checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _checkOrderButton;
}

#pragma mark----------click action
-(void)backToShop:(UIButton*)sender
{
    NSLog(@"返回到商家");
    NSArray *subViews = self.navigationController.viewControllers;
    for (BaseViewController *obj in subViews) {
        if ([obj isKindOfClass:[GroupDetailViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
}

-(void)checkOrder:(UIButton*)sender
{
//    NSLog(@"查看订单详情");
//    LoginViewController *firVC = [[LoginViewController alloc] init];
//    [firVC setHiddenTabbar:YES];
//    [firVC.navigationItem setTitle:@"设置"];
//    [self.navigationController pushViewController:firVC animated:YES];
  
    GroupCheckCodeViewController *firVC = [[GroupCheckCodeViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    firVC.messageDict = self.messageDict;
    firVC.passArray = self.passArray;
    [firVC setNavBarTitle:@"团购凭证" withFont:14.0f];
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
