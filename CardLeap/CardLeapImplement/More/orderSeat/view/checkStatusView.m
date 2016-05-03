//
//  checkStatusView.m
//  CardLeap
//
//  Created by mac on 15/1/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "checkStatusView.h"

@interface checkStatusView()
{
    NSTimer *timer;
}
@property (strong,nonatomic)UILabel *hintLable;
@property (strong,nonatomic)UIButton *waitButton;
@property (strong,nonatomic)UIButton *cancelButton;
@end

@implementation checkStatusView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor clearColor];
        //self.layer.borderWidth = 1;
    }
    return self;
}

-(void)dealloc
{
    [timer invalidate];
}

-(void)setSeatId :(NSString*)seat_id
{
    self.seat_id = seat_id;
    [self initTimer];
    [self setUI];
}

-(void)initTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateOrderState) userInfo:nil repeats:YES];
}

-(void)updateOrderState
{
    if (![self.identifier isEqualToString:@"1"]) {
        NSString *url = connect_url(@"seat_status");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"seat_id":self.seat_id
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                [SVProgressHUD dismiss];
                if ([[param[@"obj"] objectForKey:@"is_status"] integerValue]==1) {
                    [self removeFromSuperview];
                    [timer invalidate];
                    [self.delegate orderSuccessAction];
                }else{
                    
                }
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }else{
        NSString *url = connect_url(@"hotel_status");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"hotel_id":self.seat_id
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                [SVProgressHUD dismiss];
                if ([[param[@"obj"] objectForKey:@"is_status"] integerValue]==1) {
                    [self removeFromSuperview];
                    [timer invalidate];
                    [self.delegate orderSuccessAction];
                }else{
                    
                }
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }
}

#pragma mark-----set UI
-(void)setUI
{
    [self addSubview:self.hintLable];
    [_hintLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_hintLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_hintLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    [_hintLable autoSetDimension:ALDimensionHeight toSize:30.0f];
    
    UIView *lView = [[UIView alloc] initForAutoLayout];
    [self addSubview:lView];
    [lView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_hintLable withOffset:50.0f];
    [lView autoSetDimension:ALDimensionHeight toSize:80.5f];
    lView.backgroundColor = [UIColor whiteColor];
    lView.layer.masksToBounds = YES;
    lView.layer.cornerRadius = 4.0f;
    //lView.layer.borderWidth = 1;
    
    [lView addSubview:self.waitButton];
    [_waitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_waitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_waitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_waitButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    lineImage.backgroundColor = [UIColor lightGrayColor];
    [lView addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_waitButton withOffset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    
    [lView addSubview:self.cancelButton];
    [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_cancelButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:0.0f];
    [_cancelButton autoSetDimension:ALDimensionHeight toSize:40.0f];
}

#pragma mark-----get UI
-(UILabel *)hintLable
{
    if (!_hintLable) {
        _hintLable = [[UILabel alloc] initForAutoLayout];
        _hintLable.font = [UIFont systemFontOfSize:15.0f];
        _hintLable.textColor = [UIColor whiteColor];
        _hintLable.text = @"店小二为您预定成功！店家为您安排座位中";
        _hintLable.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLable;
}

-(UIButton *)waitButton
{
    if (!_waitButton) {
        _waitButton = [[UIButton alloc] initForAutoLayout];
        [_waitButton setBackgroundColor:[UIColor whiteColor]];
        [_waitButton setTitle:@"继续等待" forState:UIControlStateNormal];
        [_waitButton setTitle:@"继续等待" forState:UIControlStateHighlighted];
        [_waitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_waitButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_waitButton addTarget:self action:@selector(waitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _waitButton;
}

-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initForAutoLayout];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateHighlighted];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(void)waitAction:(UIButton*)sender
{
    [timer invalidate];
    [self removeFromSuperview];
    [self.delegate cancelAction];
}

-(void)cancelAction:(UIButton*)sender
{
    [timer invalidate];
    NSLog(@"取消订单");
    [self.delegate deleteOrderSeat];
}

@end
