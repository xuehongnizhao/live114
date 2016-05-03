//
//  PictureCell.m
//  CardLeap
//
//  Created by songweiping on 15/1/4.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "PictureCell.h"


@implementation PictureCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 *  初始化一个 cell
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype) pictureCellWithTableView:(UITableView *)tableView {

    PictureCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureCell" owner:nil options:nil] lastObject];
    
    cell.transform      = CGAffineTransformMakeRotation(M_PI / 2);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/**
 *  显示本地的图片
 *
 *  @param pictureName
 */
- (void)setPictureName:(UIImage *)pictureName {
    _pictureName           = pictureName;
    self.pictureView.image = _pictureName;;
}

/**
 *  显示远程的图片
 *
 *  @param pictureUrlName
 */
- (void)setPictureUrlName:(NSString *)pictureUrlName {
    _pictureUrlName = pictureUrlName;
    NSURL *url = [NSURL URLWithString:_pictureUrlName];
    [self.pictureView sd_setImageWithURL:url placeholderImage:nil];
}






@end
