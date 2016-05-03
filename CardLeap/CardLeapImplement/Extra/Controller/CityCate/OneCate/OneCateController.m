//
//  OneCateController.m
//  CardLeap
//
//  Created by songweiping on 15/1/6.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "OneCateController.h"
#import "RDVTabBarController/RDVTabBarController.h"
#import "MJExtension.h"

#import "CityAddController.h"
#import "TwoCateController.h"

#import "CityOneCate.h"
#import "CityTwoCate.h"
#import "CityAddMessage.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface OneCateController () <UITableViewDataSource, UITableViewDelegate>


// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)     UITableView     *oneCateTableView;

// ---------------------- 数据模型 ----------------------
/** 一级分类的数据 */
@property (strong, nonatomic)   NSArray         *oneCate;


@end

@implementation OneCateController


#pragma mark @@@@ ----> 生命周期

/**
 *  页面加载时调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 设置 UI控件
    [self initUI];
    
    // 获取出数据
    [self getData];
}


/**
 *  页面 当前页面 即将出现时 调用
 *
 *  @param animated
 */
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 隐藏 当前页面的 tabBar
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

/**
 *  页面 当前页面 即将消失时 调用
 *
 *  @param animated <#animated description#>
 */
- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 显示出 上个页面的 tabBar
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}


/**
 *  内存不足时调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark @@@@ ----> 设置UI控件



- (void) initUI {
    
    
    [self settingNav];
    
    [self oneCateTableView];
    
}


/**
 *  设置导航栏
 */
- (void) settingNav {
    self.navigationItem.title = @"选择分类";

}






/**
 *  UITableView 设置
 *
 *  @return     UITableView
 */
- (UITableView *)oneCateTableView {
    
    if (_oneCateTableView == nil) {
    
        UITableView *oneCateTableView    = [[UITableView alloc] init];
        oneCateTableView.frame           = self.view.frame;
        oneCateTableView.backgroundColor = [UIColor whiteColor];
        oneCateTableView.dataSource      = self;
        oneCateTableView.delegate        = self;
        [UZCommonMethod hiddleExtendCellFromTableview:oneCateTableView];
        _oneCateTableView = oneCateTableView;
        
        [self.view addSubview:_oneCateTableView];
    }
    
    return _oneCateTableView;
}



#pragma mark @@@@ ----> 获取数据

/**
 *  获取数据
 */
- (void) getData {

//   NSArray *cityCate =  [[NSUserDefaults standardUserDefaults] objectForKey:@"cityCates"];
    NSArray *cityCate = userDefault(@"cityCates");
    
    self.oneCate      = [CityOneCate objectArrayWithKeyValuesArray:cityCate];
}


#pragma mark @@@@ ----> UITableView 数据源方法

/**
 *  返回tableView分组信息
 *
 *  @param      tableView
 *
 *  @return     NSInteger
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/**
 *  返回 tableView Cell 的数量
 *
 *  @param      tableView
 *  @param      section
 *
 *  @return     NSInteger
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.oneCate.count;
}


/**
 *  返回 每个 cell 显示的数据
 *
 *  @param      tableView
 *  @param      indexPath
 *
 *  @return     UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellName = @"oneCateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    CityOneCate *cityOneCate    = self.oneCate[indexPath.row];
    cell.textLabel.text         = cityOneCate.cat_name;
    cell.textLabel.textColor    = Color(106, 106, 106, 255);
    cell.textLabel.font         = SYSTEM_FONT_SIZE(12);
    
    if (cityOneCate.son.count != 0) {
        cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark @@@@ ----> UITableView 代理方法

/**
 *  点击每个 cell 执行的方法
 *
 *  @param tableView
 *  @param indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 取出 一级分类
    CityOneCate *cityOneCate = self.oneCate[indexPath.row];
    // 取出 二级分类
    NSArray     *cityTwoCate = cityOneCate.son;
    
    CityAddMessage    *message = [[CityAddMessage alloc] init];
    if (self.cityAddMessage != nil) {
        message = self.cityAddMessage;
    }

    message.cityOneCateId      = cityOneCate.cat_id;
    message.cityOneCateName    = cityOneCate.cat_name;
    
    if (cityTwoCate.count == 0) {
        [self toJump:message];
    } else {
        // 有二级分类 跳 二级分类
        TwoCateController *twoCate = [[TwoCateController alloc] init];
        twoCate.cityAddMessage     = message;
        twoCate.cateMessage        = cityTwoCate;
        // 地区分类
        twoCate.cityAddress        = self.cityAddress;
        [self.navigationController pushViewController:twoCate animated:YES];
    }
    
}



/**
 *  跳转方法处理
 *
 *  @param message 模型数据
 */
- (void) toJump:(CityAddMessage *)message {
    // 页面存在
    BOOL is_exit = NO;
    NSArray *subViews = self.navigationController.viewControllers;
    for (BaseViewController *obj in subViews) {
        if ([obj isKindOfClass:[CityAddController class]]) {
            is_exit = YES;
            CityAddController *friVC1=(CityAddController *)obj;
            friVC1.cityAddMessage = message;
            friVC1.cityAddress    = self.cityAddress;
            [self.navigationController popToViewController:friVC1 animated:YES];
            
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
        CityAddController *cityAdd = [[CityAddController alloc] init];
        cityAdd.cityAddMessage     = message;
        // 地区分类
        cityAdd.cityAddress        = self.cityAddress;
        [self.navigationController pushViewController:cityAdd animated:YES];
    }
}


@end
