//
//  ListViewController.h
//  TabBarTest2
//
//  Created by Sky on 14-7-23.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewController.h"
@interface ListViewController : CategoryTableViewController
@property (strong, nonatomic) NSMutableDictionary *datadic;
-(id)initWithURL:(NSString*) url;
@end
