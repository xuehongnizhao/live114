//
//  ReplyTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyInfo.h"
@interface ReplyTableViewCell : UITableViewCell
-(void)configureCell :(ReplyInfo*)info;
@end
