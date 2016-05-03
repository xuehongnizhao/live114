//
//  VoiceView.m
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "VoiceView.h"
#import "VoiceRecorderBase.h"
#import "PulsingHaloLayer.h"
#import <AVFoundation/AVFoundation.h>
#import "MLAudioMeterObserver.h"

//录音类
#import "MLAudioRecorder.h"
#import "AmrRecordWriter.h"

//录音播放类
#import "MLAudioPlayer.h"
#import "AmrPlayerReader.h"

#import "UUProgressHUD.h"

@interface VoiceView()
{
    NSInteger playTime;
    NSTimer *playTimer;
}
@property (nonatomic, strong) MLAudioRecorder *recorder;

@property (nonatomic, strong) AmrRecordWriter *amrWriter;

@property (nonatomic, strong) MLAudioPlayer *player;

@property (nonatomic, strong) AmrPlayerReader *amrReader;

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;

@property (strong, nonatomic)  UIButton *recordButton;

@property (nonatomic,strong) UIButton* deleteButton;

//是否录音完成 默认未完成
@property (nonatomic) BOOL  isComplete;

@end

@implementation VoiceView
{
    //脉冲动画
    PulsingHaloLayer* halo;
    
    UILabel* secondLabel;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isShow=NO;
        self.isComplete=NO;
        self.backgroundColor=UIColorFromRGB(0xf4f4f4);
        [self initRecorderButton];
        [self initRecorderAndPlayer];
        [self initDeleteButton];
        secondLabel=[[UILabel alloc]init];
        secondLabel.frame=CGRectMake(53, 80, 45, 20);
        secondLabel.textColor=[UIColor whiteColor];
        secondLabel.font=[UIFont systemFontOfSize:12];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shutDown) name:@"STOPPLAY" object:nil];
        
    }
    return self;
}
#pragma mark----停止播放
-(void)shutDown
{
    [_player stopPlaying];
}

#pragma mark--------初始化删除按钮
-(void)initDeleteButton
{
    self.deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame=CGRectMake(260*LinPercent, 160*LinHeightPercent, 33, 33);
    [self.deleteButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteVoice) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
}
#pragma mark--------初始化录音控件
-(void)initRecorderAndPlayer
{
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
    amrWriter.filePath = [VoiceRecorderBase getPathByFileName:@"record.amr"];
    NSLog(@"filePaht:%@",amrWriter.filePath);
    amrWriter.maxSecondCount = 60;
    amrWriter.maxFileSize = 1024*256;
    self.amrWriter = amrWriter;
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        DLOG(@"volume:%f",[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]);
    };
    meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    self.meterObserver = meterObserver;
    
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    __weak __typeof(self)weakSelf = self;
    recorder.receiveStoppedBlock = ^{
        if ((int)[AmrPlayerReader durationOfAmrFilePath:self.amrWriter.filePath]<3)
        {
            //[SVProgressHUD showErrorWithStatus:@"录音太短"];
            [UUProgressHUD dismissWithError:@"录音太短"];
            [playTimer invalidate];
            [self deleteVoice];
        }
        else
        {
            //[weakSelf.recordButton setTitle:@"Record" forState:UIControlStateNormal];
            //此处改变按钮背景图片 并且移除录音方法，改为播放方法
            [self.recordButton setImage:[UIImage imageNamed:@"issue_play_no"] forState:UIControlStateNormal];
            [self.recordButton removeTarget:self action:@selector(down) forControlEvents:UIControlEventTouchDown];
            [self.recordButton removeTarget:self  action:@selector(upInside) forControlEvents:UIControlEventTouchUpInside];
            [self.recordButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            secondLabel.text=[NSString stringWithFormat:@"%d''",(int)[AmrPlayerReader durationOfAmrFilePath:self.amrWriter.filePath]];
            [secondLabel setHidden:NO];
            [self.recordButton addSubview:secondLabel];
            
            //改变删除按钮图片
            [self.deleteButton setImage:[UIImage imageNamed:@"issue_delete_sel"] forState:UIControlStateNormal];
            //发送文件
            [self.delegate sendDataWithFilePath:self.amrWriter.filePath];
        }
        
        NSLog(@"停止录音代码块");
        weakSelf.meterObserver.audioQueue = nil;
    };
    recorder.receiveErrorBlock = ^(NSError *error){
        //[weakSelf.recordButton setTitle:@"Record" forState:UIControlStateNormal];
        weakSelf.meterObserver.audioQueue = nil;
        NSLog(@"错误代码块");
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    
    //amr
    recorder.bufferDurationSeconds = 0.5;
    recorder.fileWriterDelegate = self.amrWriter;
    
    self.recorder = recorder;
    
    
    MLAudioPlayer *player = [[MLAudioPlayer alloc]init];
    AmrPlayerReader *amrReader = [[AmrPlayerReader alloc]init];
    
    player.fileReaderDelegate = amrReader;
    player.receiveErrorBlock = ^(NSError *error){
        //[weakSelf.playButton setTitle:@"Play" forState:UIControlStateNormal];
        
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    player.receiveStoppedBlock = ^{
        [self.deleteButton setEnabled:YES];
        NSLog(@"停止播放");
        [weakSelf.recordButton setImage:[UIImage imageNamed:@"issue_play_no"] forState:UIControlStateNormal];
        //[weakSelf.playButton setTitle:@"Play" forState:UIControlStateNormal];
    };
    self.player = player;
    self.amrReader = amrReader;
}
#pragma mark--------初始化录音按钮
-(void)initRecorderButton
{
    self.recordButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame=CGRectMake(100*LinPercent, 50*LinHeightPercent, 112, 112);
    [self.recordButton setImage:[UIImage imageNamed:@"issue_microBtn_sel"] forState:UIControlStateNormal];
    
    //button event test
    [self.recordButton addTarget:self action:@selector(dragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self.recordButton addTarget:self action:@selector(dragExit) forControlEvents:UIControlEventTouchDragExit];
    [self.recordButton addTarget:self action:@selector(upOutSide) forControlEvents:UIControlEventTouchUpOutside];
    [self.recordButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchCancel];
    //开始录音
    [self.recordButton addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchDown];
    //停止录音
    [self.recordButton addTarget:self action:@selector(upInside) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton addTarget:self action:@selector(recorder:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionDidChangeInterruptionType:)
                                                 name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    
    halo=[PulsingHaloLayer layer];
    halo.position=self.recordButton.center;
    [self addSubview:self.recordButton];
}

- (void)audioSessionDidChangeInterruptionType:(NSNotification *)notification
{
    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo]
                                                        objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (AVAudioSessionInterruptionTypeBegan == interruptionType)
    {
        DLOG(@"begin");
    }
    else if (AVAudioSessionInterruptionTypeEnded == interruptionType)
    {
        DLOG(@"end");
    }
}

-(void)play:(UIButton*)sender
{
    [self.deleteButton setEnabled:NO];
    self.amrReader.filePath = self.amrWriter.filePath;
    
    DLOG(@"文件时长%f",[AmrPlayerReader durationOfAmrFilePath:self.amrReader.filePath]);
    
    UIButton *playButton = sender;
    [playButton setImage:[UIImage imageNamed:@"issue_ suspend_no"] forState:UIControlStateNormal];
    if (self.player.isPlaying)
    {
        [self.player stopPlaying];
        [playButton setImage:[UIImage imageNamed:@"issue_play_no"] forState:UIControlStateNormal];
    }else{
        [self.player startPlaying];
    }
}

- (void)dragEnter
{
    DLOG(@"T普通提示录音状态");
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
  //  [playTimer invalidate];
}

- (void)dragExit
{
    DLOG(@"T提示松开可取消");
    //[UUProgressHUD dismissWithSuccess:@"slip to cancel"];
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)upOutSide
{
    DLOG(@"T取消录音");
    [UUProgressHUD dismissWithSuccess:@"cancel"];
    [playTimer invalidate];
    [self.recorder stopRecording];
    [self deleteVoice];
}

- (void)cancel
{
    DLOG(@"T取消录音");
    [UUProgressHUD dismissWithSuccess:@"T取消录音"];
    [playTimer invalidate];
}

#pragma mark------录音计时
- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60) {
        [self upInside];
    }
}

- (void)down
{
    DLOG(@"T开始录音");
    
    //[SVProgressHUD showWithStatus:@"正在录音..." maskType:SVProgressHUDMaskTypeClear];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
    
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self dragEnter];
    if (self.recorder.isRecording) {
        //取消录音
        [self.recorder stopRecording];
    }else{
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        //开始录音
        [self.recorder startRecording];
        self.meterObserver.audioQueue = self.recorder->_audioQueue;
    }
}

- (void)upInside
{
    DLOG(@"T结束录音");
    [playTimer invalidate];
    [UUProgressHUD dismissWithSuccess:@"Success"];
    if (self.recorder.isRecording)
    {
        //取消录音
        [self.recorder stopRecording];
    }
}
#pragma mark-------删除录音
-(void)deleteVoice
{
    //此处改变按钮背景图片 并且移除播放方法，改为录音方法
    [self.recordButton setImage:[UIImage imageNamed:@"issue_microBtn_no"] forState:UIControlStateNormal];
    [self.recordButton removeTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.recordButton addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self  action:@selector(upInside) forControlEvents:UIControlEventTouchUpInside];
    
    secondLabel.text=[NSString stringWithFormat:@"%d''",(int)[AmrPlayerReader durationOfAmrFilePath:self.amrWriter.filePath]];
    [self.recordButton addSubview:secondLabel];
    [secondLabel setHidden:YES];
    //改变删除按钮图片
    [self.deleteButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [self.delegate deleteBadgeFromButton];
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
