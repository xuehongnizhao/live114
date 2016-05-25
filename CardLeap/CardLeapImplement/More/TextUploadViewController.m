//
//  TextUploadViewController.m
//  cityo2o
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 Sky. All rights reserved.
//文字路况

#import "TextUploadViewController.h"

@interface TextUploadViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *currentLocation;
@property (weak, nonatomic) IBOutlet UIButton *EtoW;
@property (weak, nonatomic) IBOutlet UIButton *WtoE;
@property (weak, nonatomic) IBOutlet UIButton *StoN;
@property (weak, nonatomic) IBOutlet UIButton *NtoS;
@property (weak, nonatomic) IBOutlet UITextView *descriptionForCondition;
@property (weak, nonatomic) IBOutlet UIButton *sendCondition;
@property (weak, nonatomic) IBOutlet UIView *locationCell;
@property (strong, nonatomic) NSString *lastChosenMediaType;
@property (strong, nonatomic) UIImageView *contentimageview;
@property (strong, nonatomic) UITableView *locationChose;
@end

@implementation TextUploadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
- (IBAction)dismissViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 2016.5 调用相册
- (void)setNearbyRoad:(NSArray *)nearbyRoad{
    _nearbyRoad=nearbyRoad;
}

- (IBAction)direction:(UIButton *)sender {
    sender.selected=!sender.selected;
}

- (IBAction)roadConditon:(UIButton *)sender {
        sender.selected=!sender.selected;
}



- (void)setUI{
    self.EtoW.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.EtoW.layer.borderWidth=2.f;
    self.WtoE.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.WtoE.layer.borderWidth=2.f;
    self.StoN.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.StoN.layer.borderWidth=2.f;
    self.NtoS.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.NtoS.layer.borderWidth=2.f;
    self.sendCondition.layer.cornerRadius=5.f;
    self.sendCondition.clipsToBounds=YES;
    self.EtoW.layer.cornerRadius=5.f;
    self.EtoW.clipsToBounds=YES;
    self.WtoE.layer.cornerRadius=5.f;
    self.WtoE.clipsToBounds=YES;
    self.StoN.layer.cornerRadius=5.f;
    self.StoN.clipsToBounds=YES;
    self.NtoS.layer.cornerRadius=5.f;
    self.NtoS.clipsToBounds=YES;
    self.descriptionForCondition.delegate=self;
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loacationCellAction)];
    [self.locationCell addGestureRecognizer:tapG];
    self.currentLocation.text=self.nearbyRoad[0];
    
}

- (void)loacationCellAction{
    _locationChose=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    _locationChose.delegate=self;
    _locationChose.dataSource=self;
    [self.view addSubview:_locationChose];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSLog(@"%@",self.nearbyRoad[indexPath.row]);
    cell.textLabel.text=self.nearbyRoad[indexPath.row];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nearbyRoad.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentLocation.text=self.nearbyRoad[indexPath.row];
    [UIView animateWithDuration:.35 animations:^{
        self.locationChose.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.locationChose=nil;
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}


@end
