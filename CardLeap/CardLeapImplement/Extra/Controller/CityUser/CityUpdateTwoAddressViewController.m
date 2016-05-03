//
//  CityUpdateTwoAddressViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUpdateTwoAddressViewController.h"

#import "CityUpdateViewController.h"

#import "MJExtension.h"


#import "CityAddressTwoCate.h"
#import "CityAddMessage.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface CityUpdateTwoAddressViewController () <UITableViewDataSource, UITableViewDelegate>


// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)   UITableView *updateAddressTwoTableView;

// ---------------------- 数据模型 ----------------------
/** 地区二级分类 数据源 */
@property (strong, nonatomic) NSArray     *twoCate;


@end

@implementation CityUpdateTwoAddressViewController

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



#pragma mark ----- 设置UI控件

/**
 *  初始化 UI 控件
 */
- (void) initUI {
    
    [self settingNav];
    
    [self updateAddressTwoTableView];
}

/**
 *  设置 导航栏
 */
- (void) settingNav {
    self.navigationItem.title = self.cityAddMessage.cityOneCateAddressName;
}


- (UITableView *)updateAddressTwoTableView {
    
    
    if (_updateAddressTwoTableView == nil) {
        
        UITableView *updateAddressTwoTableView = [[UITableView alloc] init];
        
        CGFloat twoX = self.view.frame.origin.x;
        CGFloat twoY = self.view.frame.origin.y;
        CGFloat twoW = self.view.frame.size.width;
        CGFloat twoH = self.view.frame.size.height;
        updateAddressTwoTableView.frame = CGRectMake(twoX, twoY, twoW, twoH);
        updateAddressTwoTableView.dataSource = self;
        updateAddressTwoTableView.delegate   = self;
        [UZCommonMethod hiddleExtendCellFromTableview:updateAddressTwoTableView];
        _updateAddressTwoTableView = updateAddressTwoTableView;
        [self.view addSubview:_updateAddressTwoTableView];
    }
    return _updateAddressTwoTableView;
}


#pragma mark ----- 初始化数据

/**
 *  初始化数据
 */
- (void) initData {
    self.twoCate = [self updateTwoAddressDataTreatment:self.addressTwoCate];
}

/**
 *  数据处理 (字典转模型数据)
 *
 *  @param      param
 *
 *  @return     NSArray
 */
- (NSArray *) updateTwoAddressDataTreatment:(NSArray *)param {
    return [CityAddressTwoCate objectArrayWithKeyValuesArray:param];
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
    return self.twoCate.count;
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

    static NSString *cellName = @"addressTwoCellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    CityAddressTwoCate *addressTwoCate = self.twoCate[indexPath.row];
    cell.textLabel.text      = addressTwoCate.area_name;
    cell.textLabel.font      = SYSTEM_FONT_SIZE(12);
    cell.textLabel.textColor = Color(106, 106, 106, 255);
    return cell;
}


#pragma mark UITableView delegate

/**
 *  点击每个 cell 进行跳转
 *
 *  @param tableView
 *  @param indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CityAddressTwoCate *addressTwoCate = self.twoCate[indexPath.row];
    CityAddMessage     *message        = [[CityAddMessage alloc] init];
    
    if (self.cityAddMessage != nil) {
        message        = self.cityAddMessage;
    }
    message.cityTwoCateAddressID   = addressTwoCate.area_id;
    message.cityTwoCateAddressName = addressTwoCate.area_name;
    [self toJumpUpdate:message];
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
            CityUpdateViewController *updateCity = (CityUpdateViewController *)obj;
            updateCity.cityAddMessage = message;
            updateCity.cityAddress    = self.cityAddress;
            [self.navigationController popToViewController:updateCity animated:YES];
            break;
        }
    }
    
    // 页面不存在
    if (!is_exit) {
        // 没有二级分类 跳 添加
        CityUpdateViewController *updateCity = [[CityUpdateViewController alloc] init];
        updateCity.cityAddMessage     = message;
        // 地区分类
        updateCity.cityAddress        = self.cityAddress;
        [self.navigationController pushViewController:updateCity animated:YES];
    }
    
}



@end
