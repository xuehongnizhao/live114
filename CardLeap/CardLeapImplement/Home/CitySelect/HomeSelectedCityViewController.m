//
//  HomeSelectedCityViewController.m
//  WeiBang
//
//  Created by songweipng on 15/3/17.
//  Copyright (c) 2015年 songweipng. All rights reserved.
//

#import "HomeSelectedCityViewController.h"

#import "HomeSelectedCityHeaderView.h"

#import "MyChineseBookAddress.h"
#import "MJExtension.h"
#import "CityModule.h"



@interface HomeSelectedCityViewController () <UITableViewDataSource, UITableViewDelegate, HomeSelectedCityHeaderViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UITableView *selectedCityTableView;

@property (strong, nonatomic) HomeSelectedCityHeaderView *headerView;


@property(nonatomic,strong)UISearchBar* searchBar;

@property(nonatomic,strong)UISearchDisplayController* searchController;

@property(nonatomic,strong)NSArray* filterArray;


@end

@implementation HomeSelectedCityViewController
{
    NSMutableArray* moduleArray;
    
    NSString* selectCityName;
    
    NSString* selectCityID;

    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"城市列表";
    
    [self getCity];
    moduleArray=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.m_tableView.delegate   = self;
    self.m_tableView.dataSource = self;
    [self.view addSubview:_m_tableView];
    
    [self.view addSubview:self.searchBar];
    
    [self.searchBar sizeToFit];

    [_m_tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar];
    [_m_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom   withInset:0.0f];
    [_m_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft     withInset:0.0f];
    [_m_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight    withInset:0.0f];
    _m_tableView.keyboardDismissMode = YES;
    
    // 设置头部代理 控件 数据 代理方法
    _m_tableView.tableHeaderView     = self.headerView;
   
    if (_isFirstShow==YES)
    {
        [self.navigationItem setHidesBackButton:YES];
    }

    //[self getCity];
}



-(void)viewDidLayoutSubviews
{
    //    if (IS_HEIGHT_GTE_568==0) {
    //        CGRect rect = _m_tableView.frame;
    //        rect
    //    }
}

-(void)setUI
{
    self.m_allName = [[NSMutableArray alloc] init];
    for (int i=0; i<self.dataArray.count; i++) {
        char firstChar = pinyinFirstLetter([[self.dataArray objectAtIndex:i] characterAtIndex:0]);
        NSString *youName = [NSString stringWithFormat:@"%c",firstChar];
        //不添加重复元素
        if (![_m_allName containsObject:[youName uppercaseString]]) {
            [self.m_allName addObject:[youName uppercaseString]];
        }
        
    }
    
    [self.m_allName sortUsingSelector:@selector(compare:)];
    //
    nameDic = [[NSMutableDictionary alloc] init];
    //每个section对应的行数列表
    for(NSString * sectionString  in _m_allName)
    {
        NSMutableArray *rowSource = [[NSMutableArray alloc] init];
        for (NSString *charString in self.dataArray) {
            char firstChar = pinyinFirstLetter([charString characterAtIndex:0]);
            NSString *youName = [NSString stringWithFormat:@"%c",firstChar];
            if ([sectionString isEqualToString:[youName uppercaseString]]) {
                [rowSource addObject:charString];
            }
        }
        
        [nameDic setValue:rowSource forKey:sectionString];
        
    }
    
}

-(void)getCity
{
    
//    NSLog(@"user_city:%@",USER_CITY);
    NSString *url = connect_url(@"shop_city");
    NSDictionary* dict=@{
                         @"app_key":url,
                         };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        
        if ([param[@"code"] integerValue]==200)
        {
            NSArray* arr=[CityModule objectArrayWithKeyValuesArray:[param objectForKey:@"obj"]];
            self.dataArray=[[NSMutableArray alloc]init];
            [moduleArray addObjectsFromArray:arr];
            for (CityModule* module in arr)
            {
                [self.dataArray addObject:module.city_name];
                [self setUI];
                [_m_tableView reloadData];
                [_headerView openLoaction];
            }
        }
        
    } andErrorBlock:^(NSError *error) {

        [SVProgressHUD showErrorWithStatus:@"网络异常！"];
    }];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (tableView==self.searchController.searchResultsTableView)
    {
        return [self.filterArray count];
    }
    else
    {
        NSArray *dicCount = [nameDic objectForKey:[_m_allName objectAtIndex:section]];
        return [dicCount count];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.searchController.searchResultsTableView)
    {
        return 1;
    }
    return [_m_allName count];
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_m_allName objectAtIndex:section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
    
    for(char c = 'A';c<='Z';c++)
        
        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    
    return toBeReturned;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.searchController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"citychose";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        CityModule* module=[self.filterArray objectAtIndex:indexPath.row];
        cell.textLabel.text=module.city_name;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString * sectionString = [_m_allName objectAtIndex:indexPath.section];
        
        NSArray *allShowName = [nameDic objectForKey:sectionString];
        if (allShowName.count>0) {
            cell.textLabel.text = [allShowName objectAtIndex:indexPath.row];
        }
        
        return cell;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSInteger count = 0;
    for(NSString *character in _m_allName)
    {
        if([character isEqualToString:title]) return count;
        count ++;
    }
    
    return 0;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.searchController.searchResultsTableView)
    {
        CityModule* module=[self.filterArray objectAtIndex:indexPath.row];
        [self.delegate choseTheCityModule:module];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        NSString * sectionString = [_m_allName objectAtIndex:indexPath.section];
        
        NSArray *allShowName = [nameDic objectForKey:sectionString];
        NSString* cityName=[allShowName objectAtIndex:indexPath.row];
        [self.delegate choseTheCity:cityName];
        
        for (CityModule* module in moduleArray)
        {
            if ([module.city_name isEqualToString:cityName])
            {
                [self.delegate choseTheCityModule:module];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void) homeSelectedCityHeaderView:(HomeSelectedCityHeaderView *)cityHeaderView cityName:(NSString *)cityName cityID:(NSString *)cityID {
    
    __block BOOL isHaveCity=NO;
    [moduleArray enumerateObjectsUsingBlock:^(CityModule* obj, NSUInteger idx, BOOL *stop) {
        //如果在列表中能够查找到相应的城市
        if ([cityName rangeOfString:obj.city_name].location!=NSNotFound)
        {
            [cityHeaderView.homeSelectedCityDescView setTitle:obj.city_name forState:UIControlStateNormal];
            
            selectCityID=obj.city_id;
            selectCityName=obj.city_name;
            
            isHaveCity=YES;
        }
        
    }];
    
    if (!isHaveCity)
    {
        [cityHeaderView.homeSelectedCityDescView setUserInteractionEnabled:NO];
        [SVProgressHUD showErrorWithStatus:@"当前城市暂未开通"];
    }
    
    
}

-(void)clickButtonPopController
{
    if ([self.delegate respondsToSelector:@selector(homeSelectedCityViewController:currentCityName:currentCityID:)])
    {
        [self.delegate homeSelectedCityViewController:self currentCityName:selectCityName currentCityID:selectCityID];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - searchDisplayControllerDelegate

-(NSArray*)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSMutableArray* tempArr=[[NSMutableArray alloc]init];
    
    for (CityModule* module in moduleArray)
    {
        if ([module.city_name rangeOfString:searchText].location!=NSNotFound)
        {
            [tempArr addObject:module];
        }
    }
    
    return tempArr;
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSMutableArray* searchArray=[[NSMutableArray alloc]init];
    [searchArray addObjectsFromArray:[self filterContentForSearchText:searchString scope:nil]];
    /**
     *  查重
     */
    _filterArray=searchArray;
    return YES;
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
    
}



#pragma mark - Property Accessor

- (HomeSelectedCityHeaderView *)headerView {
    
    if (!_headerView) {

        _headerView = [[HomeSelectedCityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _headerView.delegate         = self;
        _headerView.currentCityName  = self.currentCityName;
        _headerView.cityID           = self.cityID;
    }
    return _headerView;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.barStyle=UIBarStyleDefault;
        _searchBar.translucent=YES;
        _searchBar.tintColor=[UIColor blackColor];
        _searchBar.backgroundColor=[UIColor whiteColor];
        _searchBar.delegate=self;
        _searchBar.placeholder=@"搜索";
        [_searchBar sizeToFit];
    }
    return _searchBar;
}

-(UISearchDisplayController *)searchController
{
    if (!_searchController)
    {
        _searchController=[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        _searchController.searchResultsDelegate=self;
        _searchController.searchResultsDataSource=self;
        _searchController.delegate=self;
    }
    return _searchController;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_headerView stopLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
