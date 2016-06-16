//
//  defaultName.h
//  WMYRiceNoodles
//
//  Created by mac on 13-12-19.
//  Copyright (c) 2013年 mac. All rights reserved.
//

/**
 * @file         defaultName.h
 * @brief        NSUserDefault的key集合
 *
 * @author       xiaocao
 * @version      0.1
 * @date         2012-12-19
 * @since        2012-12 ~
 */

#ifndef WMYRiceNoodles_defaultName_h
#define WMYRiceNoodles_defaultName_h


#define everLaunch  @"firstEnter"           /*!< 判断是否第一次进入应用: yes-不是第一次，no-是第一次 */
#define isLogined_s     @"islogined"              /*!< 判断用户登录状态: yes-已登录，no-未登录 */
#define userInfomation    @"userInfo"       /*!< NSUserDefault中，保存用户信息的key */
#define loginInfomation @"loginInfo"        /*!< NSUserDefault中，保存用户登录信息的key */
/**
 *  自动登录
 */
#define autoLogin @"autoLogin"

/*!
 *  @author Sky
 *
 *  @brief  城市ID
 */
#define KCityID    @"CityID"
#define KCityNAME    @"CityNAME"

/*!
 *  @author Sky
 *
 *  @brief  是否进入选择城市
 */
#define isShowCityChose     @"isShowCityChose"
/**
 *  @author zq, 16-06-16 13:06:57
 *
 * 微信appid
 */
#define WXAPPID             @"wxadf37d5562adeb69"
//url分类
#define URLFilter           @"URLFilter"

//大集合
#define as_comm             @"as_comm"

//龙广路况图片上传
#define hd_upload_img       @"hd_upload_img"

//龙光路况语音上传
#define hd_upload_voice     @"hd_upload_voice"
// 写入NSUserDefault中的数据
#define SetUserDefault(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
// 获取NSUserDefault中的数据
#define GetUserDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#endif
