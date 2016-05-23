//
//  UploadConditonViewController.m
//  cityo2o
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 Sky. All rights reserved.
//上报路况

#import "UploadConditonViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageUploadViewController.h"
#import "TextUploadViewController.h"
#define kRecordAudioFile @"myRecord.caf"
@interface UploadConditonViewController ()<AVAudioRecorderDelegate>
@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic) UIButton *textUpdata;
@property (strong, nonatomic) UIButton *imageUpdata;
@property (strong, nonatomic) UIButton *voiceUpdata;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件

@end

@implementation UploadConditonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAudioSession];
    [self setUI];

}

- (void)setNearbyRoad:(NSArray *)nearbyRoad{
    _nearbyRoad=nearbyRoad;
}
- (UIButton *)textUpdata{
    if (!_textUpdata) {
        _textUpdata=[[UIButton alloc]initForAutoLayout];
        [_textUpdata addTarget:self action:@selector(textUpdataAction) forControlEvents:UIControlEventTouchUpInside];
        [_textUpdata setImage:[UIImage imageNamed:@"textUpdata"] forState:UIControlStateNormal];
        
    }
    return _textUpdata;
}

- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView=[[UIImageView alloc]initForAutoLayout];
        _showImageView.image=[UIImage imageNamed:@"showImageVie"];
        
    }
    return _showImageView;
    
}

- (UIButton *)voiceUpdata{
    if (!_voiceUpdata) {
        _voiceUpdata=[[UIButton alloc]initForAutoLayout];
        [_voiceUpdata addTarget:self action:@selector(voiceUpdataDownAction) forControlEvents:UIControlEventTouchDown];
        [_voiceUpdata setImage:[UIImage imageNamed:@"voiceUpdata"] forState:UIControlStateNormal];
        [_voiceUpdata addTarget:self action:@selector(voiceUpdataUpAction) forControlEvents:UIControlEventTouchUpInside];
        [_voiceUpdata addTarget:self action:@selector(voiceUpdataCancell) forControlEvents:UIControlEventTouchCancel];
    }
    
    return _voiceUpdata;
}

- (UIButton *)imageUpdata{
    if (!_imageUpdata) {
        _imageUpdata=[[UIButton alloc]initForAutoLayout];
        [_imageUpdata addTarget:self action:@selector(imageUpdataAction) forControlEvents:UIControlEventTouchUpInside];
        [_imageUpdata setImage:[UIImage imageNamed:@"imageUpdata"] forState:UIControlStateNormal];
    }
    return _imageUpdata;
    
}
- (UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton=[[UIButton alloc]initForAutoLayout];
        [_dismissButton setImage:[UIImage imageNamed:@"park"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dissmissButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}
/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
- (void)imageUpdataAction{
    ImageUploadViewController *firvc=[UIStoryboard storyboardWithName:@"ImageUploadViewController" bundle:nil].instantiateInitialViewController;
    firvc.nearbyRoad=self.nearbyRoad;
    [self presentViewController:firvc animated:NO completion:nil];
}
- (void)voiceUpdataDownAction{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    }
}
- (void)voiceUpdataUpAction{
    [self.audioRecorder stop];
}
- (void)voiceUpdataCancell{
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];

}
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
    NSLog(@"录音完成!");
}

- (void)textUpdataAction{
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;

}
- (void)setUI{
    [self.view addSubview:self.dismissButton];
    [_dismissButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [_dismissButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [_dismissButton autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    [self.view addSubview:self.showImageView];
    [_showImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_showImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_showImageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2/3)];
    
    [self.view addSubview:self.textUpdata];
    [_textUpdata autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_showImageView];
    [_textUpdata autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH/2-175];
    [_textUpdata autoSetDimensionsToSize:CGSizeMake(175, 44)];
    
    [self.view addSubview:self.imageUpdata];
    [_imageUpdata autoSetDimensionsToSize:CGSizeMake(175, 44)];
    [_imageUpdata autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_showImageView];
    [_imageUpdata autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_textUpdata];
    
    [self.view addSubview:self.voiceUpdata];
    [_voiceUpdata autoSetDimensionsToSize:CGSizeMake(90, 90)];
    [_voiceUpdata autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imageUpdata withOffset:10];
    [_voiceUpdata autoAlignAxisToSuperviewAxis:ALAxisVertical];

}

- (void)dissmissButtonAction{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
