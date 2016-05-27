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


@end

@interface VoiceView : UIView<UIGestureRecognizerDelegate,AVAudioRecorderDelegate>
@property(nonatomic,weak)id<VoiceViewDelegate> delegate;

@end
