//
//  UZCommonTableViewController.h
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define pageMaxCount 20

/*================================================================================================*/

@protocol UZTableViewDatasource <NSObject>

@optional
- (NSInteger)UZNumberOfSectionsInTableView:(UITableView *)tableView;

@required
- (NSInteger)UZTableView:(UITableView *)tableView
   numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)UZTableView:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/*================================================================================================*/

@protocol UZTableDelegate <NSObject>

@optional
- (void)UZTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)refreshAction;

- (void)loadMoreAction;

@end

/*================================================================================================*/

@interface UZCommonTableViewController : UITableViewController

@property (strong, nonatomic) id<UZTableViewDatasource> UZTableViewDatasource;
@property (strong, nonatomic) id<UZTableDelegate> UZTableViewDelegate;

// refresh
@property (nonatomic) int   page ;
@property (nonatomic) int   count ;
// loadMore


// 留给子类实现的虚函数(虽然oc没有虚函数的概念),子类必须实现的方法
- (void)refreshAction;      // 刷新执行方法，必选
- (void)loadMoreAction;     // 加载执行方法，必选
- (void)refreshComplete;    // 刷新完成方法，可选

// 当子类实现refreshAction时候，需要在最后调用dismissMark
- (void)dismissMark;        // 销毁弹出信息


- (BOOL)checkBottomFrom:(NSInteger)arrayCount
               maxCount:(NSInteger)maxCount;

@end
