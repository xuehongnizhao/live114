//
//  SJCollectionView.h
//  cityo2o
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (copy, nonatomic) NSArray *dataList;
@property (copy, nonatomic) NSString *shop_id;
@property (copy, nonatomic) NSString *shop_name;
@end
