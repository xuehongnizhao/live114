//
//  ShopDishConfirmViewController.m
//  CardLeap
//
//  Created by lin on 12/31/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  外卖 - 确认美食

#import "ShopDishConfirmViewController.h"
#import "dishConfirmTableViewCell.h"
#import "takeoutDishInfo.h"
#import "SubmitOrderViewController.h"
#import "LoginViewController.h"
#import "JYJSON.h"

@interface ShopDishConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UILabel *countLable;
@property (strong, nonatomic) UILabel *priceLable;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UITableView *dishTableview;
@end

@implementation ShopDishConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------set UI
-(void)setUI
{
    [self.view addSubview:self.dishTableview];
    [_dishTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_dishTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_dishTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_dishTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:80.0f];
    
    [self.view addSubview:self.submitButton];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
    [_submitButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    //---总价 数量--------
    [self.view addSubview:self.priceLable];
    [_priceLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_priceLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_submitButton withOffset:-5.0f];
    [_priceLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    int width = self.total_price.length * 8;
    [_priceLable autoSetDimension:ALDimensionWidth toSize:width];
    CGFloat price = (self.ship_price == nil) ?[self.total_price floatValue]:[self.ship_price floatValue] + [self.total_price floatValue];
    _priceLable.text = [NSString stringWithFormat:@"￥%0.2f",price];
    
    [self.view addSubview:self.countLable];
    [_countLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_priceLable withOffset:-5.0f];
    [_countLable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_priceLable];
    [_countLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_countLable autoSetDimension:ALDimensionWidth toSize:100.0f];
    _countLable.text = [NSString stringWithFormat:@"%@份美食",self.total_count];
}

#pragma mark---------get UI
-(UILabel *)countLable
{
    if (!_countLable) {
        _countLable = [[UILabel alloc] initForAutoLayout];
        //_countLable.layer.borderWidth = 1;
        _countLable.textAlignment = NSTextAlignmentRight;
        _countLable.font = [UIFont systemFontOfSize:13.0f];
        _countLable.textColor = [UIColor lightGrayColor];
    }
    return _countLable;
}

-(UILabel *)priceLable
{
    if (!_priceLable) {
        _priceLable = [[UILabel alloc] initForAutoLayout];
        //_priceLable.layer.borderWidth = 1;
        _priceLable.font = [UIFont systemFontOfSize:14.0f];
        _priceLable.textColor = [UIColor redColor];
    }
    return _priceLable;
}

-(UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initForAutoLayout];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 4.0f;
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitButton setTitle:@"提交订单" forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_submitButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        [_submitButton addTarget:self action:@selector(submitAtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

-(UITableView *)dishTableview
{
    if (!_dishTableview) {
        _dishTableview = [[UITableView alloc] initForAutoLayout];
        [UZCommonMethod hiddleExtendCellFromTableview:_dishTableview];
        _dishTableview.delegate = self;
        _dishTableview.dataSource = self;
        if ([_dishTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_dishTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_dishTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_dishTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _dishTableview;
}

#pragma mark-------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ship_price == nil || (self.ship_price != nil && indexPath.row < self.dishArray.count)) {
        static NSString *simpleTableIdentifier=@"shop_submit_cell";
        dishConfirmTableViewCell *cell=(dishConfirmTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell==nil)
        {
            cell = [[dishConfirmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        while ([cell.contentView.subviews lastObject]!= nil) {
            [[cell.contentView.subviews lastObject]removeFromSuperview];
        }
        takeoutDishInfo *info = [self.dishArray objectAtIndex:indexPath.row];
        [cell confirgureCell:info];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else {
        // 商店 - 配送费
        //        static NSString * shipPriceTableIdentifier = @"shop_shipPrice_cell";
        //        UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:shipPriceTableIdentifier];
        //        if (cell == nil) {
        //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shipPriceTableIdentifier];
        //        }
        //        cell.textLabel.text = [NSString stringWithFormat:@"配送费：%@元",self.ship_price];
        //        return cell;
        static NSString *simpleTableIdentifier=@"shop_submit_cell";
        dishConfirmTableViewCell *cell=(dishConfirmTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell==nil)
        {
            cell = [[dishConfirmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        while ([cell.contentView.subviews lastObject]!= nil) {
            [[cell.contentView.subviews lastObject]removeFromSuperview];
        }
        takeoutDishInfo *info = [[takeoutDishInfo alloc] init];
        info.take_name = @"配送费";
        info.take_price = self.ship_price;
        [cell confirgureCell:info];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ship_price == nil) {
        return [self.dishArray count];
    }else {
        return ([self.dishArray count]+1);
    }
}


#pragma mark-------submit action
-(void)submitAtion :(UIButton*)sender
{
    NSLog(@"跳转到");
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        //        [firVC.navigationItem setTitle:@"登录"];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        SubmitOrderViewController *firVC = [[SubmitOrderViewController alloc] init];
        firVC.dishArray = self.dishArray;
        firVC.orderJson = [self jsonForOrder];
        firVC.shop_id   = self.shop_id;
        CGFloat price = (self.ship_price == nil) ?[self.total_price floatValue]:[self.ship_price floatValue] + [self.total_price floatValue];
        firVC.totalPrice = [NSString stringWithFormat:@"%0.2f",price];
        [firVC setNavBarTitle:@"提交订单" withFont:14.0f];
        //        [firVC.navigationItem setTitle:@"提交订单"];
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(NSString*)jsonForOrder
{
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (takeoutDishInfo *info in self.dishArray) {
        NSDictionary *dic = @{
                              @"num":[NSString stringWithFormat:@"%ld",(long)info.count],
                              @"take_id":info.take_id,
                              @"take_name":info.take_name,
                              @"take_price":info.take_price
                              };
        [tmpArray addObject:dic];
    }
    NSString *jsonStr = [JYJSON JSONStringWithDictionaryOrArray:tmpArray];
    return jsonStr;
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
