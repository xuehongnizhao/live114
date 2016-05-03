//
//  EvenMoreListViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/22.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EvenMoreListViewController.h"

#import "RDVTabBarController/RDVTabBarController.h"

#import "EvenMoreToWebViewController.h"
#import "EvenMoreFeedbackViewController.h"


#import "EvenMore.h"
#import "EvenMoreIsToJump.h"


#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size];

@interface EvenMoreListViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

// ---------------------- UI 控件 ----------------------
/** 列表显示的TableView */
@property (weak, nonatomic)     UITableView *evenMoreTableView;

// ---------------------- 数据模型 ----------------------
/** 数据源 */
@property (strong, nonatomic)   NSArray     *moreArray;



@end

@implementation EvenMoreListViewController



#pragma mark ----- 生命周期

/**
 *  页面加载之后 调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initUI];
}

/**
 *  内存不足调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  页面 即将加载 调用
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self. rdv_tabBarController setTabBarHidden:YES animated:YES];
}

/**
 *  页面 即将消失 调用
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}


#pragma mark ----- 初始化UI控件

/**
 *  初始化UI控件
 */
- (void) initUI {
    [self settingNav];
    [self evenMoreTableView];
}


/**
 *  设置导航栏
 */
- (void) settingNav {
    [self setHiddenTabbar:YES];
    self.navigationItem.title = @"更多";
}

/**
 *  添加一个 tableView
 *
 *  @return UITableView
 */
- (UITableView *)evenMoreTableView {
    
    if (_evenMoreTableView == nil) {
        
        CGFloat moreX     = self.view.frame.origin.x;
        CGFloat moreY     = self.view.frame.origin.y;
        CGFloat moreW     = self.view.frame.size.width;
        CGFloat moreH     = self.view.frame.size.height;
        CGRect  moreFrame = CGRectMake(moreX, moreY, moreW, moreH);
        UITableView *evenMoreTableView    = [[UITableView alloc] initWithFrame:moreFrame style:UITableViewStyleGrouped];
        evenMoreTableView.dataSource      = self;
        evenMoreTableView.delegate        = self;
        _evenMoreTableView                = evenMoreTableView;
        [self.view addSubview:_evenMoreTableView];
    }
    return _evenMoreTableView;
}



#pragma mark ----- 初始化数据

/**
 *  数据初始化
 */
- (void) initData {
    
    // 第一组
    EvenMore *aboutApp     = [[EvenMore alloc] init];
    aboutApp.moreName      = @"关于如意生活";
    aboutApp.moreImageName = @"more_about";
    
    EvenMore *privacy      = [[EvenMore alloc] init];
    privacy.moreName       = @"权限隐私";
    privacy.moreImageName  = @"more_privacyt";
    NSArray *group1        = @[aboutApp, privacy];
    
    // 第二组
    EvenMore *feedback     = [[EvenMore alloc] init];
    feedback.moreName      = @"意见反馈";
    feedback.moreImageName = @"more_feedback";
    
    EvenMore *score        = [[EvenMore alloc] init];
    score.moreName         = @"给我打分";
    score.moreImageName    = @"more_score";
    NSArray *group2        = @[feedback, score];
    
    // 第三组
    EvenMore *help         = [[EvenMore alloc] init];
    help.moreName          = @"使用帮助";
    help.moreImageName     = @"more_help";
    
    EvenMore *code         = [[EvenMore alloc] init];
    code.moreName          = @"我的二维码";
    code.moreImageName     = @"more_code";
    NSArray *group3        = @[help, code];
    
    // 第四组
    EvenMore *clear        = [[EvenMore alloc] init];
    clear.moreName         = @"清理缓存";
    clear.moreImageName    = @"more_clear";
    
    EvenMore *update       = [[EvenMore alloc] init];
    update.moreName        = @"检测更新";
    update.moreImageName   = @"more_update";
    NSArray *group4        = @[clear];
    
    self.moreArray  = @[group1, group2, group3, group4];
    
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
    return self.moreArray.count;
}


/**
 *  返回 每组显示多少个Cell
 *
 *  @param  tableView
 *  @param  section
 *
 *  @return NSInteger
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.moreArray[section];
    return array.count;
}


/**
 *  返回 每个cell展示的数据 和 样式
 *
 *  @param  tableView
 *  @param  indexPath
 *
 *  @return UITableViewCell
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellName = @"evenMoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    NSArray  *array          = self.moreArray[indexPath.section];
    EvenMore *evenMore       = array[indexPath.row];
    cell.imageView.image     = [UIImage imageNamed:evenMore.moreImageName];
    cell.textLabel.text      = evenMore.moreName;
    cell.textLabel.textColor = UIColorFromRGB(0x606366);
    cell.textLabel.font      = SYSTEM_FONT_SIZE(14);
    cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/**
 *  返回每个分组的 高度
 *
 *  @param  tableView
 *  @param  section
 *
 *  @return CGFloat
 */
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 10;
}



#pragma mark ----- UITableView delegate

/**
 *  点击每个 cell 的操作
 *
 *  @param tableView
 *  @param indexPath
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EvenMoreToWebViewController *morWebView = [[EvenMoreToWebViewController alloc] init];
    
    EvenMoreIsToJump *evenMoreJump = [[EvenMoreIsToJump alloc] init];
    if (indexPath.section == 0) {
        
        // 关于App
        if (indexPath.row == 0) {
            evenMoreJump.isAboutApp = YES;
            morWebView.evenMoreJomp = evenMoreJump;
            [morWebView setNavBarTitle:@"关于APP" withFont:14.0f];
            [self.navigationController pushViewController:morWebView animated:YES];
        }
        
        //隐私权限
        if (indexPath.row == 1) {
            evenMoreJump.isPrivacy  = YES;
            morWebView.evenMoreJomp = evenMoreJump;
            [morWebView setNavBarTitle:@"隐私权限" withFont:14.0f];
            [self.navigationController pushViewController:morWebView animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            NSLog(@"意见反馈");
            EvenMoreFeedbackViewController *feedback = [[EvenMoreFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
        }
        
        if (indexPath.row == 1) {
            NSLog(@"给我打分");
            [self toScore];
        }
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            NSLog(@"使用帮助");
            evenMoreJump.isHelp     = YES;
            morWebView.evenMoreJomp = evenMoreJump;
            [morWebView setNavBarTitle:@"使用帮助" withFont:14.0f];
            [self.navigationController pushViewController:morWebView animated:YES];
        }
        
        if (indexPath.row == 1) {
            NSLog(@"二维码分享");
            evenMoreJump.isCode = YES;
            morWebView.evenMoreJomp = evenMoreJump;
            [morWebView setNavBarTitle:@"我的二维码" withFont:14.0f];
            [self.navigationController pushViewController:morWebView animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            NSLog(@"清理缓存");
            [self clearCache];
        }
        
        if (indexPath.row == 1) {
            [self checkVersion];
        }
    }
    
}


/**
 *  给我打分
 */
- (void) toScore {
    
    NSInteger appID = 1;
    NSString  *str  = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


/**
 *  清理缓存
 */
- (void) clearCache {
    
    SDImageCache *sd = [SDImageCache sharedImageCache];
    // 获取 缓存文件的 长度
    if (sd.getSize == 0) {
        [SVProgressHUD showSuccessWithStatus:@"已经没有缓存文件啦！"];
        return;
    }
    [sd clearMemory];
    [sd clearDisk];
    [SVProgressHUD showSuccessWithStatus:@"已经清理完毕..."];
}

/**
 *  检测更新
 */
-(void)checkVersion {
    
    NSString *cr_version  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *net_version = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_v"];
    //
    if ([net_version compare:cr_version] == 1) {
        // 是否强制更新
        NSString *is_update = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"] objectForKey:@"is_update"] ;
        // 取出 更新内容
        NSString *hintStr = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"] objectForKey:@"ios_desc"] ;
        
        if ([is_update intValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"强制版本更新" message:hintStr delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:hintStr delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:@"暂时不要了", nil];
            alert.tag = 1;
            [alert show];
        }
    }
}

#pragma mark-------alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSString *downLoadUrl = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_download"] ;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoadUrl]];
        }
    }
}





@end
