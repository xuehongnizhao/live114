//
//  CityUpdateOneAddressViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUpdateOneAddressViewController.h"

#import "CityUpdateViewController.h"
#import "CityUpdateTwoAddressViewController.h"


#import "MJExtension.h"

#import "CityAddressOneCate.h"
#import "CityAddMessage.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface CityUpdateOneAddressViewController () <UITableViewDataSource, UITableViewDelegate>

// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)     UITableView *updateAddressOneTbaleView;

// ---------------------- 数据模型 ----------------------
/** 一级地区分类的数据 */
@property (strong, nonatomic)   NSArray     *oneAddressCate;

@end

@implementation CityUpdateOneAddressViewController

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


#pragma mark ----- 初始化控件

/**
 *  初始化控件
 */
- (void) initUI {
    [self settingNav];
    
    [self updateAddressOneTbaleView];
}


/**
 *  设置导航栏
 */
- (void) settingNav {
    self.navigationItem.title = @"选择地区";
}


- (UITableView *)updateAddressOneTbaleView {
    
    if (_updateAddressOneTbaleView == nil) {
        
        UITableView *updateAddressOneTbaleView = [[UITableView alloc] init];
        
        CGFloat oneX = self.view.frame.origin.x;
        CGFloat oneY = self.view.frame.origin.y;
        CGFloat oneW = self.view.frame.size.width;
        CGFloat oneH = self.view.frame.size.height;
        updateAddressOneTbaleView.frame = CGRectMake(oneX, oneY, oneW, oneH);
        updateAddressOneTbaleView.dataSource = self;
        updateAddressOneTbaleView.delegate   = self;
        [UZCommonMethod hiddleExtendCellFromTableview:updateAddressOneTbaleView];
        _updateAddressOneTbaleView = updateAddressOneTbaleView;
        [self.view addSubview:_updateAddressOneTbaleView];
    
    }
    return _updateAddressOneTbaleView;
}


#pragma mark ----- 初始化数据

/**
 *  初始化数据
 */
- (void) initData {
    
    self.oneAddressCate = [self updateOneAddressDataTreatment:self.cityAddress];
}


/**
 *  数据处理 (字典转模型)
 *
 *  @param     param
 *
 *  @return    NSArray
 */
- (NSArray *) updateOneAddressDataTreatment:(NSArray *)param {
    return [CityAddressOneCate objectArrayWithKeyValuesArray:param];
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
    return self.oneAddressCate.count;
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
    
    static NSString *cellName = @"updateOneAddressCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
   
    CityAddressOneCate *cityOneAddress = self.oneAddressCate[indexPath.row];
    cell.textLabel.text       = cityOneAddress.area_name;
    cell.textLabel.textColor  = Color(106, 106, 106, 255);
    cell.textLabel.font       = SYSTEM_FONT_SIZE(12);
    if (cityOneAddress.son.count != 0) {
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
    
    CityAddressOneCate *addressOne = self.oneAddressCate[indexPath.row];
    CityAddMessage     *message    = self.cityAddMessage;
    
    if (self.cityAddMessage != nil) {
        message = self.cityAddMessage;
    }
    
    message.cityOneCateAddressID   = addressOne.area_id;
    message.cityOneCateAddressName = addressOne.area_name;
    if (addressOne.son.count == 0) {
        [self toJumpUpdate:message];
    } else {
        [self toJumpTwoAddress:message cityAddressTwoCate:addressOne.son];
    }

    
}



/**
 *  跳转回修改页面
 *
 *  @param message 提交的数据模型
 */
- (void) toJumpUpdate:(CityAddMessage *)message {
    
    BOOL is_exit = NO;
    NSArray *subViews = self.navigationController.viewControllers;
    for (BaseViewController *obj in subViews) {
        if ([obj isKindOfClass:[CityUpdateViewController class]]) {
            is_exit = YES;
            CityUpdateViewController *updateCity = (CityUpdateViewController *)obj;
            updateCity.cityAddMessage = message;
            updateCity.cityAddress    = self.cityAddress;
            
            if (message.cityTwoCateAddressID && message.cityTwoCateAddressName) {
                message.cityTwoCateAddressID     = nil;
                message.cityTwoCateAddressName   = nil;
            }
            
            [self.navigationController popToViewController:updateCity animated:YES];
            break;
        }
    }
    
    
    if (!is_exit) {
        // 没有二级分类 跳 添加
        CityUpdateViewController *updateCity = [[CityUpdateViewController alloc] init];
        updateCity.cityAddMessage = message;
        // 地区分类
        updateCity.cityAddress    = self.cityAddress;
        [self.navigationController pushViewController:updateCity animated:YES];
    }
}


/**
 *  跳转二级分类控制器
 *
 *  @param message
 *  @param cityAddressTwoCate 
 */
- (void) toJumpTwoAddress:(CityAddMessage *)message cityAddressTwoCate:(NSArray *)cityAddressTwoCate {
    
    CityUpdateTwoAddressViewController *updateAddressTwoCate = [[CityUpdateTwoAddressViewController alloc] init];
    updateAddressTwoCate.cityAddMessage = message;
    updateAddressTwoCate.cityAddress    = self.cityAddress;
    updateAddressTwoCate.addressTwoCate = cityAddressTwoCate;
    [self.navigationController pushViewController:updateAddressTwoCate animated:YES];
}


@end
