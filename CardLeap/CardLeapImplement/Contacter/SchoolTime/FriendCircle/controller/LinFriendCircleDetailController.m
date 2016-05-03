//
//  LinFriendCircleDetailController.m
//  EnjoyDQ
//
//  Created by lin on 14-8-16.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "LinFriendCircleDetailController.h"
//#import "LinDataMgr.h"
#import "LinFriendCircleDetailCell.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "SDImageCache.h"
#import "Base64Tool.h"
#import "UMSocial.h"
#import "VoiceConverter.h"
#import "VoiceRecorderBase.h"
#import "UIScrollView+MJRefresh.h"
#import "ReviewLable.h"
#import "LinFriendCircleController.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#define KFacialSizeWidth    20

#define KFacialSizeHeight   20

#define KCharacterWidth     8

#define VIEW_LINE_HEIGHT    24

#define VIEW_LEFT           16

#define VIEW_RIGHT          16

#define VIEW_TOP            8

#define VIEW_WIDTH_MAX      166
@interface LinFriendCircleDetailController ()<UIAlertViewDelegate>
{
    NSMutableDictionary *dic;
    NSDictionary *friendCircleDetailDic;
    NSString *com_user_review;
    NSString *com_userid_review;
    //----------------
    OHAttributedLabel *t_OHAttributedLabel;
    MarkupParser *wk_markupParser;
    //----------------
    BOOL keyboardHide;
    UILabel *backLable ;
    NSMutableArray *phontos;
    UIWebView * t_ReviewName;
    BOOL is_send;
    int page;
    int picHeight ;
    BOOL is_play;
    UIRefreshControl* refreshControl;//刷新控件
    NSString *filePath;
    NSString *wavPath;
    NSError *playerError;
    int second;//音频时间长度
    NSTimer *timer;//定时器
    UIImageView *btnimage;//动画图片
    int imagePage;//播放当前图片
    NSMutableArray *reviewHeight;
    UIImageView *strechTestNo;
    UIImageView *strechTestSel;
    //灰色背景的高度
    int backgroundheight;
    int backgroundy;
    //回复lables
    NSMutableArray *reviewArray;
    BOOL is_count_zero;
    NSMutableArray *photoArray;
    NSString *rev_text;
    BOOL isFirst;
}
@property (strong, nonatomic) UITableView *LinFriendCircleTableview;
@end
static NSMutableDictionary* g_nsdicemojiDict = nil;
@implementation LinFriendCircleDetailController
@synthesize com_id = _com_id;
@synthesize lin_user_pic = _lin_user_pic;
@synthesize lin_user_name = _lin_user_name;
@synthesize lin_com_text = _lin_com_text;
@synthesize lin_pic_list_short = _lin_pic_list_short;
@synthesize lin_pic_list_clear = _lin_pic_list_clear;
@synthesize lin_add_time = _lin_add_time;
@synthesize lin_review_list = _lin_review_list;
@synthesize lin_com_voice = _lin_com_voice;
@synthesize player = _player;
@synthesize downloadOperation = _downloadOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.detailInfo);
    // Do any additional setup after loading the view.
    [self setUI];
    [self initData];
    [self getDataFromNetwork];
}
#pragma mark------界面显示
-(void)setUI
{
    _LinFriendCircleTableview = [[UITableView alloc] initForAutoLayout];
    [_LinFriendCircleTableview setSectionIndexColor:[UIColor clearColor]];
    [_LinFriendCircleTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_LinFriendCircleTableview setSeparatorColor:[UIColor clearColor]];
    [_LinFriendCircleTableview setBackgroundView:nil];
    _LinFriendCircleTableview.keyboardDismissMode = YES;
    _LinFriendCircleTableview.delegate = self;
    _LinFriendCircleTableview.dataSource = self;
    [UZCommonMethod hiddleExtendCellFromTableview:_LinFriendCircleTableview];
    [self.view addSubview:_LinFriendCircleTableview];
    [_LinFriendCircleTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_LinFriendCircleTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:55.0f];
    [_LinFriendCircleTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_LinFriendCircleTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}
-(void)initData
{
    photoArray = [[NSMutableArray alloc] init];
    //控制条 表情按钮  发送按钮 输入框创建及设置
    CGRect rect = self.view.frame;
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGRect barRect = bar.frame;
    toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-55-barRect.size.height-barRect.origin.y, rect.size.width, 55)];
    toolBar.layer.borderWidth = 1;
    toolBar.layer.borderColor = [[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0] CGColor];
    [toolBar.layer setMasksToBounds:YES];
    toolBar.layer.shadowColor = [UIColor colorWithRed:246 green:245 blue:245 alpha:1.0].CGColor;
    toolBar.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    toolBar.layer.shadowOpacity = 0.2;
    toolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolBar];
    //-------------------------
    textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, 234*LinPercent, 35)];
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 6;
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0] CGColor];
    textView.layer.shadowColor = [UIColor colorWithRed:246 green:245 blue:245 alpha:1.0].CGColor;
    textView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    textView.layer.shadowOpacity = 0.2;
    //书写操作板
    [toolBar addSubview:textView];
    keyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 12, 32, 32)];
    [keyboardButton setImage:[UIImage imageNamed:@"creart_expass"] forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"creart_expass"] forState:UIControlStateHighlighted];
    [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:keyboardButton];
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(278*LinPercent+4, 12, 32, 32)];
    [sendButton setImage:[UIImage imageNamed:@"found_send"] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"found_send"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(faceBoardHide:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sendButton];
    //回复lable
    reviewArray = [[NSMutableArray alloc] init ];
    backgroundy = 0;//背景灰色y
    backgroundheight = 0;//背景颜色高度
    reviewHeight = [[NSMutableArray alloc] init];
    //添加新控件
    imagePage = 0;
    [self setupRefresh];
    //[self downLoadFile];
    picHeight = 0;//图片高度
    is_send = NO;//判断是否发送评论
    is_play = YES;
    page = 1;//分页
    isFirst = YES;
    textView.layer.cornerRadius = 12;
    textView.layer.masksToBounds = YES;
    [self setNavBarTitle:@"发现详情" withFont:14.0f];
    //    [self.navigationItem setTitle:@"发现详情"];
    phontos = [[NSMutableArray alloc] init];
    keyboardHide = YES;
    dic = [[NSMutableDictionary alloc] init];
    friendCircleDetailDic = [[NSDictionary alloc] init];
    //传入数据参数
    [dic setObject:self.com_id forKey:@"com_id"];
    [dic setObject:connect_url(@"comment_message") forKey:@"app_key"];
    [dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    //表情键盘相关属性初始化
    //textView.delegate =self;
    if ( !faceBoard) {
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.send = @"1";
        faceBoard.delegate = self;
        faceBoard.inputTextView = textView;
        textView.delegate=self;
    }
    
    if ( !messageList ) {
        messageList = [[NSMutableArray alloc] init];
    }
    
    if ( !sizeList ) {
        sizeList = [[NSMutableDictionary alloc] init];
    }
    
    isFirstShowKeyboard = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    backLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 8, 200, 16)];
    backLable.textColor = [UIColor grayColor];
    backLable.text = @"请输入评论";
    [textView addSubview:backLable];
    //添加分享
    [self setShareButton];
    //[self downLoadFile];
}

-(void)textviewSend:(UITextView *)textView
{
    NSLog(@"发送信息");
}

/** ################################ UIKeyboardNotification ################################ **/

- (void)keyboardWillShow:(NSNotification *)notification {
    
    isKeyboardShowing = YES;
    keyboardHide = NO;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _LinFriendCircleTableview.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         //_LinFriendCircleTableview.frame = frame;
                         keyboardHeight = keyboardRect.size.height;
                         CGRect rect = toolBar.frame;
                         rect.origin.y = keyboardRect.origin.y - rect.size.height;
                         toolBar.frame = rect;
                     }];
    
    if ( isFirstShowKeyboard ) {
        
        isFirstShowKeyboard = NO;
        
        isSystemBoardShow = !isButtonClicked;
    }
    
    if ( isSystemBoardShow ) {
        
        [keyboardButton setImage:[UIImage imageNamed:@"creart_expass"]
                        forState:UIControlStateNormal];
    }
    else {
        
        [keyboardButton setImage:[UIImage imageNamed:@"issue_text_no.png"]
                        forState:UIControlStateNormal];
    }
    
    if ( messageList.count ) {
        
        //        [_LinFriendCircleTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageList.count - 1
        //                                                                   inSection:0]
        //                               atScrollPosition:UITableViewScrollPositionBottom
        //                                       animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboardHide = YES;
    //backLable.hidden = NO;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame1 = _LinFriendCircleTableview.frame;
                         //                         frame.size.height += keyboardHeight;
                         //                         _LinFriendCircleTableview.frame = frame;
                         //CGFloat height = [_LinFriendCircleTableview systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                         CGRect frame = toolBar.frame;
                         frame.origin.y = frame1.size.height;
                         toolBar.frame = frame;
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        if ( ![textView.inputView isEqual:faceBoard] ) {
            
            isSystemBoardShow = NO;
            
            textView.inputView = faceBoard;
        }
        else {
            
            isSystemBoardShow = YES;
            
            textView.inputView = nil;
        }
        
        [textView becomeFirstResponder];
    }
}

/** ################################ ViewController ################################ **/

- (IBAction)faceBoardClick:(id)sender {
    
    isButtonClicked = YES;
    keyboardHide = ~keyboardHide;
    if ( isKeyboardShowing ) {
        [textView resignFirstResponder];
    }
    else {
        
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            textView.inputView = faceBoard;
        }
        
        [textView becomeFirstResponder];
    }
    
}

- (IBAction)faceBoardHide:(id)sender {
    if (ApplicationDelegate.islogin==NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        keyboardHide = YES;
        is_send = YES;
        int length_str = (int)textView.text.length ;
        if (length_str > 0) {
            BOOL needReload = NO;
            if ( ![textView.text isEqualToString:@""] ) {
                
                needReload = YES;
                
                NSMutableArray *messageRange = [[NSMutableArray alloc] init];
                [self getMessageRange:textView.text :messageRange];
                [messageList addObject:messageRange];
                //[messageRange release];
                
                messageRange = [[NSMutableArray alloc] init];
                [self getMessageRange:textView.text :messageRange];
                [messageList addObject:messageRange];
                //[messageRange release];
            }
            //向服务器提交  刷新数据
            NSMutableDictionary *review_post_dic  =  [[NSMutableDictionary alloc] init];
            NSString *com_text_str = textView.text;
            NSString *reviewUrl = connect_url(@"review_add");
            NSString *u_id = [UserModel shareInstance].u_id;
            NSString *session_key = [UserModel shareInstance].session_key;
            [review_post_dic setObject:com_text_str forKey:@"rev_text"];
            [review_post_dic setObject:reviewUrl forKey:@"app_key"];
            [review_post_dic setObject:_com_id forKey:@"com_id"];
            [review_post_dic setObject:u_id forKey:@"u_id"];
            [review_post_dic setObject:session_key forKey:@"session_key"];
            if (com_userid_review!=nil) {
                [review_post_dic setObject:com_userid_review forKey:@"rev_return_uid"];
            }else{
                [review_post_dic setObject:@"0" forKey:@"rev_return_uid"];
            }
            NSLog(@"回复内容%@",com_text_str);
            [SVProgressHUD showWithStatus:@"正在提交..."];
            //NSString *url = @"/community/ac_com/review_add";
            BOOL is_base64 = [IS_USE_BASE64 boolValue];
            [Base64Tool postSomethingToServe:reviewUrl andParams:review_post_dic isBase64:is_base64 CompletionBlock:^(id param) {
                NSLog(@"%@",param);
                NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
                if ([code isEqualToString:@"200"]) {
                    //重新获取列表 排列界面显示
                    page=1;
                    [dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
                    [dic setObject:@"1" forKey:@"is_review"];
                    [self getDataFromNetwork];
                }else{
                    [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
                }
            } andErrorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }];
            //------------------------------------------------------------------------------
            textView.text = nil;
            [self textViewDidChange:textView];
            
            [textView resignFirstResponder];
            
            isFirstShowKeyboard = YES;
            
            isButtonClicked = NO;
            
            textView.inputView = nil;
            
            //[keyboardButton setImage:[UIImage imageNamed:@"board_emoji"]
            // forState:UIControlStateNormal];
            is_send = NO;
            
        }
        
    }
}

/**
 * 解析输入的文本
 *
 * 根据文本信息分析出哪些是表情，哪些是文字
 */
-(void)getMessageRange:(NSString*)message :(NSMutableArray*)array {
    
    NSRange range = [message rangeOfString:FACE_NAME_HEAD];
    
    //判断当前字符串是否存在表情的转义字符串
    if ( range.length > 0 ) {
        
        if ( range.location > 0 ) {
            
            [array addObject:[message substringToIndex:range.location]];
            
            message = [message substringFromIndex:range.location];
            
            if ( message.length > FACE_NAME_LEN ) {
                
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else
                // 排除空字符串
                if ( message.length > 0 ) {
                    
                    [array addObject:message];
                }
        }
        else {
            
            if ( message.length > FACE_NAME_LEN ) {
                
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else
                // 排除空字符串
                if ( message.length > 0 ) {
                    
                    [array addObject:message];
                }
        }
    }
    else {
        
        [array addObject:message];
    }
}

/**
 *  获取文本尺寸
 */
- (void)getContentSize:(NSIndexPath *)indexPath {
    
    @synchronized ( self ) {
        
        
        CGFloat upX;
        
        CGFloat upY;
        
        CGFloat lastPlusSize;
        
        CGFloat viewWidth;
        
        CGFloat viewHeight;
        
        BOOL isLineReturn;
        
        
        NSArray *messageRange = [messageList objectAtIndex:indexPath.row];
        
        NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        
        isLineReturn = NO;
        
        upX = VIEW_LEFT;
        upY = VIEW_TOP;
        
        for (int index = 0; index < [messageRange count]; index++) {
            
            NSString *str = [messageRange objectAtIndex:index];
            if ( [str hasPrefix:FACE_NAME_HEAD] ) {
                
                //NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                
                NSArray *imageNames = [faceMap allKeysForObject:str];
                NSString *imageName = nil;
                NSString *imagePath = nil;
                
                if ( imageNames.count > 0 ) {
                    
                    imageName = [imageNames objectAtIndex:0];
                    imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                }
                
                if ( imagePath ) {
                    
                    if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    
                    upX += KFacialSizeWidth;
                    
                    lastPlusSize = KFacialSizeWidth;
                }
                else {
                    
                    for ( int index = 0; index < str.length; index++) {
                        
                        NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                        
                        CGSize size = [character sizeWithFont:font
                                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                        
                        if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
                            
                            isLineReturn = YES;
                            
                            upX = VIEW_LEFT;
                            upY += VIEW_LINE_HEIGHT;
                        }
                        
                        upX += size.width;
                        
                        lastPlusSize = size.width;
                    }
                }
            }
            else {
                
                for ( int index = 0; index < str.length; index++) {
                    
                    NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                    
                    CGSize size = [character sizeWithFont:font
                                        constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                    
                    if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    
                    upX += size.width;
                    
                    lastPlusSize = size.width;
                }
            }
        }
        
        if ( isLineReturn ) {
            
            viewWidth = VIEW_WIDTH_MAX + VIEW_LEFT * 2;
        }
        else {
            
            viewWidth = upX + VIEW_LEFT;
        }
        
        viewHeight = upY + VIEW_LINE_HEIGHT + VIEW_TOP;
        
        NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake( viewWidth, viewHeight )];
        [sizeList setObject:sizeValue forKey:indexPath];
    }
}

/** ################################ UITextViewDelegate ################################ **/

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    is_send = NO;
    if ([text isEqualToString:@"\n"]){
        //NSLog(@"发送信息");
        //is_send = YES;
        //[self sendMessage];
        return NO;
    }
    backLable.hidden = YES;
    NSLog(@"%ld",text.length);
    NSLog(@"%ld",range.length);
    if (text.length == 0 && range.length==1) {
        //删除操作
        if (textView.text.length == 1) {
            backLable.hidden = NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)_textView {
    if (is_send) {
        CGSize size = textView.contentSize;
        size.height -= 2;
        if ( size.height >= 68 ) {
            
            size.height = 68;
        }
        else if ( size.height <= 32 ) {
            
            size.height = 32;
        }
        
        if ( size.height != textView.frame.size.height ) {
            
            CGFloat span = size.height - textView.frame.size.height;
            
            CGRect frame = toolBar.frame;
            frame.origin.y -= span;
            frame.size.height += span;
            toolBar.frame = frame;
            
            CGFloat centerY = frame.size.height / 2;
            
            frame = textView.frame;
            frame.size = size;
            textView.frame = frame;
            
            CGPoint center = textView.center;
            center.y = centerY;
            textView.center = center;
            
            center = keyboardButton.center;
            center.y = centerY;
            keyboardButton.center = center;
            
            center = sendButton.center;
            center.y = centerY;
            sendButton.center = center;
        }
    }
}

-(void)getDataFromNetwork
{
    //[SVProgressHUD showWithStatus:@"加载中"];
    NSLog(@"参数是%@",dic);
    NSString *url = connect_url(@"comment_message");
    BOOL is_base64 = [IS_USE_BASE64 boolValue];
    [[LinLoadingView shareInstances:self.view] startAnimation];
    [Base64Tool postSomethingToServe:url andParams:dic isBase64:is_base64 CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        reviewHeight = [[NSMutableArray alloc] init];
        if ([code isEqualToString:@"200"]) {
            friendCircleDetailDic = [param objectForKey:@"obj"];
            //解析数据
            [self parseDictionary:friendCircleDetailDic page:page];
            _lin_pic_list_clear = self.detailInfo.com_pic_big;
            [SVProgressHUD dismiss];
            [[LinLoadingView shareInstances:self.view]stopWithAnimation:[param objectForKey:@"message"]];
        }else{
            [[LinLoadingView shareInstances:self.view]stopWithAnimation:[param objectForKey:@"message"]];
            //[SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
        [self.LinFriendCircleTableview headerEndRefreshing];
        [self.LinFriendCircleTableview footerEndRefreshing];
        reviewArray = [[NSMutableArray alloc] init];
        [_LinFriendCircleTableview reloadData];
    } andErrorBlock:^(NSError *error) {
        [[LinLoadingView shareInstances:self.view]stopWithAnimation:@"这网速，我也是醉了"];
        //[SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}
#pragma mark------------解析数据
-(void)parseDictionary :(NSDictionary*)dict page:(int)curr_page
{
    NSMutableDictionary *dics = [[NSMutableDictionary alloc] initWithDictionary:dict];
    if (page!=1) {
        NSMutableArray *arr = self.detailInfo.com_list;
        NSArray *array = [dics objectForKey:@"com_list"];
        [arr addObjectsFromArray:array];
        [dics removeObjectForKey:@"com_list"];
        [dics setObject:arr forKey:@"com_list"];
    }
    self.detailInfo = [[LinFriendCircleInfo alloc] initWithDetailDictionary:dics];
    
    NSLog(@"%@",self.detailInfo.com_text);
    NSLog(@"%lu",(unsigned long)self.detailInfo.com_list.count);
    NSLog(@"%@",self.detailInfo.com_voice);
    NSLog(@"%@",self.detailInfo.user_nickname);
}
-(void)backToListController :(NSArray*)reviewList
{
    //LinFriendCircleController *firVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LinFriendCircleController"];
    //将reviewList写入nsuserdefault
    [[NSUserDefaults standardUserDefaults] setObject:reviewList forKey:@"reviewList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NEEDUPDATAE" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)lengthForUsername :(NSString*)userName
{
    CGFloat length = 0;
    for (int i=0;i<userName.length;i++) {
        char c=[userName characterAtIndex:i];
        if ((c>'a'&&c<'z') || c == ' ')
        {
            length += 0.5;
        }else{
            length += 1.0;
        }
    }
    return length;
}

-(CGFloat)length_str :(NSString*)str
{
    NSString *text = str;
    NSString *regex_emoji = @"\\[[^x00-xff]{1,3}\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count])
    {
        for (NSString *str in array_emoji)
        {
            NSRange range = [text rangeOfString:str];
            NSString *replaceStr = @"$";
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:replaceStr];
        }
    }
    CGFloat length = 0;
    for (int i=0;i<text.length;i++) {
        char c=[text characterAtIndex:i];
        if ((c>'a'&&c<'z') || c == ' ')
        {
            length += 0.5;
        }else if(c == '$'){
            length += 1.3;
        }else{
            length += 1.0;
        }
    }
    return length;
}

#pragma mark------添加刷新控件
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //[self.LinFriendCircleTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
#pragma mark --- 自动刷新(一进入程序就下拉刷新)
    //[self.LinFriendCircleTableview headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.LinFriendCircleTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //    self.LinFriendCircleTableview.headerPullToRefreshText = @"下拉可以刷新了";
    //    self.LinFriendCircleTableview.headerReleaseToRefreshText = @"松开马上刷新了";
    //    self.LinFriendCircleTableview.headerRefreshingText = @" ";
    
    self.LinFriendCircleTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.LinFriendCircleTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.LinFriendCircleTableview.footerRefreshingText = @" ";
}


/**
 *  下拉刷新
 */
#pragma mark------下拉刷新
-(void)headerRereshing
{
    NSLog(@"下拉刷新");
    NSLog(@"%@",dic);
    is_count_zero = NO;
    page=0;
    [dic removeObjectForKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    NSLog(@"%@",dic);
    //[dic setObject:@"1" forKey:@"is_review"];
    _lin_review_list = [[NSMutableArray alloc] init];
    reviewArray = [[NSMutableArray alloc] init];
    //reviewHeight = [[NSMutableArray alloc] init];
    [self getDataFromNetwork];
}
/**
 *  上拉加载更多
 */
#pragma mark-------上拉加载更多
-(void)footerRereshing
{
    NSLog(@"上拉加载更多");
    if (is_count_zero == NO) {
        page+=1;
        NSLog(@"%d",page);
        if (page == 1) {
            _lin_review_list = [[NSMutableArray alloc] init];
            reviewArray = [[NSMutableArray alloc] init];
        }
        [dic removeObjectForKey:@"page"];
        [dic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        //reviewHeight = [[NSMutableArray alloc] init];
        //[dic setObject:@"0" forKey:@"is_review"];
        NSLog(@"%@",dic);
        [self getDataFromNetwork];
    }else{
        [SVProgressHUD showErrorWithStatus:@"暂时无评论了"];
        [_LinFriendCircleTableview footerEndRefreshing];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *simpleTableIdentifier = @"DetailMSGCell";
        LinFriendCircleDetailCell *cell = nil;
        cell = (LinFriendCircleDetailCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell==nil)
        {
            cell = [[LinFriendCircleDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
        }else{
            
        }
        if ([cell.subviews count]>1) {
            
        }else{
            //设置用户头像 尚未添加点击放大手势
            UIImageView *user_pic = [[UIImageView alloc] initForAutoLayout];
            [user_pic sd_setImageWithURL:[NSURL URLWithString:self.detailInfo.user_pic] placeholderImage:[UIImage imageNamed:@"user"]];
            user_pic.layer.masksToBounds = YES;
            user_pic.layer.cornerRadius = 4;
            [cell addSubview:user_pic];
            [user_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [user_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
            [user_pic autoSetDimension:ALDimensionHeight toSize:45.0f];
            [user_pic autoSetDimension:ALDimensionWidth toSize:45.0f];
            //距离or推荐
            UILabel *distanceLable = [[UILabel alloc] initForAutoLayout];
            distanceLable.textColor = UIColorFromRGB(0x0e0e0e);
            distanceLable.textAlignment = NSTextAlignmentRight;
            distanceLable.font = [UIFont systemFontOfSize:12.0f];
            distanceLable.text = @"";//没决定添加什么东西  再说吧
            [cell addSubview:distanceLable];
            [distanceLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [distanceLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [distanceLable autoSetDimension:ALDimensionHeight toSize:15.0f];
            [distanceLable autoSetDimension:ALDimensionWidth toSize:80.0f];
            //用户名
            UILabel *userName = [[UILabel alloc] initForAutoLayout];
            userName.textColor = UIColorFromRGB(0x0e0e0e);
            [userName setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
            userName.text = self.detailInfo.user_nickname;
            [cell addSubview:userName];
            [userName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [userName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:user_pic withOffset:8.0f*LinPercent];
            [userName autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:distanceLable withOffset:-8.0f];
            [userName autoSetDimension:ALDimensionHeight toSize:29.0f];
            //帖子创建时间
            UILabel *addTime = [[UILabel alloc] initForAutoLayout];
            [addTime setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
            addTime.textColor = UIColorFromRGB(0xa8a8aa);
            addTime.text = self.detailInfo.add_time;
            [cell addSubview:addTime];
            [addTime autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userName withOffset:5.0f];
            [addTime autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:user_pic withOffset:8.0f*LinPercent];
            [addTime autoSetDimension:ALDimensionHeight toSize:15.0f];
            [addTime autoSetDimension:ALDimensionWidth toSize:100.0f];
            //正文
            NSString *com_text = self.detailInfo.com_text ;
            //计算length
            int length_text = [self length_str:com_text];
            int com_text_line = length_text/18+1;
            UILabel *com_text_lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 320, com_text_line*18)];
            [com_text_lable setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];//格式
            [com_text_lable setNumberOfLines:com_text_line];
            com_text_lable.text = com_text;
            //[cell addSubview:com_text_lable];
            
            //t_OHAttributedLabel = [cell.contentView viewWithTag:112];
            if (t_OHAttributedLabel)
            {
                [t_OHAttributedLabel removeFromSuperview];
            }
            //内容
            g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
            if (g_nsdicemojiDict == nil)
            {
                g_nsdicemojiDict = [NSMutableDictionary dictionary];
                g_nsdicemojiDict = (NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
                [[NSUserDefaults standardUserDefaults] setObject:g_nsdicemojiDict forKey:@"FaceMap"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            OHAttributedLabel*  textLabelEx = nil;
            textLabelEx = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
            textLabelEx.tag = 112;
            [textLabelEx setNeedsDisplay];
            NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",com_text] emojiDic:g_nsdicemojiDict];
            //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
            wk_markupParser = [[MarkupParser alloc] init];
            NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
            [attString setFont:[UIFont systemFontOfSize:14]];
            [textLabelEx setBackgroundColor:[UIColor clearColor]];
            [textLabelEx setAttString:attString withImages:wk_markupParser.images];
            textLabelEx.frame = CGRectMake(40*LinPercent, 65, 320, com_text_line*18);
            CGRect labelRect = textLabelEx.frame;
            labelRect.size.width = [textLabelEx sizeThatFits:CGSizeMake(250, CGFLOAT_MAX)].width;
            labelRect.size.height = [textLabelEx sizeThatFits:CGSizeMake(250, CGFLOAT_MAX)].height;
            textLabelEx.frame = labelRect;
            [textLabelEx.layer display];
            textLabelEx.textColor = UIColorFromRGB(0x838486);
            textLabelEx.userInteractionEnabled = YES;
            //textLabelEx.backgroundColor = [UIColor grayColor];
            [CustomMethod drawImage:textLabelEx];
            
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
            UIView *pastView = [[UIView alloc] initWithFrame:textLabelEx.frame];
            [pastView setBackgroundColor:[UIColor clearColor]];
            pastView.userInteractionEnabled = YES;
            [pastView addGestureRecognizer:longPressGestureRecognizer];
            [cell addSubview:pastView];
            [cell  addSubview:textLabelEx];
            //----------------------------
            //添加图片九宫格
            int picCount = 0;//图片个数
            for (NSString *pic_str in self.detailInfo.com_pic) {
                if (pic_str.length <= 1) {
                    //
                }else{
                    picCount++;
                }
            }
            //计算图片起始位置
            int pic_y = 0;
            if (com_text.length > 0) {
                pic_y = textLabelEx.frame.origin.y + textLabelEx.frame.size.height+5;
            }else{
                pic_y = 65;
            }
            if (picCount) {
                if (picCount == 1) {
                    //一张大图
                    UIImageView *com_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(45*LinPercent,pic_y, 130, 130)];
                    com_image_view.userInteractionEnabled = YES;
                    com_image_view.tag = 0;
                    com_image_view.layer.borderWidth = 0.5;
                    com_image_view.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
                    [com_image_view sd_setImageWithURL:[NSURL URLWithString:[self.detailInfo.com_pic objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"user"]];
                    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                       action:@selector(singleDoubleTap:)];
                    [com_image_view addGestureRecognizer:singleTapGesture];
                    [photoArray addObject:com_image_view];
                    [cell addSubview:com_image_view];
                }else if(picCount <= 4){
                    //四张以内 田格显示
                    for (int i=0;i<picCount;i++) {
                        int lines = i / 2;
                        int col = i % 2;
                        UIImageView *com_image_view = nil;
                        com_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(45*LinPercent+col*105, pic_y+lines*105, 100, 100)];
                        com_image_view.userInteractionEnabled = YES;
                        com_image_view.tag = i;
                        com_image_view.layer.borderWidth = 0.5;
                        com_image_view.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
                        [com_image_view sd_setImageWithURL:[NSURL URLWithString:[self.detailInfo.com_pic objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"user"]];
                        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                           action:@selector(singleDoubleTap:)];
                        [com_image_view addGestureRecognizer:singleTapGesture];
                        [photoArray addObject:com_image_view];
                        [cell addSubview:com_image_view];
                    }
                }else if(picCount <= 9){
                    for (int n=0; n<picCount; n++) {
                        int lines = n / 3;
                        int col = n % 3;
                        UIImageView *com_image_view = nil;
                        com_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(45*LinPercent+col*78, pic_y+lines*78, 72, 72)];
                        com_image_view.userInteractionEnabled = YES;
                        com_image_view.tag = n;
                        com_image_view.layer.borderWidth = 0.5;
                        com_image_view.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
                        [com_image_view sd_setImageWithURL:[NSURL URLWithString:[self.detailInfo.com_pic objectAtIndex:n]] placeholderImage:[UIImage imageNamed:@"user"]];
                        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                           action:@selector(singleDoubleTap:)];
                        [com_image_view addGestureRecognizer:singleTapGesture];
                        [photoArray addObject:com_image_view];
                        [cell addSubview:com_image_view];
                    }
                }
            }
            //添加语音
            [self getFile];
            int voice_y = 0;
            if (com_text.length > 0) {
                voice_y = textLabelEx.frame.origin.y + textLabelEx.frame.size.height+5;
            }else{
                voice_y = 60;
            }
            if (picCount>0) {
                voice_y+=picHeight+10;
            }
            
            if (self.detailInfo.com_voice.length > 0) {
                NSLog(@"播放时间长度%d",second);
                //设置图片拉伸 未点击图片
                strechTestNo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"issue_voice_no.png"]];
                [strechTestNo setContentStretch:CGRectMake(0.5f, 0.5f, 0.0f, 0.0f)];
                CGRect frame = strechTestNo.frame;
                frame.size.width += 0.7*second;
                strechTestNo.frame = frame;
                //点击图片
                strechTestSel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"issue_voice_sel.png"]];
                [strechTestSel setContentStretch:CGRectMake(0.5f, 0.5f, 0.0f, 0.0f)];
                CGRect frame1 = strechTestSel.frame;
                frame1.size.width += 0.7*second;
                strechTestSel.frame = frame;
                
                UIButton *voice_button =  [UIButton buttonWithType:UIButtonTypeCustom];
                [voice_button setFrame:CGRectMake(45*LinPercent, voice_y, frame.size.width, frame.size.height)];
                [voice_button addSubview:strechTestNo];
                //[voice_button setImage:strechTest.image forState: UIControlStateNormal];
                [voice_button sendSubviewToBack:strechTestNo];
                //[voice_button setBackgroundColor:[UIColor redColor]];
                [voice_button addTarget:self
                                 action:@selector(ActionPlay)
                       forControlEvents:UIControlEventTouchUpInside];
                btnimage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 7, 10, 10)];
                [btnimage setImage:[UIImage imageNamed:@"issue_play_03@2x.png"]];
                [voice_button addSubview:btnimage];
                //音频文件时长
                NSLog(@"%d",voice_y);
                UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+60, voice_y+8, 20, 10)];
                timeLable.text = [NSString stringWithFormat:@"%d\"",second];
                [timeLable setFont:[UIFont systemFontOfSize:12]];
                timeLable.textColor = [UIColor grayColor];
                [cell addSubview:timeLable];
                [cell addSubview:voice_button];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }else{
        static NSString *simpleTableIdentifier1 = @"revivewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier1];
        }
        //清楚原有信息
        NSLog(@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]);
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            while ([cell.subviews lastObject] != nil) {
                [(UIView*)[cell.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
            }
        }else{
            //            while ([cell.subviews lastObject] != nil) {
            //                [(UIView*)[cell.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
            //            }
        }
        //加背景框架
        //设置背景灰色
        NSLog(@"当前为第几行%ld",(long)indexPath.row);
        int temp_height = [[reviewHeight objectAtIndex:indexPath.row] intValue];
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(45, 0, 250,temp_height )];
        [backgroudView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
        //        if (indexPath.row ==5) {
        //            backgroudView.backgroundColor = [UIColor redColor];
        //        }
        [cell addSubview:backgroudView];
        NSDictionary *one_user_review = [self.detailInfo.com_list objectAtIndex:(indexPath.row-1)];
        //回复列表显示 用户名 ：user_nickname 回复 user_nickname ：
        NSString *user_nickname_str = [Base64Tool fuckNULL:[one_user_review objectForKey:@"user_name"]];
        NSString *user_back_str = [Base64Tool fuckNULL:[one_user_review objectForKey:@"return_user_name"]];
        NSLog(@"%@",user_back_str);
        NSString *review_text_str = [one_user_review objectForKey:@"rev_text"];
        
        int blank_length;//留白长度
        blank_length = [self Linlength_str:user_nickname_str];
        if (user_back_str!=nil && user_back_str.length>0) {
            blank_length += [self Linlength_str:user_back_str]+2;
        }else{
        }
        NSString *tempUserName = user_nickname_str;
        if (user_back_str!=nil && user_back_str.length>0) {
            tempUserName = [NSString stringWithFormat:@"%@回复%@: ",tempUserName,user_back_str];
        }else{
            tempUserName = [NSString stringWithFormat:@"%@: ",tempUserName];
        }
        review_text_str = [NSString stringWithFormat:@"%@%@",tempUserName,review_text_str];
        int y = 0;
        if (indexPath.row == [_lin_review_list count]) {
            y = 0;
        }
        if (indexPath.row == 1) {
            y = 5;
        }
        UIView *blankView ;
        UILabel *blankLable = [[UILabel alloc] init];
        blankLable.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        //        blankView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        blankLable.text = tempUserName;
        blankLable.font=[UIFont systemFontOfSize:13];
        [blankLable sizeToFit];
        blankLable.text = @"";
        if ([self isEmoji:review_text_str]) {
            blankView = [[UIView alloc] initWithFrame:CGRectMake(50, y+5, blank_length*13+5, 14)];
            blankLable.frame = CGRectMake(50, y+5, blankLable.frame.size.width, blankLable.frame.size.height);
        }else{
            blankView = [[UIView alloc] initWithFrame:CGRectMake(50, y, blank_length*13+5, 14)];
            blankLable.frame = CGRectMake(50, y, blankLable.frame.size.width, blankLable.frame.size.height);
        }
        g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        if (g_nsdicemojiDict == nil)
        {
            g_nsdicemojiDict = [NSMutableDictionary dictionary];
            g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
            [[NSUserDefaults standardUserDefaults] setObject:g_nsdicemojiDict forKey:@"FaceMap"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        t_OHAttributedLabel = [cell.contentView viewWithTag:0];
        if (t_OHAttributedLabel)
        {
            [t_OHAttributedLabel removeFromSuperview];
        }
        OHAttributedLabel*  textLabelEx = nil;
        textLabelEx = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        textLabelEx.tag = 0;
        [textLabelEx setNeedsDisplay];
        NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",review_text_str] emojiDic:g_nsdicemojiDict];
        //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
        wk_markupParser = [[MarkupParser alloc] init];
        NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
        [attString setFont:[UIFont systemFontOfSize:13]];
        [textLabelEx setBackgroundColor:[UIColor clearColor]];
        [textLabelEx setAttString:attString withImages:wk_markupParser.images];
        //int review_text_y = user_name_label.frame.origin.y + user_name_label.frame.size.height;
        textLabelEx.frame = CGRectMake(50,y, 230,100);
        CGRect labelRect = textLabelEx.frame;
        labelRect.size.width = [textLabelEx sizeThatFits:CGSizeMake(240, CGFLOAT_MAX)].width;
        labelRect.size.height = [textLabelEx sizeThatFits:CGSizeMake(240, CGFLOAT_MAX)].height;
        textLabelEx.frame = labelRect;
        textLabelEx.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
        [textLabelEx.layer display];
        //textLabelEx.backgroundColor = [UIColor grayColor];
        [CustomMethod drawImage:textLabelEx];
        //OHAttributedLabel*  textLabelEx1 = [reviewArray objectAtIndex:indexPath.row - 1];
        textLabelEx.frame = CGRectMake(50, y, textLabelEx.frame.size.width, textLabelEx.frame.size.height);
        [cell addSubview:textLabelEx];
        //掩盖
        [cell addSubview:blankLable];
        if ([self isEmoji:review_text_str]) {
            y += 2;
        }
        UILabel *user_name_label = nil;
        user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(50,y, 232, 16)];
        [user_name_label setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];//格式
        [user_name_label setTextColor:[UIColor colorWithRed:93/255.0 green:181/255.0 blue:235/255.0 alpha:1.0]];
        [user_name_label setNumberOfLines: 1];//行数，只有设为0才能自适应
        user_name_label.text = [NSString stringWithFormat:@"%@:",user_nickname_str];
        //n++;
        [cell addSubview:user_name_label];
        if (user_back_str!=nil && user_back_str.length>0) {
            user_name_label.text = [NSString stringWithFormat:@"%@",user_nickname_str];
            [user_name_label sizeToFit];
            NSLog(@"%@",user_back_str);
            int back_lable_x = user_name_label.frame.origin.x + user_name_label.frame.size.width ;
            UILabel *back_lable = [[UILabel alloc] initWithFrame:CGRectMake(back_lable_x, y, 28, 16)];
            [back_lable setFont:[UIFont systemFontOfSize:13.0]];
            back_lable.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
            back_lable.text = @"回复";
            [back_lable sizeToFit];
            [cell addSubview:back_lable];
            int user_back_x = back_lable.frame.origin.x + back_lable.frame.size.width;
            UILabel *back_user_lable = [[UILabel alloc] initWithFrame:CGRectMake(user_back_x, y, 100, 16)];
            back_user_lable.textColor = [UIColor colorWithRed:93/255.0 green:181/255.0 blue:235/255.0 alpha:1.0];
            [back_user_lable setFont:[UIFont systemFontOfSize:13.0]];
            back_user_lable.text = [NSString stringWithFormat:@"%@:",user_back_str];
            [cell addSubview:back_user_lable];
        }
        //cell.backgroundColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark-----长按复制
-(void)longPressGestureRecognized :(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"测试");
    if (isFirst) {
        isFirst = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要复制该条朋友圈状态吗" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *str = self.detailInfo.com_text;
        NSLog(@"%@",str);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:str];
        isFirst = YES;
    }
}

-(CGFloat)Linlength_str:(NSString*)string
{
    NSString *text = string;
    CGFloat length = 0;
    for (int i=0;i<text.length;i++) {
        NSRange bankRang = NSMakeRange(i, 1);
        NSString *ele = [text substringWithRange:bankRang];
        char c = [text characterAtIndex:i];
        if ([self validateChinese:ele]) {
            length+=1;
        }else{
            if ((c>='a'&&c<='z') || c == ' ')
            {
                length += 0.5;
            }else{
                length += 1.0;
            }
            
        }
    }
    return length;
}

-(BOOL) validateChinese:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符 @"\\[[^x00-xff]{1,3}\\]"
    NSString *phoneRegex = @"[^x00-xff]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

-(BOOL)isEmoji :(NSString*)str
{
    NSString *regex_emoji = @"\\[[^x00-xff]{1,3}\\]";
    //截取第一行的字符串 计算出一个合理的截取长度
    CGFloat length = 0;
    int count = 0;
    for (int i=0;i<str.length;i++) {
        NSRange bankRang = NSMakeRange(i, 1);
        NSString *ele = [str substringWithRange:bankRang];
        char c = [str characterAtIndex:i];
        count++;
        if ([self validateChinese:ele]) {
            length+=1;
        }else{
            if ((c>='a'&&c<='z') || c == ' ')
            {
                length += 0.5;
            }else if(c>'1' && c <'9'){
                length += 0.5;
            }else{
                length += 1;
            }
        }
        if (length >= 20 ) {
            break;
        }
    }
    NSRange bankRang = NSMakeRange(0, count);
    NSString *testStr = [str substringWithRange:bankRang];
    
    NSArray *array_emoji = [testStr componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]>0) {
        return YES;
    }
    return NO;
}

-(void)singleDoubleTap :(UITapGestureRecognizer*) recognizer
{
    
    if (_lin_pic_list_clear != nil) {
        UIImageView *selectImage = (UIImageView*)recognizer.view;
        NSLog(@"%ld",selectImage.tag);
        int count = (int)_lin_pic_list_clear.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片
            NSString *url = [_lin_pic_list_clear[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            //            UIImageView *tempView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.png"]];
            photo.srcImageView = photoArray[i]; //来源于哪个UIImageView
            [photos addObject:photo];
        }
        //取消键盘
        [textView resignFirstResponder];
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = selectImage.tag; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

-(void)deletePhotoAtIndex:(NSInteger)photoIndex andPhotoTag:(NSInteger)photoTag
{
    //[self addButtonBadge];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_LinFriendCircleTableview deselectRowAtIndexPath:indexPath animated:NO];
    //点击回复列表  设置回复对象
    if (indexPath.row>0) {
        NSArray *review_list = self.detailInfo.com_list;
        NSLog(@"");
        NSDictionary *one_user_review = [review_list objectAtIndex:(indexPath.row-1)];
        com_user_review = [Base64Tool fuckNULL:[one_user_review objectForKey:@"user_name"]];
        com_userid_review = [Base64Tool fuckNULL:[one_user_review objectForKey:@"u_id"]];
        NSString *backStr = [NSString stringWithFormat:@"回复给%@",com_user_review];
        NSLog(@"回复给哪个用户%@=====%@",com_user_review,com_userid_review);
        //设置背景字
        backLable.text = backStr;
        backLable.textColor = [UIColor grayColor];
        if (textView.text.length == 0) {
            backLable.hidden = NO;
        }
        
        //[textView addSubview:backLable];
    }else{
        com_userid_review = @"0";
        textView.textColor = [UIColor grayColor];
        NSString *backStr = [NSString stringWithFormat:@"回复贴主"];
        backLable.text =backStr;
        backLable.textColor = [UIColor grayColor];
        [textView addSubview:backLable];
        if (textView.text.length == 0) {
            backLable.hidden = NO;
        }else{
            backLable.hidden = YES;
        }
    }
    if (keyboardHide) {
        [textView becomeFirstResponder];
        //keyboardHide = NO;
    }
    else {
        [textView resignFirstResponder];
        //textView.text = @"";
        keyboardHide = YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 80;
        //正文
        NSString *com_text = self.detailInfo.com_text;
        int length_text = [self length_str:com_text];
        int com_text_line = length_text/18+1;
        height += com_text_line * 20;
        //图片
        int picCount = 0;
        for (NSString *pic_str in self.detailInfo.com_pic) {
            if (pic_str.length <= 1) {
                //
            }else{
                picCount++;
            }
        }
        if (picCount <= 1) {
            picHeight = picCount*130;
            height += picHeight;
        }else if(picCount <= 4){
            int lines = picCount/2;
            if (picCount%2) {
                lines++;
            }
            picHeight = 105*lines;
            height += picHeight;
        }else{
            int line = picCount/3;
            if (picCount%3) {
                line++;
            }
            picHeight = 80*line;
            height += picHeight;
        }
        //语音
        if (self.detailInfo.com_voice != nil && self.detailInfo.com_voice.length > 1) {
            height += 40;
        }
        backgroundy = height;
    }else{
        NSArray *review_list = self.detailInfo.com_list;
        
        NSDictionary *one_user_review = [review_list objectAtIndex:(indexPath.row-1)];
        NSString *rev_text = [one_user_review objectForKey:@"rev_text"];
        //为用户名头留白显示
        NSString *user_nickname_str = [Base64Tool fuckNULL:[one_user_review objectForKey:@"user_name"]];
        NSString *user_back_str = [Base64Tool fuckNULL:[one_user_review objectForKey:@"return_user_name"]];
        
        NSString *tempUserName = user_nickname_str;
        if (user_back_str!=nil && user_back_str.length>0) {
            tempUserName = [NSString stringWithFormat:@"%@回复%@: ",tempUserName,user_back_str];
        }else{
            tempUserName = [NSString stringWithFormat:@"%@: ",tempUserName];
        }
        rev_text = [NSString stringWithFormat:@"%@ %@",tempUserName,rev_text];
        
        if (t_OHAttributedLabel)
        {
            [t_OHAttributedLabel removeFromSuperview];
        }
        //内容
        g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        if (g_nsdicemojiDict == nil)
        {
            g_nsdicemojiDict = [NSMutableDictionary dictionary];
            
            g_nsdicemojiDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
        }
        OHAttributedLabel*  textLabelEx = nil;
        textLabelEx = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        textLabelEx.tag = 0;
        [textLabelEx setNeedsDisplay];
        NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",rev_text] emojiDic:g_nsdicemojiDict];
        //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
        wk_markupParser = [[MarkupParser alloc] init];
        NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
        [attString setFont:[UIFont systemFontOfSize:13]];
        [textLabelEx setBackgroundColor:[UIColor clearColor]];
        [textLabelEx setAttString:attString withImages:wk_markupParser.images];
        //int review_text_y = user_name_label.frame.origin.y + user_name_label.frame.size.height;
        textLabelEx.frame = CGRectMake(50,5, 230,100);
        CGRect labelRect = textLabelEx.frame;
        labelRect.size.width = [textLabelEx sizeThatFits:CGSizeMake(240, CGFLOAT_MAX)].width;
        labelRect.size.height = [textLabelEx sizeThatFits:CGSizeMake(240, CGFLOAT_MAX)].height;
        textLabelEx.frame = labelRect;
        textLabelEx.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
        [textLabelEx.layer display];
        [CustomMethod drawImage:textLabelEx];
        [reviewArray addObject:textLabelEx];
        height = textLabelEx.frame.size.height;
        height += 2;
        if (indexPath.row == 1) {
            height += 7;
        }else{
            if (indexPath.row == [review_list count]) {
                //height += 8;
            }
        }
    }
    //backgroundheight += height;
    NSLog(@"当前cell的高度是多少%f",height);
    [reviewHeight addObject:[NSNumber numberWithFloat:height]];
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //回复列表 + 详情显示
    if (self.detailInfo == nil) {
        return 0;
    }else{
        if ([self.detailInfo.com_list count] > 5) {
            return [self.detailInfo.com_list count]+1;
        }
        else{
            NSLog(@"%lu",(unsigned long)[self.detailInfo.com_list count]);
            return 1+[self.detailInfo.com_list count];
        }
    }
}


//- (void)faceBoardTextViewDidChange:(UITextView *)textView
//{
//    NSLog(@"ddddd");
//}

-(void)faceBoardTextViewDidChange:(UITextView *)tView andDelete:(BOOL)isDelete
{
    NSLog(@"mytext%@",tView.text);
    if (tView.text.length > 0) {
        backLable.hidden = YES;
    }
}

-(void)faceBoardDeleteFinsish:(UITextView *)text
{
    NSLog(@"%@",text.text);
    if (text.text.length == 0) {
        backLable.hidden = NO;
    }
}

-(void)textFieldDidChange:(UITextField*)textField
{
    NSLog(@"textview begin edit");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textView resignFirstResponder];
}

-(void)setShareButton
{
    NSMutableArray *items = [NSMutableArray array];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setImage:LoadNormalImage(@"xq_share.png") forState:UIControlStateNormal];
    [rightButton setImage:LoadNormalImage(@"xq_share_hover.png") forState:UIControlStateHighlighted];
    [rightButton addTarget:self
                    action:@selector(share)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -20);
    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [items addObject:collectionItem];
    self.navigationItem.rightBarButtonItems = items;
}

#pragma mark ---- 分享 功能暂不需要
-(void)share
{
    [self UserSharePoint];
    //分享什么东西？？？？？？？
    NSString *url = [[[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"api"]objectForKey:@"share"];
    url = [NSString stringWithFormat:@"%@?com_id=%@",url,self.com_id];
    NSString *sinaText = [NSString stringWithFormat:@"如e生活 %@",url];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"如e生活"
                                     shareImage:[UIImage imageNamed:@"shareIcon"]
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = sinaText;
    
}
#pragma mark --- 11.28 点击分享按钮就加积分
- (void) UserSharePoint {
    if (ApplicationDelegate.islogin == YES) {
        NSString *url = connect_url(@"share_point");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"u_id":[UserModel shareInstance].u_id
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                //                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您尚未登录，无法给您增加积分"];
    }
}
#pragma mark--------分享回掉方法（弃用）
//#pragma mark - UM share delegate
-(void)didFinishGetUMSocialDataInViewController1:(UMSocialResponseEntity *)response
{
    NSLog(@"进入代理方法");
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        if (ApplicationDelegate.islogin == YES) {
            NSString *url = connect_url(@"share_point");
            NSDictionary *dict = @{
                                   @"app_key":url,
                                   @"u_id":[UserModel shareInstance].u_id
                                   };
            [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                if ([param[@"code"] integerValue]==200) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                }
            } andErrorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您尚未登录，无法给您增加积分"];
        }
    }
    else if (response.responseCode == UMSResponseCodeFaild){
        [SVProgressHUD showSuccessWithStatus:@"分享失败"];
    }
}

-(void)getFile
{
    //    NSString *urlStr = _lin_com_voice;
    //    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    //    NSData *audioData = [NSData dataWithContentsOfURL:url];
    //    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [VoiceRecorderBase getPathByFileName:@"temp" ofType:@"amr"];
    //    NSLog(@"filePath ==== %@",filePath);
    //    [audioData writeToFile:filePath atomically:YES];
    //转换后文件路径
    wavPath =[VoiceRecorderBase getPathByFileName:@"fuck" ofType:@"wav"];
    NSLog(@"声音urlStr %@" ,wavPath);
    //转格式
    int result = [VoiceConverter amrToWav:filePath  wavSavePath:wavPath];
    NSLog(@"转换的结果%d",result);
    //获取时间长度
    //播放本地音乐
    NSURL *fileURL = [NSURL fileURLWithPath:wavPath];
    NSLog(@"%@",fileURL);
    
    //初始化音频类 并且添加播放文件
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    if (_player) {
        second = _player.duration;
        NSLog(@"总时间长%d",second);
    }
}

//播放帖子语音
-(void)ActionPlay
{
    if (is_play) {
        //换图片
        [strechTestNo setImage:[UIImage imageNamed:@"issue_voice_sel.png"]];
        is_play = NO;
        if (![_lin_com_voice isEqualToString:@""]) {
            //设置代理
            if (_player == nil)
            {
                NSLog(@"ERror creating player: %@", [playerError description]);
            }else{
                [_player prepareToPlay];
                _player.delegate = self;
                _player.currentTime = 0;
                _player.volume = 1.0;
                [_player play];
                timer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                                       target:self
                                                     selector:@selector(LinplayMusic)
                                                     userInfo:nil
                                                      repeats:YES];
            }
        }
        //换回来
        [strechTestNo setImage:[UIImage imageNamed:@"issue_voice_sel.png"]];
    }else{
        is_play = YES;
        [_player stop];
        [timer invalidate];
        [btnimage setImage:[UIImage imageNamed:@"issue_play_03@2x.png"]];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"声音播放完毕~~~");
    _player.delegate =nil;
    is_play = YES;
    //停止播放动画
    [timer invalidate];
    [btnimage setImage:[UIImage imageNamed:@"issue_play_03@2x.png"]];
}

-(void)LinplayMusic
{
    imagePage++;
    imagePage %= 4;
    NSString *imageString = [NSString stringWithFormat:@"issue_play_0%d@2x.png",imagePage];
    [btnimage setImage:[UIImage imageNamed:imageString]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_player stop];
    [SVProgressHUD dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHiddenTabbar:YES];
}
#pragma mark----屏幕适配
-(void)changeSize
{
    if (IS_HEIGHT_GTE_568==0) {
        CGRect rect = _LinFriendCircleTableview.frame;
        rect.size.height = 387;
        _LinFriendCircleTableview.frame = rect;
        toolBar.frame = CGRectMake(0, 425, 320, 55);
    }
}

-(void)viewDidLayoutSubviews
{
    [UZCommonMethod hiddleExtendCellFromTableview:_LinFriendCircleTableview];
    [self changeSize];
}

-(void)viewDidAppear:(BOOL)animated
{
    //[_LinFriendCircleTableview reloadData];
}
//
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
