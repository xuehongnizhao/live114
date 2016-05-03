//
//  PhotoView.m
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "PhotoView.h"
#import "imageCell.h"

#define IMAGE_SIZE 60
@implementation PhotoView
{
    UICollectionView* photoCollectionView;
    NSMutableArray* newImageArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.isShow=NO;
        self.photoArray=[[NSMutableArray alloc]init];
        newImageArray=[[NSMutableArray alloc]init];
        
        UICollectionViewFlowLayout* flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize=CGSizeMake(IMAGE_SIZE, IMAGE_SIZE);
        
        photoCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, 300*LinPercent, 216*LinHeightPercent) collectionViewLayout:flowLayout];
//        photoCollectionView.layer.borderWidth = 1;
        [photoCollectionView registerClass:[imageCell class] forCellWithReuseIdentifier:@"collectionCell"];
        photoCollectionView.backgroundColor=[UIColor whiteColor];
        photoCollectionView.dataSource=self;
        photoCollectionView.delegate=self;
        [self addSubview:photoCollectionView];
    }
    return self;
}
//删除后的刷新操作
-(void)deleteReloadData
{
    if (self.photoArray.count==8&&self.isAddImage==NO)
    {
      [self.photoArray addObject:[UIImage imageNamed:@"issue_add_sel"]];
        self.isAddImage=YES;
    }
    [photoCollectionView reloadData];
    //[self reloaddata];
}
-(void)reloaddata
{
    NSLog(@"photoarray.count:%ld",self.photoArray.count);
    if (self.photoArray.count<9)
    {
        [self.photoArray addObject:[UIImage imageNamed:@"issue_add_sel"]];
        [photoCollectionView reloadData];
        self.isAddImage=YES;
    }
    else if (self.photoArray.count==9)
    {       // [self.photoArray removeLastObject];
        self.isAddImage=NO;        [photoCollectionView reloadData];
    }
}
-(void)addNewsImageArray:(NSArray *)newArray
{
    NSLog(@"newArray:%ld",newArray.count);
    [self.photoArray removeAllObjects];
    [self.photoArray addObjectsFromArray:newArray];
    [self reloaddata];
}
#pragma mark--------对得到的图片进行压缩
-(void)saveImageAndCompress
{
    int i=1;
    for (UIImage* image in self.photoArray)
    {
        //现将原始图片保存到document里
        [self saveImage:image WithName:[NSString stringWithFormat:@"OriginalImage %d",i]];
        i++;
        //将原始图片压缩并显示到界面上
        UIImage* newImage=[self imageWithImageSimple:image scaledToSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE)];
        [newImageArray addObject:newImage];
    }
}

#pragma mark---------获取Documents下的图片路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
#pragma mark---------对原始图片进行保存
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}
#pragma mark---------对选取图片进行压缩
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark---------UICollectionViewDelegateAndDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageCell* cell=(imageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    if (self.photoArray.count!=0)
    {
        cell.imageView.image=[self.photoArray objectAtIndex:indexPath.row];
        cell.imageView.layer.cornerRadius=5;
    }
    return cell;
}

#pragma mark @@@@ ----> 返回每个cell的大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60*LinPercent, 60*LinHeightPercent);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"self.photoArray.count=%ld",self.photoArray.count);
    NSLog(@"indexPath.row=%ld",indexPath.row);
    if (self.isAddImage==YES)
    {
        if (indexPath.row<[self.photoArray count]-1&&[self.photoArray count]<=9)
        {
            NSLog(@"点击获取相册");
            [self.delegate showBrowserWithIndex:indexPath.row];
        }
        else if(self.photoArray.count-1==indexPath.row&&self.photoArray.count<=9)
        {
            NSLog(@"更多");
            [self.delegate getMorePhoto];
        }
    }
    else
    {
            NSLog(@"点击获取相册");
            [self.delegate showBrowserWithIndex:indexPath.row];
    }
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
