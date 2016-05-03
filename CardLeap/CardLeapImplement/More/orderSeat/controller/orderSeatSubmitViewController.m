//
//  orderSeatSubmitViewController.m
//  CardLeap
//
//  Created by mac on 15/1/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderSeatSubmitViewController.h"
#import "NVDate.h"
#import "RemarkViewController.h"
#import "NSDate+WQCalendarLogic.h"
#import "XHRealTimeBlur.h"
#import "choosePickerView.h"
#import "orderSeatSuccessViewController.h"

@interface orderSeatSubmitViewController ()<UITableViewDataSource,UITableViewDelegate,finishDelegate,chooseTimeDelegate>
{
    NSString *connect_name;
    NSString *connect_tel;
    NSString *submit_conde;
    NSString *submit_desc;
    NSString *num_order;
    NSString *time_order;
    NSMutableArray *dateArray;
    NSMutableArray *timeArray;
    NSMutableArray *countArray;
    NSMutableArray *yearArray;
    NSString *date_s;
    NSString *time_s;
    NSString *count_s;
    NSString *year_s;
    NSString *myTime;//发送给服务器的格式
}
@property (strong,nonatomic)UIPickerView *timePicker;
@property (strong,nonatomic)UITableView *orderSubmitTableview;
@property (strong,nonatomic)UIButton *orderSeatButton;
@property (strong,nonatomic)UITextField *connect_name_T;
@property (strong,nonatomic)UITextField *connect_phone_T;
@property (strong,nonatomic)UITextField *connect_code_T;
@end

@implementation orderSeatSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark------init data
-(void)initData
{
    connect_name = @"";
    connect_tel = @"";
    submit_conde = @"";
    submit_desc = @"备注";
    num_order = @"请选择预定人数";
    time_order = @"请选择预定时间";
    date_s = @"未选择";
    time_s = @"未选择";
    count_s = @"未选择";
    dateArray = [[NSMutableArray alloc] init];
    timeArray = [[NSMutableArray alloc] init];
    countArray = [[NSMutableArray alloc] init];
    yearArray = [[NSMutableArray alloc] init];
    [self getData];
}

-(void)getData
{
    //获取日期
    NSDate *curDate = [NSDate date];
    for (int i=0;i<7;i++) {
        NSDate *tmpDate = [curDate dayInTheFollowingDay:i];
        int week = (int)[tmpDate weeklyOrdinality];
        NSString *tmpStr = [NSDate getWeekStringFromInteger:week];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps  = [calendar components:unitFlags fromDate:tmpDate];
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSString *dateString = [NSString stringWithFormat:@"%ld月%ld日 %@",(long)month,(long)day,tmpStr];
        [yearArray addObject:[NSString stringWithFormat:@"%ld",(long)year]];
        [dateArray addObject:dateString];
    }
    //获取时间
    for (int i =0; i<24; i++)
    {
        for (int j=0; j<2; j++)
        {
            NSString *send_minite;
            if (j==0)
            {
                send_minite =@"00";
            }else if (j==1)
            {
                send_minite =@"30";
            }
            NSString *sendTime = [NSString stringWithFormat:@"%02d:%@",i,send_minite];
            [timeArray addObject:sendTime];
        }
    }
    //获取人数
    for (int i = 1; i <= 20; i++) {
        NSString *count = [NSString stringWithFormat:@"%d人",i];
        [countArray addObject:count];
    }
}



#pragma mark------set UI
-(void)setUI
{
    [self.view addSubview:self.orderSeatButton];
    [_orderSeatButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_orderSeatButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_orderSeatButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_orderSeatButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [self.view addSubview:self.orderSubmitTableview];
    [_orderSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_orderSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_orderSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_orderSubmitTableview autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_orderSeatButton withOffset:-10.0f];
}

#pragma mark------get UI
//-(UIPickerView *)timePicker
//{
//    if (!_timePicker) {
//        _timePicker = [[UIPickerView alloc] initForAutoLayout];
//        _timePicker.delegate = self;
//    }
//    return _timePicker;
//}

-(UITextField *)connect_name_T
{
    if (!_connect_name_T) {
        _connect_name_T = [[UITextField alloc] initForAutoLayout];
        _connect_name_T.placeholder = @"请输入真实姓名";
        //_connect_name_T.keyboardType=UIKeyboardTypeNumberPad;
        _connect_name_T.leftViewMode = UITextFieldViewModeAlways;
        //_connect_name_T.borderStyle=UITextBorderStyleRoundedRect;
        _connect_name_T.textColor = UIColorFromRGB(singleTitle);
        _connect_name_T.font = [UIFont systemFontOfSize:14.0f];
        _connect_name_T.clearsOnBeginEditing = YES;
        _connect_name_T.tintColor = UIColorFromRGB(tintColors);
        [_connect_name_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 50, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(singleTitle);
        leftLable.text = @"联系人";
        //        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        //        passImage.frame = CGRectMake(30, 3, 20, 20);
        _connect_name_T.leftView = leftLable;
        
    }
    return _connect_name_T;
}

-(UITextField *)connect_phone_T
{
    if (!_connect_phone_T) {
        _connect_phone_T = [[UITextField alloc] initForAutoLayout];
        _connect_phone_T.placeholder = @"输入有效的手机号码";
        _connect_phone_T.keyboardType=UIKeyboardTypeNumberPad;
        _connect_phone_T.leftViewMode = UITextFieldViewModeAlways;
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _connect_phone_T.textColor = UIColorFromRGB(singleTitle);
        _connect_phone_T.font = [UIFont systemFontOfSize:14.0f];
        _connect_phone_T.clearsOnBeginEditing = YES;
        _connect_phone_T.tintColor = UIColorFromRGB(tintColors);
        [_connect_phone_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 50, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(singleTitle);
        leftLable.text = @"手  机";
        _connect_phone_T.leftView = leftLable;
        if (userDefault(@"USERNAME")!=nil) {
            _connect_phone_T.text=userDefault(@"USERNAME");
        }
    }
    return _connect_phone_T;
}

-(UITextField *)connect_code_T
{
    if (!_connect_code_T) {
        _connect_code_T = [[UITextField alloc] initForAutoLayout];
        _connect_code_T.placeholder = @"输入验证码";
        _connect_code_T.layer.masksToBounds = YES;
        _connect_code_T.layer.cornerRadius = 4.0;
        _connect_code_T.keyboardType=UIKeyboardTypeNumberPad;
        _connect_code_T.textColor = UIColorFromRGB(singleTitle);
        _connect_code_T.font = [UIFont systemFontOfSize:14.0f];
        _connect_code_T.clearsOnBeginEditing = YES;
        _connect_code_T.tintColor = UIColorFromRGB(tintColors);
        //        _connect_code_T.layer.borderWidth = 1;
        [_connect_code_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        _connect_code_T.leftViewMode = UITextFieldViewModeAlways;
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 50, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(singleTitle);
        leftLable.text = @"验证码";
        _connect_code_T.leftView = leftLable;
        _connect_code_T.rightViewMode = UITextFieldViewModeAlways;
        //------输入验证码功能暂时不添加---之后可能添加
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(165, 0, 114, 39);
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(getVerfiryCode:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:UIColorFromRGB(0xe34a51)];
        _connect_code_T.rightView = button;
    }
    return _connect_code_T;
}

-(UITableView *)orderSubmitTableview
{
    if(!_orderSubmitTableview)
    {
        _orderSubmitTableview = [[UITableView alloc] initForAutoLayout];
        _orderSubmitTableview.delegate = self;
        _orderSubmitTableview.dataSource = self;
        _orderSubmitTableview.separatorInset = UIEdgeInsetsZero;
        [_orderSubmitTableview setScrollEnabled:NO];
        [UZCommonMethod hiddleExtendCellFromTableview:_orderSubmitTableview];
        if ([_orderSubmitTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_orderSubmitTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_orderSubmitTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_orderSubmitTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _orderSubmitTableview;
}

-(UIButton *)orderSeatButton
{
    if (!_orderSeatButton) {
        _orderSeatButton = [[UIButton alloc] initForAutoLayout];
        _orderSeatButton = [[UIButton alloc] initForAutoLayout];
        _orderSeatButton.layer.masksToBounds = YES;
        _orderSeatButton.layer.cornerRadius = 4.0f;
        [_orderSeatButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_orderSeatButton setTitle:@"提交订单" forState:UIControlStateHighlighted];
        [_orderSeatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderSeatButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_orderSeatButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        [_orderSeatButton addTarget:self action:@selector(submitAtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderSeatButton;
}

#pragma mark------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 2) {
        RemarkViewController *firVC = [[RemarkViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"备注信息" withFont:14.0f];
        if (submit_desc == nil || [submit_desc isEqualToString:@""] == YES ||[submit_desc isEqualToString:@"备注"] == YES) {
            
        }else {
            firVC.noteString = submit_desc;
        }
        //        [firVC.navigationItem setTitle:@"备注信息"];
        firVC.delegate = self;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if (section == 0){
        if (row == 0) {
            [self.view showRealTimeBlurWithBlurStyle:XHBlurStyleBlackTranslucent];
            choosePickerView *picker = [[choosePickerView alloc] initForAutoLayout];
            picker.delegate = self;
            [self.view addSubview:picker];
            [picker autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [picker autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50.0f];
            [picker autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [picker autoSetDimension:ALDimensionHeight toSize:240.0f];
            [picker initWithArray:timeArray CountArray:countArray dateArray:dateArray year:yearArray];
            
        }else{
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat height;
    switch (section) {
        case 0:
            height = 40.0;
            break;
        case 1:
            height = 40.0f;
            break;
        case 2:
            height = 40.0f;
            break;
        case 3:
            if (row == 0) {
                height = 40.0f;
            }else{
                //通过计算得到
                int line = 0;
                line = (int)(self.hintMessage.length / 21+1);
                
                int height_lable = line*15;
                if (height_lable>280) {
                    height = height_lable;
                }else{
                    height = 280;
                }
            }
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_seat_submit_cell";
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
        [cell.contentView addSubview:titleLable];
        titleLable.textColor = UIColorFromRGB(singleTitle);
        titleLable.font = [UIFont systemFontOfSize:14.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        if (row == 0) {
            titleLable.text = num_order;
        }else{
            titleLable.text = time_order;
        }
    }else if (section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            [cell.contentView addSubview:self.connect_name_T];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        }else if (row == 1){
            [cell.contentView addSubview:self.connect_phone_T];
            [_connect_phone_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_connect_phone_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_connect_phone_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_connect_phone_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        }else{
            //暂时废弃
            [cell.contentView addSubview:self.connect_code_T];
            [_connect_code_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_connect_code_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_connect_code_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_connect_code_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        }
    }else if (section == 2){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
        [cell.contentView addSubview:titleLable];
        titleLable.textColor = UIColorFromRGB(singleTitle);
        titleLable.font = [UIFont systemFontOfSize:14.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        titleLable.text = submit_desc;
    }else if (section == 3){
#pragma mark --- 2015.12.24 去掉温馨提示。
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"shop_icon"];
            [cell.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:22.0f];
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(singleTitle);
            tmpLable.text = @"温馨提示";
            [cell.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else{
            UILabel *hint_lable = [[UILabel alloc] initForAutoLayout];
            hint_lable.textColor = [UIColor lightGrayColor];
            hint_lable.font = [UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:hint_lable];
            [hint_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [hint_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [hint_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            hint_lable.text = self.hintMessage;
        }
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }else if (section == 2)
    {
        return 1;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#pragma mark --- 2015.12.24 去掉“温馨提示”
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 5.0f;
}

#pragma mark-------share action
-(void)submitAtion:(UIButton*)sender
{
    NSLog(@"立即预定");
    //[submit_conde isEqualToString:self.connect_code_T.text]  验证码
    NSString *url = connect_url(@"seat_insert");
    connect_name = self.connect_name_T.text;
    connect_tel = self.connect_phone_T.text;
    date_s = [NSString stringWithFormat:@"%@年%@",year_s,date_s];
    if (connect_tel == nil || [connect_tel isEqualToString:@""] == YES) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    if (connect_name.length>0 && myTime!=nil) {
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"u_id":[UserModel shareInstance].u_id,
                               @"session_key":[UserModel shareInstance].session_key,
                               @"shop_id":self.shop_id,
                               @"seat_num":count_s,
                               @"use_name":connect_name,
                               @"use_time":myTime,
                               @"seat_tel":connect_tel,
                               @"seat_note":submit_desc
                               };
        [SVProgressHUD showWithStatus:@"正在向商家提交" maskType:SVProgressHUDMaskTypeBlack];
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if([param[@"code"] integerValue]==200){
                [SVProgressHUD dismiss];
                NSString *url = [param[@"obj"] objectForKey:@"seat_url"];;
                NSString *seat_id = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"seat_id"]];
                orderSeatSuccessViewController *firVC = [[orderSeatSuccessViewController alloc] init];
                firVC.url = url;
                firVC.seat_id = seat_id;
                [firVC setHiddenTabbar:YES];
                [firVC setNavBarTitle:@"下单成功" withFont:14.0f];
                [self.navigationController pushViewController:firVC animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入预定信息"];
    }
}

#pragma mark-------获取验证码
-(void)getVerfiryCode :(UIButton*)sender
{
    NSLog(@"获取验证码");
    if ([self checkTel:self.connect_phone_T.text]==YES)
    {
        __block int timeout=59;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                    sender.userInteractionEnabled = YES;
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [sender setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                    sender.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        NSString* user_name=self.connect_phone_T.text;
        NSDictionary* dict=@{
                             @"user_name":user_name,
                             @"app_key":GET_SECURITY_CODE
                             };
        [Base64Tool postSomethingToServe:GET_SECURITY_CODE andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            NSDictionary* dic=(NSDictionary*)param;
            NSLog(@"get message:%@",[dic  objectForKey:@"message"]);
            submit_conde = [NSString stringWithFormat:@"%@",[dic objectForKey:@"obj"]];
            sender.userInteractionEnabled = NO;
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力,稍后重试"];
        }];
    }
}

#pragma mark----------检查用户输入手机号，尚未确定如何验证
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"信息输入不完整" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
        
    }
    //    //1[0-9]{10}
    //
    //    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    //    NSString *regex = @"[0-9]{11}";
    //    NSString *regex = @"^((13[0-9])|(147)|(17[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    BOOL isMatch = [pred evaluateWithObject:str];
    //    if (!isMatch)
    //    {
    //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //        return NO;
    //    }
    //    if([passWord.text isEqualToString:@""])
    //    {
    //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    //
    //        [alert show];
    //        return NO;
    //    }
    return YES;
}

-(void)finishActionDelegate:(NSString *)remarkStr
{
    if (remarkStr == nil || [remarkStr isEqualToString:@""] == YES) {
        submit_desc = @"备注";
    }else{
        submit_desc = remarkStr;
    }
    [self.orderSubmitTableview reloadData];
}

-(void)cancelActionDelegate
{
    [self.view disMissRealTimeBlur];
}

-(void)confirmDelegate:(NSString *)date time:(NSString *)time count:(NSString *)count year:(NSString *)year
{
    [self.view disMissRealTimeBlur];
    date_s = date;
    myTime = [[date_s componentsSeparatedByString:@" "] objectAtIndex:0];
    time_s = time;
    count_s = count;
    year_s = year;
    num_order = [NSString stringWithFormat:@"%@ %@ %@",date_s,time_s,count_s];
    myTime = [NSString stringWithFormat:@"%@年%@ %@",year_s,myTime,time];
    [self.orderSubmitTableview reloadData];
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
