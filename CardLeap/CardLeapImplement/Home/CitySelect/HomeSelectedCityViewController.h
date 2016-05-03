//
//  HomeSelectedCityViewController.h
//  WeiBang
//
//  Created by songweipng on 15/3/17.
//  Copyright (c) 2015年 songweipng. All rights reserved.
//

#import "BaseViewController.h"

@class CityModule;
@class HomeSelectedCityViewController;

@protocol HomeSelectedCityViewControllerDelegate <NSObject>

@optional

- (void)choseTheCity:(NSString*)cityName;

- (void)choseTheCityModule:(CityModule*)module;

- (void)homeSelectedCityViewController:(HomeSelectedCityViewController *)homeSelectedCityViewController currentCityName:(NSString *)cityName currentCityID:(NSString *)ciytID;

@end

@interface HomeSelectedCityViewController : BaseViewController {
    NSMutableDictionary* nameDic;
    //key：姓  value：对应姓的NSarray;
}
@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,assign)id<HomeSelectedCityViewControllerDelegate> delegate;
@property(nonatomic,strong) UITableView    *m_tableView;
@property(nonatomic,strong) NSMutableArray *m_allName;

@property(nonatomic,assign) BOOL isFirstShow; //是否是第一次显示

@property (strong, nonatomic) NSString *currentCityName;
@property (strong, nonatomic) NSString *cityID;


@end
