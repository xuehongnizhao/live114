//
//  ActivityDetailViewController.h
//  CardLeap
//
//  Created by lin on 1/9/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "activityInfo.h"

@interface ActivityDetailViewController : BaseViewController
@property (strong, nonatomic) activityInfo *info;
@property (strong, nonatomic) NSString *url;
@end
