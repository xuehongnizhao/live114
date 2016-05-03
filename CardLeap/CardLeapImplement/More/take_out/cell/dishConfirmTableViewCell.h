//
//  dishConfirmTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/31/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "takeoutDishInfo.h"

@interface dishConfirmTableViewCell : UITableViewCell
-(void)confirgureCell :(takeoutDishInfo*)info;
@end
