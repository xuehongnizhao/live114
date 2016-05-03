//
//  ShopTakeOutViewController.m
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  外卖- 商家菜品列表

#import "ShopTakeOutViewController.h"
#import "shopTakeCateInfo.h"
#import "takeoutDishInfo.h"
#import "ShopDishTableViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "dishCateInfo.h"
#import "JSBadgeView.h"
#import "ShopTakeOutDetailViewController.h"
#import "ShopDishConfirmViewController.h"
#import "DishDetailView.h"
#import "XHRealTimeBlur.h"

@interface ShopTakeOutViewController ()<UITableViewDataSource,UITableViewDelegate,ActionDelegate,DishDetailViewDelegate>
{
    NSMutableArray *cateArrary ;
    NSMutableArray *dishArray ;
    shopTakeCateInfo *myInfo ;
    int page ;
    NSString *cate_id ;
    NSString *cate_name;
    //-----total--------
    int total_num;
    float total_price;
    //-----data---------
    NSMutableDictionary *dataDict;
    NSMutableDictionary *pageDict;
    BOOL is_first;
}
@property (strong, nonatomic) UIView *messageView;
@property (strong, nonatomic) UITableView *cateTableview;
@property (strong, nonatomic) UITableView *dishTableview;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIView *operationView;
@property (strong, nonatomic) UIImageView *shopCar;
@property (strong, nonatomic) UILabel *priceLable;
@property (strong, nonatomic) UIButton *subButton;
@end

@implementation ShopTakeOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getCateFromNet];
    self.view.alpha = 1.0f;
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------网络获取数据
-(void)getCateFromNet
{
    NSString *url = @"takeout/ac_takeout/takeout_message";
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"shop_id":self.shop_id
                           };
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *dic = [param objectForKey:@"obj"];
            myInfo = [[shopTakeCateInfo alloc] initWithDictionary:dic];
            [_cateTableview reloadData];
            while ([[_messageView subviews] lastObject]!= nil) {
                [[[_messageView subviews] lastObject] removeFromSuperview];
            }
            [self setShopMessageView:myInfo.begin_price speed:myInfo.shipping inTime:myInfo.ship_price ];
            if ([myInfo.cate count]>0) {
                dishCateInfo *dishCate = [myInfo.cate objectAtIndex:0];
                cate_id = dishCate.cate_id;
                cate_name = dishCate.cate_name;
                [self getDishFromNet];
            }else{
                [SVProgressHUD showErrorWithStatus:@"当前商家尚未添加任何菜品"];
            }
            //[SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

-(void)getDishFromNet
{
    NSString *url = connect_url(@"takeout_message_index");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"shop_id":self.shop_id,
                           @"cat_id":cate_id
                           };
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            if (page == 1) {
                [dishArray removeAllObjects];
            }
            [SVProgressHUD dismiss];
            NSArray *array = [param objectForKey:@"obj"];
            for (NSDictionary *dic in array) {
                takeoutDishInfo *info = [[takeoutDishInfo alloc] initWithDictionary:dic];
                info.count = 0;
                [dishArray addObject:info];
                //[dataArray addObject:info];
            }
            //存储数据
            [dataArray addObjectsFromArray:dishArray];
            [dataDict setObject:dataArray forKey:cate_id];
            [pageDict setObject:[NSString stringWithFormat:@"%d",page] forKey:cate_id];
            [_dishTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
        [_dishTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-----初始化数据
-(void)initData
{
    dataDict = [[NSMutableDictionary alloc] init];
    cateArrary = [[NSMutableArray alloc] init];
    dishArray = [[NSMutableArray alloc] init];
    pageDict = [[NSMutableDictionary alloc] init];
    page = 1;
    cate_id = @"0";
    total_num = 0;
    total_price = 0.0;
    is_first = YES;
}

#pragma mark-----set UI
-(void)setUI
{
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.messageView];
    [_messageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_messageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_messageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_messageView autoSetDimension:ALDimensionHeight toSize:80.0f];
    if (self.info != nil) {
        [self setShopMessageView:self.info.begin_price speed:self.info.timely inTime:self.info.shop_price ];
    }
    
    [self.view addSubview:self.cateTableview];
    [_cateTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_cateTableview autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_messageView withOffset:0.5];
    [_cateTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40.0f];
    [_cateTableview autoSetDimension:ALDimensionWidth toSize:100];
    
    [self.view addSubview:self.dishTableview];
    [_dishTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_dishTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40.0f];
    [_dishTableview autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_cateTableview withOffset:0.5f];
    [_dishTableview autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_messageView withOffset:0.5f];
    
    [self.view addSubview:self.operationView];
    [_operationView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_operationView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_operationView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_operationView  autoSetDimension:ALDimensionHeight toSize:39.5f];
    //添加分割线
    UIImageView *image = [[UIImageView alloc] initForAutoLayout];
    [image setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:image];
    [image autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_messageView withOffset:0.5];
    [image autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_cateTableview withOffset:0.0f];
    [image autoSetDimension:ALDimensionWidth toSize:0.5];
    [image autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_operationView withOffset:0.0f];
    
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [lineImage setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    [lineImage autoPinEdge:ALEdgeBottom  toEdge:ALEdgeTop ofView:image withOffset:0.0f];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.rightBarButtonItem = leftBarItem;
    
}

//设置商家外送的各种信息简介
#pragma mark-----set message view
/**
 *  设置商家外卖信息简介
 *
 *  @param reciveTime 起送价格
 *  @param speed      送餐时间
 *  @param percent    送餐费
 */
-(void)setShopMessageView :(NSString*)reciveTime speed:(NSString*)speed inTime:(NSString*)percent
{
    UIImageView *imageLine = [[UIImageView alloc] initForAutoLayout];
    imageLine.backgroundColor = [UIColor lightGrayColor];
    [_messageView addSubview:imageLine];
    [imageLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    [imageLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
    [imageLine autoSetDimension:ALDimensionWidth toSize:1.0f];
    [imageLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH/3.0];
    
    UIImageView *imageLine1 = [[UIImageView alloc] initForAutoLayout];
    imageLine1.backgroundColor = [UIColor lightGrayColor];
    [_messageView addSubview:imageLine1];
    [imageLine1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    [imageLine1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
    [imageLine1 autoSetDimension:ALDimensionWidth toSize:1.0f];
    [imageLine1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageLine withOffset:SCREEN_WIDTH/3.0f];
    
    //计算lable距离边界的宽度
    CGFloat blankWidth = (SCREEN_WIDTH/3.0-50-2)/2.0;
    //添加标注
    UILabel *reciveLable = [[UILabel alloc] initForAutoLayout];
    [_messageView addSubview:reciveLable];
    reciveLable.backgroundColor = UIColorFromRGB(0x28b582);
    reciveLable.textColor = [UIColor whiteColor];
    reciveLable.font = [UIFont systemFontOfSize:11.0];
    //    reciveLable.text = @"接单时间";
    reciveLable.text = @"起送价格";
    reciveLable.textAlignment = NSTextAlignmentCenter;
    [reciveLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [reciveLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:blankWidth];
    [reciveLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [reciveLable autoSetDimension:ALDimensionWidth toSize:50.0f];
    
    UILabel *acceptLable = [[UILabel alloc] initForAutoLayout];
    [_messageView addSubview:acceptLable];
    acceptLable.textColor = [UIColor lightGrayColor];
    acceptLable.font = [UIFont systemFontOfSize:11.0];
    acceptLable.text = ([self StringToBool:reciveTime] == YES)?[NSString stringWithFormat:@"%@元",reciveTime]:@"暂无数据";
    acceptLable.textAlignment = NSTextAlignmentCenter;
    [acceptLable autoAlignAxis:ALAxisVertical toSameAxisOfView:reciveLable];
    [acceptLable autoSetDimension:ALDimensionWidth toSize:50.0f];
    [acceptLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [acceptLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:reciveLable withOffset:5.0f];
    
    //送餐速度
    UILabel *speedLable = [[UILabel alloc] initForAutoLayout];
    [_messageView addSubview:speedLable];
    speedLable.backgroundColor = UIColorFromRGB(0xfb6f4c);
    speedLable.textColor = [UIColor whiteColor];
    speedLable.font = [UIFont systemFontOfSize:11.0];
    speedLable.text = @"送餐速度";
    speedLable.textAlignment = NSTextAlignmentCenter;
    [speedLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [speedLable autoSetDimension:ALDimensionWidth toSize:50.0f];
    [speedLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [speedLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageLine withOffset:blankWidth];
    
    UILabel *takeSpeedLable = [[UILabel alloc] initForAutoLayout];
    [_messageView addSubview:takeSpeedLable];
    takeSpeedLable.textColor = [UIColor lightGrayColor];
    takeSpeedLable.font = [UIFont systemFontOfSize:11.0];
    takeSpeedLable.text = ([self StringToBool:speed] == YES)?[NSString stringWithFormat:@"%@分钟",speed]:@"暂无数据";
    takeSpeedLable.textAlignment = NSTextAlignmentCenter;
    [takeSpeedLable autoAlignAxis:ALAxisVertical toSameAxisOfView:speedLable];
    [takeSpeedLable autoSetDimension:ALDimensionWidth toSize:50.0f];
    [takeSpeedLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [takeSpeedLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:speedLable withOffset:5.0f];
    
    //及时送达
    UILabel *timeLable = [[UILabel alloc] initForAutoLayout];
    [_messageView addSubview:timeLable];
    timeLable.backgroundColor = UIColorFromRGB(0x7fb1ee);
    timeLable.textColor = [UIColor whiteColor];
    timeLable.font = [UIFont systemFontOfSize:11.0];
    //    timeLable.text = @"及时送达";
    timeLable.text = @"送餐费";
    timeLable.textAlignment = NSTextAlignmentCenter;
    [timeLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [timeLable autoSetDimension:ALDimensionWidth toSize:50.0f];
    [timeLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [timeLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageLine1 withOffset:blankWidth];
    
    UILabel *inTimeLable = [[UILabel alloc] initForAutoLayout];
    [_messageView addSubview:inTimeLable];
    inTimeLable.textColor = [UIColor lightGrayColor];
    inTimeLable.font = [UIFont systemFontOfSize:11.0];
    inTimeLable.text = ([self StringToBool:percent] == YES)?[NSString stringWithFormat:@"%@元",percent]:@"暂无数据";
    inTimeLable.textAlignment = NSTextAlignmentCenter;
    [inTimeLable autoAlignAxis:ALAxisVertical toSameAxisOfView:timeLable];
    [inTimeLable autoSetDimension:ALDimensionWidth toSize:50.0f];
    [inTimeLable autoSetDimension:ALDimensionHeight toSize:20.0f];
    [inTimeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:timeLable withOffset:5.0f];
}
/**
 *  判断字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return 空：YES   非空：NO
 */
-(BOOL) StringToBool:(NSString *) string
{
    if (string == nil || [string isEqualToString:@""] == YES) {
        return NO;
    }
    return YES;
}

#pragma mark-----get UI

-(UIImageView *)shopCar
{
    if (!_shopCar) {
        _shopCar = [[UIImageView alloc] initForAutoLayout];
        [_shopCar setImage:[UIImage imageNamed:@"shopcar_icon"]];
    }
    return _shopCar;
}

-(UIButton *)subButton
{
    if (!_subButton) {
        _subButton = [[UIButton alloc] initForAutoLayout];
        [_subButton setBackgroundColor:UIColorFromRGB(0xe5565d)];
        [_subButton setTitle:@"去买单" forState:UIControlStateNormal];
        [_subButton setTitle:@"去买单" forState:UIControlStateHighlighted];
        [_subButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_subButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_subButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        _subButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _subButton;
}

-(UILabel *)priceLable
{
    if (!_priceLable) {
        _priceLable = [[UILabel alloc] initForAutoLayout];
        _priceLable.textColor = UIColorFromRGB(0xe5565d);
        _priceLable.font = [UIFont systemFontOfSize:13.0f];
        _priceLable.text = [NSString stringWithFormat:@"%d份  ￥%0.2f",total_num,total_price];
    }
    return _priceLable;
}

-(UIView *)operationView
{
    if (!_operationView) {
        _operationView = [[UIView alloc] initForAutoLayout];
        [_operationView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        [_operationView addSubview:self.shopCar];
        [_shopCar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_shopCar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_shopCar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_shopCar autoSetDimension:ALDimensionWidth toSize:30.0f];
        
        [_operationView addSubview:self.subButton];
        [_subButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
        [_subButton autoPinEdgeToSuperviewEdge:ALEdgeTop  withInset:3.0f];
        [_subButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:3.0f];
        [_subButton autoSetDimension:ALDimensionWidth toSize:80.0f];
        
        [_operationView addSubview:self.priceLable];
        [_priceLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0];
        [_priceLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
        [_priceLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopCar withOffset:10.0f];
        [_priceLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_subButton withOffset:-15.0f];
    }
    return _operationView;
}

-(UITableView *)cateTableview
{
    if (!_cateTableview) {
        _cateTableview = [[UITableView alloc] initForAutoLayout];
        _cateTableview.delegate = self;
        _cateTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_cateTableview];
        if ([_cateTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_cateTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_cateTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_cateTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _cateTableview;
}

-(UITableView *)dishTableview
{
    if (!_dishTableview) {
        _dishTableview = [[UITableView alloc] initForAutoLayout];
        _dishTableview.delegate = self;
        _dishTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_dishTableview];
        [_dishTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _dishTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _dishTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _dishTableview.footerRefreshingText = @" ";
        if ([_dishTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_dishTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_dishTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_dishTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _dishTableview;
}

-(UIView *)messageView
{
    if (!_messageView) {
        _messageView = [[UIView alloc] init];
        _messageView.backgroundColor = [UIColor whiteColor];
    }
    return _messageView;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        [_leftButton setImage:[UIImage imageNamed:@"navbusiness_no"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"navbusiness_sel"] forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

#pragma mark------加载下一页
-(void)footerBeginRefreshing
{
    page++;
    [self getDishFromNet];
}

#pragma mark-----click action
-(void)leftAction :(UIButton*)sender
{
    NSLog(@"跳商家详情");
    if (myInfo != nil) {
        ShopTakeOutDetailViewController *firVC = [[ShopTakeOutDetailViewController alloc] init];
        [firVC setNavBarTitle:@"如e商家" withFont:14.0f];
        //        [firVC.navigationItem setTitle:@"商家详情"];
        [firVC setHiddenTabbar:YES];
        firVC.info = myInfo;
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(void)submitAction :(UIButton*)sender
{
    NSLog(@"跳转到下一个页面了");
    if(total_num == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"生活助手" message:@"对不起，您还没点餐" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if(total_price < [myInfo.begin_price floatValue]){
            NSString *notice = [NSString stringWithFormat:@"该商家起送价格为%@",myInfo.begin_price];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notice message:@"您未满商家起送价格" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSMutableArray *submitArray = [[NSMutableArray alloc] init];
            NSArray *allkeys = [dataDict allKeys];
            for (NSString *cat_id in allkeys) {
                NSArray *array = [dataDict objectForKey:cat_id];
                for (takeoutDishInfo *tmpInfo in array) {
                    if (tmpInfo.count > 0) {
                        [submitArray addObject:tmpInfo];
                    }
                }
            }
            //跳转到下一个界面
            ShopDishConfirmViewController *firVC = [[ShopDishConfirmViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:@"确认美食" withFont:14.0f];
            //            [firVC.navigationItem setTitle:@"确认美食"];
            firVC.total_price = [NSString stringWithFormat:@"%f",total_price];
            firVC.total_count = [NSString stringWithFormat:@"%d",total_num];
            firVC.ship_price  = (myInfo == nil)? self.info.shop_price:myInfo.ship_price;
            firVC.dishArray = submitArray;
            firVC.shop_id = self.shop_id;
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }
}

#pragma mark-----table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _dishTableview) {
        return 0.0f;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _dishTableview) {
        //        UIView *view = [[UIView alloc] init];
        //        view.backgroundColor = UIColorFromRGB(0xfedcde);
        //        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 15)];
        //        titleLable.text = cate_name;
        //        titleLable.font = [UIFont systemFontOfSize:13.0f];
        //        [view addSubview:titleLable];
        //        return view;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTableview) {
        NSLog(@"点击分类");
        if (myInfo.cate.count>0) {
            dishCateInfo *myDishCate = [myInfo.cate objectAtIndex:indexPath.row];
            cate_id = myDishCate.cate_id;
            cate_name = myDishCate.cate_name;
            NSMutableArray *array = [dataDict objectForKey:cate_id];
            if (array == nil) {
                page = 1;
                [self getDishFromNet];
            }else{
                [dishArray removeAllObjects];
                [dishArray addObjectsFromArray:array];
                page = [[pageDict objectForKey:cate_id] intValue];
                [_dishTableview reloadData];
            }
        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)isRemoveFromSuperView:(BOOL)isremove
{
    if (isremove)
    {
        [self.view disMissRealTimeBlur];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTableview) {
        return  40.0f;
    }else{
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _dishTableview) {
        static NSString *simpleTableIdentifier=@"dish_cell";
        ShopDishTableViewCell *cell=(ShopDishTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell==nil)
        {
            cell = [[ShopDishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
        takeoutDishInfo *info = [dishArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        [cell configureCell:info index:indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (is_first) {
            if (indexPath.row == [dishArray count]-1 && [dishArray count]>0) {
                is_first = NO;
                NSIndexPath *first = [NSIndexPath
                                      indexPathForRow:0 inSection:0];
                [_cateTableview selectRowAtIndexPath:first
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionTop];
            }
        }
        return cell;
    }else{
        static NSString *simpleTableIdentifier=@"dish_cate_cell";
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
        if (myInfo != nil) {
            dishCateInfo *linInfo = [myInfo.cate objectAtIndex:indexPath.row];
            NSString *cate_str = linInfo.cate_name;
            cell.textLabel.text = cate_str;
            //数量
            UILabel *lable = [[UILabel alloc] initForAutoLayout];
            [cell.contentView addSubview:lable];
            [lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18.0f];
            [lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
            [lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
            [lable autoSetDimension:ALDimensionWidth toSize:5.0f];
            //添加数量
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:lable alignment:JSBadgeViewAlignmentTopLeft];
            badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)linInfo.count];
            if (linInfo.count == 0) {
                badgeView.hidden = YES;
            }
        }else{
            NSString *cate_str = [[self.info.cate objectAtIndex:indexPath.row] objectForKey:@"cat_name"];
            cell.textLabel.text = cate_str;
            cell.textLabel.textColor = UIColorFromRGB(singleTitle);
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _cateTableview) {
        if (myInfo== nil) {
            NSLog(@"cate count === %ld",(unsigned long)[self.info.cate count]);
            return [self.info.cate count];
        }else{
            NSLog(@"cate count === %ld",(unsigned long)[myInfo.cate count]);
            return [myInfo.cate count];
        }
    }else{
        NSLog(@"cate count === %ld",(unsigned long)[dishArray count]);
        return [dishArray count];
    }
}

#pragma mark-----------cell delegate
-(void)subAction:(takeoutDishInfo *)info dishCell:(ShopDishTableViewCell *)cell
{
    if (dishArray.count>0) {
        NSIndexPath *indexPath = [_dishTableview indexPathForCell:cell];
        takeoutDishInfo *info_lin = [dishArray objectAtIndex:indexPath.row];
        NSLog(@"info-----price--------%ld",(long)info_lin.count);
        total_num --;
        total_price -= [info_lin.take_price floatValue];
        _priceLable.text = [NSString stringWithFormat:@"%d份  ￥%0.2f",total_num,total_price];
        //提示减少
        for (dishCateInfo *LocalInfo in myInfo.cate) {
            if (LocalInfo.cate_id == cate_id) {
                LocalInfo.count --;
                break;
            }
        }
        [_cateTableview reloadData];
    }
    //------------------------
}

-(void)addAction:(takeoutDishInfo *)info dishCell:(ShopDishTableViewCell *)cell btn:(UIButton *)sender
{
    if (dishArray.count>0) {
        //提示增加
        for (dishCateInfo *LocalInfo in myInfo.cate) {
            if (LocalInfo.cate_id == cate_id) {
                LocalInfo.count ++;
                break;
            }
        }
        [_cateTableview reloadData];
        //--------------------------
        NSIndexPath *indexPath = [_dishTableview indexPathForCell:cell];
        takeoutDishInfo *info_lin = [dishArray objectAtIndex:indexPath.row];
        NSLog(@"info-----price--------%ld",(long)info_lin.count);
        total_num ++;
        total_price += [info_lin.take_price floatValue];
        //加入购物车动画效果
        CALayer *transitionLayer = [[CALayer alloc] init];
        //transitionLayer.borderWidth = 1;
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        transitionLayer.opacity = 1.0;
        transitionLayer.contents = sender.titleLabel.layer.contents;
        transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:sender.titleLabel.bounds fromView:sender.titleLabel];
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
        [CATransaction commit];
        
        //路径曲线
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:transitionLayer.position];
        CGPoint toPoint = CGPointMake(_operationView.center.x, _operationView.center.y+60);
        [movePath addQuadCurveToPoint:toPoint
                         controlPoint:CGPointMake(_operationView.center.x,transitionLayer.position.y-120)];
        //关键帧
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.path = movePath.CGPath;
        positionAnimation.removedOnCompletion = YES;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.beginTime = CACurrentMediaTime();
        group.duration = 0.7;
        group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
        group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        group.delegate = self;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.autoreverses= NO;
        [transitionLayer addAnimation:group forKey:@"opacity"];
        [self performSelector:@selector(addShopFinished:) withObject:transitionLayer afterDelay:0.5f];
    }
}

-(void)addShopFinished:(CALayer*)transitionLayer{
    transitionLayer.hidden = YES;
    NSLog(@"加入购物车之后做点什么");
    _priceLable.text = [NSString stringWithFormat:@"%d份  ￥%0.2f",total_num,total_price];
}

-(void)didselectImage:(NSInteger)indexpath
{
    takeoutDishInfo *info = [dishArray objectAtIndex:indexpath];
    //NSLog(@"info----%ld",(long)info.count);
    DishDetailView* ddv=[[DishDetailView alloc]initForAutoLayout];
    ddv.delegate=self;
    ddv.url = info.review_url;
    [ddv initWebViewContent];
    [self.view showRealTimeBlurWithBlurStyle:XHBlurStyleBlackTranslucent];
    [self.view addSubview:ddv];
    [ddv autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    [ddv autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [ddv autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [ddv autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
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
