//
//  TwoAddressCateController.m
//  CardLeap
//
//  Created by songweiping on 15/1/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "TwoAddressCateController.h"
#import "MJExtension.h"

#import "CityAddController.h"

#import "CityAddressTwoCate.h"

#import "CityAddMessage.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

@interface TwoAddressCateController ()<UITableViewDataSource, UITableViewDelegate>


// ---------------------- UI 控件 ----------------------
/** UITableView */
@property (weak, nonatomic)   UITableView *addressTwoTableView;

// ---------------------- 数据模型 ----------------------
/** 地区二级分类 数据源 */
@property (strong, nonatomic) NSArray     *twoCate;


@end

@implementation TwoAddressCateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.cityAddMessage.cityOneCateAddressName;
    
    [self addressTwoTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)addressTwoTableView {
    
    if (_addressTwoTableView == nil) {
        
        UITableView *addressTwoTableView = [[UITableView  alloc] init];
        addressTwoTableView.frame        = self.view.frame;
        addressTwoTableView.dataSource   = self;
        addressTwoTableView.delegate     = self;
        [UZCommonMethod hiddleExtendCellFromTableview:addressTwoTableView];
        _addressTwoTableView             = addressTwoTableView;
        [self.view addSubview:_addressTwoTableView];
    }
    return _addressTwoTableView;
}


- (NSArray *)twoCate {
    
    if (_twoCate == nil) {
        _twoCate = [self dataTreatment:self.addressTwoCate];
    }
    return _twoCate;
}


- (NSArray *) dataTreatment:(NSArray *)param {
    return [CityAddressTwoCate objectArrayWithKeyValuesArray:param];
}




#pragma mark UITableView ---- dataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.twoCate.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellName = @"addressTwoCell";
    
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


#pragma mark UITableView ---- delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityAddressTwoCate *addressTwoCate = self.twoCate[indexPath.row];
    CityAddMessage     *message        = [[CityAddMessage alloc] init];
    
    if (self.cityAddMessage != nil) {
        message        = self.cityAddMessage;
    }
    message.cityTwoCateAddressID   = addressTwoCate.area_id;
    message.cityTwoCateAddressName = addressTwoCate.area_name;
    [self toJump:message];
 
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
