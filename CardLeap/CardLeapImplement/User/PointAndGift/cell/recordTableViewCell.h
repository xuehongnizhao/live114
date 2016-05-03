//
//  recordTableViewCell.h
//  cityo2o
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recordInfo.h"
@interface recordTableViewCell : UITableViewCell
-(void)configureCell:(recordInfo*)info;
@end
