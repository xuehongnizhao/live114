//
//  ExchangeGiftViewController.m
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ExchangeGiftViewController.h"

@interface ExchangeGiftViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int count;//兑换数量
}
@property (strong,nonatomic)UIButton *submitButton;//确认兑换按钮
@property (strong,nonatomic)UIButton *addButton;//增加数量按钮
@property (strong,nonatomic)UILabel *numLable;//数量lable
@property (strong,nonatomic)UIButton *subButton;//减少数量按钮
@property (strong,nonatomic)UILabel *totalPriceLable;//总价lable
@property (strong,nonatomic)UITextField *user_name_T;//用户姓名输入框
@property (strong,nonatomic)UITextField *user_phone_T;//用户手机号码输入框
@property (strong,nonatomic)UITableView *exchangeTableview;//兑换列表
@end

@implementation ExchangeGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark --- 12.7 将默认兑换数字改为1，并且数字为0的时候禁止提交
    count = 1;
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------set UI
-(void)setUI
{
    [self.view addSubview:self.exchangeTableview];
    [_exchangeTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_exchangeTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_exchangeTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_exchangeTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}

#pragma mark------tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"my_exchange_cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    //cell布局显示
    if (indexPath.row == 0) {
        [cell setBackgroundColor:UIColorFromRGB(0xf3f3f3)];
        UILabel *mallName = [[UILabel alloc] initForAutoLayout];
        mallName.textColor=UIColorFromRGB(singleTitle);
        [cell.contentView addSubview:mallName];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        mallName.text = self.info.mall_name;
    }else if (indexPath.row == 1){
        [cell setBackgroundColor:[UIColor whiteColor]];
        UILabel *mallName = [[UILabel alloc] initForAutoLayout];
        mallName.textColor=UIColorFromRGB(singleTitle);
        [cell.contentView addSubview:mallName];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [mallName autoSetDimension:ALDimensionWidth toSize:100.0f];
        mallName.text = @"单价";
        //单价lable
        UILabel *singlePrice = [[UILabel alloc] initForAutoLayout];
        singlePrice.textColor=UIColorFromRGB(singleTitle);
        singlePrice.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:singlePrice];
        [singlePrice autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [singlePrice autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [singlePrice autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [singlePrice autoSetDimension:ALDimensionWidth toSize:100.0f];
        singlePrice.text = [NSString stringWithFormat:@"%@积分",self.info.mall_integral];
        
    }else if (indexPath.row == 2){
        [cell setBackgroundColor:[UIColor whiteColor]];
        UILabel *mallName = [[UILabel alloc] initForAutoLayout];
        mallName.textColor=UIColorFromRGB(singleTitle);
        [cell.contentView addSubview:mallName];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [mallName autoSetDimension:ALDimensionWidth toSize:100.0f];
        mallName.text = @"数量";
        
        //数量操作
        [cell.contentView addSubview:self.addButton];
        [_addButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_addButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_addButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_addButton autoSetDimension:ALDimensionWidth toSize:30.0f];
        
        [cell.contentView addSubview:self.numLable];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_numLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_numLable autoSetDimension:ALDimensionWidth toSize:40.0f];
        [_numLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_addButton withOffset:-3.0f];
        _numLable.text = [NSString stringWithFormat:@"%d",count];
        
        [cell.contentView addSubview:self.subButton];
        [_subButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_addButton];
        [_subButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_numLable withOffset:-3.0f];
        [_subButton autoSetDimension:ALDimensionWidth toSize:30.0f];
        [_subButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_subButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        
    }else if (indexPath.row == 3){
        [cell setBackgroundColor:[UIColor whiteColor]];
        UILabel *mallName = [[UILabel alloc] initForAutoLayout];
        mallName.textColor=UIColorFromRGB(singleTitle);
        [cell.contentView addSubview:mallName];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [mallName autoSetDimension:ALDimensionWidth toSize:100.0f];
        mallName.text = @"总价";
        //总价lable
        UILabel *singlePrice = [[UILabel alloc] initForAutoLayout];
        singlePrice.textColor=UIColorFromRGB(singleTitle);
        singlePrice.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:singlePrice];
        [singlePrice autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [singlePrice autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [singlePrice autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [singlePrice autoSetDimension:ALDimensionWidth toSize:100.0f];
        float total = [self.info.mall_integral integerValue]*count;
        singlePrice.text = [NSString stringWithFormat:@"%0.0f积分",total];
    }else if (indexPath.row == 4){
        [cell setBackgroundColor:UIColorFromRGB(0xf3f3f3)];
        UILabel *mallName = [[UILabel alloc] initForAutoLayout];
        mallName.textColor=UIColorFromRGB(singleTitle);
        [cell.contentView addSubview:mallName];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [mallName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [mallName autoSetDimension:ALDimensionWidth toSize:100.0f];
        mallName.text = @"兑换人信息";
    }else if (indexPath.row == 5){
        [cell.contentView addSubview:self.user_name_T];
        [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    }else if (indexPath.row == 6){
        [cell.contentView addSubview:self.user_phone_T];
        [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    }else if (indexPath.row == 7){
        [cell.contentView addSubview:self.submitButton];
        [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
        [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

#pragma mark-------get UI
-(UITableView *)exchangeTableview
{
    if (!_exchangeTableview) {
        _exchangeTableview = [[UITableView alloc] initForAutoLayout];
        _exchangeTableview.delegate = self;
        _exchangeTableview.dataSource = self;
        _exchangeTableview.scrollEnabled = NO;
        [UZCommonMethod hiddleExtendCellFromTableview:_exchangeTableview];
        if ([_exchangeTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_exchangeTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_exchangeTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_exchangeTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _exchangeTableview;
}

-(UILabel *)numLable
{
    if (!_numLable) {
        _numLable = [[UILabel alloc] initForAutoLayout];
        _numLable.layer.borderWidth =1;
        _numLable.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _numLable.font = [UIFont systemFontOfSize:13.0f];
        _numLable.textColor = UIColorFromRGB(0x6c6c6c);
        _numLable.textAlignment = NSTextAlignmentCenter;
    }
    return _numLable;
}

-(UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [[UIButton alloc] initForAutoLayout];
        [_addButton setImage:[UIImage imageNamed:@"order_duction-02"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"order_duction-02"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

-(UIButton *)subButton
{
    if (!_subButton) {
        _subButton = [[UIButton alloc] initForAutoLayout];
        [_subButton setImage:[UIImage imageNamed:@"order_duction"] forState:UIControlStateNormal];
        [_subButton setImage:[UIImage imageNamed:@"order_duction"] forState:UIControlStateHighlighted];
        [_subButton addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

-(UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initForAutoLayout];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 4.0f;
        [_submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
        [_submitButton setTitle:@"确认提交" forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_submitButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

-(UITextField *)user_name_T
{
    if (!_user_name_T) {
        _user_name_T = [[UITextField alloc] initForAutoLayout];
        _user_name_T.placeholder = @"请输入真实姓名";
        _user_name_T.leftViewMode = UITextFieldViewModeAlways;
        _user_name_T.textColor = UIColorFromRGB(singleTitle);
        _user_name_T.font = [UIFont systemFontOfSize:14.0f];
        _user_name_T.clearsOnBeginEditing = YES;
        _user_name_T.tintColor = UIColorFromRGB(tintColors);
        [_user_name_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 50, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(singleTitle);
        leftLable.text = @"联系人";
        _user_name_T.leftView = leftLable;
    }
    return _user_name_T;
}

-(UITextField *)user_phone_T
{
    if (!_user_phone_T) {
        _user_phone_T = [[UITextField alloc] initForAutoLayout];
        _user_phone_T.placeholder = @"输入有效的手机号码";
        _user_phone_T.keyboardType=UIKeyboardTypeNumberPad;
        _user_phone_T.leftViewMode = UITextFieldViewModeAlways;
        _user_phone_T.textColor = UIColorFromRGB(singleTitle);
        _user_phone_T.font = [UIFont systemFontOfSize:14.0f];
        _user_phone_T.clearsOnBeginEditing = YES;
        _user_phone_T.tintColor = UIColorFromRGB(tintColors);
        [_user_phone_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 50, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(singleTitle);
        leftLable.text = @"手  机";
        _user_phone_T.leftView = leftLable;
        if (userDefault(@"USERNAME")!=nil) {
            _user_phone_T.text=userDefault(@"USERNAME");
        }
    }
    return _user_phone_T;
}

#pragma mark-------加减数量操作
-(void)addAction:(UIButton*)sender
{
    count ++;
    [_exchangeTableview reloadData];
    //计算总价
}

-(void)subAction:(UIButton*)sender
{
    if (count>0) {
        count--;
        [_exchangeTableview reloadData];
        //计算总价
    }
}

-(void)submitAction:(UIButton*)sender
{
    NSLog(@"确认提交");
    if (self.user_name_T.text.length>0 && self.user_phone_T.text.length>0) {
        float total = [self.info.mall_integral integerValue]*count;
        if (total<=[[UserModel shareInstance].pay_point integerValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"o2o助手提示" message:@"请确保您的个人信息填写正确" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"取消", nil];
            [alert show];
        }else{
            [SVProgressHUD showErrorWithStatus:@"用户积分不足"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请准确填写兑换人信息"];
    }
}

#pragma mark-------alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self submit2server];
    }
}

/**
 向服务器提交
 */
-(void)submit2server
{
    if (count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择兑换数量"];
        return;
    }
    NSString *url = connect_url(@"mall_insert");
    float total = [self.info.mall_integral integerValue]*count;
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"price":self.info.mall_integral,
                           @"all_price":[NSString stringWithFormat:@"%f",total],
                           @"num":[NSString stringWithFormat:@"%d",count],
                           @"use_name":self.user_name_T.text,
                           @"use_tel":self.user_phone_T.text,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"mall_id":self.info.mall_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
            //兑换成功提醒
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
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
