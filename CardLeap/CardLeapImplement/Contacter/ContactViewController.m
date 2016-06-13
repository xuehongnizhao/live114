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

@interface ContactViewController ()<SINavigationMenuDelegate>

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFriendCircle];
}

#pragma mark----------跳转到朋友圈
-(void)setFriendCircle
{
    LinFriendCircleController *firVC = [[LinFriendCircleController alloc] init];
    [firVC setNavBarTitle:@"发现" withFont:14.0f];
    [self.navigationController pushViewController:firVC animated:YES];
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


@end
