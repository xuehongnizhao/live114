//
//  reviewTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reviewInfo.h"
@interface reviewTableViewCell : UITableViewCell
-(void)configureCell  :(reviewInfo*)shopInfo;
@end
