//
//  CommendView.m
//  LeDing
//
//  Created by Sky on 14/11/6.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "CommendView.h"
#import "ButtonView.h"
#import "IndexCateMoudle.h"
#import "MJExtension.h"
#import "littleCateModel.h"

#define FACE_COUNT_ROW  2

#define FACE_COUNT_CLU  4

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_WIDTH  45

#define FACE_ICON_HEIGHT 75

#define TOP_INDEX_LIST @"/top/ac_top/index_list"

@interface CommendView ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray* cateArray;
@end

@implementation CommendView
@synthesize buttonArray = _buttonArray;
@synthesize facePageControl = _facePageControl;
@synthesize faceView = _faceView;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        ;
        //[self setButtonView];
    }
    return self;
}

#pragma mark setButtonView
-(void)setButtonView :(NSArray*)array
{
    while ([self.subviews lastObject] != nil) {
    [(UIView*)[self.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
    }
    //加载各种控件
    _buttonArray = array;
    _faceView = [[UIScrollView alloc] initForAutoLayout];
    [self addSubview:_faceView];
    //----------------------------
    [_faceView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_faceView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_faceView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_faceView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    _faceView.pagingEnabled = YES;
    _faceView.showsHorizontalScrollIndicator = NO;
    _faceView.showsVerticalScrollIndicator = YES;
    _faceView.delegate = self;
    _faceView.scrollEnabled = YES;
    CGRect rect = [[UIScreen mainScreen] bounds];
    float width = rect.size.width;
    float hieght = self.frame.size.height;
    NSInteger count = [_buttonArray count]/8 ;
    if (count%8 != 0 && [_buttonArray count]%8 != 0 && [_buttonArray count] != 0) {
        count += 1;
    }
    _faceView.contentSize = CGSizeMake( count* width, hieght);
    if (count<=1) {
        _faceView.scrollEnabled = NO;
    }
    //----------------------------
    //添加PageControl
    _facePageControl = [[GrayPageControl alloc]initForAutoLayout];
    [self addSubview:_facePageControl];
    [_facePageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_facePageControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_facePageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_facePageControl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:166.0f*LinHeightPercent];
    //CGRectMake(110, 170, 100, 20)
    [_facePageControl addTarget:self
                        action:@selector(pageChange:)
              forControlEvents:UIControlEventValueChanged];
    _facePageControl.numberOfPages = count;
    _facePageControl.currentPage = 0;
    //----------------------------
    //计算适配之后的空隙宽度
    CGFloat blank = (width - FACE_ICON_WIDTH*LinPercent*4-30)/3.0;
    for (int i=1; i<=_buttonArray.count; i++)
    {
        //适配之后的宽高
        CGFloat myWidth = FACE_ICON_WIDTH*LinPercent;
        CGFloat myHeight = FACE_ICON_HEIGHT*LinHeightPercent;
        
        littleCateModel* module=[_buttonArray objectAtIndex:i-1];
        //计算每一个表情按钮的坐标和在哪一屏
        CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) *
        (myWidth + blank) + 15 + ((i - 1) / FACE_COUNT_PAGE * width);
        //NSLog(@"facbutton.x=%f",x);
        CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * (myHeight + 4)+10;

        ButtonView* bc=[[ButtonView alloc]initWithFrame:CGRectMake(x, y, myWidth, myHeight)];
        [bc setButtonViewTag:i-1];
        [bc setButtonImageurl:module.cat_img andTitle:module.cat_name];
        [bc addTarget:self action:@selector(buttonviewClick:)];
        [_faceView addSubview:bc];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_facePageControl setCurrentPage:_faceView.contentOffset.x / 320];
    [_facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [_faceView setContentOffset:CGPointMake(_facePageControl.currentPage * 320*LinPercent
                                            , 0) animated:YES];
    [_facePageControl setCurrentPage:_facePageControl.currentPage];
}

#pragma mark buttonViewClick
-(void)buttonviewClick:(UIButton*) sender
{
    NSLog(@"按钮被点击");
    littleCateModel* module=[_buttonArray objectAtIndex:sender.tag];
    [self.delegate clikButtonToPushViewController:module];
}

#pragma mark Property Accessor
-(NSMutableArray *)cateArray
{
    if (!_cateArray)
    {
        _cateArray=[[NSMutableArray alloc]init];
    }
    return _cateArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
