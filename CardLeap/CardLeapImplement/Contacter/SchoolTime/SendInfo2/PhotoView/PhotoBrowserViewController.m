 //
//  PhotoBrowserViewController.m
//  SendInfo2
//
//  Created by Sky on 14-8-16.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "MRZoomScrollView.h"

@interface PhotoBrowserViewController ()

@end

@implementation PhotoBrowserViewController
{
    UIScrollView* scrollView;
    MRZoomScrollView* zoomScrollView;
    UILabel* indexLabel;
    NSInteger currentIndex;
    UIButton* backButton;
    UIButton* delete;
    NSMutableArray* myArray;
    NSMutableArray* imageViewArray;
    BOOL isShowNavBar;
    int count;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageViewArray=[[NSMutableArray alloc]init];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    isShowNavBar=YES;
    self.view.backgroundColor=[UIColor blackColor];
    myArray =[[NSMutableArray alloc]init];
    if (self.photoArray.count==9&&self.isAddImage==NO)
    {
        for (int i=0; i<self.photoArray.count; i++)
        {
            [myArray addObject:[self.photoArray objectAtIndex:i]];
        }
        count=(int)self.photoArray.count;
    }
    else
    {
        for (int i=0; i<self.photoArray.count-1; i++)
        {
            [myArray addObject:[self.photoArray objectAtIndex:i]];
        }
        count=(int)self.photoArray.count-1;
    }
    NSLog(@"myArray:%@",myArray);
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320*LinPercent, self.view.frame.size.height)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(320*LinPercent * count, 568*LinHeightPercent)];

    [self.view addSubview:scrollView];
    
    [self addPhoto];
    
    [scrollView setContentOffset:CGPointMake(self.photoIndex*320*LinPercent, 0)];

    if (self.photoArray.count>1)
    {
        if (IS_HEIGHT_GTE_568 == 0) {
            indexLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 450, 220, 50)];
        }else{
            indexLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 500*LinHeightPercent, 220*LinPercent, 50)];
        }
        indexLabel.font = [UIFont boldSystemFontOfSize:20];
        indexLabel.backgroundColor = [UIColor clearColor];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.text=[NSString stringWithFormat:@"%ld / %d",self.photoIndex+1,count];
        indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:indexLabel];
    }
    backButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (IS_HEIGHT_GTE_568 == 0) {
        backButton.frame=CGRectMake(10, 450, 40, 50);
    }else{
        backButton.frame=CGRectMake(10, 500*LinHeightPercent, 40, 50);
    }
    [backButton setBackgroundImage:[UIImage imageNamed:@"issue_back_no"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTintColor:[UIColor blueColor]];
    [self.view addSubview:backButton];
    if (![self.is_exit isEqualToString:@"0"]) {
        delete=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        delete.frame=CGRectMake(250*LinPercent, 513*LinHeightPercent, 25, 25);
        delete.backgroundColor=[UIColor clearColor];
        [delete setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:delete];
    }
}

#pragma mark------添加照片
-(void)addPhoto
{
    for (UIView* view in scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    for (int i=0; i<count; i++)
    {
        zoomScrollView=[[MRZoomScrollView alloc]init];
        zoomScrollView.backgroundColor=[UIColor blackColor];
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        zoomScrollView.frame = frame;
        UIImage* image=[myArray objectAtIndex:i];
        // NSLog(@"image.width :%f    image.height:%f",image.size.width,image.size.height);
        zoomScrollView.imageView.frame=[self adjustFrame:image];
        
        zoomScrollView.imageView.image =image;
        //设置tag值为删除做准备
        zoomScrollView.imageView.tag=[[[_imageDict allValues] objectAtIndex:i] intValue];
        NSLog(@"imageViewtag---------%ld",(long)zoomScrollView.imageView.tag);
        [imageViewArray addObject:zoomScrollView.imageView];
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleDoubleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [zoomScrollView.imageView addGestureRecognizer:singleTapGesture];
        
        [scrollView addSubview:zoomScrollView];
    }
    if (count==0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
#pragma mark------删除图片
-(void)delete
{
    NSLog(@"删除 第%d张照片",(int)currentIndex);
    UIImageView* iv=[imageViewArray objectAtIndex:currentIndex];
    iv.tag = currentIndex;
    NSLog(@"iv.tag----------%ld",(long)iv.tag);
    [self.delegate deletePhotoAtIndex:currentIndex andPhotoTag:iv.tag];
    [myArray removeObjectAtIndex:currentIndex];
    [imageViewArray removeObjectAtIndex:currentIndex];
    --count;
    [scrollView setContentSize:CGSizeMake(320*LinPercent * count, 568)];
    indexLabel.text=[NSString stringWithFormat:@"%ld / %d",currentIndex+1,count];
    if (currentIndex!=0)
    {
        [scrollView setContentOffset:CGPointMake(320*LinPercent*(currentIndex-1), 0)];
    }
    [self addPhoto];
}
#pragma mark-------返回按钮
-(void)backToController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark-------调整imageViewFrame
-(CGRect)adjustFrame:(UIImage*) image
{
  //	if (zoomScrollView.imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = zoomScrollView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 2.0;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	zoomScrollView.maximumZoomScale = maxScale;
	zoomScrollView.minimumZoomScale = minScale;
	zoomScrollView.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    zoomScrollView.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
//    if (boundsHeight<600) {
        if (imageFrame.size.height < boundsHeight) {
            imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
        } else {
            imageFrame.origin.y = 0;
        }
//    }else{
//        imageFrame.origin.y = 0;
//    }
    
    //NSLog(@"imageFrame:%f,%f,%f,%f",imageFrame.origin.x,imageFrame.origin.y,imageFrame.size.width,imageFrame.size.height);

    return imageFrame;
}
#pragma mark-----scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentIndex=(int)(scrollView.contentOffset.x/scrollView.frame.size.width);
    indexLabel.text=[NSString stringWithFormat:@"%d / %d",currentIndex+1,count];
}

-(void)singleDoubleTap:(UITapGestureRecognizer*)recognizer
{
    if (isShowNavBar==YES)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            indexLabel.alpha=0;
            backButton.alpha=0;
            delete.alpha=0;
            [self backToController];
        } completion:nil];
        isShowNavBar=NO;
    }
    else
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            indexLabel.alpha=1;
            backButton.alpha=1;
            delete.alpha=1;
        } completion:nil];

        isShowNavBar=YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
