//
//  CityAddController.m
//  CardLeap
//
//  Created by songweiping on 14/12/28.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityAddController.h"

#import "RDVTabBarController/RDVTabBarController.h"
#import "DoImagePickerController.h"
#import "PictureCell.h"

#import "OneCateController.h"
#import "OneAddressCateController.h"
#import "CityAddDescController.h"
#import "CityUserController.h"

#import "PhotoView.h"
#import "PhotoBrowserViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


#import "MessageCell.h"
#import "CityAddLableMessage.h"

#import "CityAddMessage.h"
#import "UserModel.h"

#define PADDING             10
#define PICTURE_COUNT        9
#define ADD_PICTURE         [UIImage imageNamed:@"xong"]


@interface CityAddController ()
    <UITableViewDataSource,
     UITableViewDelegate,
     PhotoBrowserViewControllerDelegate,
     MessageCellDelegate,
     UINavigationControllerDelegate,
     UIImagePickerControllerDelegate,
     UIActionSheetDelegate,
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
@property (strong, nonatomic)   NSMutableArray  *pictures;
/** 初始化数据 */
@property (strong, nonatomic)   NSArray         *labelDesc;

@end

@implementation CityAddController
{
    //相机 
    DoImagePickerController* cont;
    NSMutableDictionary* selectedImageDict;
    BOOL isFromCamera;
    PhotoView* photoView;
    NSInteger cameraNumber;
//    SelectBar* selectBar;
//    PhotoView* photoView;
}

#pragma mark @@@@ ----> 生命周期

/**
 *  页面 加载时 调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    // 图片初始化
    [self initPicture];
    
    // 初始化数据
    [self initData];
    
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
    selectedImageDict   = [[NSMutableDictionary alloc] init];
    self.pictures       = [NSMutableArray arrayWithObjects: ADD_PICTURE, nil];
}

/**
 *  初始化数据
 */
- (void) initData {
    
    CityAddMessage *message = self.cityAddMessage;
    
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
    self.navigationItem.title = @"发布信息";
    
    
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
        [button addTarget:self action:@selector(insertCiytMessage) forControlEvents:UIControlEventTouchUpInside];
        
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
        cell.pictureName = self.pictures[indexPath.row];

        // 绑定按钮的唯一属性
        cell.deletePicture.tag = indexPath.row;

        // 绑定点击事件
        [cell.deletePicture addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];

        // 判断是否是 添加按键 隐藏 删除 按钮
        if ([self.pictures[indexPath.row] isEqual:ADD_PICTURE]) {
            cell.deletePicture.hidden = YES;
        }
        return cell;
    }
    
    
    // 用户输入信息的 tableView
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
    
    

    if (tableView == self.pictureTableView) {
        // 判断数组的长度
        if (self.pictures.count > PICTURE_COUNT) {
            // 移除添加图片
            [self.pictures removeLastObject];
        }

        if (indexPath.row == self.pictures.count - 1) {
        //        [self.pictures insertObject:[UIImage imageNamed:@"password"] atIndex:self.pictures.count -1];
//            [ self localPicture];
            
            UIActionSheet* mySheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate : self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"相机",@"相册", nil];
            
            mySheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [mySheet showInView:self.view];
            
        } else {
            [self showBrowserWithIndex:indexPath.row];
        }
        
        
        [self.pictureTableView reloadData];
    } else {
        
        
        //  选择地区
        if (indexPath.section == 0) {
            
            if (indexPath.row == 1) {
                OneAddressCateController *oneAddressCate = [[OneAddressCateController alloc] init];
                oneAddressCate.cityAddress    = self.cityAddress;
                oneAddressCate.cityAddMessage = self.cityAddMessage;
                [self.navigationController pushViewController:oneAddressCate animated:YES];
            }
            
        }
        
        // 选择分类
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                OneCateController *oneCate = [[OneCateController alloc] init];
                oneCate.cityAddMessage = self.cityAddMessage;
                oneCate.cityAddress    = self.cityAddress;
                [self.navigationController pushViewController:oneCate animated:YES];
            }
            
            // 选择 描述
            if (indexPath.row == 1) {
                CityAddDescController *cityDesc = [[CityAddDescController alloc] init];
                cityDesc.cityAddMessage = self.cityAddMessage;
                cityDesc.cityAddress    = self.cityAddress;
                [self.navigationController pushViewController:cityDesc animated:YES];
            }
            
        }
    }
}



- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 相机
    if (buttonIndex == 0) {
        [self takePicture];
    }
    
    // 相册
    if (buttonIndex == 1) {
        [self localPicture];
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





/**
 *  删除数据
 *
 *  @param button
 */
- (void) deletePicture:(UIButton *)button {
    
    //删除数组 中的元素
    [self.pictures removeObjectAtIndex:button.tag];
    
    NSLog(@"selectedImageDict --> %@", selectedImageDict);
    // 判断数组的长度 和 图片的名称 是否是 添加图片
    UIImage *addPicture = [self.pictures objectAtIndex:self.pictures.count -1];

    if (self.pictures.count < PICTURE_COUNT && ![addPicture isEqual:ADD_PICTURE]) {
        
        // 添加添加按钮
        [self.pictures addObject:ADD_PICTURE];
    }
    
    // 刷新数据
    [self.pictureTableView reloadData];

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

#pragma mark @@@@ ----> 发布信息
/**
 *  发布信息
 */
- (void) insertCiytMessage {
    
    // 所有数据
    CityAddMessage *message     = [self dataProcessing];
    
    // 图片数组
    NSArray        *picture     = [self pictureProcessing:self.pictures];
    // 图片数组名称
    NSArray        *pictureName = [self pictureNameProcessing:picture];
    // 表单 验证
    if (![self checkDataMessage:message checkPicture:picture]) {
        return;
    }
    
    // 提交表单数据
    NSString *url = connect_url(@"city_message_insert");
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
                           @"c_id"          : message.c_id
                           };
    [Base64Tool postFileTo:url andParams:dict andFiles:picture andFileNames:pictureName isBase64:YES CompletionBlock:^(id param) {
        
        NSLog(@"%@", param);
        
        if ([param[@"code"] isEqualToString:@"200"]) {
            
            //跳转我的发布
            CityUserController *userAdd = [[CityUserController alloc] init];
            userAdd.identifier = @"1";
            [self.navigationController pushViewController:userAdd animated:YES];
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
- (BOOL) checkDataMessage:(CityAddMessage *)param checkPicture:(NSArray *)picture {
    
    
//    if (picture.count == 0) {
//        
//        [SVProgressHUD showErrorWithStatus:@"图片不能为空！"];
//        return NO;
//    }
    
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
    
    param.cityOneCateAddressID = [self trimString:param.cityOneCateAddressID];
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
    
    NSString *regex = @"^(1)\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:param.cityTel];
    if (!isMatch)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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

/**
 *  图片数据的处理
 *
 *  @return     NSMutableArray
 */
- (NSMutableArray *) pictureProcessing:(NSArray *)param {
    
    NSMutableArray *picture   = [[NSMutableArray alloc] init];
    if (param.count != 0) {
        for (UIImage *image in param) {
            if ([image isEqual:[param lastObject]]) {
                break;
            }
            NSData* data = UIImageJPEGRepresentation(image, 0.3);
            [picture addObject:data];
        }
    }
    return  picture;
}


/**
 *  图片数组 名称 处理
 *
 *  @param  param
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *) pictureNameProcessing:(NSArray *)param {

    NSMutableArray *array =  [[NSMutableArray alloc] init];
    if (param.count != 0) {
        for (int i=0; i<param.count; i++) {
            NSString *type = [NSString stringWithFormat:@"message_pic[%i]", i];
            
            [array addObject:type];
        }
    }
    return array;
    
}



#pragma mark--------照相
-(void)takePicture
{
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        NSLog(@"选择完毕");
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        //拍照结束保存到本地
        UIImageWriteToSavedPhotosAlbum(portraitImg,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        
        //所选择的照片平移一张
        //        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        //        for (NSNumber* number in [selectedImageDict allKeys])
        //        {
        //            NSNumber *value = [selectedImageDict objectForKey:number];
        //            NSNumber *tmpKey = [NSNumber numberWithInt:[number intValue]+1];
        //            [tmpDic setObject:value forKey:tmpKey];
        //            //NSLog(@"object:%@",[selectedImageDict objectForKey:number]);
        //        }
        //        selectedImageDict = tmpDic;
        //每照一张相则从照片库里选择的就少一张
        //        cont.nMaxCount--;
        //        photoView.isFromCamera=YES;
        //        [photoView addNewsImageArray:@[portraitImg]];
        //        [self addButtonBadge];
        //[photoView setHidden:NO];
        //photoView.isShow=YES;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        NSLog(@"停止选择");
    }];
}
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    //Handle the end of the image write process
    if(!error)
    {
        NSLog(@"顺位之前的dic:%@",selectedImageDict);
        NSMutableDictionary* newDict=[[NSMutableDictionary alloc]init];
        for (NSNumber* key in [selectedImageDict allKeys])
        {
            //key+1
            NSInteger newkey=[key integerValue]+1;
            //之前key的value
            NSNumber* value=selectedImageDict[key];
            
            [newDict setObject:value forKey:@(newkey)];
        }
        NSLog(@"顺位之后的dic:%@",newDict);
        //清楚字典 重新加入
        [selectedImageDict removeAllObjects];
        [selectedImageDict setValuesForKeysWithDictionary:newDict];
        NSLog(@"Image written to photo album");
        //设置已拍摄照片为选中状态
        selectedImageDict[@(0)] = @(selectedImageDict.count);
        isFromCamera=YES;
        [self localPicture];
        cameraNumber++;
        NSLog(@"已选择的图片字典:%@",selectedImageDict);
    }
    else
    {
        NSLog(@"Error writing to photo album:%@",[error localizedDescription]);
    }
}




#pragma mark--------本地相册
-(void)localPicture
{
    NSInteger count = 3;
    if (LinPercent>1) {
        count = 4;
    }
    cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate       = self;
    cont.nResultType    = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount      = 9;
    cont.nColumnCount   = count;
    //修改_dSelected字典以确保再次进入时显示已点击图片
    cont.dSelected=selectedImageDict;
    cont.title=@"相机胶卷";
    [self presentViewController:cont animated:YES completion:^{
        if (isFromCamera==YES)
        {
            [cont readAlbumList];
            //[cont.cvPhotoList reloadData];
            isFromCamera=NO;
        }
    }];
    //[self.navigationController pushViewController:cont animated:YES];
}

#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 进入相册详情
-(void)showBrowserWithIndex:(NSInteger)index
{
    NSLog(@"showPhotoIndex:%ld",(long)index);
    PhotoBrowserViewController*  pbvc = [[PhotoBrowserViewController alloc]init];
    pbvc.delegate   = self;
    pbvc.photoArray = self.pictures;            // 图片数组
    pbvc.photoIndex = index;                    // 每张图片的索引
    pbvc.imageDict  = [selectedImageDict copy]; // 图片字典的位置
    //NSLog(@"imageDict:%@",pbvc.imageDict);
    pbvc.isAddImage = photoView.isAddImage;
    pbvc.title      = @"相册";
    [self presentViewController:pbvc animated:YES completion:nil];
}


#pragma mark @@@@ ----> 相机代理方法
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"didSelected:%@",picker.dSelected);
    selectedImageDict = picker.dSelected;
    NSLog(@"aselected:%@",aSelected);
    NSLog(@"selectedImageDict ===> %@", selectedImageDict);
    
    
    self.pictures = [self picturesArrayData:aSelected];
    [self.pictureTableView reloadData];
}


/**
 *  图片数据的处理
 *
 *  @param aSelected
 *
 *  @return
 */
- (NSMutableArray *) picturesArrayData:(NSArray *)aSelected {
    
    NSArray        *pictureArray   = aSelected;
    NSMutableArray *picture        = [NSMutableArray array];
    for (UIImage *image in pictureArray) {
        [picture addObject:image];
    }
    
    if (picture.count < PICTURE_COUNT) {
        [picture insertObject:ADD_PICTURE atIndex:picture.count];
    }
    
    return picture;
}


#pragma mark-------photoBrowserViewControllerDelegate
-(void)deletePhotoAtIndex:(NSInteger)photoIndex andPhotoTag:(NSInteger)photoTag
{
    NSLog(@"index:%ld",(long)photoIndex);
    NSLog(@"dict:%@",selectedImageDict);
    [selectedImageDict removeObjectForKey:@(photoTag)];
    
    for (NSNumber* number in [selectedImageDict allKeys])
    {
        //NSLog(@"object:%@",[selectedImageDict objectForKey:number]);
        if ([@(photoTag) isEqualToNumber:[selectedImageDict objectForKey:number]])
        {
            NSLog(@"已找到匹配照片");
            [selectedImageDict removeObjectForKey:number];
            NSLog(@"seledict:%@",selectedImageDict);
        }
    }
    
    // 删除 显示数组 的图片
    NSMutableArray *typeAarry = self.pictures;
    [typeAarry removeObjectAtIndex:photoIndex];
    
    // 判断数组的长度 和 图片的名称 是否是 添加图片
    UIImage *addPicture = [typeAarry objectAtIndex:typeAarry.count -1];
    
    if (typeAarry.count < PICTURE_COUNT && ![addPicture isEqual:ADD_PICTURE]) {
        
        // 添加添加按钮
        [typeAarry addObject:ADD_PICTURE];
    }
    
    self.pictures = typeAarry;
    
    // 刷新数据
    [self.pictureTableView reloadData];
}


#pragma mark------------camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

@end
