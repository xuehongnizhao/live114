//
//  UZCommonMethod.h
//  WMYRiceNoodles
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>




/**
 * @brief           公用方法类
 *
 *                  封装了一些常用方法
 * @author          xiaog
 * @version         0.1
 * @date            2012-12-18
 * @since           2012-12 ~
 */
@interface UZCommonMethod : NSObject



+ (void)settingBackButtonImage:(NSString *)imagename
                 selectedImage:(NSString *)selImagename
                  andContrller:(UIViewController *)controller;

/**
 *	@brief	在应用内拨打电话
 *
 *	@param 	phoneNumber 	电话号码
 *	@param 	view 	调用controller的view
 */
+ (void)callPhone:(NSString *)phoneNumber
        superView:(UIView *)view;


/**
 *	@brief	设置按钮的image或者backgroundImage
 *
 *	@param 	button 	按钮
 *	@param 	imageUrl 	正常状态的图片名称
 *	@param 	highLightImageUrl 	高亮状态的图片名称
 */
+ (void)settingButton:(UIButton *)button
                Image:(NSString *)imageUrl
      hightLightImage:(NSString *)highLightImageUrl;

+ (void)settingButton:(UIButton *)button
                Image:(NSString *)imageUrl
      hightLightImage:(NSString *)highLightImageUrl
         disableImage:(NSString *)disableImageUrl;

/**
 *	@brief	判断应用运行在什么系统版本上
 *
 *	@return	返回系统版本 ：7.0     6.0     6.1等
 */
+ (CGFloat)checkSystemVersion;


/**
 *	@brief	判断应用的版本号
 *
 *	@return	返回版本号
 */
+ (NSString *)checkAPPVersion;



/**
 *	@brief	隐藏tableivew中多余的cell
 *
 *	@param 	tableview 	承载的Tableview
 */
+ (void)hiddleExtendCellFromTableview:(UITableView *)tableview;


/**
 *	@brief	给应用提供统一的返回按钮样式
 *          
 *  图片尺寸是 40*40 80*80
 *	@param 	imagename 	正常状态时的图片名称
 *	@param 	selImagename 	高亮时候的状态名称
 */
+ (void)settingBackButtonImage:(NSString *)imagename andSelectedImage:(NSString *)selImagename;




@end

