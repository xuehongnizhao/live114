//
//  SkyTitleView.h
//  AiJuHui
//
//  Created by Sky on 15/4/24.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkyTitleView : UIView


/*!
 *  @brief  设置当前的page数以及所对应的字
 *
 *  @param currentPage 当前page数
 *  @param title       和当前page所对应的title
 */
-(void)setCurrentPage:(NSInteger) currentPage andTitle:(NSString*) title;


/*!
 *  @brief  设置pageControl的数量
 *
 *  @param totalPageNumer page总数
 */
-(void)setTotalPageNumer:(NSInteger) totalPageNumer;

@end
