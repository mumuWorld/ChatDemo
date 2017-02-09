//
//  AVAudioTools.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/7.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "AVAudioTools.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "ChatInfo.h"
#import "ServiceViewController.h"

@interface AVAudioTools ()<AVAudioRecorderDelegate>

@property (nonatomic,copy) NSString *playName;
@property (nonatomic,copy) NSString *voicePath;
@property (nonatomic,strong) NSDictionary *recorderSettingsDict;

@property (nonatomic,strong) AVAudioRecorder *recordering;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) ServiceViewController *serviceView;
@end

@implementation AVAudioTools

+ (instancetype)AVAudioToolsShareInstance
{
    static AVAudioTools *avAudioTools = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        avAudioTools = [[self alloc] init];
        
    });
    return avAudioTools;
}
- (instancetype)init
{
    if (self = [super init]) {
        //录音设置
        self.recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                                    [NSNumber numberWithInt:44100.0],AVSampleRateKey,
                                    [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    nil];
        
        self.isCancelSend = false;
    }
    return self;
}

-(void)startRecordWithNumber:(NSUInteger)ID
{
    NSLog(@"开始录音------");
//    [self.recordering deleteRecording];
    self.isCancelSend = false;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.playName = [NSString stringWithFormat:@"voice_%i.acc",(short)ID];
    self.voicePath = [NSString stringWithFormat:@"%@/%@",docDir,self.playName];
  
    
    
    NSError *error = nil;
    //必须真机上测试,模拟器上可能会崩溃
    self.recordering = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.voicePath]
                                                   settings:self.recorderSettingsDict
                                                      error:&error];
    self.recordering.delegate = self;
    if (self.recordering) {
        
        // 打开音量检测
        self.recordering.meteringEnabled = YES;
        
        // 创建文件准备录音
        [self.recordering prepareToRecord];
        
        // 开始录音
        [self.recordering record];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    }
}
- (void)stopRecord
{
    int tempTime = self.recordering.currentTime;
    NSLog(@"------time = %i",tempTime);
    [_timer invalidate];
    _timer = nil;
    [self.recordering stop];
    self.recordering = nil;
    
    if (self.isCancelSend) {
        [self.recordering deleteRecording];
        NSLog(@"取消发送--------");
    } else {
        NSLog(@"-------发送");

        if ([self.delegate respondsToSelector:@selector(avAudioToolsDelegateWith:)]) {
            ChatInfo *c1 = [[ChatInfo alloc] initWithVoice:tempTime withVoiceUrl:self.playName];
            [self.delegate avAudioToolsDelegateWith:c1];
        }
    }
}
- (void)cancelRecord
{
    [self.recordering stop];
    [self.recordering deleteRecording];
    NSLog(@"------cancelRecord = %f",self.recordering.currentTime);
}
- (void)changeImage
{
    if (self.recordering.currentTime>60) {
        [self stopRecord];
    }
    [self.recordering updateMeters];//更新测量值
    float avg = [_recordering averagePowerForChannel:0];
//    NSLog(@"------changeImage avg= %f",avg);
    float minValue = -60;
    float range = 60;
    float outRange = 100;
    if (avg < minValue) {
        avg = minValue;
    }
    float decibels = (avg + range) / range * outRange;
    int volume;
    if (decibels <30) {
        volume = 1;
    } else if(decibels < 40) {
        volume = 2;
    } else if (decibels < 50) {
        volume = 3;
    } else if (decibels < 60) {
        volume = 4;
    } else if (decibels < 80) {
        volume = 5;
    } else {
        volume = 6;
    }
    if ([self.delegate respondsToSelector:@selector(avAudioChangeVolumeImageWith:)]) {
            [self.delegate avAudioChangeVolumeImageWith:volume];
    }
//    NSLog(@"------changeImage decibels= %f",decibels);
    
}
#pragma mark ========================= delegate=============
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"---------录音成功");
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error
{
    NSLog(@"------录音失败");
}
@end
