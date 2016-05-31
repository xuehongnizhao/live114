//
//  VoiceView.m
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//录音功能

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
    CALayer *_layer;
    CAAnimationGroup *_animaTionGroup;
    CADisplayLink *_disPlayLink;
    NSInteger playTime;
    NSTimer *playTimer;
    UILabel* secondLabel;
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

@property (strong, nonatomic) UIButton *completeButton;

@end

@implementation VoiceView
{
    //脉冲动画
//    PulsingHaloLayer* halo;
    
}
- (void)startAnimation
{
    CALayer *layer = [[CALayer alloc] init];
    layer.cornerRadius = self.bounds.size.width/2;
    layer.frame = CGRectMake(0, 0, layer.cornerRadius * 2, layer.cornerRadius * 2);
    layer.position = self.recordButton.layer.position;
    UIColor *color = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    [self.layer insertSublayer:self.recordButton.layer above:layer];
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    _animaTionGroup = [CAAnimationGroup animation];
    _animaTionGroup.delegate = self;
    _animaTionGroup.duration = 2;
    _animaTionGroup.removedOnCompletion = YES;
    _animaTionGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = 2;
    
    CAKeyframeAnimation *opencityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opencityAnimation.duration = 2;
    opencityAnimation.values = @[@0.8,@0.4,@0];
    opencityAnimation.keyTimes = @[@0,@0.5,@1];
    opencityAnimation.removedOnCompletion = YES;
    
    NSArray *animations = @[scaleAnimation,opencityAnimation];
    _animaTionGroup.animations = animations;
    [layer addAnimation:_animaTionGroup forKey:nil];
    
    [self performSelector:@selector(removeLayer:) withObject:layer afterDelay:1.5];
}
- (void)removeLayer:(CALayer *)layer
{
    [layer removeFromSuperlayer];
}

- (void)delayAnimation
{
    [self startAnimation];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        [self initRecorderButton];
        [self initRecorderAndPlayer];
        [self initDeleteButton];
        secondLabel=[[UILabel alloc]init];
        secondLabel.frame=CGRectMake(53, 80, 45, 20);
        secondLabel.textColor=[UIColor whiteColor];
        secondLabel.font=[UIFont systemFontOfSize:12];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shutDown) name:@"STOPPLAY" object:nil];
        [self addSubview:self.completeButton];
        [_completeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
        [_completeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [_completeButton autoSetDimensionsToSize:CGSizeMake(80, 80)];
    }
    return self;
}
#pragma mark----停止播放
-(void)shutDown
{
    [_player stopPlaying];
}
- (UIButton *)completeButton{
    if (!_completeButton) {
        _completeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton setImage:[UIImage imageNamed:@"done_voiceView"] forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(completeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

- (void)completeButtonAction{
    
    if ((int)[AmrPlayerReader durationOfAmrFilePath:self.amrWriter.filePath]>2)
    {
    [self.delegate sendDataWithFilePath:self.amrWriter.filePath];
        self.hidden=YES;
        [self removeFromSuperview];
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"录音时间不应小于3秒"];
    }

}
#pragma mark--------初始化删除按钮
-(void)initDeleteButton
{
    self.deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"cancell_voiceView"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_voiceView"] forState:UIControlStateSelected];
    [self.deleteButton setTitleColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor colorWithRed:0.502 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
    [self.deleteButton addTarget:self action:@selector(deleteVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    [_deleteButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [_deleteButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [_deleteButton autoSetDimensionsToSize:CGSizeMake(80, 80)];
}
#pragma mark--------初始化录音控件
-(void)initRecorderAndPlayer
{
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
    amrWriter.filePath = [VoiceRecorderBase getPathByFileName:@"record.amr"];
    NSLog(@"filePaht:%@",amrWriter.filePath);
    amrWriter.maxSecondCount = 12.0;
    amrWriter.maxFileSize = 1024*100;
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
            [UUProgressHUD dismissWithError:@"录音太短"];
            [playTimer invalidate];
            [self deleteVoice:self.deleteButton];
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
            self.deleteButton.selected=YES;
//            [self.delegate sendDataWithFilePath:self.amrWriter.filePath];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionDidChangeInterruptionType:)
                                                 name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
//    halo=[PulsingHaloLayer layer];
//    halo.position=self.recordButton.center;
    [self addSubview:self.recordButton];
    [_recordButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:SCREEN_HEIGHT/7];
    [_recordButton autoSetDimensionsToSize:CGSizeMake(112, 112)];
    [_recordButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
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
    [UUProgressHUD changeSubTitle:@"松开可取消"];
  //  [playTimer invalidate];
}

- (void)dragExit
{
    DLOG(@"提示松开可取消");
    //[UUProgressHUD dismissWithSuccess:@"slip to cancel"];
    [UUProgressHUD changeSubTitle:@"松开可取消"];
}

- (void)upOutSide
{
    //以下三行动画用
    [self.layer removeAllAnimations];
    [_disPlayLink invalidate];
    _disPlayLink = nil;
    DLOG(@"T取消录音");
//    [UUProgressHUD dismissWithSuccess:@"取消"];
    [playTimer invalidate];
    [self.recorder stopRecording];
    self.deleteButton.selected=YES;
    [self deleteVoice:self.deleteButton];
}

- (void)cancel
{
    //以下三行动画用
    [self.layer removeAllAnimations];
    [_disPlayLink invalidate];
    _disPlayLink = nil;
    DLOG(@"取消录音");
//    [UUProgressHUD dismissWithSuccess:@"取消录音"];
    [playTimer invalidate];
}

#pragma mark------录音计时
- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=11) {
        [SVProgressHUD showErrorWithStatus:@"录音不应超出10秒"];
        [SVProgressHUD setDefaultMaskType:1];
        [self upInside];
    }
}

- (void)down
{
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(delayAnimation)];
    _disPlayLink.frameInterval = 40;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    DLOG(@"T开始录音");
    
    self.deleteButton.selected=YES;
//    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
//    [UUProgressHUD show];
    
    [self dragEnter];
    if (self.recorder.isRecording) {
        //取消录音
        [self.recorder stopRecording];
    }else{
        [self.recordButton setTitle:@"停止" forState:UIControlStateNormal];
        //开始录音
        [self.recorder startRecording];
        self.meterObserver.audioQueue = self.recorder->_audioQueue;
    }
}

- (void)upInside
{

    //以下三行动画用
    [self.layer removeAllAnimations];
    [_disPlayLink invalidate];
    _disPlayLink = nil;

    DLOG(@"T结束录音");
    [playTimer invalidate];
//    [UUProgressHUD dismissWithSuccess:@"成功"];
    if (self.recorder.isRecording)
    {
        //取消录音
        [self.recorder stopRecording];
    }
}
#pragma mark-------删除录音
-(void)deleteVoice:(UIButton *)sender
{
    if (sender.selected==NO) {
        self.hidden=YES;
        [self removeFromSuperview];
    }else{
        //此处改变按钮背景图片 并且移除播放方法，改为录音方法
        [self.recordButton setImage:[UIImage imageNamed:@"issue_microBtn_no"] forState:UIControlStateNormal];
        [self.recordButton removeTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.recordButton addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchDown];
        [self.recordButton addTarget:self  action:@selector(upInside) forControlEvents:UIControlEventTouchUpInside];
    
        secondLabel.text=[NSString stringWithFormat:@"%d''",(int)[AmrPlayerReader durationOfAmrFilePath:self.amrWriter.filePath]];
        [self.recordButton addSubview:secondLabel];
        [secondLabel setHidden:YES];
        //改变删除按钮图片
        sender.selected=NO;
        NSFileManager* fileManager=[NSFileManager defaultManager];
        [fileManager removeItemAtPath:self.amrWriter.filePath error:nil];
    }
}



@end
