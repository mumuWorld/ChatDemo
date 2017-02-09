//
//  AVAudioPlayerTools.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/8.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAudioPlayerTools : NSObject
- (instancetype)initWithUrl:(NSString *)url;
- (float)startPlayAudio;
- (void)stopPlayAudio;
@end
