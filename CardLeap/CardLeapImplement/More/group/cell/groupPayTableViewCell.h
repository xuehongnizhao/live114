//
//  groupPayTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol choosePayMethodeDelegate <NSObject>
-(void)choosePayAction:(NSInteger)indexPath;
@end

@interface groupPayTableViewCell : UITableViewCell
@property (strong,nonatomic)id<choosePayMethodeDelegate> delegate;
-(void)confirgureCell:(NSInteger)row param:(NSDictionary*)dic index:(NSInteger)index;
@end
