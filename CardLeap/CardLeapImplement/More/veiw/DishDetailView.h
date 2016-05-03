//
//  DishDetailView.h
//  LeDing
//
//  Created by Sky on 14/11/5.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  商品预览
 */
@protocol DishDetailViewDelegate  <NSObject>
-(void)isRemoveFromSuperView:(BOOL) isremove;
@end

@interface DishDetailView : UIView

@property(nonatomic,weak)id<DishDetailViewDelegate> delegate;

@property(nonatomic ,strong) NSString *take_id;//外卖id
@property (strong, nonatomic) NSString *url;//加载url
-(void) initWebViewContent;
@end
