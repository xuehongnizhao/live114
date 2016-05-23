//
//  ImageUploadViewController.m
//  cityo2o
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 Sky. All rights reserved.
//图片路况

#import "ImageUploadViewController.h"

@interface ImageUploadViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentLocation;
@property (weak, nonatomic) IBOutlet UIButton *EtoW;
@property (weak, nonatomic) IBOutlet UIButton *WtoE;
@property (weak, nonatomic) IBOutlet UIButton *StoN;
@property (weak, nonatomic) IBOutlet UIButton *NtoS;
@property (weak, nonatomic) IBOutlet UITextView *descriptionForCondition;
@property (weak, nonatomic) IBOutlet UIButton *sendCondition;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIView *locationCell;

@end

@implementation ImageUploadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
- (IBAction)dismissViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)takePhoto:(UIButton *)sender {
    
}
- (IBAction)EtoW:(UIButton *)sender {
    self.EtoW.selected=!self.EtoW.selected;
}
- (IBAction)WtoE:(UIButton *)sender {
    self.WtoE.selected=!self.WtoE.selected;
}
- (IBAction)StoN:(UIButton *)sender {
    self.StoN.selected=!self.StoN.selected;
}
- (IBAction)NtoS:(UIButton *)sender {
    self.NtoS.selected=!self.NtoS.selected;
}
- (IBAction)sendCondition:(UIButton *)sender {
    
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
    
}

- (void)loacationCellAction{
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}


@end
