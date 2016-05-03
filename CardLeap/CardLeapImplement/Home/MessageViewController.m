//
//  MessageViewController.m
//  CardLeap
//
//  Created by lin on 12/19/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "MessageViewController.h"

#import "UIScrollView+MJRefresh.h"

#import "LoginViewController.h"
#import "MessageInfoViewController.h"
#import "PublicAndPrivateMessageTableViewCell.h"

#import "PublicAndPrivateMessageFrame.h"
#import "PublicAndPrivateMessage.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size]

/**
 由于UI显示效果 部分控件被废弃 但是不排除以后会修改 所以暂时未删除
 */
@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIButton *allButton;//公信按钮
    UIButton *classButton;//私信按钮
}
// ---------------------- UI 控件 除tableview之外 其余被废弃----------------------
/** 背景View实现圆角效果 */
@property (weak, nonatomic)     UIView      *titleView;
/** 私信按钮 */
@property (weak, nonatomic)     UIButton    *privateButton;
/** 公信按钮 */
@property (weak, nonatomic)     UIButton    *publicButton;
/** 选中按钮 */
@property (weak, nonatomic)     UIButton    *selectedButton;
/** 显示数据的tableView */
@property (weak, nonatomic)     UITableView *messageTableView;

// ---------------------- 数据模型 ----------------------
/** 公信存放数组 */
@property (strong, nonatomic)   NSMutableArray *messageArray;
/** 是否获取私信 */
@property (assign, nonatomic)   BOOL           isGetPrivate;
/** 分页数 */
@property (assign, nonatomic)   NSInteger      page;
/** 判断是否是公信数据改变 */
@property (assign, nonatomic)   BOOL           isPublicChange;

@end

@implementation MessageViewController


#pragma mark ----- 生命周期方法

/**
 *  页面加载完毕之后调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self initData];
}

/**
 *  内存不足时调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  页面将要出现时调用
 *
 *  @param animated
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    // 获取私信
//    if (ApplicationDelegate.islogin == NO) {
//        if (self.isGetPrivate) {
//            [self selectButton:self.privateButton];
//        } else {
//            [self selectButton:self.publicButton];
//        }
//    }else{
//        if (self.isGetPrivate == NO) {
//            [self selectButton:self.privateButton];
//        } else {
//            [self selectButton:self.publicButton];
//        }
//    }
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];

//    [self.messageArray removeAllObjects];
}

#pragma mark ----- 初始化控件

/**
 *  初始化 控件
 */
- (void) initUI {
    
    [self settingNav];
    
    [self messageTableView];
    
    [self setButton];
}

/**
 设置titleview 按钮
 */
-(void)setButton
{
    //全部按钮
    allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 74, 30)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:allButton.frame ];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [allButton addSubview:imageView];
    [allButton setTitle:@"公信" forState:UIControlStateNormal];
    [allButton setTitleColor:UIColorFromRGB(0xe84848) forState:UIControlStateNormal];
    allButton.titleLabel.text = @"公信";
    allButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [allButton addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
    //我的班级
    classButton = [[UIButton alloc] initWithFrame:CGRectMake(76, 0, 73, 30)];
    UIImageView *ClassImageView = [[UIImageView alloc] initWithFrame:allButton.frame ];
    [ClassImageView setBackgroundColor:UIColorFromRGB(0xe84848)];
    [classButton addSubview:ClassImageView];
    [classButton setTitle:@"私信" forState:UIControlStateNormal];
    classButton.titleLabel.text = @"私信";
    classButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [classButton addTarget:self action:@selector(classAction:) forControlEvents:UIControlEventTouchUpInside];
    //titleView
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    //加按钮
    [view  addSubview:classButton];
    [view  addSubview:allButton];
    view.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = view;
}

/**
 导航条button的点击方式
 */
-(void)allAction:(UIButton*)sender
{
    for (id obj in allButton.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView* iv=(UIImageView*)obj;
            [iv setBackgroundColor:[UIColor whiteColor]];
        }
    }
    for (id obj in classButton.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView* iv=(UIImageView*)obj;
            [iv setBackgroundColor:UIColorFromRGB(0xe84848)];
        }
    }
    [classButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [allButton setTitleColor:UIColorFromRGB(0xe84848) forState:UIControlStateNormal];
    self.page         = 1;
    self.isGetPrivate = NO;
    [self getPublicData];
}

-(void)classAction:(UIButton*)sender
{
    if (ApplicationDelegate.islogin == YES) {
        for (id obj in allButton.subviews) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView* iv=(UIImageView*)obj;
                [iv setBackgroundColor:UIColorFromRGB(0xe84848)];
            }
        }
        for (id obj in classButton.subviews) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView* iv=(UIImageView*)obj;
                [iv setBackgroundColor:[UIColor whiteColor]];
            }
        }
        [classButton setTitleColor: UIColorFromRGB(0xe84848) forState:UIControlStateNormal];
        [allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.page         = 1;
        self.isGetPrivate = YES;
        [self getPrivateData];
    }else{
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

/**
 *  设置 导航栏
 */
- (void) settingNav {
    [self setHiddenTabbar:YES];
}

/**
 *  显示数据的tableView
 *
 *  @return UITableView
 */
- (UITableView *)messageTableView {
    
    if (_messageTableView == nil) {
        UITableView *messageTableView = [[UITableView alloc] init];
        CGFloat messX = self.view.frame.origin.x;
        CGFloat messY = self.view.frame.origin.y;
        CGFloat messW = self.view.frame.size.width;
        CGFloat messH = self.view.frame.size.height - 64;
        messageTableView.frame      = CGRectMake(messX, messY, messW, messH);
        messageTableView.dataSource = self;
        messageTableView.delegate   = self;
        messageTableView.rowHeight  = 60;
        
        
        [messageTableView addHeaderWithTarget:self action:@selector(upLoad)];
        [messageTableView addFooterWithTarget:self action:@selector(downRefresh)];
        messageTableView.headerRefreshingText = @"正在刷新数据...";
        messageTableView.footerRefreshingText = @"正在加载数据...";
        
        if ([messageTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [messageTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([messageTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [messageTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        [UZCommonMethod hiddleExtendCellFromTableview:messageTableView];
        
        _messageTableView           = messageTableView;
        [self.view addSubview:_messageTableView];
    }
    return _messageTableView;
}

/**
 *  按钮点击事件
 *
 *  @param button
 */
- (void) selectButton:(UIButton *)button {
    
    // 1.取消当前选中的按钮 的选中状态
    self.selectedButton.selected = NO;
    
    // 2.设置点击的按钮 设置选中
    button.selected              = YES;
    
    // 3.选中按钮 赋值 给取消选中按钮
    self.selectedButton          = button;
    [self.messageArray removeAllObjects];
    [self.messageTableView reloadData];
    //公信点击
    if (button.tag == 0) {
        self.page = 1;
        self.isGetPrivate = NO;
        [self getPublicData];
        //修改privatebutton字体颜色
        UILabel *textLalbe = (UILabel*)[_privateButton viewWithTag:103];
        textLalbe.textColor = UIColorFromRGB(0xe84848);
        
        UILabel *titleLalbe = (UILabel*)[_publicButton viewWithTag:104];
        titleLalbe.textColor = [UIColor whiteColor];
    }
    //私信点击
    if (button.tag == 1) {
        // 是否登陆
        if (!ApplicationDelegate.islogin) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [login setNavBarTitle:@"登陆" withFont:14.0f];
            [self.navigationController pushViewController:login animated:YES];
            self.isGetPrivate = NO;
        } else {
            //修改publicbutton字体颜色
            UILabel *textLalbe = (UILabel*)[_privateButton viewWithTag:103];
            textLalbe.textColor = [UIColor whiteColor];
            
            UILabel *titleLalbe = (UILabel*)[_publicButton viewWithTag:104];
            titleLalbe.textColor = UIColorFromRGB(0xe84848);
            
            self.page         = 1;
            self.isGetPrivate = YES;
            [self getPrivateData];
        }
        
    }
    
}


#pragma mark ----- 获取网络数据
/**
 *  初始化数据
 */
- (void) initData {
    self.page = 1;
    self.isGetPrivate = NO;
    [self getPublicData];
}


/**
 *  网络获取 公告数据
 */
- (void) getPublicData {
    
    NSString *typePage  = [NSString stringWithFormat:@"%ld", (long)self.page];
    self.isPublicChange = YES;
    NSString *url       = connect_url(@"message_list");
    NSDictionary *dict  = @{
                           @"app_key" : url,
                           @"page"    : typePage,
                           };
    
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
       
        [self.messageTableView headerEndRefreshing];
        [self.messageTableView footerEndRefreshing];
        if ([param[@"code"] isEqualToString:@"200"]) {
        
            NSMutableArray *array = param[@"obj"];
            [SVProgressHUD dismiss];
            if (array.count != 0) {
                self.messageArray = [self publicDataTreatment:array];
                [self.messageTableView reloadData];
            } else {
                //[SVProgressHUD showErrorWithStatus:@"没有数据啦！"];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常！"];
    }];
}

/**
 *  获取 私信的数据
 */
- (void) getPrivateData {
    NSString *typePage  = [NSString stringWithFormat:@"%ld", self.page];
    self.isPublicChange = NO;
    NSString  *url      = connect_url(@"my_message_list");
    UserModel *user     = [UserModel shareInstance];
    NSDictionary *dict  = @{
                           @"app_key" : url,
                           @"u_id"    : user.u_id,
                           @"page"    : typePage,
                           };
    
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        
        [self.messageTableView headerEndRefreshing];
        [self.messageTableView footerEndRefreshing];
        if ([param[@"code"] isEqualToString:@"200"]) {
            NSMutableArray *array = param[@"obj"];
            [SVProgressHUD dismiss];
            if (self.page == 1) {
                [self.messageArray removeAllObjects];
            }
            if (array.count != 0) {
                self.messageArray = [self privateDataTreatment:array];
            } else {
                //[SVProgressHUD showErrorWithStatus:@"没有数据啦！"];
            }
            [self.messageTableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力！"];
    }];
}

/**
 *  是否登陆
 *
 *  @return BOOL
 */
- (BOOL) isLogin {
    if (!ApplicationDelegate.islogin) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return NO;
    }
    return YES;
}

/**
 *  公信的数据处理 (字典转模型数据)
 *
 *  @param  param
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *) publicDataTreatment:(NSMutableArray *)param {

    NSMutableArray *array = [NSMutableArray array];
    
    if (self.page != 1) {
        array = self.messageArray;
    }
    
    for (NSDictionary *dict in param) {
        PublicAndPrivateMessage *publicMessage = [PublicAndPrivateMessage publicAndPrivateMessageWithDict:dict];
        
        // 自定义cell 的frame 模型
        PublicAndPrivateMessageFrame *publicFrame = [[PublicAndPrivateMessageFrame alloc] init];
        publicFrame.message = publicMessage;
        [array addObject:publicFrame];
    }
    return array;
}

/**
 *  私信的数据处理 (字典转模型数据)
 *
 *  @param  param
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *) privateDataTreatment:(NSMutableArray *)param {
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.page != 1) {
        array = self.messageArray;
    }
    for (NSDictionary *dict in param) {
        PublicAndPrivateMessage *privateMessage = [PublicAndPrivateMessage publicAndPrivateMessageWithDict:dict];
        PublicAndPrivateMessageFrame *privateFrame = [[PublicAndPrivateMessageFrame alloc] init];
        privateFrame.message = privateMessage;
        [array addObject:privateFrame];
    }
    return array;
}

#pragma mark ----- UITableView dataSource
/**
 *  返回 数据 的分组个数
 *
 *  @param  tableView
 *
 *  @return NSInteger
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 *  返回显示多少个cell
 *
 *  @param  tableView
 *  @param  section
 *
 *  @return NSInteger
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}


/**
 *  返回 每组显示多少个Cell
 *
 *  @param  tableView
 *  @param  section
 *
 *  @return NSInteger
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PublicAndPrivateMessageTableViewCell *cell = [PublicAndPrivateMessageTableViewCell publicAndPrivateMessageWithTableView:tableView];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cell.messageFrame = self.messageArray[indexPath.row];
    return cell;
}


/**
 *  上拉下载更多数据
 */
- (void) upLoad {
    
    self.page = 1;
    if (self.isPublicChange) {
//        [self getPublicData];
        [self selectButton:self.publicButton];
    } else {

        [self selectButton:self.privateButton];
//        [self getPrivateData];
    }
}

/**
 *  下拉刷新数据
 */
- (void) downRefresh {
    
    self.page++;
    if (self.isPublicChange) {
//        [self selectButton:self.publicButton];
        [self getPublicData];
    } else {
//        [self selectButton:self.privateButton];
        [self getPrivateData];
    }
}


#pragma mark ----- UITableView delegate
/**
 *  UITableView  代理方法 点击了 每个Cell(跳转详情)
 *
 *  @param tableView
 *  @param indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PublicAndPrivateMessageFrame *mseeageFrame = self.messageArray[indexPath.row];
    MessageInfoViewController    *messageInfo  = [[MessageInfoViewController alloc] init];
    messageInfo.message_url = mseeageFrame.message.message_url;
    [self.navigationController pushViewController:messageInfo animated:YES];
}


@end
