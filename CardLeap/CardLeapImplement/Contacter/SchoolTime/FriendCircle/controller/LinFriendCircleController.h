//
//  LinFriendCircleController.h
//  EnjoyDQ
//
//  Created by lin on 14-8-14.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTabBarController.h"
#import "MYBlurIntroductionView.h"
#import "BaseViewController.h"
@interface LinFriendCircleController : BaseViewController<          MHTabBarControllerDelegate,
                                                            UITableViewDelegate,
                                                            UITableViewDataSource,
                                                            MYIntroductionDelegate,
                                                            UIAlertViewDelegate>


@property (strong, nonatomic) UITableView *FriendTableview;
@property (strong, nonatomic) UIRefreshControl *refreshControl; //用户分页刷新
@property (strong, nonatomic) NSMutableArray *friendCircleList;

+(LinFriendCircleController*)shareInstance;
@end
