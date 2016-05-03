//
//  SpikeCodeViewController.m
//  CardLeap
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "SpikeCodeViewController.h"
#import "SpikeCodeTableViewCell.h"
#import "MySpikeListViewController.h"
#import "CouponDetailViewController.h"

@interface SpikeCodeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *spikeCodeTableview;
@end

@implementation SpikeCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------get UI
-(UITableView *)spikeCodeTableview
{
    if (!_spikeCodeTableview) {
        _spikeCodeTableview = [[UITableView alloc] initForAutoLayout];
        _spikeCodeTableview.delegate = self;
        _spikeCodeTableview.dataSource = self;
        [_spikeCodeTableview setScrollEnabled:NO];
        _spikeCodeTableview.separatorInset = UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_spikeCodeTableview];
    }
    return _spikeCodeTableview;
}

#pragma mark-------set UI
-(void)setUI
{
    [self.view addSubview:self.spikeCodeTableview];
    [_spikeCodeTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_spikeCodeTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_spikeCodeTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_spikeCodeTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
}

#pragma mark-------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    CouponDetailViewController *firVC = [[CouponDetailViewController alloc] init];
    [firVC setNavBarTitle:self.info.spike_name withFont:14.0f];
    firVC.message_url = self.info.message_url;
    firVC.share_url = self.info.share_url;
    [firVC setHiddenTabbar:YES];
    [self.navigationController pushViewController:firVC animated:YES];
//    MySpikeListViewController *firVC = [[MySpikeListViewController alloc] init];
//    [firVC setHiddenTabbar:YES];
//    [firVC.navigationItem setTitle:@"我的优惠券"];
//    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0;
    }else{
      return 5.0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 1;
    
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 200;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"spike_message_cell";
    SpikeCodeTableViewCell *cell=(SpikeCodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[SpikeCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    NSDictionary *dic = @{
                          @"spike_code":self.spike_code,
                          @"spike_desc":self.info.spike_name,
                          @"spike_end_time":self.info.spike_end_time
                          };
    [cell configureCell:dic section:indexPath.section];
    //cell.showsReorderControl = YES;
    return cell;
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
