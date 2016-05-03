//
//  SendViewController.h
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectBar.h"
#import "PhotoView.h"
#import "FaceBoard.h"
#import "DoImagePickerController.h"
#import "PhotoBrowserViewController.h"
#import "VoiceView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UITableView+DataSourceBlocks.h"
#import "BaseViewController.h"
#define POST_URL @"community/ac_com/add"
@class TableViewWithBlock;
@interface SendViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DoImagePickerControllerDelegate,SelectBarDelegate,photoViewDelegate,FaceBoardDelegate,PhotoBrowserViewControllerDelegate,UITextViewDelegate,VoiceViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *cateDic;
//下拉框
@property (strong, nonatomic) TableViewWithBlock *tb;
@property (strong, nonatomic) NSString *u_lat;
@property (strong, nonatomic) NSString *u_lng;
@end
