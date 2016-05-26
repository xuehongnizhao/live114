//
//  AddressMangeViewController.m
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "AddressMangeViewController.h"
#import "userAddressInfo.h"
#import "addressTableViewCell.h"
#import "AddAddressViewController.h"

@interface AddressMangeViewController ()<UITableViewDelegate,UITableViewDataSource,addAddressDelegate,selectDelegate>
@property (strong, nonatomic) UITableView *addressTableview;
@property (strong, nonatomic) UIButton *rightButton;
@end

@implementation AddressMangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark--------set UI
-(void)setUI
{
    [self.view addSubview:self.addressTableview];
    [_addressTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_addressTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_addressTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_addressTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}

#pragma mark--------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0;
    }
    return 5.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 1;
    
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.addressArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    userAddressInfo *info = [self.addressArray objectAtIndex:indexPath.row];
    NSString *address = info.as_address;
    CGFloat height = (float)(address.length / 20 + 2)*18.0f+30;
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_address_cell";
    addressTableViewCell *cell=(addressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[addressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    userAddressInfo *info = [self.addressArray objectAtIndex:indexPath.section];
    cell.delegate = self;
    [cell configureCell:info row:indexPath.section];
    
    cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    NSLog(@"去删除");
    userAddressInfo *info = [self.addressArray objectAtIndex:indexPath.section];
    [self deleteAddress:info];
}

//以下方法可以不是必须要实现，添加如下方法可实现特定效果：
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//实现Cell可上下移动，调换位置，需要实现UiTableViewDelegate中如下方法：

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//当两个Cell对换位置后
- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    [self.addressArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark--------get UI
-(UITableView *)addressTableview
{
    if (!_addressTableview) {
        _addressTableview = [[UITableView alloc] initForAutoLayout] ;
        _addressTableview.delegate = self;
        _addressTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_addressTableview];
    }
    return _addressTableview;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        [_rightButton setImage:[UIImage imageNamed:@"city_release_no"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"city_release_sel"] forState:UIControlStateHighlighted];
        [_rightButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(void)addAction:(UIButton*)sender
{
    NSLog(@"跳转添加地址");
    AddAddressViewController *firVC = [[AddAddressViewController alloc] init];
    firVC.delegate = self;
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"添加收货地址" withFont:14.0f];
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark---------cell delegate
-(void)selectActionDelegate:(UIButton *)sender
{
    NSLog(@"点击了按钮%ld",(long)sender.tag);
    NSInteger tag = sender.tag;
    userAddressInfo *info = [self.addressArray objectAtIndex:tag];
    if ([info.is_default isEqualToString:@"0"]) {
        //将其他的全都设置为0
        for(userAddressInfo *tmpInfo in self.addressArray)
        {
            tmpInfo.is_default = @"0";
        }
        info.is_default = @"1";
    }
    [self.addressTableview reloadData];
    //back to preview
    [self setDefaultAddress:info];
}

#pragma mark---------set default address
-(void)setDefaultAddress :(userAddressInfo*)info
{
    NSString *url = connect_url(@"takeout_address_default");
    NSDictionary *dict = @{
                           @"session_key":[UserModel shareInstance].session_key,
                           @"app_key":url,
                           @"as_id":info.as_id,
                           @"u_id":[UserModel shareInstance].u_id
                           };
    [SVProgressHUD showWithStatus:@"正在设置，请稍候"];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [self.delegate selectAddress:info.as_address phone:info.as_tel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark---------delete address
-(void)deleteAddress :(userAddressInfo*)info
{
    if ([info.is_default integerValue]==1) {
        [SVProgressHUD showErrorWithStatus:@"默认收货地址不允许删除"];
    }else{
        NSString *url = connect_url(@"takeout_address_delete");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"session_key":[UserModel shareInstance].session_key,
                               @"as_id":info.as_id,
                               @"u_id":[UserModel shareInstance].u_id
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                NSLog(@"删除成功");
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
        [self.addressArray removeObject:info];
        [self.addressTableview reloadData];
    }
}

#pragma mark---------add address delegate
-(void)addAddressDelegate
{
    NSLog(@"跳回来了吗");
    [self getDataFormNet];
}

-(void)getDataFormNet
{
    NSString *url = connect_url(@"takeout_address");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"u_id":[UserModel shareInstance].u_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            [self.addressArray removeAllObjects];
            [SVProgressHUD dismiss];
            NSArray *tmpArray = [param objectForKey:@"obj"];
            for (NSDictionary *dic in tmpArray) {
                userAddressInfo *info = [[userAddressInfo alloc] initWithNSDictionary:dic];
                [self.addressArray addObject:info];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
        [self.addressTableview reloadData];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
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
