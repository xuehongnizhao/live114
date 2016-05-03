//
//  GroupReviewViewController.h
//  CardLeap
//
//  Created by mac on 15/2/3.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myGroupInfo.h"

@protocol GroupRefreshDelegate <NSObject>
-(void)refreshAction;
@end

@interface GroupReviewViewController : BaseViewController
@property (strong,nonatomic)id<GroupRefreshDelegate> delegate;
@property (strong,nonatomic) myGroupInfo *info;
@end
