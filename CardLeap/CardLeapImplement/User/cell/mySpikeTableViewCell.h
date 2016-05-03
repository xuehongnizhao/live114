//
//  mySpikeTableViewCell.h
//  CardLeap
//
//  Created by lin on 1/9/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mySpikeInfo.h"

@protocol chooseDelegate <NSObject>
-(void)deleteMySpikeDelegate:(NSInteger)index;
@end

@interface mySpikeTableViewCell : UITableViewCell
@property (strong, nonatomic) id<chooseDelegate> delegate;
-(void)configureCell :(mySpikeInfo*)info row:(NSInteger)row;
@end
