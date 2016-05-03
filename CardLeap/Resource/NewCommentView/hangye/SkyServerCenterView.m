//
//  SkyServerCenterView.m
//  cityo2o
//
//  Created by hm－02 on 15/7/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SkyServerCenterView.h"
#import "linServicemodel.h"
#import "SkyServerButtonView.h"
#import "MJExtension.h"
#import "GrayPageControl.h"

#import "ccDisplayModel.h"
#import "ccDisplayButtonView.h"


typedef NS_ENUM(NSUInteger, kButtonViewDirection) {
    
    kButtonViewDirectionTop = 1,
    kButtonViewDirectionTopLeft = 2,
    kButtonViewDirectionLeft = 3,
    kButtonViewDirectionBottomLeft = 4,
    kButtonViewDirectionBottom = 5,
    kButtonViewDirectionBottomRight = 6,
    kButtonViewDirectionRight = 7,
    kButtonViewDirectionTopRight = 8,
    
};

@interface SkyServerCenterView ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView       *buttonSrollView;

@property (strong, nonatomic) IBOutlet UIView             *contentView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;

@property (nonatomic, strong) NSMutableArray     * cateArray;

@property (nonatomic, strong) NSArray            * moduleArray;

@property (strong, nonatomic) GrayPageControl *facePageControl;


// 用一个bool值去标识是否已设置约束
@property (assign, nonatomic) BOOL               didSetupConstraints;



@end

@implementation SkyServerCenterView

@synthesize ColumnOfTagButton,RowOfTagButton;

+(instancetype)initViewWithXib:(NSInteger)column andRow:(NSInteger)row
{
    SkyServerCenterView* centerView=[[[NSBundle mainBundle] loadNibNamed:@"SkyServerCenterView" owner:self options:nil] lastObject];
    if (column != 0) {
        centerView.ColumnOfTagButton = column;
    }else{
        centerView.ColumnOfTagButton = 4;
    }
    if ( row != 0) {
        centerView.RowOfTagButton = row;
    }else{
        centerView.RowOfTagButton = 3;
    }
    return centerView;
}

-(void)setButtonViewWithModuleArray:(NSArray *)moduleArray
{
    if (moduleArray.count==0)
    {
        NSAssert(nil, @"can't set titles must greater than 0");
    }
    
    self.moduleArray=moduleArray;
    
    [self.cateArray removeAllObjects];
    
    [moduleArray enumerateObjectsUsingBlock:^(linServicemodel* module, NSUInteger idx, BOOL *stop) {
        
        SkyServerButtonView* tagButton=[[SkyServerButtonView alloc] initForAutoLayout];;
        tagButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [tagButton setButtonViewTag:idx];
        [tagButton setButtonImageurl:module.index_pic andTitle:module.index_name];
        //        tagButton
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
    NSInteger pages=self.cateArray.count<=(ColumnOfTagButton*RowOfTagButton)?1:(self.cateArray.count-1)/(ColumnOfTagButton*RowOfTagButton)+1;
    
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.buttonSrollView withMultiplier:pages];
    
    
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
    [self setAutolayout:@"server"];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_facePageControl setCurrentPage:self
     .buttonSrollView.contentOffset.x / 320];
    [_facePageControl updateCurrentPageDisplay];
}

#pragma mark - CC 新方法

-(void)setDisplayButtonViewWithModuleArray:(NSArray *)moduleArray
{
    if (moduleArray.count==0)
    {
        NSAssert(nil, @"can't set titles must greater than 0");
    }
    
    self.moduleArray=moduleArray;
    
    [self.cateArray removeAllObjects];
    
    [moduleArray enumerateObjectsUsingBlock:^(ccDisplayModel* module, NSUInteger idx, BOOL *stop) {
        
        ccDisplayButtonView* tagButton=[[ccDisplayButtonView alloc] initForAutoLayout];;
        tagButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [tagButton setButtonViewTag:idx];
        [tagButton setButtonImageurl:module.goods_pic andTitle:module.goods_name];
        
        [tagButton addTarget:self action:@selector(displayButtonviewClick:)];
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
    NSInteger pages=self.cateArray.count<=(ColumnOfTagButton*RowOfTagButton)?1:(self.cateArray.count-1)/(ColumnOfTagButton*RowOfTagButton)+1;
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.buttonSrollView withMultiplier:pages];
    
    
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
    [self setAutolayout:@"display"];
    
}

-(void)displayButtonviewClick:(UIButton*) sender
{
    linServicemodel* module=[self.moduleArray objectAtIndex:sender.tag];
    [self.delegate disPlayCenterClickButtonToPushViewController:module];
}

-(void)addLineImageDisplay
{
    [self.cateArray enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        if (idx%4 == 0 && idx/12==0) {//第一页第一行第一个第二个
            UIImageView *line = [[UIImageView alloc] initForAutoLayout];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [view addSubview:line];
            [line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
            [line autoSetDimension:ALDimensionWidth toSize:0.5f];
        }
        //-----第一行----------
        
        
        if (idx%4 == 2) {
            UIImageView *line_right = [[UIImageView alloc] initForAutoLayout];
            [line_right setBackgroundColor:UIColorFromRGB(0xcccccc)];
            [view addSubview:line_right];
            
            
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            [line_right autoSetDimension:ALDimensionWidth toSize:0.5f];
        }else {
            UIImageView *line_right = [[UIImageView alloc] initForAutoLayout];
            [line_right setBackgroundColor:[UIColor lightGrayColor]];
            [view addSubview:line_right];
            
            
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            [line_right autoSetDimension:ALDimensionWidth toSize:0.5f];
        }
        
    }];
}


#pragma mark - CC 新方法结束



#pragma mark - Autolayout
-(void)setAutolayout:(NSString *)string
{
    self.buttonSrollView.delegate = self;
    //如果未设置约束 则进行约束
    if (!self.didSetupConstraints)
    {
        //如果数组中的数量为0则不进行自动布局
        if (self.cateArray.count==0) return;
        
        //在这里才添加到视图是防止再次调用添加方法的时候将视图重复添加
        [self.cateArray enumerateObjectsUsingBlock:^(SkyServerButtonView* buttonView, NSUInteger idx, BOOL *stop) {
            [self.contentView addSubview:buttonView];
        }];
        
        //autolayout
        CGFloat tagButtonWidth=(SCREEN_WIDTH-(TagButtonHorizontalMargin*(ColumnOfTagButton-1)))/ColumnOfTagButton;
        CGFloat tagButtonHeight=(self.frame.size.height-(TagButtonVerticalMargin*(RowOfTagButton-1))-20)/RowOfTagButton;
        
        SkyServerButtonView* tagButton=[self.cateArray firstObject];
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
        
        //----------addline--------------
        if([string isEqualToString:@"server"]){
#pragma mark --- 2016.4 设置生活服务图标的分割线
            //            [self addLineImage];
        }
        if ([string isEqualToString:@"display"]) {
            [self addLineImageDisplay] ;
        }
        
        
        self.buttonSrollView.contentOffset = CGPointZero;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        self.didSetupConstraints = YES;
        
    }
}
#pragma mark --- 2016.4 弃用
-(void)addLineImage
{
    [self.cateArray enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        if (idx%4 == 0 && idx/12==0) {//第一页第一行第一个第二个
            UIImageView *line = [[UIImageView alloc] initForAutoLayout];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [view addSubview:line];
            [line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
            [line autoSetDimension:ALDimensionWidth toSize:0.5f];
        }
        //-----第一行----------
        if (idx/4%3==0) {
            UIImageView *line_top = [[UIImageView alloc] initForAutoLayout];
            [line_top setBackgroundColor:[UIColor lightGrayColor]];
            [view addSubview:line_top];
            
            //--------autolayout---------
            [line_top autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
            [line_top autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            [line_top autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
            [line_top autoSetDimension:ALDimensionHeight toSize:0.5f];
        }
        
        if (idx%4 == 2) {
            UIImageView *line_right = [[UIImageView alloc] initForAutoLayout];
            [line_right setBackgroundColor:UIColorFromRGB(0xcccccc)];
            [view addSubview:line_right];
            
            
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            [line_right autoSetDimension:ALDimensionWidth toSize:0.5f];
        }else {
            UIImageView *line_right = [[UIImageView alloc] initForAutoLayout];
            [line_right setBackgroundColor:[UIColor lightGrayColor]];
            [view addSubview:line_right];
            
            
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
            [line_right autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            [line_right autoSetDimension:ALDimensionWidth toSize:0.5f];
        }
        
        
        UIImageView *line_bottom = [[UIImageView alloc] initForAutoLayout];
        [line_bottom setBackgroundColor:[UIColor lightGrayColor]];
        [view addSubview:line_bottom];
        
        [line_bottom autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [line_bottom autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        [line_bottom autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
        [line_bottom autoSetDimension:ALDimensionHeight toSize:0.5f];
    }];
}



#pragma mark - Helpul Method
-(void)createLineDirection:(kButtonViewDirection) lineDirection  withView:(UIView*) view
{
    //    kButtonViewDirectionTop = 1,
    //    kButtonViewDirectionTopLeft = 2,
    //    kButtonViewDirectionLeft = 3,
    //    kButtonViewDirectionBottomLeft = 4,
    //    kButtonViewDirectionBottom = 5,
    //    kButtonViewDirectionBottomRight = 6,
    //    kButtonViewDirectionRight = 7,
    //    kButtonViewDirectionTopRight = 8,
    if (lineDirection==1)
    {
        CAShapeLayer* shapLayer=[CAShapeLayer layer];
        [view.layer addSublayer:shapLayer];
        shapLayer.borderColor=[UIColor lightGrayColor].CGColor;
        
    }
    else if (lineDirection==2)
    {
        
    }
    else if (lineDirection==3)
    {
        
    }
    else if (lineDirection==4)
    {
        
    }
    else if (lineDirection==5)
    {
        
    }
    else if (lineDirection==6)
    {
        
    }
    else if (lineDirection==7)
    {
        
    }
    else if (lineDirection==8)
    {
        
    }
}

#pragma mark - buttonViewClick
-(void)buttonviewClick:(UIButton*) sender
{
    linServicemodel* module=[self.moduleArray objectAtIndex:sender.tag];
    [self.delegate serverCenterClickButtonToPushViewController:module];
}


#pragma mark - Property Accessor
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
