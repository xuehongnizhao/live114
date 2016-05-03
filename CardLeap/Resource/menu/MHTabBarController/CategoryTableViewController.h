//
//  CategoryTableViewController.h
//  Tuan
//
//  Created by 李凯 on 14-4-16.
//  Copyright (c) 2014年 Liekksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSString *selectedText;
@property (nonatomic, copy) NSMutableDictionary *dataDict;
@property (nonatomic, retain) UITableView *leftTableView;
@property (nonatomic, retain) UITableView *rightTableView;

@end
