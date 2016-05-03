//
//  MXPullDownMenu000.m
//  MXPullDownMenu
//
//  Created by 马骁 on 14-8-21.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MXPullDownMenu.h"
#import "cateInfo.h"
#import "cateSonInfo.h"

@implementation MXPullDownMenu
{
    
    UIColor *_menuColor;
    

    UIView *_backGroundView;
    UITableView *_tableView;
    UITableView *_secondTableview;
    NSMutableArray *_titles;
    NSMutableArray *_indicators;
    
    NSInteger _currentSelectedMenudIndex;
    bool _show;
    
    NSInteger _numOfMenu;
    
    NSArray *_array;
    NSMutableArray *selectRowAtTableview;
    
    int select_one;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    
    }
    return self;
}

#pragma mark------set cate title
-(void)setCateTitle:(NSString *)title
{
    CATextLayer *title1 = (CATextLayer *)_titles[0];
    title1.string = title;
}

- (MXPullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 36);
        select_one = 0;
        _menuColor = UIColorFromRGB(0x717070);
        
        _array = array;
        _numOfMenu = _array.count;
        selectRowAtTableview = [[NSMutableArray alloc] init];
        for (int i=0; i<_numOfMenu; i++) {
            NSString *selectForRow = @"0";
            [selectRowAtTableview addObject:selectForRow];
        }
        CGFloat textLayerInterval = SCREEN_WIDTH / ( _numOfMenu * 2);
        CGFloat separatorLineInterval = SCREEN_WIDTH / _numOfMenu;
        
        _titles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        _indicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        
        for (int i = 0; i < _numOfMenu; i++) {
            CGPoint position = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
            NSArray *MyArray = (NSArray*)_array[i];
            cateInfo *info = MyArray[0];
            CATextLayer *title = [self creatTextLayerWithNSString:info.cate_name withColor:_menuColor andPosition:position];
            [self.layer addSublayer:title];
            [_titles addObject:title];
            
            CAShapeLayer *indicator = [self creatIndicatorWithColor:_menuColor andPosition:CGPointMake(position.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
            [self.layer addSublayer:indicator];
            [_indicators addObject:indicator];
            
            if (i != _numOfMenu - 1) {
                CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
                CAShapeLayer *separator = [self creatSeparatorLineWithColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0] andPosition:separatorPosition];
                [self.layer addSublayer:separator];
            }
        }
        
        //创建一级下拉菜单
        _tableView = [self creatTableViewAtPosition:CGPointMake(0, self.frame.origin.y + self.frame.size.height)];
        _tableView.tintColor = [UIColor redColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //_tableView.layer.borderWidth = 0.5;
        //--------添加分割线------------
//        UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
//        [_tableView addSubview:lineImage];
//        [lineImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
//        [lineImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
//        [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.5];
//        [lineImage autoSetDimension:ALDimensionWidth toSize:0.5f];
//        lineImage.backgroundColor = UIColorFromRGB(0xdfdfdf);
        //----------------------------
        //创建二级下拉菜单
        _secondTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height, 160, 0)];
        _secondTableview.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _secondTableview.rowHeight = 36;
        _secondTableview.tintColor = [UIColor redColor];
        _secondTableview.dataSource = self;
        _secondTableview.delegate = self;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_secondTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_secondTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_secondTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_secondTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
//        _secondTableview.layer.borderWidth = 1;
        // 设置menu, 并添加手势
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenu:)];
        [self addGestureRecognizer:tapGesture];
        // 创建背景
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackGround:)];
        [_backGroundView addGestureRecognizer:gesture];
        _currentSelectedMenudIndex = -1;
        _show = NO;
    }
    return self;
}


#pragma mark - tapEvent
// 处理菜单点击事件.
- (void)tapMenu:(UITapGestureRecognizer *)paramSender
{
    CGPoint touchPoint = [paramSender locationInView:self];
    // 得到tapIndex
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                }];
            }];
        }
    }
    //清空为0
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
        }];
    } else {
        _currentSelectedMenudIndex = tapIndex;
        [_tableView reloadData];
        [_secondTableview reloadData];
        [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_tableView title:_titles[tapIndex] forward:YES complecte:^{
            _show = YES;
        }];
    }
}

- (void)tapBackGround:(UITapGestureRecognizer *)paramSender
{
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];

}


#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
        如果点击的是一级菜单
        查看有没有对应的子菜单
        如果有则_secondTableview重新加载
        如果没有则直接点击
     */
    if (tableView == _tableView) {
        select_one = indexPath.row;
        NSString *currentRow = [selectRowAtTableview objectAtIndex:_currentSelectedMenudIndex];
        currentRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        //重新加入数组
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for(int i=0;i<[selectRowAtTableview count];i++)
        {
            if (_currentSelectedMenudIndex == i) {
                [tempArr addObject:currentRow];
            }else{
                [tempArr addObject:[selectRowAtTableview objectAtIndex:i]];
            }
        }
        selectRowAtTableview = tempArr;
        NSLog(@"%@",selectRowAtTableview);
        NSArray *array = _array[_currentSelectedMenudIndex];
        cateInfo *info = array[indexPath.row];
        
        if ([info.son count]>0) {
            [self confiMenuWithSelectRow:indexPath.row isFirst:YES];
            [self confiMenuWithSelectRow:indexPath.row isFirst:YES];
            [_tableView reloadData];
            [_secondTableview reloadData];
        }else{
            [self confiMenuWithSelectRow:indexPath.row isFirst:YES];
            
            NSArray *array = _array[_currentSelectedMenudIndex];
            cateInfo *info = array[indexPath.row];
            NSString *selectText = info.cate_name;
            
//            CATextLayer *title = [[CATextLayer alloc] init];
//            title.string = selectText;
            //菜单消失
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _show = NO;
            }];
            [_secondTableview reloadData];
            [self confiMenuWithSelectRow:indexPath.row isFirst:YES];
            //[self confiMenuWithSelectRow:indexPath.row isFirst:YES];
            [self.delegate PullDownMenu:self didSelectRowAtColumn:_currentSelectedMenudIndex row:indexPath.row selectText:info.cate_id];
        }
        select_one = [[selectRowAtTableview objectAtIndex:_currentSelectedMenudIndex] integerValue];
        NSIndexPath *first = [NSIndexPath
                              indexPathForRow:select_one inSection:0];
        [_tableView selectRowAtIndexPath:first
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    }else if(tableView == _secondTableview){
        [self confiMenuWithSelectRow:indexPath.row isFirst:NO];
        [_secondTableview reloadData];
        
        NSArray *array = _array[_currentSelectedMenudIndex];
        cateInfo *info = [array objectAtIndex:select_one];
        NSArray *secondArray = info.son;
        cateSonInfo *secondInfo = [secondArray objectAtIndex:indexPath.row];
        
//        CATextLayer *title = [[CATextLayer alloc] init];
//        title.string = selectText;
        //菜单消失
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        [self confiMenuWithSelectRow:indexPath.row isFirst:NO];
        [self.delegate PullDownMenu:self didSelectRowAtColumn:_currentSelectedMenudIndex row:indexPath.row selectText:secondInfo.cate_son_id];
    }
}

#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return [_array[_currentSelectedMenudIndex] count];
    }else{
//        NSDictionary *dic = _array[_currentSelectedMenudIndex];
//        NSString *currentRow = [selectRowAtTableview objectAtIndex:_currentSelectedMenudIndex];
//        NSString *key = [[_array[_currentSelectedMenudIndex] allKeys] objectAtIndex:[currentRow intValue]];
//        NSArray *value = [dic objectForKey:key];
        NSArray *array = _array[_currentSelectedMenudIndex];
        NSString *currentRow = [selectRowAtTableview objectAtIndex:_currentSelectedMenudIndex];
        cateInfo *info = [array objectAtIndex:[currentRow intValue]];
        
        return [info.son count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        }
        [cell.textLabel setTextColor:[UIColor grayColor]];
        //[cell setAccessoryType:UITableViewCellAccessoryNone];
        NSArray *array = _array[_currentSelectedMenudIndex];
        cateInfo *info = [array objectAtIndex:indexPath.row];
        cell.textLabel.text = info.cate_name;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (cell.textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            //[cell.textLabel setTextColor:[tableView tintColor]];
            //select_one = indexPath.row;
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        return cell;
    }else if(tableView == _secondTableview){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        }
        [cell setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
        [cell.textLabel setTextColor:[UIColor grayColor]];
        //[cell setAccessoryType:UITableViewCellAccessoryNone];
        NSArray *array = _array[_currentSelectedMenudIndex];
        NSString *currentRow = [selectRowAtTableview objectAtIndex:_currentSelectedMenudIndex];
        cateInfo *info = [array objectAtIndex:[currentRow intValue]];
        NSArray *secondArray = info.son;
        cateSonInfo *secondInfo = [secondArray objectAtIndex:indexPath.row];
        cell.textLabel.text = secondInfo.cate_son_name;
        if (cell.textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            //[cell.textLabel setTextColor:[tableView tintColor]];
            NSIndexPath *first = [NSIndexPath
                                  indexPathForRow:indexPath.row inSection:0];
            [tableView selectRowAtIndexPath:first
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        return cell;
    }
    return nil;
}





#pragma mark - animation

- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim andValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    indicator.fillColor = nil;
    indicator.strokeColor = forward ? _tableView.tintColor.CGColor : _menuColor.CGColor;
    
    complete();
}





- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    
    if (show) {
        
        [self.superview addSubview:view];
        [view.superview addSubview:self];

        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
    }
    complete();
    
}
#pragma mark-------判断有没有二级菜单项
-(BOOL)isPopSecondMenu
{
    NSArray *keys = _array[_currentSelectedMenudIndex] ;
    for (cateInfo *key in keys) {
        NSArray *secondArr = key.son;
        if ([secondArr count]>0) {
            return YES;
        }
    }
    return NO;
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        //判断有没有二级的子菜单 有就宽度调整 没有就不做调整
        CGFloat tableViewWidth ;
        CGFloat secondHeight = 5 * tableView.rowHeight;
        if ([self isPopSecondMenu]==YES) {
            tableViewWidth = self.frame.size.width/2;
            _secondTableview.frame = CGRectMake(tableViewWidth, self.frame.origin.y + self.frame.size.height, tableViewWidth, 0);
            [self.superview addSubview:_secondTableview];
        }else{
            tableViewWidth = self.frame.size.width;
        }
        tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, tableViewWidth, 0);
        [self.superview addSubview:tableView];
        CGFloat tableViewHeight = 5 * tableView.rowHeight;
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, tableViewWidth, tableViewHeight);
            _secondTableview.frame = CGRectMake(tableViewWidth, self.frame.origin.y + self.frame.size.height, tableViewWidth, tableViewHeight);
        }];
    } else {
        CGFloat tableViewWidth ;
        if ([self isPopSecondMenu]==YES) {
            tableViewWidth = self.frame.size.width/2;
            _secondTableview.frame = CGRectMake(tableViewWidth, self.frame.origin.y + self.frame.size.height, tableViewWidth, 0);
            [self.superview addSubview:_secondTableview];
        }else{
            tableViewWidth = self.frame.size.width;
        }
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, tableViewWidth, 0);
            if ([self isPopSecondMenu]==YES) {
                _secondTableview.frame = CGRectMake(tableViewWidth, self.frame.origin.y + self.frame.size.height, tableViewWidth, 0);
            }
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
            if ([self isPopSecondMenu]==YES) {
                [_secondTableview removeFromSuperview];
            }
        }];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        title.foregroundColor = _tableView.tintColor.CGColor;
    } else {
        title.foregroundColor = _menuColor.CGColor;
    }
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                    select_one = [[selectRowAtTableview objectAtIndex:_currentSelectedMenudIndex] integerValue];
                    NSIndexPath *first = [NSIndexPath
                                          indexPathForRow:select_one inSection:0];
                    [tableView selectRowAtIndexPath:first
                                           animated:NO
                                     scrollPosition:UITableViewScrollPositionNone];
                }];
            }];
        }];
    }];
    
    complete();
}


#pragma mark - drawing


- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path addLineToPoint:CGPointMake(8, 0)];
   
//    [path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(8, 0) controlPoint2:CGPointMake(4, 5)];
    //[path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    layer.fillColor = nil;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    layer.position = point;
    
    return layer;
}

/**
 */

- (CAShapeLayer *)creatSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point
{
    CGSize size = [self calculateTitleSizeWithString:string];
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 13.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}


- (UITableView *)creatTableViewAtPosition:(CGPoint)point
{
    UITableView *tableView = [UITableView new];
    tableView.frame = CGRectMake(point.x, point.y, self.frame.size.width/2, 0);
    tableView.rowHeight = 36;
    return tableView;
}


#pragma mark - otherMethods


- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 13.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

- (void)confiMenuWithSelectRow:(NSInteger)row isFirst:(BOOL)isFirst
{
    
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    if (isFirst) {
        NSArray *array = [_array objectAtIndex:_currentSelectedMenudIndex];
        cateInfo *info = [array objectAtIndex:row];
        
        NSLog(@"%@",info.cate_name);
        title.string = info.cate_name;
    }else{
        /*
            获取到当前点击的是一级菜单的第几行 0.0
            然后才能获取到对应的二级菜单的正确项
         */
        
        NSArray *array = _array[_currentSelectedMenudIndex];
        NSString *currentRow = [selectRowAtTableview objectAtIndex:_currentSelectedMenudIndex];
        cateInfo *info = [array objectAtIndex:[currentRow intValue]];
        NSArray *secondArray = info.son;
        cateSonInfo *secondInfo = [secondArray objectAtIndex:row];
        title.string = secondInfo.cate_son_name;
    }
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}


@end

#pragma mark - CALayer Category

@implementation CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath
{
    [self addAnimation:anim forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}


@end
