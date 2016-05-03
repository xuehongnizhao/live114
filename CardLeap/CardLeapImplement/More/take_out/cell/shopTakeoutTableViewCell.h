//
//  shopTakeoutTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopTakeoutInfo.h"
@interface shopTakeoutTableViewCell : UITableViewCell
-(void)configureCell :(shopTakeoutInfo*)info;
@end
