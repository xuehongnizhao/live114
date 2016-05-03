//
//  SearchViewController.h
//  UZModel
//
//  Created by Sky on 14-9-22.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEARCH_POST connect_url(@"shop_list")

/**
 *  该类为搜索类 拥有记忆历史输入功能还搜索帖子功能
 */
@interface SearchViewController : BaseViewController

@property(nonatomic,copy) NSString *u_lng;
@property(nonatomic,copy) NSString *u_lat;

@end
