//
//  AVAudioTools.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/7.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatInfo;
@protocol AVAudioToolsDelegate <NSObject>

- (void)avAudioToolsDelegateWith:(ChatInfo *)chatInfo;
- (void)avAudioChangeVolumeImageWith:(int)volume;

@end

@interface AVAudioTools : NSObject

@property (nonatomic,assign) BOOL isCancelSend;
@property (nonatomic,weak) id<AVAudioToolsDelegate> delegate;

+ (instancetype)AVAudioToolsShareInstance;

- (void)startRecordWithNumber:(NSUInteger)ID;
- (void)stopRecord;
- (void)cancelRecord;
@end
