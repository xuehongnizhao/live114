//
//  EvenMoreFeedbackViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EvenMoreFeedbackViewController.h"

#import "EvenMoreFeedbackInfoViewController.h"
#import "EvenMoreFeedbackCell.h"

#import "EvenMoreFeedback.h"
#import "EvenMoreFeedbackFrame.h"
#import "UserModel.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size];
#define padding 10

@interface EvenMoreFeedbackViewController () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

// ---------------------- UI 控件 ----------------------
/** UIView */
@property (weak, nonatomic) UIView      *messageView;
/** UITextView */
@property (weak, nonatomic) UITextView  *messageTextView;

/** 提交按钮 */
@property (weak, nonatomic) UIButton    *insertMessageButton;

/** placeholder 效果 */
@property (weak, nonatomic) UILabel     *textLabelView;

/** 展示数据的 TableView */
@property (weak, nonatomic) UITableView *messageTableView;


// ---------------------- 数据模型 ----------------------
@property (strong, nonatomic) NSMutableArray *feedback;


@end

@implementation EvenMoreFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----- 初始UI控件

/**
 *  初始化控件
 */
- (void) initUI {
    
    [self settingNav];
    
    [self messageView];
    
    [self messageTextView];
    
    [self insertMessageButton];
    
    [self textLabelView];
    
    [self messageTableView];
}


/**
 * 设置导航栏
 */
- (void) settingNav {
    
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = Color(243, 243, 243, 255);
}


/**
 *  添加一个 UIView
 *
 *  @return UIView
 */
- (UIView *)messageView {
    
    if (_messageView == nil) {
        
        UIView *messageView = [[UIView alloc] init];
        CGFloat messX = self.view.frame.origin.x;
        CGFloat messY = self.view.frame.origin.y;
        CGFloat messW = self.view.frame.size.width;
        CGFloat messH = 200;
        messageView.frame = CGRectMake(messX, messY, messW, messH);
        messageView.backgroundColor = [UIColor whiteColor];
        _messageView                = messageView;
        [self.view addSubview:_messageView];
    }
    return _messageView;
}

/**
 *  添加一个 UITextView
 *
 *  @return UITextView
 */
- (UITextView *)messageTextView {
    
    if (_messageTextView == nil) {
    
        UITextView *messageTextView = [[UITextView alloc] init];
        CGFloat messX = padding;
        CGFloat messY = padding;
        CGFloat messW = self.messageView.frame.size.width - padding * 2;
        CGFloat messH = self.messageView.frame.size.height * 0.65;
        messageTextView.frame = CGRectMake(messX, messY, messW, messH);
        messageTextView.layer.borderWidth   = 1;
        messageTextView.layer.cornerRadius  = 5 / 1;
        messageTextView.layer.masksToBounds = YES;
        messageTextView.layer.borderColor   = Color(231, 231, 231, 255).CGColor;
        messageTextView.delegate            = self;
        _messageTextView                    = messageTextView;
        [self.messageView addSubview:_messageTextView];
    }
    
    
    return _messageTextView;
}

/**
 *  添加一个 UIButton
 *
 *  @return UIButton
 */
- (UIButton *)insertMessageButton {
    
    if (_insertMessageButton == nil) {
       
        UIButton *insertMessageButton = [[UIButton alloc] init];
        CGFloat buttonX = self.messageTextView.frame.origin.x;
        CGFloat buttonY = CGRectGetMaxY(self.messageTextView.frame) + padding;
        CGFloat buttonW = self.messageTextView.frame.size.width;
        CGFloat buttonH = 40;

        insertMessageButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        insertMessageButton.backgroundColor     = Color(121, 191, 208, 255);
        insertMessageButton.layer.cornerRadius  = 5 / 1;
        insertMessageButton.layer.masksToBounds = YES;
        insertMessageButton.titleLabel.font     = SYSTEM_FONT_SIZE(15);
        
        // 点击文字
        [insertMessageButton setTitle:@"提交" forState:UIControlStateNormal];
        [insertMessageButton setTitle:@"提交" forState:UIControlStateHighlighted];
        
        // 点击颜色
        [insertMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [insertMessageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        // 点击绑定方法
        [insertMessageButton addTarget:self action:@selector(insertMessage) forControlEvents:UIControlEventTouchUpInside];
        _insertMessageButton                    = insertMessageButton;
        [self.messageView addSubview:_insertMessageButton];
    }
    return _insertMessageButton;
}


/**
 *  添加一个 UITextField
 *
 *  @return UITextField
 */
- (UILabel *)textLabelView {
    
    if (_textLabelView == nil) {
       
        UILabel *textLabelView = [[UILabel alloc] init];
        CGFloat textX =  padding / 2;
        CGFloat textY = -padding / 2;
        CGFloat textW = self.messageTextView.frame.size.width;
        CGFloat textH = 40;
        textLabelView.frame     = CGRectMake(textX, textY, textW, textH);
        textLabelView.text      = @"请输入您的反馈意见...";
        textLabelView.textColor = Color(193, 193, 193, 255);
        textLabelView.font      = SYSTEM_FONT_SIZE(12);
        _textLabelView          = textLabelView;
        [self.messageTextView addSubview:_textLabelView];
        
    }
    return _textLabelView;
}

/**
 *  添加一个 UITableView
 *
 *  @return UITableView
 */
- (UITableView *)messageTableView {
    
    if (_messageTableView == nil) {
        
        UITableView *messageTableView = [[UITableView alloc] init];
        CGFloat messX = self.view.frame.origin.x;
        CGFloat messY = CGRectGetMaxY(self.messageView.frame) + padding;
        CGFloat messW = self.view.frame.size.width;
        CGFloat messH = self.view.frame.size.height - self.messageView.frame.size.height - 64 - padding;
        messageTableView.frame       = CGRectMake(messX, messY, messW, messH);
        messageTableView.dataSource  = self;
        messageTableView.delegate    = self;
        messageTableView.rowHeight   = 60;
        [UZCommonMethod hiddleExtendCellFromTableview:messageTableView];
        _messageTableView            = messageTableView;
        [self.view addSubview:_messageTableView];
    }
    return _messageTableView;
}


#pragma mark ----- 数据处理

/**
 *  数据初始化
 */
- (void) initData {
    
    [self getFeedbackData];
}


/**
 *  获取 意见反馈列表数据
 */
- (void) getFeedbackData {
    
    NSString *url = connect_url(@"feed_back_list");
    NSDictionary *dict = @{
                           @"app_key" : url
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD dismiss];
            NSMutableArray *array = param[@"obj"];
            if (array.count != 0) {
                self.feedback = [self feedbackDataTreatment:array];
                [self.messageTableView reloadData];
            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD dismiss];
        }
    } andErrorBlock:^(NSError *error) {
        
    }];
}

/**
 *  数据处理 (字典转模型数据) 存放模型数据的数组
 *
 *  @param  param
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *) feedbackDataTreatment:(NSMutableArray *)param {

    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in param) {

        EvenMoreFeedback *feedback = [EvenMoreFeedback evenMoreFeedbackWithDict:dict];
        EvenMoreFeedbackFrame *feedbackFrame = [[EvenMoreFeedbackFrame alloc] init];
        feedbackFrame.feedback = feedback;
        [array addObject:feedbackFrame];
    }
    return array;
}


/**
 *  发布信息
 */
- (void) insertMessage {
    
    
    // 收键盘
    [self.view endEditing:YES];
    
    // 验证信息 不能为空
    if ([self trimString:self.messageTextView.text].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"反馈信息不能为空！"];
        return;
    }
    
    // 访问接口
    UserModel *user = [UserModel shareInstance];
    NSString *url   = connect_url(@"feedback");
    
    NSDictionary *dict = @{
                           @"app_key"       : url,
                           @"u_id"          : user.u_id,
                           @"session_key"   : user.session_key,
                           @"feed_desc"     : self.messageTextView.text
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            // 获取列表数据
            [self getFeedbackData];
            // 清空数据
            self.messageTextView.text = @"";
            // 显示 placeholder
            self.textLabelView.hidden = NO;
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力！"];
    }];
    
}


#pragma mark ----- UITableView dataSource

/**
 *  返回多少个分组
 *
 *  @param  tableView
 *
 *  @return NSInteger
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 *  返回每个分组显示多少个Cell
 *
 *  @param  tableView
 *  @param  section
 *
 *  @return NSInteger
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedback.count;
}

/**
 *  返回每个Cell 展示的数据 和 显示的样式
 *
 *  @param  tableView
 *  @param  indexPath
 *
 *  @return UITableViewCell
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建Cell
    EvenMoreFeedbackCell *cell = [EvenMoreFeedbackCell evenMoreFeedbackCellWithTableView:tableView];
    
    // 赋值
    cell.feedbackFrame = self.feedback[indexPath.row];
    
    // 返回
    return cell;
}


#pragma mark ----- UITableView delegate 

/**
 *  tableView 代理方法 点击每个cell (点击跳转详情)
 *
 *  @param tableView
 *  @param indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取出数据
    EvenMoreFeedbackFrame *feedbackFrame = self.feedback[indexPath.row];
    EvenMoreFeedback      *feedback      = feedbackFrame.feedback;
    
    // 跳转详情
    EvenMoreFeedbackInfoViewController *feedbackInfo = [[EvenMoreFeedbackInfoViewController alloc] init];
    feedbackInfo.message_url = feedback.message_url;
    [self.navigationController pushViewController:feedbackInfo animated:YES];
}





#pragma mark ----- UITextView delegate

/**
 *  文字 改变时 调用 (来设置 UILabel 隐藏 或者 显示 实现 placeholder 效果)
 *
 *  @param  textView
 *  @param  range
 *  @param  text
 *
 *  @return BOOL
 */
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if ([text isEqualToString:@"\n"]) {
        //检测到“完成”
        [textView resignFirstResponder];
        //释放键盘
        return NO;
    }
    
    //textview长度为0
    if (self.messageTextView.text.length == 0) {
        //判断是否为删除键
        if ([text isEqualToString:@""]) {
            self.textLabelView.hidden = NO;
        }else{
            self.textLabelView.hidden = YES;
        }
    } else {
        //textview长度不为0
        if (self.messageTextView.text.length == 1) {
            //textview长度为1时候
            if ([text isEqualToString:@""]) {
                //判断是否为删除键
                self.textLabelView.hidden = NO;
            }else{//不是删除
                self.textLabelView.hidden = YES;
            }
        } else {
            //长度不为1时候
            self.textLabelView.hidden = YES;
        }
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
