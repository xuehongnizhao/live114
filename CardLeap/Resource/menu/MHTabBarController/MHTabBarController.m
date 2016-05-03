/*
 * Copyright (c) 2011-2012 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHTabBarController.h"
#define TABBAR_HEIGHT 44

static const NSInteger TagOffset = 1000;

@implementation MHTabBarController
{
    UIView *tabButtonsContainerView;    //分栏按钮内容视图
    UIView *contentContainerView;       //下拉菜单内容视图
    UIView *shadowView;                 //阴影部分
    UIImageView *indicatorImageView;    //选中的图标^
    
    CGRect viewRect;                    //视图初始化Frame
    BOOL contentIsDisplay;
    
    //是否显示下来菜单
}
@synthesize normalImageArray;
@synthesize selectedImageArray;
//设置整个视图的Frame
- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    viewRect=frame;
    return self;
}
- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if (CGRectIsEmpty(viewRect)) {
        viewRect = CGRectMake(0, 64, 320, 300);
    }
    self.view.frame=CGRectMake(0, 0, 320, 64+TABBAR_HEIGHT);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //设置shadowView
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    shadowView.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)];
    [shadowView addGestureRecognizer:tapGesture];
    shadowView.hidden=YES;
    [self.view addSubview:shadowView];
    
    //设置tabView
	CGRect rect = CGRectMake(viewRect.origin.x, viewRect.origin.y, viewRect.size.width, TABBAR_HEIGHT);
    NSLog(@"rect:%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
	tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
	tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //设置contentView
    rect.origin.y = viewRect.origin.y + TABBAR_HEIGHT;
    rect.size.height = viewRect.size.height - TABBAR_HEIGHT;
	contentContainerView = [[UIView alloc] initWithFrame:rect];
    
    [self.view addSubview:contentContainerView];
	[self.view addSubview:tabButtonsContainerView];

    //设置标记image
	indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHTabBarIndicator"]];
    [self.view addSubview:indicatorImageView];
	[self reloadTabButtons];
}
#pragma mark - Layout Override Reset Buttons
- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}

//重载绘制按钮、标记位置
- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];
    
	CGRect rect = CGRectMake(0.0f, 0.0f, floorf(self.view.bounds.size.width / count), self.tabBarHeight);
    
	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
			rect.size.width = viewRect.size.width - rect.origin.x;
        
		button.frame = rect;
        
		rect.origin.x += rect.size.width;
		if (index == self.selectedIndex)
			[self centerIndicatorOnButton:button];
        NSLog(@"button.frame:%f,%f,%f,%f",button.frame.origin.x,button.frame.origin.y,button.frame.size.width,button.frame.size.height
            );
        
        for (id obj in button.subviews)
        {
            if ([obj isKindOfClass:[UIImageView class]])
            {
                UIImageView* iv=(UIImageView*)obj;
                iv.frame=CGRectMake(button.titleLabel.frame.origin.x-16, button.titleLabel.frame.origin.y, 16, 16);
            }
        }
        
		++index;
	}
}
#pragma mark - Buttons & indicator Management -
- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];
	_selectedIndex = NSNotFound; //默认无选择
    
    //默认选择
    //	NSUInteger lastIndex = _selectedIndex;
    //	self.selectedIndex = lastIndex;
}
//添加Button
- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

		UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
		button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
		button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
        
		[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
		[button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        //NSLog(@"button.frame:%f,%f,%f,%f",button.frame.origin.x,button.frame.origin.y,button.frame.size.width,button.frame.size.height);
		[self deselectTabButton:button];
        
        UIImageView* imageView=[[UIImageView alloc]init];
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.normalImageArray objectAtIndex:index]]];

		[tabButtonsContainerView addSubview:button];
        [button addSubview:imageView];
		++index;
	}
}
//移除子视图Button
- (void)removeTabButtons
{
	while ([tabButtonsContainerView.subviews count] > 0)
	{
		[[tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}
//设置标记图片的位置Center
- (void)centerIndicatorOnButton:(UIButton *)button
{
	CGRect rect = indicatorImageView.frame;
	rect.origin.x = button.center.x - floorf(indicatorImageView.frame.size.width/2.0f);
    rect.origin.y = TABBAR_HEIGHT + viewRect.origin.y - indicatorImageView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
       	indicatorImageView.frame = rect;
    }];
}

#pragma mark -Override SelectedVC GET SET-
//重写SelectedVC Get方法
- (UIViewController *)selectedViewController
{
    //获取当前选中的VC
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}
//重写SelectedVC Set方法
- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}
//重载set方法 添加animated参数
- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}
#pragma mark - Set ViewControllers & SelectedIndex -
- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}
- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
//	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}
    
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController = nil;
		UIViewController *toViewController = nil;
		NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;
		UIButton *toButton;
        
        //From索引不为空 Set Deselect State
        if (oldSelectedIndex != NSNotFound) {
            //set FromButton
			UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + oldSelectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
        }
        //To索引不为空 Set Selected State
		if (newSelectedIndex != NSNotFound)
		{
            //set ToButton
			toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + newSelectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
       // NSLog(@"%@",self.selectedViewController);
        //如果ToView为空 将FromView移除
		if (toViewController == nil)
		{
            UIButton *fromButton=(UIButton *)[self.view viewWithTag:oldSelectedIndex + TagOffset];
            [self deselectTabButton:fromButton];
            
            CGRect rect= contentContainerView.bounds;
            rect.origin.y = rect.origin.y - rect.size.height;
            fromViewController.view.frame = rect;
            [self setShade:NO];

			[fromViewController.view removeFromSuperview];
		}
        //如果FromView为空
		else if (fromViewController == nil)
		{
//            CGRect rect= contentContainerView.bounds;
//            rect.origin.y -= rect.size.height;
//            toViewController.view.frame = rect;
//            NSLog(@"(%f,%f)(%f,%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
            
            CGRect rect= contentContainerView.bounds;
            rect.origin.y -= rect.size.height;
            contentContainerView.frame = rect;
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rectTo = contentContainerView.frame;
                rectTo.origin.y = rectTo.origin.y + rectTo.size.height+64+44;
                contentContainerView.frame = rectTo;
            }];
            [self setShade:YES];

			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else
		{
            [fromViewController.view removeFromSuperview];
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
    }
}
//重写ViewControllers Set方法
- (void)setViewControllers:(NSArray *)newViewControllers
{
	//NSAssert([newViewControllers count] >= 2, @"TabBarController requires at least two view controllers");
    
	UIViewController *oldSelectedViewController = self.selectedViewController;
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
	_viewControllers = [newViewControllers copy];
    
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
    
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound && newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;
    
    //设置vc的观察者属性，通知回调函数
    for (int i=0 ; i<[_viewControllers count]; i++) {
        UIViewController *VC = [_viewControllers objectAtIndex:i];
        [VC addObserver:self forKeyPath:@"selectedText" options: NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:(__bridge void *)([NSString stringWithFormat:@"viewlist%d",i+1])];
    }
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
	if ([self isViewLoaded])
		[self reloadTabButtons];
}
#pragma mark -Logic & ObserveValueKey-
//对ViewController 设置观察者回调函数
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *newValue = [change objectForKey:@"new"];
    UIButton *toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
    toButton.titleEdgeInsets = UIEdgeInsetsMake(toButton.titleEdgeInsets.top, 10, toButton.titleEdgeInsets.bottom, 10);
    [toButton setTitle:newValue forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(subViewController:SelectedCell:)])
	{
        [self.delegate subViewController:self.selectedViewController SelectedCell:newValue];
	}
    [self setSelectedIndex:NSNotFound];
}
//设置显示阴影层
- (void) setShade:(BOOL) isDisplay
{
    if (!isDisplay) {
        self.view.frame=CGRectMake(0, 0, 320, 64+TABBAR_HEIGHT);
        contentContainerView.hidden=YES;
        shadowView.hidden=YES;
        indicatorImageView.hidden=YES;
    }
    else{
        self.view.frame=CGRectMake(0, 0, 320, 640);
        contentContainerView.hidden=NO;
        shadowView.hidden=NO;
        indicatorImageView.hidden=NO;
    }
}
//TabButton点击事件
- (void)tabButtonPressed:(UIButton *)sender
{
//    [self setSelectedIndex:sender.tag - TagOffset animated:NO];
    if (_selectedIndex == sender.tag - TagOffset) {
        [self setSelectedIndex:NSNotFound];
    }
    else{
        [self setSelectedIndex:sender.tag - TagOffset animated:NO];
    }
}
#pragma mark - Gesture Handle
- (void) handleTap:(UITapGestureRecognizer *) gesture
{
    [self setSelectedIndex:NSNotFound];
}
#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
    //setTitle
    [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
	UIImage *image = [[UIImage imageNamed:@"classify_bg@2x.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]];
	[button setTitleColor:[UIColor colorWithRed:214/255.0 green:112/255.0 blue:115/255.0 alpha:1.0] forState:UIControlStateNormal];
	//[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
    if (self.selectedImageOfButton)
    {
        image=[self.selectedImageOfButton stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    if (self.selectedTitleOfButton)
    {
        [button setTitleColor:self.selectedTitleOfButton forState:UIControlStateNormal];
    }
    for (id obj in button.subviews)
    {
        if ([obj isKindOfClass:[UIImageView class]])
        {
            UIImageView* iv=(UIImageView*)obj;
            iv.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.selectedImageArray objectAtIndex:(button.tag-TagOffset)]]];
        }
    }

}

- (void)deselectTabButton:(UIButton *)button
{
    //setTitle
	UIImage *image = [[UIImage imageNamed:@"classify_bg@2x.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]];
	[button setTitleColor:[UIColor colorWithRed:122/255.0f green:122/255.0f blue:122/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.normalImageOfButton)
    {
        image=[self.normalImageOfButton stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    if (self.normalTitleOfButton)
    {
        [button setTitleColor:self.normalTitleOfButton forState:UIControlStateNormal];
    }
    for (id obj in button.subviews)
    {
        if ([obj isKindOfClass:[UIImageView class]])
        {
            UIImageView* iv=(UIImageView*)obj;
            iv.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.normalImageArray objectAtIndex:(button.tag-TagOffset)]]];
        }
    }


}

- (CGFloat)tabBarHeight
{
	return 44.0f;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    
	if ([self isViewLoaded] && self.view.window == nil)
	{
		self.view = nil;
		tabButtonsContainerView = nil;
		contentContainerView = nil;
		indicatorImageView = nil;
        shadowView = nil;
	}
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)deleteObserver
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if (![self.isPush isEqualToString:@"0"]) {
            for (int i=0 ; i<[_viewControllers count]; i++) {
                UIViewController *VC = [_viewControllers objectAtIndex:i];
                // [VC addObserver:self forKeyPath:@"selectedText" options: NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:(__bridge void *)([NSString stringWithFormat:@"viewlist%d",i+1])];
                [VC removeObserver:self forKeyPath:@"selectedText"];
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        if (![self.isPush isEqualToString:@"0"]) {
//            for (int i=0 ; i<[_viewControllers count]; i++) {
//                UIViewController *VC = [_viewControllers objectAtIndex:i];
//                // [VC addObserver:self forKeyPath:@"selectedText" options: NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:(__bridge void *)([NSString stringWithFormat:@"viewlist%d",i+1])];
//                [VC removeObserver:self forKeyPath:@"selectedText"];
//            }
//        }
//    }
}
@end
