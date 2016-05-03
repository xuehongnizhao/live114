//
//  ContactViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "ContactViewController.h"

//pull down menu
#import "SINavigationMenuView.h"
//firend circle
#import "LinFriendCircleController.h"

@interface ContactViewController ()<SINavigationMenuDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set Circle
    [self setFriendCircle];
    //set pull down menu
    //[self setPullDownMenu];
}

#pragma mark----------跳转到朋友圈
-(void)setFriendCircle
{
    LinFriendCircleController *firVC = [[LinFriendCircleController alloc] init];
    [firVC setNavBarTitle:@"发现" withFont:14.0f];
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark - setpullDownMenu
-(void)setPullDownMenu
{
//    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
//    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Menu"];
//    [menu displayMenuInView:self.navigationController.view];
//    menu.items = @[@"News", @"Top Articles", @"Messages", @"Account", @"Settings", @"Top Articles", @"Messages"];
//    menu.delegate = self;
//    self.navigationItem.titleView = menu;
}

#pragma mark - navgationmenuviewDelegate
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"select Group at index :%ld",(unsigned long)index);
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
