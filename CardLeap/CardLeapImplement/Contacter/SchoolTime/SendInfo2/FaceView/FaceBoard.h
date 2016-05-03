//
//  FaceBoard.h
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood


#import <UIKit/UIKit.h>

#import "FaceButton.h"

#import "GrayPageControl.h"


#define FACE_NAME_HEAD  @"["

#define FACE_NAME_FOOT  @"]"

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   4

@protocol FaceBoardDelegate <NSObject>

@optional

- (void)faceBoardTextViewDidChange:(UITextView *)textView andDelete:(BOOL)  isDelete;
-(void)textFieldDidChange:(UITextField*)textField;
-(void)faceBoardDeleteFinsish:(UITextView*)text;
@end


@interface FaceBoard : UIView<UIScrollViewDelegate>
{

    UIScrollView *faceView;

    GrayPageControl *facePageControl;

    NSDictionary *_faceMap;
}

@property(nonatomic)BOOL isShow;
@property (nonatomic, assign) id<FaceBoardDelegate> delegate;


@property (nonatomic, retain) UITextField *inputTextField;

@property (nonatomic, retain) UITextView *inputTextView;

@property (strong, nonatomic) NSString *send;
- (void)backFace;


@end
