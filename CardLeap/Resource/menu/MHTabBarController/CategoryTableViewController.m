//
//  CategoryTableViewController.m
//  Tuan
//
//  Created by 李凯 on 14-4-16.
//  Copyright (c) 2014年 Liekksa. All rights reserved.
//

#import "CategoryTableViewController.h"
//#import "LinDataMgr.h"
#define LeftWidth 158
#define RightWidth 161
#define TableViewHeight 250

#define TOPIC_FONT [UIFont fontWithName:@"Helvetica-Bold" size:20]
#define TOPIC_COLOR [UIColor colorWithRed:0.239 green:0.753 blue:0.698 alpha:1]
#define TEXT_COLOR_WHITE [UIColor whiteColor]
#define MENU_COLOR_LightGray [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
#define MENU_TEXT_DeepGray [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]
#define MENU_TEXT_FONT [UIFont fontWithName:@"Heiti SC" size:13]


@interface CategoryTableViewController ()
{
    NSString *selectKey;
    BOOL is_eixt;
}

@end

@implementation CategoryTableViewController
{
    NSString* str;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    selectKey = 0;
    _dataDict= [[NSMutableDictionary alloc] init];
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LeftWidth, TableViewHeight)];
//    _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_leftTableView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    _leftTableView.separatorInset =  UIEdgeInsetsZero;
    [_leftTableView setAccessibilityViewIsModal:YES];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(LeftWidth, 0, RightWidth, TableViewHeight) style:UITableViewStylePlain];
    _rightTableView.layer.shadowColor = [UIColor clearColor].CGColor;
    _rightTableView.layer.shadowOffset = CGSizeMake(0.3, 0.2);
    _rightTableView.layer.shadowOpacity = 0.2;
    _rightTableView.bounces = YES;
    [_rightTableView setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]];
//    _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    [self.view addSubview:_rightTableView];
    [UZCommonMethod hiddleExtendCellFromTableview:_rightTableView];
}

//设置默认选中
-(void)setSelectMenu
{
    //_dataDict
    NSArray *arrays = [_dataDict allValues];
    int index = 1;
    for (NSArray *array in arrays) {
        if ([array count]>0) {
            NSIndexPath *first = [NSIndexPath
                                  indexPathForRow:index inSection:0];
            
            
            [_leftTableView selectRowAtIndexPath:first
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionTop];
            
            //first = [NSIndexPath indexPathForRow:index+1 inSection:0];
            selectKey = [_leftTableView cellForRowAtIndexPath:first].textLabel.text;
            NSLog(@"%@",selectKey);
            if ([[_dataDict objectForKey:selectKey] count]==0) {
                // NSLog(@"haha");
                self.selectedText = selectKey;
            }
            [_rightTableView reloadData];
            break;
        }
        index++;
    }
}

-(BOOL)is_exitRightTableView
{
    BOOL result = NO;
    NSArray *arr = [self.dataDict allKeys];
    for (NSString *key in arr) {
        NSArray *rightArray = [self.dataDict objectForKey:key];
        if ([rightArray count]!=0) {
            result = YES;
            return result;
        }
    }
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return [[_dataDict allKeys] count]+1;
    }
    else {
        return [[_dataDict objectForKey:selectKey] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if (tableView==_leftTableView) {
        NSString *currentKey;
        if (indexPath.row == 0) {
            currentKey = self.title;
        }
        else{
            currentKey = [[_dataDict allKeys] objectAtIndex:indexPath.row-1];
        }
        cell.textLabel.text = currentKey;
        
        NSArray *currentArray=[_dataDict objectForKey:currentKey];
        if ([currentArray count]>=0) {
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[currentArray count]];
        }
        cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //[tableView setSeparatorColor:[UIColor clearColor]];
        //[self setLeftCellStyle:cell];
    }
    else if (tableView == _rightTableView)
    {
        NSArray *valueArray =[_dataDict objectForKey:selectKey];
        cell.textLabel.text = [valueArray objectAtIndex:indexPath.row];
        [self setRightCellStyle:cell];
        cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    }
    cell.textLabel.font = MENU_TEXT_FONT;
    cell.detailTextLabel.font = MENU_TEXT_FONT;
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index------ %d",indexPath.row);
    if(tableView==_leftTableView)
    {
        selectKey = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        NSLog(@"----------------");
        NSLog(@"selectkey:%@",selectKey);
        if ([[_dataDict objectForKey:selectKey] count]==0) {
           // NSLog(@"haha");
            self.selectedText = selectKey;
        }
        [_rightTableView reloadData];
    }
    if(tableView==_rightTableView)
    {
        self.selectedText = [[_dataDict objectForKey:selectKey] objectAtIndex:indexPath.row];
          NSLog(@"%@",self.selectedText);
//        self.selectedText
//        NSLog(@"%@",self.parentViewController);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateParams" object:self.parentViewController];
    }
    [_leftTableView deselectRowAtIndexPath:indexPath animated:YES];
    [_rightTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void) setLeftCellStyle:(UITableViewCell *) cell
{
//    UIView *selectionColor = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 2)];
//    selectionColor.backgroundColor = [UIColor whiteColor];
//    cell.selectedBackgroundView = selectionColor;
//    cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
//    [selectionColor release];
    
}
- (void) setRightCellStyle:(UITableViewCell *) cell
{
//    UIView *selectionColor = [[UIView alloc] init];
//    selectionColor.backgroundColor = [UIColor clearColor];
//    cell.selectedBackgroundView = selectionColor;
//    [selectionColor release];
//    UIImageView *line = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 44, 310, 0.5)] autorelease];
//    line.backgroundColor = [UIColor purpleColor];
//    [cell addSubview:line];
//    [cell bringSubviewToFront:line];
    
   // cell.textLabel.highlightedTextColor = TOPIC_COLOR;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    is_eixt = [self is_exitRightTableView];
    if (is_eixt) {
        
    }else
    {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LeftWidth+RightWidth, TableViewHeight) style:UITableViewStylePlain];
        //    _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
         _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [self.view addSubview:_leftTableView];
        _leftTableView.separatorInset = UIEdgeInsetsMake(0,10,0,10);
        [UZCommonMethod hiddleExtendCellFromTableview:_leftTableView];
    }
    [self setSelectMenu];
}
@end
