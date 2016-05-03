//
//  PhotoBrowserViewController.h
//  SendInfo2
//
//  Created by Sky on 14-8-16.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowserViewControllerDelegate <NSObject>

-(void)deletePhotoAtIndex:(NSInteger) photoIndex andPhotoTag:(NSInteger) photoTag;

@end


@interface PhotoBrowserViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray* photoArray;

@property(nonatomic,assign)NSInteger photoIndex;
@property(nonatomic)BOOL isAddImage;
@property(nonatomic,assign)id<PhotoBrowserViewControllerDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary* imageDict;
@property (strong, nonatomic) NSString *is_exit;
@end
