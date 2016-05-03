//
//  CouponCollectionViewCell.h
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "couponInfo.h"

@interface CouponCollectionViewCell : UICollectionViewCell
-(void)configureCell:(couponInfo*)info;
@end
