//
//  SJCollectionView.m
//  cityo2o
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "SJCollectionView.h"
#import "ZQFunctionWebController.h"
#import "UIView+UIViewController.h"
@interface SJCollectionView()
{
    NSMutableArray *imageList;
}
@end
@implementation SJCollectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize=CGSizeMake((SCREEN_WIDTH-12)/2, 0.3*SCREEN_WIDTH);
    flowLayout.minimumLineSpacing=1;
    flowLayout.minimumInteritemSpacing=1;
    flowLayout.sectionInset=UIEdgeInsetsMake(1, 5, 1, 5);
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.delegate=self;
        self.dataSource=self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return self;
}
- (void)setDataList:(NSArray *)dataList{
    _dataList=dataList;
    imageList=[NSMutableArray array];
    for (NSDictionary *dic in dataList) {
        NSString *imageUrl=[dic objectForKey:@"shop_img"];
        [imageList addObject:imageUrl];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataList.count;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:imageView];
    [imageView sd_setImageWithURL:[imageList objectAtIndex:indexPath.row]];
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQFunctionWebController *firVC=[[ZQFunctionWebController alloc]init];
    NSMutableArray *urlList=[NSMutableArray array];
    for (NSDictionary *dic in _dataList) {
        NSString *shopURL=[dic objectForKey:@"shop_url"];
        [urlList addObject:shopURL];
    }
    firVC.shop_id=self.shop_id;
    firVC.url=urlList[indexPath.row];
    firVC.title=self.shop_name;
    [self.viewController.navigationController pushViewController:firVC animated:YES];
}

@end
