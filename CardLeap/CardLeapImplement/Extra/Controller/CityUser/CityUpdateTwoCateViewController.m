//
//  CityUpdateTwoCateViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUpdateTwoCateViewController.h"

#import "CityUpdateViewController.h"

#import "MJExtension.h"


#import "CityTwoCate.h"
#import "CityAddMessage.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface CityUpdateTwoCateViewController ()<UITableViewDataSource, UITableViewDelegate>

// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)     UITableView *updateTwoCateTableView;


// ---------------------- 数据模型 ----------------------
/** 二级分类的数据 */
@property (strong, nonatomic)   NSArray     *twoCate;


@end

@implementation CityUpdateTwoCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    NSLog(@"%@", self.twoCate);
    
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}



#pragma mark ----- 初始化 UI 控件

/**
 *  初始化 UI 控件
 */
- (void) initUI {
    
    [self settingNav];
    [self updateTwoCateTableView];
}

/**
 *  设置 导航栏
 */
- (void) settingNav {
    self.navigationItem.title = self.cityAddMessage.cityOneCateName;
}

- (UITableView *)updateTwoCateTableView {
    
    if (_updateTwoCateTableView == nil) {
        
        UITableView *updateTwoCateTableView = [[UITableView alloc] init];
        
        CGFloat twoX = self.view.frame.origin.x;
        CGFloat twoY = self.view.frame.origin.y;
        CGFloat twoW = self.view.frame.size.width;
        CGFloat twoH = self.view.frame.size.height;
        updateTwoCateTableView.frame      = CGRectMake(twoX, twoY, twoW, twoH);
        updateTwoCateTableView.dataSource = self;
        updateTwoCateTableView.delegate   = self;
        [UZCommonMethod hiddleExtendCellFromTableview:updateTwoCateTableView];
        _updateTwoCateTableView = updateTwoCateTableView;
        [self.view addSubview:_updateTwoCateTableView];
    }
    return _updateTwoCateTableView;
}


#pragma makr ----- 初始化数据

/**
 *  初始化数据
 */
- (void) initData {
    self.twoCate = [self updateTwoCateDataTreatment:self.cateMessage];
}

/**
 *  数据处理  (字典转模型)
 *
 *  @param      param
 *
 *  @return     NSArray
 */
- (NSArray *) updateTwoCateDataTreatment:(NSArray *)param {
    return [CityTwoCate objectArrayWithKeyValuesArray:param];
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
    
    static NSString *cellName = @"updataeTwoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    CityTwoCate *cityTwoCate = self.twoCate[indexPath.row];
    cell.textLabel.text      = cityTwoCate.cat_name;
    cell.textLabel.textColor = Color(106, 106, 106, 255);
    cell.textLabel.font      = SYSTEM_FONT_SIZE(12);
    
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
    
    CityAddMessage  *message   = [[CityAddMessage alloc] init];
    CityTwoCate     *cityTwo   = self.twoCate[indexPath.row];
    
    if (self.cityAddMessage != nil) {
        message = self.cityAddMessage;
    }
    
    message.cityTwoCateId    = cityTwo.cat_id;
    message.cityTwoCateName  = cityTwo.cat_name;
    [self toJump:message];
}


/**
 *  跳转方法处理
 *
 *  @param message 模型数据
 */
- (void) toJump:(CityAddMessage *) message {
    
    BOOL is_exit = NO;
    NSArray *subViews = self.navigationController.viewControllers;
    for (BaseViewController *obj in subViews) {
        if ([obj isKindOfClass:[CityUpdateViewController class]]) {
            is_exit = YES;
            CityUpdateViewController *cityUpdate=(CityUpdateViewController *)obj;
            cityUpdate.cityAddMessage = message;
            cityUpdate.cityAddress    = self.cityAddress;
            [self.navigationController popToViewController:cityUpdate animated:YES];
            break;
        }
    }
    
    if (!is_exit) {
        CityUpdateViewController *cityUpdate = [[CityUpdateViewController alloc] init];
        // 选择分类数组
        cityUpdate.cityCates          = self.twoCate;
        
        // 同城地区分类
        cityUpdate.cityAddress        = self.cityAddress;
        cityUpdate.cityAddMessage     = message;
        [self.navigationController pushViewController:cityUpdate animated:YES];
    }
}





@end
