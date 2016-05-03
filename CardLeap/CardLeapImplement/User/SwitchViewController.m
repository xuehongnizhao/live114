//
//  SwitchViewController.m
//  CardLeap
//
//  Created by lin on 12/15/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "SwitchViewController.h"
#import "LoginViewController.h"
@interface SwitchViewController ()

@end

@implementation SwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (ApplicationDelegate.islogin == YES) {
        //跳转到个人信息界面
    }else{
        //跳转到登录界面
    }
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
