//
//  VoiceView.h
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol VoiceViewDelegate <NSObject>
/**
 *  录音完成发送录音文件路径
 *
 *  @param filePath 录音文件路径
 */
-(void)sendDataWithFilePath:(NSString*) filePath;
-(void)deleteBadgeFromButton;

@end

@interface VoiceView : UIView<UIGestureRecognizerDelegate,AVAudioRecorderDelegate>
@property(nonatomic)BOOL isShow;
@property(nonatomic,weak)id<VoiceViewDelegate> delegate;

/**
 *  frame 的隐藏和出现将在内部完成
 *
 *  @param isShow 是否显示自身
 *  @param frame  是否显示并传入自己将在显示/不显示的frame
 */
-(void)setIsShow:(BOOL)isShow AndFrame:(CGRect)frame;

@end
