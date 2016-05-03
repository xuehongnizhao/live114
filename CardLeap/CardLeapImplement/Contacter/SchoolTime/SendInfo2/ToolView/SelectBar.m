//
//  SelectBar.m
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "SelectBar.h"

@implementation SelectBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self setButton];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320*LinPercent, 2)];
        view.backgroundColor=UIColorFromRGB(0xf4f4f4);
        [self addSubview:view];
    }
    return self;
}

-(void)setButton
{
    CGFloat blankWidth = (SCREEN_WIDTH - 23*4 - 57*3*LinPercent)/2.0;
    NSArray* nomarlImage=@[@"issue_face_no",@"issue_camera_no",@"issue_picture_no",@"issue_micro_no"];
    NSArray* selectedImage=@[@"issue_face_sel",@"issue_camera_sel",@"issue_picture_sel",@"issue_micro_no"];
    for (int i=0; i<4; i++)
    {
        UIButton* button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(57*i*LinPercent+blankWidth+i*23, 13, 23, 23);
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",nomarlImage[i]]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",selectedImage[i]]] forState:UIControlStateSelected];
        button.tag=i+1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)buttonClick:(UIButton*)sender
{
    [self.delegate selectecButtonTag:sender.tag];
    if (sender.tag==1)
    {
        NSLog(@"弹出表情键盘，FaceBoard");
    }
    else if (sender.tag==2)
    {
        NSLog(@"选取相机,并弹出photoView");
    }
    else if (sender.tag==3)
    {
        NSLog(@"选择图片,弹出photoView");
    }
    else if (sender.tag==4)
    {
        NSLog(@"播放语音，弹出VoiceView");
    }
    else
    {
        NSLog(@"按钮点击错误");
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
