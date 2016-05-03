//
//  shopTakeDetailTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/30/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopTakeCateInfo.h"

@interface shopTakeDetailTableViewCell : UITableViewCell

-(void)confirgureCell :(shopTakeCateInfo*)info sectino:(NSInteger)section row:(NSInteger)row;

@end
