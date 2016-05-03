//
//  PhotoView.h
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoImagePickerController.h"


@protocol photoViewDelegate <NSObject>

-(void)getMorePhoto;

-(void)showBrowserWithIndex:(NSInteger)index;

@end

@interface PhotoView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DoImagePickerControllerDelegate,photoViewDelegate>

//图片数据源
@property(nonatomic,strong)NSMutableArray* photoArray;
@property(nonatomic)BOOL isShow;
@property(nonatomic)BOOL isAddImage;
@property(nonatomic,assign)id<photoViewDelegate> delegate;


//-(void)reloaddata;
-(void)deleteReloadData;
-(void)addNewsImageArray:(NSArray*) newArray;

@end
