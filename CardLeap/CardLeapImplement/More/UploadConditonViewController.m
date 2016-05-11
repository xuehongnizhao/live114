//
//  UploadConditonViewController.m
//  cityo2o
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "UploadConditonViewController.h"

@interface UploadConditonViewController ()
{
    
}
@property (strong, nonatomic) UIButton *goBack;
@property (strong, nonatomic) UIButton *voice;
@end

@implementation UploadConditonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (UIButton *)goBack{
    if (!_goBack) {
        _goBack =[[UIButton alloc]initForAutoLayout];
        [_goBack addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
        [_goBack setImage:[UIImage imageNamed:@"park"] forState:UIControlStateNormal];
        
    }
    return _goBack;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (void)setUI{
    self.navigationController.navigationBarHidden=YES;
    [self.view addSubview:self.goBack];
    [_goBack autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [_goBack autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [_goBack autoSetDimensionsToSize:CGSizeMake(30, 30)];
}



@end
