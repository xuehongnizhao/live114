//
//  imageCell.m
//  SendInfo
//
//  Created by Sky on 14-8-14.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "imageCell.h"

@implementation imageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化加载imageCell。xib文件
        NSArray* arryOfView=[[NSBundle mainBundle] loadNibNamed:@"imageCell" owner:self options:nil];
        //如果路径不存在return  nil
        if (arryOfView.count<1)
        {
            return nil;
        }
        //如果xib中的view不属于collectionViewcell类 返回nie
        if (![[arryOfView objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return  nil;
        }
        self=[arryOfView objectAtIndex:0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
