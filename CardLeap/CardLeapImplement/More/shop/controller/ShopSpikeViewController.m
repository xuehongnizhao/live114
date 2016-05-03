//
//  ShopSpikeViewController.m
//  CardLeap
//
//  Created by mac on 15/2/4.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ShopSpikeViewController.h"
#import "CouponCollectionViewCell.h"
#import "CouponDetailViewController.h"
#import "couponInfo.h"

@interface ShopSpikeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *couponArray;
}
@property (strong, nonatomic) UICollectionView *couponCollectionview;
@end

@implementation ShopSpikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----init data
-(void)initData
{
    couponArray = [[NSMutableArray alloc] init];
}

#pragma mark-----get data
-(void)getData
{
    NSString *url = connect_url(@"spike_shop");
    NSDictionary *dict=@{
                         @"app_key":url,
                         @"shop_id":self.shop_id
                         };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]) {
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                couponInfo *info = [[couponInfo alloc] initWithDictionary:dic];
                [couponArray addObject:info];
            }
            [self.couponCollectionview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-----set UI
-(void)setUI
{
    [self.view addSubview:self.couponCollectionview];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_couponCollectionview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
}
#pragma mark-----get UI
-(UICollectionView *)couponCollectionview
{
    if (!_couponCollectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(100,100);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _couponCollectionview = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _couponCollectionview.backgroundColor = [UIColor whiteColor];
        _couponCollectionview.translatesAutoresizingMaskIntoConstraints = NO;
        [_couponCollectionview registerClass:[CouponCollectionViewCell class] forCellWithReuseIdentifier:@"coupon_cell"];
        _couponCollectionview.scrollEnabled = YES;
        _couponCollectionview.delegate = self;
        _couponCollectionview.dataSource = self;
    }
    return _couponCollectionview;
}

#pragma mark-----tableview delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"点击进入详情");
    couponInfo *info = [couponArray objectAtIndex:indexPath.row];
    CouponDetailViewController *firVC = [[CouponDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:info.spike_name withFont:14.0f];
//    [firVC.navigationItem setTitle:info.spike_name];
    firVC.info = info;
    firVC.message_url = info.message_url;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [couponArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"coupon_cell";
    CouponCollectionViewCell *cell=(CouponCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    couponInfo *info = [couponArray objectAtIndex:indexPath.row];
    [cell configureCell:info];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(140*LinPercent,167*LinPercent);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10); // top, left, bottom, right
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
