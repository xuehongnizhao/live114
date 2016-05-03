//
//  UserViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setNavBarTitle:@"User" withFont:20];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (ApplicationDelegate.islogin == YES) {
        UserInfoViewController *firVC = [[UserInfoViewController alloc] init];
        [firVC setNavBarTitle:@"个人中心" withFont:14.0f];
        [firVC.navigationItem setHidesBackButton:YES];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        firVC.identifier=@"1";
        [self.navigationController pushViewController:firVC animated:YES];
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
