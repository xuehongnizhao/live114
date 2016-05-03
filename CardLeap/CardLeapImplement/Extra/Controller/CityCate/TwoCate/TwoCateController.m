//
//  TwoCateController.m
//  CardLeap
//
//  Created by songweiping on 15/1/6.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "TwoCateController.h"
#import "MJExtension.h"
#import "CityAddController.h"


#import "CityTwoCate.h"
#import "CityAddMessage.h"



#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface TwoCateController ()<UITableViewDataSource, UITableViewDelegate>


// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)     UITableView *twoTableView;


// ---------------------- 数据模型 ----------------------
/** 二级分类的数据 */
@property (strong, nonatomic)   NSArray     *twoCate;

@end

@implementation TwoCateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setHiddenTabbar:YES];
    
    // 设置title
    self.navigationItem.title = self.cityAddMessage.cityOneCateName;
    
    // 获取数据
    self.twoCate = [self dataTreatment:self.cateMessage];
    
    // 设置控件
    [self twoTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark @@@@ ----> 数据处理

/**
 *  数据处理 字典转 模型
 *
 *  @param      NSArray
 *
 *  @return     NSArray
 */
- (NSArray *) dataTreatment:(NSArray *)param {
    NSArray *array = [CityTwoCate objectArrayWithKeyValuesArray:param];
    return array;
}


#pragma mark @@@@ ----> 添加控件

/**
 *  添加控件
 *
 *  @return     UITableView
 */
- (UITableView *)twoTableView {
    
    if (_twoTableView == nil) {
        
        UITableView *twoTableView = [[UITableView alloc] init];
        twoTableView.frame           = self.view.frame;
        twoTableView.backgroundColor = [UIColor whiteColor];
        twoTableView.dataSource      = self;
        twoTableView.delegate        = self;
        [UZCommonMethod hiddleExtendCellFromTableview:twoTableView];
        _twoTableView                = twoTableView;
        [self.view addSubview:_twoTableView];
    }
    return _twoTableView;
}


#pragma mark UITableView 数据源方法

/**
 *  返回  tableView 分组个数
 *
 *  @param      tableView
 *
 *  @return     NSInteger
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 *  返回 tableView cell 显示个数
 *
 *  @param      tableView
 *  @param      section
 *
 *  @return     NSInteger
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return self.twoCate.count;
}


/**
 *  返回每个 cell 显示的数据
 *
 *  @param      tableView
 *  @param      indexPath
 *
 *  @return     UITableViewCell
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellName = @"twoCateCell";
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


#pragma mark @@@@ ----> tableView 代理方法

/**
 *  tableView 每个 cell 点击事件
 *
 *  @param tableView
 *  @param indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
 *  跳转逻辑
 *
 *  @param message 数据模型
 */
- (void) toJump:(CityAddMessage *) message {
    
    BOOL is_exit = NO;
    NSArray *subViews = self.navigationController.viewControllers;
    for (BaseViewController *obj in subViews) {
        if ([obj isKindOfClass:[CityAddController class]]) {
            is_exit = YES;
            CityAddController *friVC1=(CityAddController *)obj;
            friVC1.cityAddMessage = message;
            friVC1.cityAddress    = self.cityAddress;
            [self.navigationController popToViewController:friVC1 animated:YES];
            break;
        }
    }
    
    if (!is_exit) {
        CityAddController *cityAdd = [[CityAddController alloc] init];
        // 选择分类数组
        cityAdd.cityCates          = self.twoCate;
        
        // 同城地区分类
        cityAdd.cityAddress        = self.cityAddress;
        cityAdd.cityAddMessage     = message;
        [self.navigationController pushViewController:cityAdd animated:YES];
    }
}

@end
