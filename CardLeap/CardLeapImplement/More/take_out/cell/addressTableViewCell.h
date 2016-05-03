//
//  addressTableViewCell.h
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userAddressInfo.h"

@protocol selectDelegate <NSObject>
-(void)selectActionDelegate:(UIButton*)sender;
@end

@interface addressTableViewCell : UITableViewCell
@property (strong, nonatomic) id<selectDelegate> delegate;
-(void)configureCell:(userAddressInfo*)info row:(NSInteger)row;
@end
