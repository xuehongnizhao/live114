//
//  CityUserViewCell.m
//  CardLeap
//
//  Created by songweiping on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUserViewCell.h"

#import "CityUser.h"
#import "CityUserFrame.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]


@interface CityUserViewCell()


/** 浏览量的View */
@property (weak, nonatomic) UILabel     *cityUserBrowseView;

/** 固定字符串的View */
@property (weak, nonatomic) UILabel     *cityUserStrView;

/** 分割线的View */
@property (weak, nonatomic) UIImageView *cityUserImageView;

/** 简介的View */
@property (weak, nonatomic) UILabel     *cityUserMessageView;

/** 分类的View */
@property (weak, nonatomic) UILabel     *cityUserCateView;

/** 添加时间的View */
@property (weak, nonatomic) UILabel     *cityUserAddTiemView;

@end



@implementation CityUserViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 *  创建 一个cell
 *
 *  @param      tableView
 *
 *  @return
 */
+ (instancetype) cityUserCellWithTableView:(UITableView *)tableView {
    
    static NSString *cellName = @"cityCellName";
    CityUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[CityUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/**
 *
 *  初始化一个自定义Cell
 *  @param      style
 *  @param      reuseIdentifier
 *
 *  @return
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addUI];
    }
    return self;
}



/**
 *  添加控件
 */
- (void) addUI {
    
    // 浏览次数
    UILabel *cityUserBrowseView      = [[UILabel alloc] init];
    cityUserBrowseView.textAlignment = NSTextAlignmentCenter;
    cityUserBrowseView.textColor     = UIColorFromRGB(0xfe8354);
    _cityUserBrowseView              = cityUserBrowseView;
    [self.contentView addSubview:_cityUserBrowseView];
    
    // 浏览量
    UILabel *cityUserStrView      = [[UILabel alloc] init];
    cityUserStrView.text          = @"次浏览";
    cityUserStrView.textAlignment = NSTextAlignmentCenter;
    cityUserStrView.textColor     = Color(140, 140, 140, 255);
    _cityUserStrView              = cityUserStrView;
    [self.contentView addSubview:_cityUserStrView];
    
    // 分割图片
    UIImageView *cityUserImageView = [[UIImageView alloc] init];
    cityUserImageView.image        = [UIImage imageNamed:@"city_myrelease_line"];
    _cityUserImageView = cityUserImageView;
    [self.contentView addSubview:_cityUserImageView];
    
    // 简介
    UILabel *cityUserMessageView   = [[UILabel alloc] init];
    cityUserMessageView.font = [UIFont systemFontOfSize:15.0f];
    cityUserMessageView.textColor = UIColorFromRGB(indexTitle);
    _cityUserMessageView           = cityUserMessageView;
    [self.contentView addSubview:_cityUserMessageView];
    
    // 分类
    UILabel *cityUserCateView      = [[UILabel alloc] init];
    cityUserCateView.textColor     = UIColorFromRGB(addressTitle);
    cityUserCateView.font          = SYSTEM_FONT_SIZE(13);
    _cityUserCateView              = cityUserCateView;

    [self.contentView addSubview:_cityUserCateView];
    
    // 添加时间
    UILabel *cityUserAddTiemView   = [[UILabel alloc] init];
    cityUserAddTiemView.textColor  = UIColorFromRGB(addressTitle);
    cityUserAddTiemView.font       = SYSTEM_FONT_SIZE(13);
    _cityUserAddTiemView           = cityUserAddTiemView;
    [self.contentView addSubview:_cityUserAddTiemView];
}

- (void)setCityUserFrame:(CityUserFrame *)cityUserFrame {
    _cityUserFrame = cityUserFrame;
    [self settingData];
    [self settingFrame];
}

/**
 *  设置控件的数据
 */
- (void) settingData {
    
    CityUser *cityUser            = self.cityUserFrame.cityUser;
    self.cityUserBrowseView.text  = cityUser.browse;
    self.cityUserMessageView.text = cityUser.message_name;
    self.cityUserCateView.text    = cityUser.cate_name;
    self.cityUserAddTiemView.text = cityUser.add_time;
    
}

/**
 *  设置控件的frame
 */
- (void) settingFrame {
    
    self.cityUserBrowseView.frame   = self.cityUserFrame.cityUserBrowseFrame;
    self.cityUserStrView.frame      = self.cityUserFrame.cityUserStrFrame;
    self.cityUserImageView.frame    = self.cityUserFrame.cityUserImageFrame;
    self.cityUserMessageView.frame  = self.cityUserFrame.cityUserMessageFrame;
    self.cityUserCateView.frame     = self.cityUserFrame.cityUserCateFrame;
    self.cityUserAddTiemView.frame  = self.cityUserFrame.cityUserAddTiemFrame;
}




@end
