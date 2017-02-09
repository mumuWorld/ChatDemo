//
//  AVAudioPlayerTools.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/8.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "AVAudioPlayerTools.h"
#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayerTools ()

@property (nonatomic,strong) AVAudioPlayer *avAudioPlayer;

@end

@implementation AVAudioPlayerTools
- (instancetype)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        
        self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[self getImageDocumentPathWith:url]] error:nil];
    }
    return self;
}
- (float)startPlayAudio
{

    NSTimeInterval duration = _avAudioPlayer.duration;//获取持续时间
    NSLog(@"startPlayAudio duration = %f",duration);
    [_avAudioPlayer play];
    return duration;
}
- (void)stopPlayAudio
{
    [_avAudioPlayer stop];
}
- (NSString *)getImageDocumentPathWith:(NSString *)voiceUrl
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@",docDir,voiceUrl];
}
@end
