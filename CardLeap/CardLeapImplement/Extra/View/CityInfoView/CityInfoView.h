//
//  CityInfoView.h
//  CardLeap
//
//  Created by songweiping on 14/12/29.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityInfoView : UIScrollView


/** 轮播图片数组 */
@property (strong, nonatomic)   NSArray         *images;

/** 轮播器的scrollView */
@property (weak, nonatomic)     UIScrollView    *scrollView;

/** 轮播器的 分页控件 */
@property (weak, nonatomic)     UIPageControl   *page;



@end
