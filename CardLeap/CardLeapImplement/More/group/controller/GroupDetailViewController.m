//
//  GroupDetailViewController.m
//  CardLeap
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  团购

#import "GroupDetailViewController.h"
#import "groupDetailInfo.h"
#import "groupDetailTableViewCell.h"
#import "GroupSubmitViewController.h"
#import "ReviewListViewController.h"
#import "UMSocial.h"

@interface GroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,purchaseDelegate,UMSocialUIDelegate,UIAlertViewDelegate,orderGroupCellWebViewHeight>
{
    groupDetailInfo *detailInfo;
    CGFloat webHeight;
    BOOL is_finish;
}
@property (strong,nonatomic)UIButton *shareButton;
@property (strong,nonatomic)UITableView *groupDetailTableview;
@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getDataFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHiddenTabbar:YES];
}

#pragma mark-------get web height
//-(void)getHeightForWeb:(NSString*)urlString
//{
//    UIWebView *tmpWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 600, 320, 10)];
//    tmpWeb.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:tmpWeb];
//    tmpWeb.delegate = self;
//    [tmpWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
//}
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSLog(@"加载完成，获取高度");
//    //document.getElementById(\"foo\").offsetHeight   offsetHeight
//    //@"document.body.scrollHeight"
//    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//    webHeight = [height_str floatValue];
//    is_finish = YES;
//    [self.groupDetailTableview reloadData];
//    [webView removeFromSuperview];
//    webView = nil;
//}

#pragma mark-------init data
-(void)initData
{
    webHeight = 0;
    is_finish = NO;
}

#pragma mark-------get data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"group_content");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"group_id":self.group_id
                           };
    [SVProgressHUD showWithStatus:@"数据加载..." maskType:SVProgressHUDMaskTypeBlack];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        [SVProgressHUD dismiss];
        if ([param[@"code"] integerValue]==200) {
            NSDictionary *detailDic = param[@"obj"];
            detailInfo = [[groupDetailInfo alloc] initWithDictionary:detailDic];
            [self.groupDetailTableview reloadData];
//            [self getHeightForWeb:detailInfo.message_url];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-------set UI
-(void)setUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.groupDetailTableview];
    [_groupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_groupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-2.0f];
    [_groupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_groupDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}

#pragma mark - web页加载完毕，计算web 高度

-(void) webViewDidLoad:(CGFloat )height
{
    webHeight = height;
    [SVProgressHUD dismiss];
    if (is_finish == NO) {
        is_finish = YES;
        [self.groupDetailTableview reloadData];
        self.groupDetailTableview.scrollEnabled = YES;
    }
}

-(void) webViewFailLoadWithError:(NSError *)error
{
    NSLog(@"web页加载失败:error:%@",error);
    //    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
}

#pragma mark-------get UI
-(UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_shareButton setImage:[UIImage imageNamed:@"coupon_share_no"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"coupon_share_sel"] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.imageEdgeInsets =  UIEdgeInsetsMake(0, 10, 0, -10);
    }
    return _shareButton;
}

-(UITableView *)groupDetailTableview
{
    if (!_groupDetailTableview) {
        _groupDetailTableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _groupDetailTableview.translatesAutoresizingMaskIntoConstraints = NO;
        _groupDetailTableview.delegate = self;
        _groupDetailTableview.dataSource = self;
        _groupDetailTableview.separatorInset = UIEdgeInsetsZero;
        _groupDetailTableview.scrollEnabled = NO;
        [UZCommonMethod hiddleExtendCellFromTableview:_groupDetailTableview];
    }
    return _groupDetailTableview;
}

#pragma mark-------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    NSInteger section = indexPath.section;
    if (section == 2 ) {
            NSLog(@"跳转到评价列表");
        if (detailInfo !=nil) {
            ReviewListViewController *firVC = [[ReviewListViewController alloc] init];
            firVC.shop_id = detailInfo.shop_id;
            firVC.index = @"1";
            firVC.group_id = detailInfo.group_id;
            [firVC setNavBarTitle:@"评价" withFont:14.0f];
            [self.navigationController pushViewController:firVC animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络缓慢,请稍等"];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat height = 0.0;
    switch (section) {
        case 0:
            if (row == 0) {
                height = 180.0f;
            }else{
                height = 50.0f;
            }
            break;
        case 1:
            height = 50;
            if (detailInfo == nil) {
                NSString *group_brief = self.info.group_name;
                UITextView *text = [[UITextView alloc] init];
                text.font = [UIFont systemFontOfSize:15.0f];
                text.layer.borderWidth = 1;
                text.text = group_brief;
                CGRect rect = self.view.frame;
                text.bounds = CGRectMake(10, 10, rect.size.width - 20, 100);
                [text sizeToFit];
                CGFloat my_height = text.frame.size.height;
                if (my_height > 30) {
                    my_height = 30;
                }else if(my_height < 13) {
                    my_height = 20;
                }
                height += my_height;
            }else{
                NSString *group_brief = detailInfo.group_name;
                UITextView *text = [[UITextView alloc] init];
                text.font = [UIFont systemFontOfSize:15.0f];
                text.layer.borderWidth = 1;
                text.text = group_brief;
                CGRect rect = self.view.frame;
                text.bounds = CGRectMake(10, 10, rect.size.width - 20, 100);
                [text sizeToFit];
                CGFloat my_height = text.frame.size.height;
                if (my_height > 30) {
                    my_height = 30;
                }else if(my_height < 13) {
                    my_height = 20;
                }
                height += my_height;
            }
            break;
        case 2:
            //需要计算？
            height = 40.0f;
            break;
        case 3:
            height = 30.0f;
            if (row == 0) {
                
            }else{
                height = 20.0f;
#warning 12.10 优化计算cell高度 by CC
                if (detailInfo == nil) {
                    NSString *shop_name = self.info.shop_name;
                    if (shop_name != nil && [shop_name isEqualToString:@""] == NO) {
                        CGSize shop_name_size = [self calculateLabelSizeOfContent:shop_name withFont:[UIFont systemFontOfSize:15.0f]];
                        if (shop_name_size.height > 36) {
                            shop_name_size.height = 36;
                        }
                        height += shop_name_size.height;
                    }
                    NSString *shop_address = self.info.shop_address;
                    if (shop_address.length < 30) {
                        height += 15.0f;
                    }else{
                        height += (shop_address.length/25+1)*15.0f;
                    }
                }else{
                    NSString *shop_name = detailInfo.shop_name;
                    if (shop_name != nil && [shop_name isEqualToString:@""] == NO) {
                        CGSize shop_name_size = [self calculateLabelSizeOfContent:shop_name withFont:[UIFont systemFontOfSize:15.0f]];
                        if (shop_name_size.height > 36) {
                            shop_name_size.height = 36;
                        }
                        height += shop_name_size.height;
                    }
                    NSString *shop_address = detailInfo.shop_address;
                    if (shop_address.length < 30) {
                        height += 15.0f;
                    }else{
                        height += (shop_address.length/25+1)*15.0f;
                    }
                }
            }
            break;
        case 4:
            if (row == 0) {
                height = 30.0f;
            }else{
                //计算获取
                if (is_finish == NO) {
                    height = 280.0f;
                }else{
                    height = webHeight;
                }
            }
            break;
        default:
            break;
    }
    return height;
}

//根据字体大小自动计算label大小
- (CGSize)calculateLabelSizeOfContent:(NSString*)text withFont:(UIFont*)font
{
    const CGSize defaultSize = CGSizeMake(SCREEN_WIDTH-75, 15);
    
    if (text == nil || text.length == 0) {
        return defaultSize;
    }
    
    CGSize titleSize = CGSizeZero;
    if ([text isKindOfClass:[NSString class]]) {
        titleSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        if (titleSize.height < defaultSize.height) {
            titleSize.height = defaultSize.height;
        }
    }
    return titleSize;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"group_detail_cell";
    groupDetailTableViewCell *cell=(groupDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[groupDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (detailInfo == nil) {
        [cell confirgureCell:self.info row:row section:section];
    }else{
        [cell confirgureDetailCell:detailInfo row:row section:section];
    }
    cell.delegate = self;
    if (indexPath.section == 4 && indexPath.row != 0) {
        [SVProgressHUD showWithStatus:@"数据加载..." maskType:SVProgressHUDMaskTypeBlack];
        // web页面加载，计算高度代理
        cell.webViewHeightDelegate = self;
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count;
    switch (section) {
        case 0:
            count = 2;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            count = 1;
            break;
        case 3:
            count = 2;
            break;
        case 4:
            count = 2;
            break;
        default:
            break;
    }
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (detailInfo != nil && self.info != nil) {
        return 5;
    }
    
    if (detailInfo == nil && self.info == nil) {
        return 0;
    }
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

#pragma mark-------button action  and other delegate
-(void)shareAction:(UIButton*)sender
{
    [self UserSharePoint];
    //NSString *url = @"www.baidu.com";
    NSString *sinaText = [NSString stringWithFormat:@"如e生活 %@",detailInfo.share_url];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"如e生活"
                                     shareImage:[UIImage imageNamed:@"shareIcon"]
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = detailInfo.share_url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = detailInfo.share_url;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = @"如e生活";
    [UMSocialData defaultData].extConfig.qzoneData.url = detailInfo.share_url;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaText;
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = detailInfo.share_url;
}
#warning 11.28 点击分享按钮就加积分
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
-(void)didFinishGetUMSocialDataInViewController1:(UMSocialResponseEntity *)response
{
    NSLog(@"分享完成，去执行接口增加积分");
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

-(void)go2PurchaseDelegate
{
    if (detailInfo !=nil) {
        GroupSubmitViewController *firVC = [[GroupSubmitViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:detailInfo.shop_name withFont:14.0f];
//        [firVC.navigationItem setTitle:detailInfo.shop_name];
        firVC.submitInfo = detailInfo;
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前网络异常"];
    }
}

-(void)callPhone
{
    NSLog(@"拨打电话");
    if (detailInfo !=nil) {
       //[UZCommonMethod callPhone:detailInfo.shop_tel superView:self.view];
        NSArray *array = [detailInfo.shop_tel componentsSeparatedByString:@" "];
        if ([array count]==1) {
            [UZCommonMethod callPhone:array[0] superView:self.view];
        }else{
            NSString *tel_one = [array objectAtIndex:0];
            NSString *tel_two = [array objectAtIndex:1];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系商家" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:tel_two, tel_one,nil];
            alert.tag = 2;
            [alert show];
        }
        
    }else{
       [SVProgressHUD showErrorWithStatus:@"当前网络异常"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        
    }else{
        NSArray *array = [detailInfo.shop_tel componentsSeparatedByString:@" "];
        NSString *tel_one = [array objectAtIndex:0];
        NSString *tel_two = [array objectAtIndex:1];
        if (buttonIndex == 2) {
            [UZCommonMethod callPhone:tel_one superView:self.view];
        }else if (buttonIndex == 1){
            [UZCommonMethod callPhone:tel_two superView:self.view];
        }

    }
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
