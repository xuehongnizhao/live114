//
//  CityTableViewCell.m
//  CardLeap
//
//  Created by songweiping on 14/12/22.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityTableViewCell.h"
#import "CityListFrame.h"
#import "CityList.h"


#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface CityTableViewCell()

/** 显示的图片 */
@property (weak, nonatomic) UIImageView *picView;

/** 显示的名称 */
@property (weak, nonatomic) UILabel     *nameView;

/** 显示的详情 */
@property (weak, nonatomic) UILabel     *infoView;

/** 显示的时间 */
@property (weak, nonatomic) UILabel     *priceView;

/** 显示的价格 */
@property (weak, nonatomic) UILabel     *timeView;




@end

@implementation CityTableViewCell



#pragma mark @@@@ ----> 重写初始化 cell 方法并在初始化方法中添加cell上

/**
 *  重写 cell 初始化方法 添加需要的控件到cell 上
 *
 *  @param style
 *  @param reuseIdentifier
 *
 *  @return cell
 */
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addView];
    }
    return self;
}


#pragma mark @@@@ ----> 提供一个创建cell的方法
/**
 *  提供一个初始化自定义的TableViewCell
 *
 *  @param tableView    TableView
 *
 *  @return             CityTableViewCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *cellName = @"ciytCell";
    CityTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    return cell;
}



#pragma mark @@@@ ----> 添加控件
/**
 *  添加Cell显示的所有控件
 */
- (void) addView {
    
    // 添加图片
    UIImageView *picView = [[UIImageView alloc] init];
    picView.layer.borderWidth = 0.5;
    picView.layer.borderColor = UIColorFromRGB(0x74747).CGColor;
    [self.contentView addSubview:picView];
//    picView.backgroundColor = [UIColor redColor];
    self.picView = picView;
    
    // 添加名称
    UILabel *nameView    = [[UILabel alloc] init];
    nameView.font        = SYSTEM_FONT_SIZE(16.0);
    nameView.textColor   = UIColorFromRGB(indexTitle);
    [self.contentView addSubview:nameView];
    self.nameView        = nameView;
    
    // 添加简介
    UILabel *infoView    = [[UILabel alloc] init];
    [self.contentView addSubview:infoView];
    infoView.font        = SYSTEM_FONT_SIZE(13.0);
    infoView.textColor   = UIColorFromRGB(addressTitle);
    self.infoView        = infoView;
    
    // 添加价格
    UILabel *priceView   = [[UILabel alloc] init];
    [self.contentView addSubview:priceView];
    priceView.textColor  = Color(242, 0, 0, 255);
    self.priceView       = priceView;
    
    // 添加时间
    UILabel *timeView    = [[UILabel alloc] init];
    [self.contentView addSubview:timeView];
    timeView.font        = SYSTEM_FONT_SIZE(12.0);
    timeView.textColor   = UIColorFromRGB(reviewTitle);
    timeView.textColor   = Color(158, 158, 158, 255);
    self.timeView        = timeView;
}



#pragma mark @@@@ ----> 重写 cityListFrame set方法
/**
 *  重写 cityListFrame 模型数据的set方法 控件设置数据 和 frame
 *
 *  @param cityListFrame
 */
- (void) setCityListFrame:(CityListFrame *)cityListFrame {
    
    _cityListFrame = cityListFrame;
    
    // 设置数据
    [self settingData];
    
    // 设置控件的位置
    [self settingFrame];
    
}


#pragma mark @@@@ ----> 设置控件的数据
- (void) settingData {

    
    // 取出模型数据
    CityList *cityList  = self.cityListFrame.cityList;
    
    // 设置 头像 数据
    NSURL *url          = [NSURL URLWithString:cityList.message_pic];
    [self.picView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
    
    // 设置 名称 数据
    self.nameView.text  = cityList.message_name;
    
    // 设置 简介 数据
    self.infoView.text  = cityList.m_desc;
    
    // 设置 价格 数据
    NSString *price     = [NSString stringWithFormat:@"%@元", cityList.price];
    self.priceView.text = price;
    
    // 设置 时间 数据
    self.timeView.text  = cityList.add_time;
}


#pragma mark @@@@ ----> 设置控件的位置
- (void) settingFrame {
    
    // 设置 图片的位置
    self.picView.frame   = self.cityListFrame.messagePicFrame;

    // 设置 名称的位置
    self.nameView.frame  = self.cityListFrame.messageNameFrame;
    
    // 设置 详情的位置
    self.infoView.frame  = self.cityListFrame.messageDescFrame;
    
    // 设置 价格的位置
    self.priceView.frame = self.cityListFrame.messagePriceFrame;
    
    // 设置时间的位置
    self.timeView.frame  = self.cityListFrame.messageTimeFrame;
    
}





@end
