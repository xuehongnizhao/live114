//
//  linHangyeCommendView.m
//  cityo2o
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "linHangyeCommendView.h"
#import "linHangyeButtonView.h"
#import "MJExtension.h"
#import "linHangyeModel.h"
#import "GrayPageControl.h"


//一共有多少列
#define ColumnOfTagButton   2

//一共有多少行
#define RowOfTagButton      2

//按钮水平间距
#define TagButtonHorizontalMargin     1

//按钮垂直间距
#define TagButtonVerticalMargin       1



@interface linHangyeCommendView()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView       *industryScrollView;
@property (strong, nonatomic) IBOutlet UIView             *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;


@property(nonatomic,strong)NSMutableArray                 * cateArray;

@property(nonatomic, strong)NSArray                       * moduleArray;

@property (strong, nonatomic) GrayPageControl *facePageControl;


// 用一个bool值去标识是否已设置约束
@property (assign, nonatomic) BOOL               didSetupConstraints;

@end

@implementation linHangyeCommendView


+(instancetype)initViewWithXib
{
    linHangyeCommendView* centerView=[[[NSBundle mainBundle] loadNibNamed:@"linHangyeCommendView" owner:self options:nil] lastObject];
    
    return centerView;
}


-(void)setIndustryButtonViewWithModuleArray:(NSArray*) moduleArray
{
    if (moduleArray.count==0)
    {
        NSAssert(nil, @"can't set titles must greater than 0");
    }
    
    self.moduleArray=moduleArray;
    
    [self.cateArray removeAllObjects];
    
    [moduleArray enumerateObjectsUsingBlock:^(linHangyeModel* module, NSUInteger idx, BOOL *stop) {
        
        linHangyeButtonView* tagButton=[[linHangyeButtonView alloc] initForAutoLayout];;
        
        tagButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [tagButton setButtonViewTag:idx];
        //tagButton.backgroundColor=[UIColor orangeColor];
        [tagButton setButtonImageurl:module.index_pic andTitle:module.index_name];
        
        [tagButton addTarget:self action:@selector(buttonviewClick:)];
        
        
        [self.cateArray addObject:tagButton];
        
    }];
    
    
    if (ColumnOfTagButton==0) {
        NSAssert(nil, @"can't set columnOfTagButton less than 0");
    }
    
    if (RowOfTagButton==0)
    {
        NSAssert(nil, @"con't set rowOfTagButton less than 0");
    }
    
    
    //根据tagButton的数量应该有多少页
    NSInteger pages=self.cateArray.count%(ColumnOfTagButton*RowOfTagButton)==0?self.cateArray.count/(ColumnOfTagButton*RowOfTagButton):(self.cateArray.count-1)/(ColumnOfTagButton*RowOfTagButton)+1;
    NSLog(@"pages:%ld",pages);
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.industryScrollView withMultiplier:pages];
    
    //添加PageControl
    _facePageControl = [[GrayPageControl alloc]initForAutoLayout];
//    _facePageControl.hidesForSinglePage=YES;
    [self addSubview:_facePageControl];
    [_facePageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_facePageControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_facePageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_facePageControl autoSetDimension:ALDimensionHeight toSize:20.f];
    _facePageControl.numberOfPages = pages;
    _facePageControl.currentPage = 0;
    
    //更新页面
    [self setAutolayout];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_facePageControl setCurrentPage:self
     .industryScrollView.contentOffset.x / 320];
    [_facePageControl updateCurrentPageDisplay];
}


#pragma mark - Autolayout
-(void)setAutolayout
{
    self.industryScrollView.delegate = self;
    //如果未设置约束 则进行约束
    if (!self.didSetupConstraints)
    {
        
        
        //如果数组中的数量为0则不进行自动布局
        if (self.cateArray.count==0) return;
        
        //在这里才添加到视图是防止再次调用添加方法的时候将视图重复添加
        [self.cateArray enumerateObjectsUsingBlock:^(linHangyeButtonView* buttonView, NSUInteger idx, BOOL *stop) {
            [self.contentView addSubview:buttonView];
        }];
        
        //autolayout
        CGFloat tagButtonWidth=(SCREEN_WIDTH-(TagButtonHorizontalMargin*(ColumnOfTagButton-1)))/ColumnOfTagButton;
        CGFloat tagButtonHeight=(self.frame.size.height-(TagButtonVerticalMargin*(RowOfTagButton-1))-20)/RowOfTagButton;
        
        linHangyeButtonView* tagButton=[self.cateArray firstObject];
        [tagButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [tagButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [tagButton autoSetDimension:ALDimensionHeight toSize:tagButtonHeight];
        [tagButton autoSetDimension:ALDimensionWidth toSize:tagButtonWidth];
        
        
        [self.cateArray autoMatchViewsDimension:ALDimensionHeight];
        [self.cateArray autoMatchViewsDimension:ALDimensionWidth];
        
        __block UIView *previousView = nil;
        [self.cateArray enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
            if (previousView)
            {
                if (idx%ColumnOfTagButton!=0)
                {
                    [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView withOffset:TagButtonHorizontalMargin];
                    [view autoAlignAxis:ALAxisHorizontal toSameAxisOfView:previousView];
                }
                else
                {
                    
                    //如果下一个按钮的idx刚好等于总个数则代表进入了第二页需要重新设置约束
                    if (idx%(ColumnOfTagButton*RowOfTagButton)==0)
                    {
                        CGFloat margin=SCREEN_WIDTH*(idx/(ColumnOfTagButton*RowOfTagButton))+TagButtonHorizontalMargin;
                        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
                        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:TagButtonVerticalMargin];
                    }
                    else
                    {
                        //由于分页的原因需要将
                         CGFloat margin=SCREEN_WIDTH*(idx/(ColumnOfTagButton*RowOfTagButton));
                        //判断下一行的距离
                        [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:TagButtonVerticalMargin];
                        //走着这里的一定为下一行的第一张图片
                        [view autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:margin];
                    }
                }
                
            }
            previousView = view;
        }];
        
        self.industryScrollView.contentOffset = CGPointZero;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        self.didSetupConstraints = YES;
        
    }
}


-(void)buttonviewClick:(UIButton*) sender
{
    linHangyeModel* module=[self.moduleArray objectAtIndex:sender.tag];
    [self.delegate linHangyeclikButtonToPushViewController:module];
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



@end
