//
//  orderRoomSubmitViewController.m
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  订酒店 - 查看房间详情

#import "orderRoomSubmitViewController.h"
#import "CalendarHomeViewController.h"
#import "orderRoomWaitViewController.h"
#import "LoginViewController.h"

@interface orderRoomSubmitViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    CalendarHomeViewController *chvc;
    int count;
    NSString *beginDate;
    NSString *endDate;
    CGFloat webHeight;
    BOOL is_finish;
}
@property (strong,nonatomic)UITextField *connect_name_T;
@property (strong,nonatomic)UITextField *connect_tel_T;
@property (strong,nonatomic)UIButton *submitButton;
@property (strong,nonatomic)UITableView *orderRoomSubmitTableview;
@property (strong,nonatomic)UIButton *addButton;
@property (strong,nonatomic)UIButton *subButton;
@property (nonatomic ,strong) UIWebView *messageWebView;
@end

@implementation orderRoomSubmitViewController
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
#pragma mark--------initdata
-(void)initData
{
    beginDate = @"";
    endDate = @"";
    count = 1;
    is_finish = NO;
    NSURL *url            = [NSURL URLWithString:self.info.message_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.messageWebView loadRequest:request];
}

#pragma mark--------set UI
-(void)setUI
{
    [self.view addSubview:self.submitButton];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_submitButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [self.view addSubview:self.orderRoomSubmitTableview];
    [_orderRoomSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_orderRoomSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_orderRoomSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_orderRoomSubmitTableview autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_submitButton withOffset:-10.0f];
}

#pragma mark--------get UI
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

-(UITableView *)orderRoomSubmitTableview
{
    if (!_orderRoomSubmitTableview) {
        _orderRoomSubmitTableview = [[UITableView alloc] initForAutoLayout];
        _orderRoomSubmitTableview.delegate = self;
        _orderRoomSubmitTableview.dataSource = self;
        _orderRoomSubmitTableview.scrollEnabled = NO;
        [UZCommonMethod hiddleExtendCellFromTableview:_orderRoomSubmitTableview];
        if ([_orderRoomSubmitTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_orderRoomSubmitTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_orderRoomSubmitTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_orderRoomSubmitTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _orderRoomSubmitTableview;
}

-(UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initForAutoLayout];
        _submitButton = [[UIButton alloc] initForAutoLayout];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 4.0f;
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitButton setTitle:@"提交订单" forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_submitButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

-(UITextField *)connect_name_T
{
    if (!_connect_name_T) {
        _connect_name_T = [[UITextField alloc] initForAutoLayout];
        _connect_name_T.placeholder = @"请输入真实姓名";
        //_connect_name_T.keyboardType=UIKeyboardTypeNumberPad;
        _connect_name_T.leftViewMode = UITextFieldViewModeAlways;
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

-(UITextField *)connect_tel_T
{
    if (!_connect_tel_T) {
        _connect_tel_T = [[UITextField alloc] initForAutoLayout];
        _connect_tel_T.placeholder = @"输入有效的手机号码";
        _connect_tel_T.keyboardType=UIKeyboardTypeNumberPad;
        _connect_tel_T.leftViewMode = UITextFieldViewModeAlways;
        _connect_tel_T.textColor = UIColorFromRGB(singleTitle);
        _connect_tel_T.font = [UIFont systemFontOfSize:14.0f];
        _connect_tel_T.clearsOnBeginEditing = YES;
        _connect_tel_T.tintColor = UIColorFromRGB(tintColors);
        [_connect_tel_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 50, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(singleTitle);
        leftLable.text = @"手  机";
        _connect_tel_T.leftView = leftLable;
        if (userDefault(@"USERNAME")!=nil) {
            _connect_tel_T.text=userDefault(@"USERNAME");
        }
    }
    return _connect_tel_T;
}

#pragma mark - web加载完毕，计算web高度
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    webHeight = [self CalculateWebViewHeight:webView];
    is_finish = YES;
    [self.orderRoomSubmitTableview reloadData];
    self.orderRoomSubmitTableview.scrollEnabled = YES;
}

#pragma mark--------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    NSInteger section = indexPath.section;
    //NSInteger row = indexPath.row;
    if(section == 1)
    {
        if (!chvc) {
            chvc = [[CalendarHomeViewController alloc]init];
            chvc.calendartitle = @"日期";
            //[chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
            [chvc setHotelToDay:365 ToDateforString:@"11"];
        }
        
#pragma  mark --- 2016.4 添加weakself
        __weak typeof(self) weakself = self;
        chvc.calendarblock = ^(NSString *model){
            NSLog(@"\n---------------------------");
            NSLog(@"日期区间是%@",model);
            //[btn setTitle:model forState:UIControlStateNormal];
            NSArray *arr = [model componentsSeparatedByString:@":"];
            beginDate = [arr objectAtIndex:0];
            endDate = [arr objectAtIndex:1];
            [weakself.orderRoomSubmitTableview reloadData];
        };
        [self.navigationController pushViewController:chvc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat height;
    switch (section) {
        case 0:
            height = 80.0;
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
#pragma mark --- 这里改为计算web页高度
                if (is_finish == NO) {
                    height = 280.0f;
                }else {
                    height = webHeight;
                }
            }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat ) CalculateWebViewHeight:(UIWebView *) webView
{
    CGRect frame = webView.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = 1;
    webView.scrollView.scrollEnabled = NO;
    webView.frame = frame;
    
    frame.size.height = webView.scrollView.contentSize.height;
    
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    webView.frame = frame;
    return webView.frame.size.height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_room_submit_cell";
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
        [cell.contentView addSubview:titleLable];
        titleLable.textColor = UIColorFromRGB(indexTitle);
        titleLable.font = [UIFont systemFontOfSize:15.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        [titleLable autoSetDimension:ALDimensionHeight toSize:25.0f];
        titleLable.text = self.info.shop_name;
        
        UILabel *cate_lable = [[UILabel alloc] initForAutoLayout];
        cate_lable.font = [UIFont systemFontOfSize:13.0f];
        cate_lable.textColor = UIColorFromRGB(addressTitle);
        [cell.contentView addSubview:cate_lable];
        [cate_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [cate_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLable withOffset:3.0f];
        [cate_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [cate_lable autoSetDimension:ALDimensionHeight toSize:20.0f];
        cate_lable.text = self.goods_info.goods_cate;
        
        UILabel *price_lable = [[UILabel alloc] initForAutoLayout];
        [cell.contentView addSubview:price_lable];
        price_lable.font = [UIFont systemFontOfSize:15.0f];
        price_lable.textColor = UIColorFromRGB(0xdf5d5d);
        price_lable.textAlignment = NSTextAlignmentRight;
        [price_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [price_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [price_lable autoSetDimension:ALDimensionHeight toSize:18.0f];
        [price_lable autoSetDimension:ALDimensionWidth toSize:55.0f];
        price_lable.text = [NSString stringWithFormat:@"￥%@",self.goods_info.goods_price];
        
        UILabel *desc_lable = [[UILabel alloc] initForAutoLayout];
        //desc_lable.layer.borderWidth = 1;
        [cell.contentView addSubview:desc_lable];
        desc_lable.font = [UIFont systemFontOfSize:13.0f];
        desc_lable.textColor = UIColorFromRGB(reviewTitle);
        [desc_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cate_lable withOffset:3.0f];
        [desc_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:price_lable withOffset:-5.0f];
        [desc_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [desc_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
        desc_lable.text = self.goods_info.goods_desc;
    }else if (section == 1){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
        [cell.contentView addSubview:titleLable];
        titleLable.textColor = UIColorFromRGB(singleTitle);
        titleLable.font = [UIFont systemFontOfSize:14.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        if ([beginDate isEqualToString:@""]) {
            titleLable.text = @"请选择住房日期";
        }else{
            titleLable.text = [NSString stringWithFormat:@"住房日期 %@至%@",beginDate,endDate];
        }
    }else if (section == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 1) {
            [cell.contentView addSubview:self.connect_name_T];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_connect_name_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        }else if (row == 2){
            [cell.contentView addSubview:self.connect_tel_T];
            [_connect_tel_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_connect_tel_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_connect_tel_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_connect_tel_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        }else{
            UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
            [cell.contentView addSubview:titleLable];
            titleLable.textColor = UIColorFromRGB(singleTitle);
            titleLable.font = [UIFont systemFontOfSize:14.0f];
            titleLable.text = @"房间数";
            [titleLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [titleLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [titleLable autoSetDimension:ALDimensionWidth toSize:60.0f];
            
            [cell.contentView addSubview:self.subButton];
            [_subButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_subButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_subButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:titleLable withOffset:5.0f];
            [_subButton autoSetDimension:ALDimensionWidth toSize:30.0f];
            
            UILabel *count_lable = [[UILabel alloc] initForAutoLayout];
            count_lable.font = [UIFont systemFontOfSize:13.0f];
            count_lable.textColor = [UIColor lightGrayColor];
            count_lable.layer.borderColor = [UIColor lightGrayColor].CGColor;
            count_lable.layer.borderWidth = 0.5;
            count_lable.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:count_lable];
            count_lable.text = [NSString stringWithFormat:@"%d",count];
            [count_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_subButton withOffset:5.0f];
            [count_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [count_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [count_lable autoSetDimension:ALDimensionWidth toSize:30.0f];
            
            [cell.contentView addSubview:self.addButton];
            [_addButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_addButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_addButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:count_lable withOffset:5.0f];
            [_addButton autoSetDimension:ALDimensionWidth toSize:30.0f];
        }
        
    }else if (section == 3){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"shop_icon"];
            [cell.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:20.0f];
            
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(singleTitle);
            tmpLable.text = @"房间信息";
            [cell.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else{
            //            UILabel *hint_lable = [[UILabel alloc] initForAutoLayout];
            //            //hint_lable.layer.borderWidth = 1;
            //            hint_lable.numberOfLines = 0;
            //            hint_lable.textColor = UIColorFromRGB(singleTitle);
            //            hint_lable.font = [UIFont systemFontOfSize:14.0f];
            //            [cell.contentView addSubview:hint_lable];
            //            [hint_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            //            [hint_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            //            [hint_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            //            hint_lable.text = self.info.shop_desc;
#pragma mark --- 11.28 这里改为web页
            [cell.contentView addSubview:self.messageWebView];
            [_messageWebView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [_messageWebView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [_messageWebView autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [_messageWebView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        }
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }else if (section == 2)
    {
        return 3;
    }else if(section == 0){
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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

#pragma mark--------submit action
-(void)submitAction:(UIButton*)sender
{
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        //        [firVC.navigationItem setTitle:@"登录"];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        NSLog(@"提交订单  检测数值");
        if (![beginDate isEqualToString:@""]) {
            if (self.connect_name_T.text.length == 0 || self.connect_tel_T.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请填写个人资料"];
            }else{
                if ([self checkValue]) {
                    NSString *url = connect_url(@"hotel_insert");
                    NSDictionary *dict = @{
                                           @"app_key":url,
                                           @"session_key":[UserModel shareInstance].session_key,
                                           @"u_id":[UserModel shareInstance].u_id,
                                           @"shop_id":self.goods_info.shop_id,
                                           @"goods_id":self.goods_info.goods_id,
                                           @"hotel_num":[NSString stringWithFormat:@"%d",count],
                                           @"use_name":self.connect_name_T.text,
                                           @"begin_time":beginDate,
                                           @"end_time":endDate,
                                           @"hotel_tel":self.connect_tel_T.text,
                                           @"order_price":self.goods_info.goods_price
                                           };
                    [SVProgressHUD showWithStatus:@"正在提交订单" maskType:SVProgressHUDMaskTypeBlack];
                    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                        if ([param[@"code"] integerValue]==200) {
                            [SVProgressHUD dismiss];
                            NSString *hotel_id = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"hotel_id"]];
                            NSString *url = [param[@"obj"] objectForKey:@"hotel_message"];
                            orderRoomWaitViewController *firVC = [[orderRoomWaitViewController alloc] init];
                            [firVC setHiddenTabbar:YES];
                            [firVC setNavBarTitle:@"下单成功" withFont:14.0f];
                            //                            [firVC.navigationItem setTitle:@"下单成功"];
                            firVC.url=url;
                            firVC.seat_id = hotel_id;
                            [self.navigationController pushViewController:firVC animated:YES];
                        }else{
                            [SVProgressHUD showErrorWithStatus:param[@"message"]];
                        }
                    } andErrorBlock:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"网络异常"];
                    }];
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请填写预定日期"];
        }
    }
}

-(void)subAction:(UIButton*)sender
{
    NSLog(@"减一个");
    if (count>1) {
        count--;
        [self.orderRoomSubmitTableview reloadData];
    }
}

-(void)addAction:(UIButton*)sender
{
    NSLog(@"加一个");
    count++;
    [self.orderRoomSubmitTableview reloadData];
}


-(BOOL)checkValue
{
    NSString *phone = _connect_tel_T.text;
    if (phone.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    //匹配手机号
    NSString *regex = @"^(1)\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phone];
    if (!isMatch) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (UIWebView *) messageWebView
{
    if (!_messageWebView) {
        _messageWebView = [[UIWebView alloc] initForAutoLayout];
        _messageWebView.scrollView.scrollEnabled = NO;
        _messageWebView.delegate = self;
    }
    return _messageWebView;
}

#pragma mark--------other delegate

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
