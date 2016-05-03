//
//  PictureCell.h
//  CardLeap
//
//  Created by songweiping on 15/1/4.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *pictureView;
@property (weak, nonatomic) IBOutlet UIButton       *deletePicture;


/** 显示本地图片 */
@property (strong, nonatomic)  UIImage  *pictureName;

/** 显示远程图片 */
@property (copy, nonatomic)    NSString *pictureUrlName;



/**
 *  图片自定义的Cell
 *
 *  @param      UITableView
 *
 *  @return     PictureCell
 */
+ (instancetype) pictureCellWithTableView:(UITableView *)tableView;

@end
