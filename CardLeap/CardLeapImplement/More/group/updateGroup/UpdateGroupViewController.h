//
//  UpdateGroupViewController.h
//  CardLeap
//
//  Created by mac on 15/3/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

/**
    这里和团购列表去订团购是一样的
    但是因为数据结构不同 所以重新写了一个页面
 */

#import <UIKit/UIKit.h>
#import "myGroupInfo.h"

@interface UpdateGroupViewController : BaseViewController
@property (strong,nonatomic)myGroupInfo *myUpdateInfo;
@end
