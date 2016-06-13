//
//  ShopAdviertisementView.m
//  cityo2o
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "ShopAdviertisementView.h"
#import "SDCycleScrollView.h"
#import "ZQFunctionWebController.h"
#import "UIView+UIViewController.h"
#import "SJCollectionView.h"
#import "SJCollectionView.h"
#import "SJSCTableViewCell.h"
@interface ShopAdviertisementView ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{

}
@property (strong, nonatomic) SDCycleScrollView *SJHDPView;
@property (strong, nonatomic) UIImageView *pinZhi;
@property (strong, nonatomic) SJCollectionView *SJZSView;
@property (strong, nonatomic) UIImageView *huoDong;
@property (strong, nonatomic) SJCollectionView *SJHDView;
@property (strong, nonatomic) UIImageView *shangCheng;
@property (strong, nonatomic) UITableView *shopList;
@end
@implementation ShopAdviertisementView
- (void)setShop_name:(NSString *)shop_name{
    _shop_name=shop_name;
    _SJHDView.shop_name=_shop_name;
    _SJZSView.shop_name=_shop_name;
}

- (void)setSJSC:(NSArray *)SJSC{
    _SJSC=SJSC;
    if (_SJSC) {
        _shangCheng=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shop_list"]];
        _shangCheng.frame=CGRectMake(30, _SJHDView.frame.origin.y+_SJHDView.frame.size.height, SCREEN_WIDTH-10, 40*(_SJSC.count?1:0));
        NSLog(@"%@",NSStringFromCGRect(_shangCheng.frame) );
        _shangCheng.contentMode=UIViewContentModeScaleAspectFit;
        if (_shangCheng.frame.size.height!=0) {
            [self addSubview:_shangCheng];
        }
 
        _shopList=[[UITableView alloc]initWithFrame:CGRectMake(5, _shangCheng.frame.origin.y+_shangCheng.frame.size.height, SCREEN_WIDTH-10, .3*SCREEN_WIDTH*self.SJSC.count)];
        _shopList.delegate=self;
        _shopList.dataSource=self;
        _shopList.backgroundColor=[UIColor blueColor];
        [self addSubview:_shopList];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.SJSC.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SJSCTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SJSCTableViewCell" owner:self options:nil]lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataList=[self.SJSC objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZQFunctionWebController *firVC=[[ZQFunctionWebController alloc]init];
    NSMutableArray *urlList=[NSMutableArray array];
    for (NSDictionary *dic in _SJSC) {
        NSString *shopURL=[dic objectForKey:@"shop_url"];
        [urlList addObject:shopURL];
    }
    firVC.shop_id=self.shop_id;
    firVC.url=urlList[indexPath.row];
    firVC.title=self.shop_name;
    [self.viewController.navigationController pushViewController:firVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return .3*SCREEN_WIDTH;
}


-(void)setSJHD:(NSArray *)SJHD{
    _SJHD=SJHD;
    if (_SJHD) {
        _huoDong=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity"]];
        _huoDong.frame=CGRectMake(5, _SJZSView.frame.origin.y+_SJZSView.frame.size.height, SCREEN_WIDTH-10, 40*(_SJHD.count?1:0));
        _huoDong.contentMode=UIViewContentModeScaleAspectFit;
        if (_huoDong.frame.size.height!=0) {
            [self addSubview:_huoDong];
        }

        _SJHDView=[[SJCollectionView alloc]initWithFrame:CGRectMake(0, _huoDong.frame.origin.y+_huoDong.frame.size.height, SCREEN_WIDTH, .3*SCREEN_WIDTH*_SJHD.count/2)];
        [self addSubview:_SJHDView];
        _SJHDView.dataList=_SJHD;
        _SJHDView.backgroundColor=[UIColor clearColor];
        _SJHDView.scrollEnabled=NO;
        _SJHDView.shop_name=self.shop_name;
    }
}

- (void)setSJZS:(NSArray *)SJZS{
    _SJZS=SJZS;
    if (_SJZS) {
        _pinZhi=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"enjoy"]];
        _pinZhi.frame=CGRectMake(5, _SJHDPView.frame.origin.y+_SJHDPView.frame.size.height,SCREEN_WIDTH-10, 40*(_SJZS.count?1:0));
        _pinZhi.contentMode=UIViewContentModeScaleAspectFit;
        if (_pinZhi.frame.size.height!=0) {
            [self addSubview:_pinZhi];
        }
        _SJZSView=[[SJCollectionView alloc]initWithFrame:CGRectMake(0, _pinZhi.frame.origin.y+_pinZhi.frame.size.height,SCREEN_WIDTH, 0.3*SCREEN_WIDTH*_SJZS.count/2)];
        [self addSubview:_SJZSView];
        _SJZSView.dataList=_SJZS;
        _SJHDView.shop_name=self.shop_name;
        _SJZSView.backgroundColor=[UIColor clearColor];
        _SJZSView.scrollEnabled=NO;
    }

}

- (void)setSJHDP:(NSArray *)SJHDP{
    _SJHDP=SJHDP;
    NSMutableArray *arr=[NSMutableArray array];
    for (NSDictionary *dic in _SJHDP) {
        NSString *str=[dic objectForKey:@"shop_img"];
        [arr addObject:str];
    }
    _SJHDPView=[[SDCycleScrollView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, SCREEN_WIDTH/3*(_SJHDP.count?1:0))];
    _SJHDPView.showPageControl=NO;
    _SJHDPView.delegate=self;
    _SJHDPView.imageURLStringsGroup=arr;
    [self addSubview:self.SJHDPView];

}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSMutableArray *arr=[NSMutableArray array];
    for (NSDictionary *dic in _SJHDP) {
        NSString *str=[dic objectForKey:@"shop_url"];
        [arr addObject:str];
    }
    ZQFunctionWebController*firVC=[[ZQFunctionWebController alloc]init];
    firVC.shop_id=self.shop_id;
    firVC.url=arr[index];
    firVC.title=self.shop_name;
    [self.viewController.navigationController pushViewController:firVC animated:YES];

}


@end
