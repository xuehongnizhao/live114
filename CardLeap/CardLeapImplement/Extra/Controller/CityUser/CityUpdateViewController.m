//
//  CityUpdateViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUpdateViewController.h"


#import "RDVTabBarController/RDVTabBarController.h"
#import "PictureCell.h"

#import "CityUpdateOneCateViewController.h"
#import "CityUpdateOneAddressViewController.h"

#import "CityUpdateDescViewController.h"
#import "CityUserController.h"

#import "MessageCell.h"
#import "CityAddLableMessage.h"

#import "CityAddMessage.h"
#import "UserModel.h"
#import "CityUserMessage.h"

#define PADDING             10
#define PICTURE_COUNT        9
#define ADD_PICTURE         [UIImage imageNamed:@"xong"]


@interface CityUpdateViewController ()
        <UITableViewDataSource,
            UITableViewDelegate,
            MessageCellDelegate,
            UIAlertViewDelegate>

// ---------------------- UI 控件 ----------------------
@property (weak, nonatomic)     UIScrollView    *scrollView;
/** 显示添加的图片 */
@property (weak, nonatomic)     UITableView     *pictureTableView;
/** 显示信息的tableView */
@property (weak, nonatomic)     UITableView     *messageTableView;
/** 添加按钮 */
@property (strong, nonatomic)   UIButton        *insertButton;
/** 自定义返回按钮*/
@property (strong, nonatomic)   UIButton        *returnButton;


// ---------------------- 数据展示 ----------------------
/** 存放图片数组 */
@property (strong, nonatomic)   NSArray         *pictures;
/** 初始化数据 */
@property (strong, nonatomic)   NSArray         *labelDesc;

@property (strong, nonatomic)   CityAddMessage  *message;



@end

@implementation CityUpdateViewController


/**
 *  页面 加载时 调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 图片初始化

    
    [self getCityUserMessage];
    
    
    // 初始化 UI控件
    [self initUI];

}

/**
 *  页面 即将 出现时 调用
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 隐藏 tabar
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    CGFloat scrollSizeH   = CGRectGetMaxY(self.messageTableView.frame);
    self.scrollView.contentSize = CGSizeMake(0, scrollSizeH);
    
    [self initData];
    [self.messageTableView reloadData];
    
}

/**
 *  页面 即将 消失 调用
 *  @param animated
 */
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 显示 tabar
    //    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

/**
 *  内存 不足时 调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark @@@@ ----> 初始化信息

/**
 *  初始化 UI控件
 */
- (void) initUI {
    
    // 导航栏
    [self settingNavigation];
    
    // scrollView
    [self scrollView];
    
    // 图片的 tableView
    [self pictureTableView];
    
    // 数据的 tableView
    [self messageTableView];
}



/**
 *   初始化图片数据
 */
- (void) initPicture {
//    self.pictures = [NSMutableArray arrayWithObjects: ADD_PICTURE, nil];
    
    NSLog(@"%@", self.pictures);
}

/**
 *  初始化数据
 */
- (void) initData {
    
    
    CityAddMessage *message = self.cityAddMessage;

//    message                 =
    // 标题
    CityAddLableMessage *c1 = [[CityAddLableMessage alloc] init];
    c1.name                 = @"标  题";
    c1.title                = message.cityTitle;
    
    // 区域
    NSString *address = @"";
    if (message.cityTwoCateAddressID != nil && message.cityTwoCateAddressName != nil) {
        address = [NSString stringWithFormat:@"%@ - %@", message.cityOneCateAddressName, message.cityTwoCateAddressName];
    } else {
        address = message.cityOneCateAddressName;
    }
    CityAddLableMessage *c2 = [[CityAddLableMessage alloc] init];
    c2.name                 = @"区  域";
    c2.cate                 = address != nil ? address : @"" ;
    c2.isDisplayLable       = YES;
    NSArray *arr1           = @[c1, c2];
    
    // 分类
    NSString  *cate = [NSString string];
    if (message.cityTwoCateId != nil && message.cityTwoCateName != nil) {
        cate = [NSString stringWithFormat:@"%@ - %@", message.cityOneCateName, message.cityTwoCateName];
    } else {
        cate = message.cityOneCateName;
    }
    CityAddLableMessage *c3 = [[CityAddLableMessage alloc] init];
    c3.name                 = @"分  类";
    c3.cate                 = cate;
    c3.isDisplayLable       = YES;
    
    // 描述
    CityAddLableMessage *c4 = [[CityAddLableMessage alloc] init];
    NSString *desc = message.cityDesc != nil ? message.cityDesc : @"10 - 200个字";
    c4.name                 = @"描  述";
    c4.cate                 = desc;
    c4.isDisplayLable       = YES;
    NSArray *arr2           = @[c3, c4];
    
    // 价格
    CityAddLableMessage *c5     = [[CityAddLableMessage alloc] init];
    c5.name                     = @"价  格";
    c5.title                    = message.cityPrice;
    c5.isDisplayLable           = NO;
    c5.isDisplayPriceImageView  = YES;
    c5.isDisplayPriceTextView   = YES;
    
    // 联系人
    CityAddLableMessage *c6 = [[CityAddLableMessage alloc] init];
    c6.name                 = @"联系人";
    c6.title                = message.cityContact;
    
    // 电话
    CityAddLableMessage *c7 = [[CityAddLableMessage alloc] init];
    c7.name                 = @"电  话";
    c7.title                = message.cityTel;
    NSArray *arr3           = @[c5, c6, c7];
    self.labelDesc          = @[arr1, arr2, arr3];
}


#pragma mark @@@@ ----> 添加控件

/**
 *  设置 导航栏
 */
- (void) settingNavigation {
    self.navigationItem.title = @"修改信息";
    
    
    UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithCustomView:self.returnButton];
    
    self.navigationItem.leftBarButtonItem = returnButton;
    // 添加发布按钮
    UIBarButtonItem *insertButton = [[UIBarButtonItem alloc] initWithCustomView:self.insertButton];
    self.navigationItem.rightBarButtonItem = insertButton;
}


/**
 *  发布 按钮的 样式
 *
 *  @return UIButton
 */
- (UIButton *) insertButton {
    if (_insertButton == nil) {
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, 40, 40);
        
        // 边距
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        // 图片
        [button setImage:[UIImage imageNamed:@"city_complete_no"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"city_complete_sel"] forState:UIControlStateHighlighted];
        
        // 点击事件
        [button addTarget:self action:@selector(updateCiytMessage) forControlEvents:UIControlEventTouchUpInside];
        
        _insertButton = button;
        
    }
    return _insertButton;
    
}


/**
 *  自定义      返回 按钮
 *
 *  @return     UIButton
 */
- (UIButton *)returnButton {
    
    if (_returnButton == nil) {
        
        UIButton *returnButton = [[UIButton alloc] init];
        returnButton.frame     = CGRectMake(0, 0, 40, 40);
        [returnButton setImageEdgeInsets:UIEdgeInsetsMake(-20, -20, 0, 20)];
        // 图片
        [returnButton setImage:[UIImage imageNamed:@"navbar_return_no"] forState:UIControlStateNormal];
        [returnButton setImage:[UIImage imageNamed:@"navbar_return_sel"] forState:UIControlStateHighlighted];
        
        [returnButton addTarget:self action:@selector(returnAndCancelEdit) forControlEvents:UIControlEventTouchUpInside];
        //        returnButton.backgroundColor = [UIColor blackColor];
        _returnButton = returnButton;
    }
    return _returnButton;
}

/**
 *  添加 scrollView 控件 允许 上下滑动
 *
 *  时间 2015-01-04 10:49:20
 *
 *  @return UIScrollView
 */
- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.view.frame;
        scrollView.backgroundColor = Color(243, 243, 243, 255);
        _scrollView = scrollView;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

/**
 *  添加 tableView
 *
 *  @return UITableView
 */
- (UITableView *)pictureTableView {
    
    if (_pictureTableView == nil) {
        
        UITableView *tableView = [[UITableView alloc] init];
        
        tableView.transform = CGAffineTransformMakeRotation(M_PI / -2);
        CGFloat picX = self.scrollView.frame.origin.x   + PADDING;
        CGFloat picY = self.scrollView.frame.origin.y   + PADDING;
        CGFloat picW = self.scrollView.frame.size.width - PADDING * 2;
        CGFloat picH = 100;
        tableView.frame      = CGRectMake(picX, picY, picW, picH);
        // 圆弧
        tableView.layer.cornerRadius  = 5 / 1;
        tableView.layer.masksToBounds = YES;
        
        // 代理 和 数据源
        tableView.dataSource = self;
        tableView.delegate   = self;
        tableView.rowHeight  = 100;
        // 去掉滚动显示
        tableView.showsVerticalScrollIndicator = NO;
        // 隐藏 cell 分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        tableView.scrollEnabled  = NO;
        _pictureTableView= tableView;
        [self.scrollView addSubview:_pictureTableView];
    }
    return _pictureTableView;
}


- (UITableView *)messageTableView {
    
    
    if (_messageTableView == nil) {
        
        CGFloat messX = self.pictureTableView.frame.origin.x;
        CGFloat messY = CGRectGetMaxY(self.pictureTableView.frame) + PADDING * 2;
        CGFloat messW = self.pictureTableView.frame.size.width;
        CGFloat messH = self.view.frame.size.height - self.pictureTableView.frame.size.height;
        CGRect  messFrame = CGRectMake(messX, messY, messW, messH);
        UITableView *messageTableView = [[UITableView alloc] initWithFrame:messFrame style:UITableViewStyleGrouped];
        messageTableView.dataSource      = self;
        messageTableView.delegate        = self;
        messageTableView.backgroundColor = Color(0, 0, 0, 0);
        messageTableView.scrollEnabled   = NO;
        messageTableView.rowHeight       = 50;
        //        messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        messageTableView.layer.cornerRadius  = 5 / 1;
        //        messageTableView.layer.masksToBounds = YES;
        _messageTableView                = messageTableView;
        
        [self.scrollView addSubview:_messageTableView];
    }
    return _messageTableView;
}



#pragma mark ----- 数据获取

/**
 *  网络获取数据
 */
- (void) getCityUserMessage {
    
    NSString     *url  = connect_url(@"my_city_ok");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"m_id"   :self.m_id,
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSDictionary *mess = param[@"obj"];
            CityUserMessage *userMessage = [CityUserMessage cityUserMessageWithDict:mess];
            self.cityAddMessage = [self cityMessageDataTreatment:userMessage];
            [self initData];
            
            self.pictures = userMessage.message_pic;
            
            [self.messageTableView reloadData];
            [self.pictureTableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力！"];
    }];
}


/**
 *  数据处理
 *
 *  @param  param
 *
 *  @return CityAddMessage
 */
- (CityAddMessage *) cityMessageDataTreatment:(CityUserMessage *)param {
    CityAddMessage *message = [[CityAddMessage alloc] init];
    
    NSLog(@"%@", param);
    message.cityTitle              = param.message_name;
    message.cityDesc               = param.m_desc;
    message.cityPrice              = param.price;
    message.cityTel                = param.tel;
    message.cityContact            = param.contact;
    
    
    if ([param.father_id isEqualToString:@""] && [param.father_name isEqualToString:@""]) {
        message.cityOneCateId          = param.c_id;
        message.cityOneCateName        = param.cate_name;
        message.cityTwoCateId          = nil;
        message.cityTwoCateName        = nil;
    } else {
        message.cityOneCateId          = param.father_id;
        message.cityOneCateName        = param.father_name;
        message.cityTwoCateId          = param.c_id;
        message.cityTwoCateName        = param.cate_name;
    }
    
    if ([param.father_a_id isEqualToString:@""] && [param.father_a_name isEqualToString:@""]) {
        
        message.cityOneCateAddressID   = param.area_id;
        message.cityOneCateAddressName = param.area_name;
        message.cityTwoCateAddressID   = nil;
        message.cityTwoCateAddressName = nil;
    } else {
        message.cityOneCateAddressID   = param.father_a_id;
        message.cityOneCateAddressName = param.father_a_name;
        message.cityTwoCateAddressID   = param.area_id;
        message.cityTwoCateAddressName = param.area_name;
    }
    return message;
    
}

#pragma mark @@@@ ----> tableView 数据源方法
/**
 *  返回 显示 分组的个数
 *
 *  @param tableView
 *  @return
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.pictureTableView) {
        return 1;
    }
    
    return self.labelDesc.count;
}


/**
 *  返回 显示多少个 图片
 *
 *  @param tableView
 *  @param section
 *  @return
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.pictureTableView) {
        return self.pictures.count;
    }
    
    NSArray *arr = self.labelDesc[section];
    return arr.count;
    
}


/**
 *  返回显示 每个cell 的样式
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    // 图片的 tableView
    if (tableView == self.pictureTableView) {
        PictureCell *cell = [PictureCell pictureCellWithTableView:tableView];
        
        // 取出数据 赋值
        cell.pictureUrlName = self.pictures[indexPath.row];

        // 判断是否是 添加按键 隐藏 删除 按钮
        cell.deletePicture.hidden = YES;
        return cell;
    }
    
    
    // 用户输入信息的 tableView
    if (tableView == self.messageTableView) {
        
        MessageCell *cell = [MessageCell messageAddCellWithTableView:tableView];
        NSArray *arr      = self.labelDesc[indexPath.section];
        cell.delegate     = self;
        cell.lableMessage = arr[indexPath.row];
        cell.indexPath    = indexPath;
        
        if (cell.indexPath.row == 2) {
            cell.messageTextFieldView.keyboardType = UIKeyboardTypeNumberPad;
        }
        return cell;
    }
    
    return nil;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.pictureTableView) {
        return 0;
    }
    return 1;
}

#pragma mark @@@@ ----> UITableView 代理方法

/**
 *  点击添加图片 添加数据
 *  @param      tableView
 *  @param      indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.messageTableView) {
        //  选择地区
        if (indexPath.section == 0) {
            
            if (indexPath.row == 1) {
                CityUpdateOneAddressViewController *updateOneAddress = [[CityUpdateOneAddressViewController alloc] init];
                updateOneAddress.cityAddress    = self.cityAddress;
                updateOneAddress.cityAddMessage = self.cityAddMessage;
                [self.navigationController pushViewController:updateOneAddress animated:YES];
            }
            
        }
        
        // 选择分类
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                
                CityUpdateOneCateViewController *updateOneCate = [[CityUpdateOneCateViewController alloc] init];
                
                updateOneCate.cityAddMessage = self.cityAddMessage;
                updateOneCate.cityAddress    = self.cityAddress;
                updateOneCate.cityCates      = self.cityCates;
                [self.navigationController pushViewController:updateOneCate animated:YES];
            }
            
            // 选择 描述
            if (indexPath.row == 1) {
                
                CityUpdateDescViewController *updateCityDesc = [[CityUpdateDescViewController alloc] init];
                updateCityDesc.cityAddMessage = self.cityAddMessage;
                updateCityDesc.cityAddress    = self.cityAddress;
                [self.navigationController pushViewController:updateCityDesc animated:YES];
            }
            
        }

    }
}


#pragma mark SkyTextFieldDelegate Methods
- (void)textFieldCell:(MessageCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)indexPath string:(NSString *)string {
    
    //NSLog(@"See input: %@ from section: %ld row: %ld, should update models appropriately", string, (long)indexPath.section, (long)indexPath.row);
    
    NSLog(@"see input string:%@",string);
    
    CityAddMessage *message = self.cityAddMessage;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            message.cityTitle = string;
        }
    }
    
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            message.cityPrice = string;
            
        } else if (indexPath.row == 1) {
            message.cityContact = string;
        } else {
            message.cityTel  = string;
        }
        
    }
    
    self.cityAddMessage = message;
}


#pragma mark ----- 点击返回按钮触发事件
/**
 *  返回 或者取消编辑
 */
- (void) returnAndCancelEdit {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否取消编辑？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}


#pragma mark ----- UIAlertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark @@@@ ----> 修改信息
/**
 *  发布信息
 */
- (void) updateCiytMessage {
    
    // 所有数据
    CityAddMessage *message     = [self dataProcessing];
    

    // 表单 验证
    if (![self checkDataMessage:message]) {
        return;
    }
    
    // 提交表单数据
    NSString *url      = connect_url(@"my_city_update");
    NSDictionary *dict = @{
                           @"app_key"       : url,
                           @"session_key"   : message.session_key,
                           @"message_name"  : message.cityTitle,
                           @"m_desc"        : message.cityDesc,
                           @"price"         : message.cityPrice,
                           @"contact"       : message.cityContact,
                           @"tel"           : message.cityTel,
                           @"u_id"          : message.u_id,
                           @"a_id"          : message.a_id,
                           @"c_id"          : message.c_id,
                           @"m_id"          : self.m_id,
                           };
    NSLog(@"%@", dict);
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] isEqualToString:@"200"]) {
        
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            CityUserController *cityUser = [[CityUserController alloc] init];
            [self.navigationController pushViewController:cityUser animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力！"];
    }];
}



/**
 *  数据处理方法
 *
 *  @return    CityAddMessage
 */
- (CityAddMessage *) dataProcessing {
    
    CityAddMessage *message = self.cityAddMessage;
    
 
    // 分类 ID 处理
    if (message.cityTwoCateId && message.cityTwoCateName) {
        message.c_id = message.cityTwoCateId;
    } else {
        message.c_id = message.cityOneCateId;
    }
    
    // 地区 ID 处理
    if (message.cityTwoCateAddressID && message.cityTwoCateAddressName) {
        message.a_id = message.cityTwoCateAddressID;
    } else {
        message.a_id = message.cityOneCateAddressID;
    }
    
    UserModel *user     = [UserModel shareInstance];
    message.u_id        = user.u_id;
    message.session_key = user.session_key;
    return message;
}

/**
 *  验证表单信息
 *
 *  @param      param
 *
 *  @return     BOOL
 */
- (BOOL) checkDataMessage:(CityAddMessage *)param  {
    

    
    param.cityTitle = [self trimString:param.cityTitle];
    if (param.cityTitle == nil || [param.cityTitle isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"标题不能为空!"];
        return NO;
    }
    
    param.cityOneCateId   = [self trimString:param.cityOneCateId];
    param.cityOneCateName = [self trimString:param.cityOneCateName];
    if (!(param.cityOneCateId && param.cityOneCateName)) {
        [SVProgressHUD showErrorWithStatus:@"分类不能为空！"];
        return NO;
    }
    
    param.cityOneCateAddressID   = [self trimString:param.cityOneCateAddressID];
    param.cityOneCateAddressName = [self trimString:param.cityOneCateAddressName];
    if (!(param.cityOneCateAddressID && param.cityOneCateAddressName)) {
        [SVProgressHUD showErrorWithStatus:@"区域不能为空"];
        return NO;
    }
    
    param.cityDesc = [self trimString:param.cityDesc];
    if (!param.cityDesc || [param.cityDesc isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"描述不能为空！"];
        return NO;
    }
    
    param.cityPrice = [self trimString:param.cityPrice];
    if (!param.cityPrice || [param.cityPrice isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"价格不能为空！"];
        return NO;
    }
    
    
    param.cityContact = [self trimString:param.cityContact];
    if (param.cityContact == nil || [param.cityContact isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"联系人不能为空！"];
        return NO;
    }
    
    param.cityTel = [self trimString:param.cityTel];
    if (param.cityTel == nil || [param.cityTel isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"电话不能为空！"];
        return NO;
    }
    
    return YES;
    
}

/**
 *  截取 字符串 前后空格
 *  @param      param
 *  @return     NSString
 */
- (NSString *) trimString:(NSString *)param {
    return [param stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}



@end
