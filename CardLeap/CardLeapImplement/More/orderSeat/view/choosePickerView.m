//
//  choosePickerView.m
//  CardLeap
//
//  Created by mac on 15/1/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "choosePickerView.h"

@interface choosePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *year;
    NSString *date;
    NSString *time;
    NSString *people;
}
@property (strong,nonatomic)UIPickerView *pickerVier;
@property (strong,nonatomic)UIButton *confirmButton;
@property (strong,nonatomic)UIButton *cancelButton;
@end

@implementation choosePickerView

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
        self.backgroundColor=[UIColor whiteColor];
        //self.layer.borderWidth = 1;
    }
    return self;
}

-(void)initWithArray :(NSArray*)timeArray CountArray:(NSArray*)countArray dateArray:(NSArray*)dateArray year:(NSArray*)years
{
    self.countArray = countArray;
    self.timeArray = timeArray;
    self.dateArray = dateArray;
    self.yearArray = years;
    [self initData];
    [self setUI];
}

-(void)setUI
{
    [self addSubview:self.pickerVier];
    [_pickerVier autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_pickerVier autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_pickerVier autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_pickerVier autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40.0f];
    
    [self addSubview:self.confirmButton];
    [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_pickerVier withOffset:0.0f];
    [_confirmButton autoSetDimension:ALDimensionWidth toSize:150*LinPercent];
    
    [self addSubview:self.cancelButton];
    [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_cancelButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_pickerVier withOffset:0.0f];
    [_cancelButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_confirmButton withOffset:0.0f];
}

-(void)initData
{
    date = [self.dateArray objectAtIndex:0];
    time =  [self.timeArray objectAtIndex:0];
    people =  [self.countArray objectAtIndex:0];
    year = [self.yearArray objectAtIndex:0];
}

#pragma mark------picker delegate
#pragma mark------uipickerview delegate

//确定picker的轮子个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {//省份个数
        return [self.dateArray count];
    } else if(component == 1){//市的个数
        return [self.timeArray count];
    }else{
        return [self.countArray count];
    }
}
//确定每个轮子的每一项显示什么内容
#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {//省份个数
        return [self.dateArray objectAtIndex:row];
    } else if(component == 1){//市的个数
        return [self.timeArray objectAtIndex:row];
    }else{
        return [self.countArray objectAtIndex:row];
    }
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSLog(@"%@",[self.dateArray objectAtIndex:row]);
        date = [self.dateArray objectAtIndex:row];
        year = [self.yearArray objectAtIndex:row];
    }else if(component == 1){
        NSLog(@"%@",[self.timeArray objectAtIndex:row]);
        time = [self.timeArray objectAtIndex:row];
    }else{
        NSLog(@"%@",[self.countArray objectAtIndex:row]);
        people = [self.countArray objectAtIndex:row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [self.dateArray objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else if(component == 1){
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [self.timeArray objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else{
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [self.countArray objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}


#pragma mark------get UI
-(UIPickerView *)pickerVier
{
    if (!_pickerVier) {
        _pickerVier = [[UIPickerView alloc] initForAutoLayout];
        _pickerVier.delegate = self;
        _pickerVier.dataSource = self;
    }
    return _pickerVier;
}

-(UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initForAutoLayout];
        [_confirmButton setBackgroundColor:[UIColor blackColor]];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateHighlighted];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initForAutoLayout];
        [_cancelButton setBackgroundColor:[UIColor blackColor]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(void)confirmAction:(UIButton*)sender
{
    NSLog(@"confirm");
    [self removeFromSuperview];
    [self.delegate confirmDelegate:date time:time count:people year:year];
}

-(void)cancelAction:(UIButton*)sender
{
    NSLog(@"cancel");
    [self removeFromSuperview];
    [self.delegate cancelActionDelegate];
}

@end
