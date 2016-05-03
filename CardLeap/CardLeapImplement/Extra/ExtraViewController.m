//
//  ExtraViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "ExtraViewController.h"
#import "CityCollectionViewCell.h"
#import "CityListViewController.h"
#import "CitySelectViewConstroller.h"
#import "OneCateController.h"

#import "CityAddController.h"
#import "LoginViewController.h"

#import "MJExtension.h"
#import "CityOneCate.h"
#import "CityTwoCate.h"




#define SUCCESS @"200"

@interface ExtraViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** 显示九宫格的 CollectionView */
@property (weak, nonatomic)     UICollectionView    *collView;

/** 同城分类信息  */
@property (strong, nonatomic)   NSArray             *cityCates;

/** 同城 */
@property (strong, nonatomic)   NSArray             *cityAddress;

/** 数组 */
@property (strong, nonatomic)   NSArray             *cityCateArray;

@end

static NSString *collName = @"collName";

@implementation ExtraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    [self setttingNavBar];
    
    [self getCityCateData];
    [self getCityAddress];
    
    [self collView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setHiddenTabbar:NO];
}

#pragma mark ----- 设置UI
/**
 *  设置导航栏
 */
- (void) setttingNavBar {
    // 设置title
    [self setNavBarTitle:@"同城" withFont:15.0f];
    // 搜索
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self selectButton]];
    // 发布按钮
    UIBarButtonItem *addCityButton = [[UIBarButtonItem alloc] initWithCustomView:[self insertButton]];
    self.navigationItem.rightBarButtonItem = addCityButton;
}

/**
 *  查询按钮
 *
 *  @return UIButton
 */
- (UIButton *) selectButton {
    
    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [selectButton setImage:[UIImage imageNamed:@"coupon_search_no"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"coupon_search_sel"] forState:UIControlStateHighlighted];
    selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
//    selectButton.layer.borderWidth =1;
//    selectButton.frame     = CGRectMake(0, 0, SCREEN_WIDTH, 30);
//    UIImageView *strechTestNo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_search"]];
//    //----图片拉伸参数-----
//    CGSize imageSize;
//    imageSize.width = strechTestNo.frame.size.width;
//    imageSize.height = strechTestNo.frame.size.height;
//    
//    CGSize stretchSize;
//    stretchSize.width = 50.0;
//    stretchSize.height = 120.0;
//    //-----图片拉伸方向----
//    [strechTestNo setContentStretch:CGRectMake(0.7f, 0.0f, stretchSize.width/imageSize.width,stretchSize.height/imageSize.height)];
//    CGRect frame = strechTestNo.frame;
//    CGFloat Width = SCREEN_WIDTH;
//    frame.size.width = Width-70;
//    frame.origin.y = 0;
//    frame.size.height = 30;
//    strechTestNo.frame = frame;
//    [selectButton addSubview:strechTestNo];
    //[selectButton setImage:strechTestNo.image forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(toSelectList) forControlEvents:UIControlEventTouchUpInside];
    return selectButton;
}

/**
 *  添加按钮
 *
 *  @return UIButton
 */
- (UIButton *) insertButton {
    UIButton    *insertButton = [[UIButton alloc] init];
    [insertButton setFrame:CGRectMake(0, 0, 40, 40)];
    [insertButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [insertButton setImage:[UIImage imageNamed:@"city_release_no"]  forState:UIControlStateNormal];
    [insertButton setImage:[UIImage imageNamed:@"city_release_sel"]  forState:UIControlStateHighlighted];
    [insertButton addTarget:self action:@selector(toAddCity) forControlEvents:UIControlEventTouchUpInside];
    return insertButton;
}

- (UICollectionView *)collView {
    if (_collView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        CGRect rect = self.view.frame;
        UICollectionView *coll = [[UICollectionView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-44) collectionViewLayout:flow];
        [coll registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collName];
        coll.backgroundColor = Color(240, 240, 240, 255);
        [coll registerNib:[UINib nibWithNibName:@"CityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collName];
        coll.dataSource      = self;
        coll.delegate        = self;
        _collView = coll;
        [self.view addSubview:_collView];
    }
    return _collView;
}

#pragma mark @@@@ ----> 获取网路数据
/**
 *  获取 同城分类 数据
 */
- (void) getCityCateData {
    
    //
    NSArray *cityArr = userDefault(@"cityCates");
    if (cityArr.count != 0) {
        self.cityCates = [self dataTreatment:cityArr];
        [_collView reloadData];
    }
    //访问接口 获取数据
    NSString     *url   = connect_url(@"city_cate"); // 获取url;
    NSDictionary *dict  = @{@"app_key":url};         // 验证AppKey
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] isEqualToString:SUCCESS]) {
            // 返回数据成功
            self.cityCateArray = param[@"obj"];
            self.cityCates = [self dataTreatment:param[@"obj"]];
            [[NSUserDefaults standardUserDefaults]setObject:param[@"obj"] forKey:@"cityCates"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_collView reloadData];
        } else {
            // 返回数据失败
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

/**
 *  获取 同城地区 数据
 */
- (void) getCityAddress {
    NSArray *addressArr = userDefault(@"cityAddress");
    if (addressArr.count != 0) {
        self.cityAddress  = addressArr;
    }
    
    NSString *url = connect_url(@"area_list");
    NSDictionary *dict = @{@"app_key":url};
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        
        if ([param[@"code"] isEqualToString:SUCCESS]) {
            
            self.cityAddress = param[@"obj"];
            [[NSUserDefaults standardUserDefaults] setObject:param[@"obj"] forKey:@"cityAddress"];
            
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark @@@@ ----> 数据处理
- (NSArray *) dataTreatment:(NSArray *)param {
    NSArray *array = [CityOneCate objectArrayWithKeyValuesArray:param];
    return array;
}

#pragma mark @@@@ ----> 返回分组
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark @@@@ ----> 返回多少个Cell
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _cityCates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collName forIndexPath:indexPath];
    
    cell.backgroundColor     = Color(255, 255, 255, 255);
    
    // 取出每一条的分类信息
    CityOneCate *cityOneCate = self.cityCates[indexPath.row];
    // 分类文字
    cell.labelView.text      = cityOneCate.cat_name;
    // 分类图片
    NSURL *url = [NSURL URLWithString:cityOneCate.cat_pic];
//    cell.imageView.layer.borderWidth = 0.5;
//    cell.imageView.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
    
    // 格子圆角
    cell.layer.cornerRadius  = 4;
    cell.layer.borderWidth   = 1;
    cell.layer.borderColor   = UIColorFromRGB(0xe5e5e5).CGColor;

    return cell;
}

#pragma mark @@@@ ----> 返回每个cell的大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 70);
}

//定义每个Section 的 margin 1
#pragma mark @@@@ ----> 返回 margin 外边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5*LinPercent, 120, 5*LinPercent);//分别为上、左、下、右
}

#pragma mark @@@@ ----> 返回 格子之间 的上下间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark @@@@ ----> 返回 格子之间 左右间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat blankWidth = 5*LinPercent;
    return blankWidth;
}

#pragma mark @@@@ ----> 触发点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CityListViewController *ciytList = [[CityListViewController alloc] init];
    if (self.cityCateArray != nil) {
        CityOneCate *cityOne    = self.cityCates[indexPath.row];
        ciytList.c_id           = cityOne.cat_id;
        ciytList.cat_name       = cityOne.cat_name;
        ciytList.cityTwoCate    = cityOne.son;
        ciytList.cityAddress    = self.cityAddress;
        ciytList.cityCateArray  = self.cityCateArray;
        [self.navigationController pushViewController:ciytList animated:YES];
    }
}

#pragma mark @@@@ ----> 跳转到发布分类信息控制器
- (void) toAddCity {
    
    if (ApplicationDelegate.islogin) {
        OneCateController *oneCate = [[OneCateController alloc] init];
        // 地区分类
        oneCate.cityAddress        = self.cityAddress;
        [self.navigationController pushViewController:oneCate animated:YES];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        
    }
}

- (void) toSelectList {
    CitySelectViewConstroller *citySelect = [[CitySelectViewConstroller alloc] init];
    [self.navigationController pushViewController:citySelect animated:YES];
}

@end
