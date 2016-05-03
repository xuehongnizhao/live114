//
//  OneAddressCateController.m
//  CardLeap
//
//  Created by songweiping on 15/1/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "OneAddressCateController.h"
#import "MJExtension.h"


#import "TwoAddressCateController.h"
#import "CityAddController.h"

#import "OneCateController.h"

#import "CityAddController.h"
#import "CityAddressOneCate.h"

#import "CityAddMessage.h"


#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface OneAddressCateController () <UITableViewDataSource, UITableViewDelegate>


// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)     UITableView *addressOneTbaleView;

// ---------------------- 数据模型 ----------------------
/** 一级地区分类的数据 */
@property (strong, nonatomic)   NSArray     *oneCate;

@end

@implementation OneAddressCateController


#pragma 生命周期

/**
 *  控制器 view 加载完毕时 调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"区域";
    [self addressOneTbaleView];
    
}

/**
 *  
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 添加控件
/**
 *  添加控件
 *
 *  @return UITableView
 */
- (UITableView *)addressOneTbaleView {
    
    if (_addressOneTbaleView == nil) {
        UITableView *addressOneTbaleView = [[UITableView alloc] init];
        addressOneTbaleView.frame        = self.view.frame;
        addressOneTbaleView.dataSource   = self;
        addressOneTbaleView.delegate     = self;
        [UZCommonMethod hiddleExtendCellFromTableview:addressOneTbaleView];
        _addressOneTbaleView             = addressOneTbaleView;
        [self.view addSubview:_addressOneTbaleView];
    }
    return _addressOneTbaleView;
}


#pragma mark 数据处理
/**
 *  获取数据
 *
 *  @return 数据处理
 */
- (NSArray *)oneCate {
    if (_oneCate == nil) {
        _oneCate = [self dataTreatment:self.cityAddress];
    }
    return _oneCate;
}

/**
 *  数据处理
 *
 *  @param param
 *
 *  @return
 */
- (NSArray *) dataTreatment:(NSArray *) param {
    return [CityAddressOneCate objectArrayWithKeyValuesArray:param];
}


#pragma mark UITableView ---- dataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oneCate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellName =  @"addressCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    

    CityAddressOneCate *addressOne = self.oneCate[indexPath.row];
    cell.textLabel.text      = addressOne.area_name;
    cell.textLabel.font      = SYSTEM_FONT_SIZE(12);
    cell.textLabel.textColor = Color(106, 106, 106, 255);
    if (addressOne.son.count != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark UITableView ---- delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityAddressOneCate *addressOne = self.oneCate[indexPath.row];
    CityAddMessage     *message    = self.cityAddMessage;
    
    if (self.cityAddMessage != nil) {
        message = self.cityAddMessage;
    }
    
    message.cityOneCateAddressID   = addressOne.area_id;
    message.cityOneCateAddressName = addressOne.area_name;
    if (addressOne.son.count == 0) {
        [self toJump:message];
    } else {
        TwoAddressCateController *addressTwoCate = [[TwoAddressCateController alloc] init];
        addressTwoCate.addressTwoCate     = addressOne.son;
        addressTwoCate.cityAddress        = self.cityAddress;
        addressTwoCate.cityAddMessage     = message;
        [self.navigationController pushViewController:addressTwoCate animated:YES];
    }
}



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
            
            if (message.cityTwoCateAddressID && message.cityTwoCateAddressName) {
                message.cityTwoCateAddressID     = nil;
                message.cityTwoCateAddressName   = nil;
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
