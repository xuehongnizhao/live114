//
//  CityUpdateOneCateViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUpdateOneCateViewController.h"

#import "CityUpdateViewController.h"
#import "CityUpdateTwoCateViewController.h"

#import "MJExtension.h"


#import "CityOneCate.h"
#import "CityAddMessage.h"


#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface CityUpdateOneCateViewController ()<UITableViewDataSource, UITableViewDelegate>


// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)     UITableView     *updateOneCateTableView;

// ---------------------- 数据模型 ----------------------
/** 一级分类的数据 */
@property (strong, nonatomic)   NSArray         *updateOneCate;

@end

@implementation CityUpdateOneCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
    
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------ 设置UI

/**
 *  初始化 UI 控件
 */
- (void) initUI {
    
    [self settingNav];
    [self updateOneCateTableView];
    
}

/**
 *  设置 导航栏
 */
- (void) settingNav {
    
    self.navigationItem.title = @"选择分类";
}


/**
 *  设置      tableView
 *
 *  @return   UITableView
 */
- (UITableView *)updateOneCateTableView {
    
    if (_updateOneCateTableView == nil) {
        
        UITableView *updateOneCateTableView = [[UITableView alloc] init];
        CGFloat oneX = self.view.frame.origin.x;
        CGFloat oneY = self.view.frame.origin.y;
        CGFloat oneW = self.view.frame.size.width;
        CGFloat oneH = self.view.frame.size.height;
        updateOneCateTableView.frame = CGRectMake(oneX, oneY, oneW, oneH);
        updateOneCateTableView.dataSource = self;
        updateOneCateTableView.delegate   = self;
        _updateOneCateTableView           = updateOneCateTableView;
        [UZCommonMethod hiddleExtendCellFromTableview:updateOneCateTableView];
        [self.view addSubview:_updateOneCateTableView];
    }
    return _updateOneCateTableView;
}


#pragma mark ----- 数据处理

- (void) initData {
    
    self.updateOneCate = [self updataOneCateDataTreatment:self.cityCates];
}


/**
 *  修改一级分类 数据处理 (字典转模型)
 *
 *  @param      param
 *
 *  @return     NSArray
 */
- (NSArray *) updataOneCateDataTreatment:(NSArray *)param {
    return [CityOneCate objectArrayWithKeyValuesArray:param];
}


#pragma mark ----- UITableView dataSource

/**
 *  返回分组 数量
 *
 *  @param  tableView
 *
 *  @return NSInteger
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/**
 *  返回 每组 多少条数据
 *
 *  @param  tableView
 *  @param  section
 *
 *  @return NSInteger
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.updateOneCate.count;
}


/**
 *  返回 每个 Cell 展示的数据 和 样式
 *
 *  @param  tableView
 *  @param  indexPath
 *
 *  @return UITableViewCell
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellName = @"updateCellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    CityOneCate *cityOneCate  = self.updateOneCate[indexPath.row];
    cell.textLabel.text       = cityOneCate.cat_name;
    cell.textLabel.textColor  = Color(106, 106, 106, 255);
    cell.textLabel.font       = SYSTEM_FONT_SIZE(12);
    
    if (cityOneCate.son.count != 0) {
        cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}




#pragma mark ----- UITableView delegate



/**
 *  点击每个 cell 进行跳转
 *
 *  @param tableView
 *  @param indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityOneCate    *cityOneCate = self.updateOneCate[indexPath.row];
    
    NSArray        *cityTwoCate        = cityOneCate.son;
    CityAddMessage *message     = [[CityAddMessage alloc] init];
    if (self.cityAddMessage != nil) {
        message = self.cityAddMessage;
    }
    message.cityOneCateId      = cityOneCate.cat_id;
    message.cityOneCateName    = cityOneCate.cat_name;
    
    
    if (cityOneCate.son.count == 0) {
        // 没有 二级分类 直接 跳转修改页面
        [self toJumpUpdate:message];
    } else {
        // 跳转二级分类
        [self toJumpTwoCate:message cityTwoCate:cityTwoCate];
    }
    
    
}


/**
 *  跳转方法处理
 *
 *  @param message 模型数据
 */
- (void) toJumpUpdate:(CityAddMessage *)message {
    // 页面存在
    BOOL is_exit = NO;
    NSArray *subViews = self.navigationController.viewControllers;
    for (BaseViewController *obj in subViews) {
        if ([obj isKindOfClass:[CityUpdateViewController class]]) {
            is_exit = YES;
            CityUpdateViewController *cityUpdate =(CityUpdateViewController *)obj;
            cityUpdate.cityAddMessage = message;
            cityUpdate.cityAddress    = self.cityAddress;
            [self.navigationController popToViewController:cityUpdate animated:YES];
            if (message.cityTwoCateId && message.cityTwoCateName) {
                message.cityTwoCateName = nil;
                message.cityTwoCateId   = nil;
            }
            break;
        }
    }
    
    // 页面不存在
    if (!is_exit) {
        // 没有二级分类 跳 添加
        CityUpdateViewController *cityUpdate = [[CityUpdateViewController alloc] init];
        cityUpdate.cityAddMessage     = message;
        // 地区分类
        cityUpdate.cityAddress        = self.cityAddress;
        [self.navigationController pushViewController:cityUpdate animated:YES];
    }
}


/**
 *  跳转二级分类
 *
 *  @param message       修改数据模型
 *  @param cityTwoCate   二级分类显示数据
 */
- (void) toJumpTwoCate:(CityAddMessage *)message cityTwoCate:(NSArray *) cityTwoCate {
    
    CityUpdateTwoCateViewController *cityTwo = [[CityUpdateTwoCateViewController alloc] init];
    cityTwo.cityAddMessage  = message;
    cityTwo.cateMessage     = cityTwoCate;
    cityTwo.cityAddress     = self.cityAddress;
    [self.navigationController pushViewController:cityTwo animated:YES];
}


@end
