//
//  ChatInfo.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 消息类型
 */
typedef NS_OPTIONS(NSUInteger, MessageType) {
    MessageTypeText=1,
    MessageTypeVoice,
    MessageTypeImage
};


/*
 消息发送方
 */
typedef NS_OPTIONS(NSUInteger, MessageSenderType) {
    MessageSenderByService=1,
    MessageSenderByUser
    
};



/*
 消息发送状态
 */

typedef NS_OPTIONS(NSUInteger, MessageSentStatus) {
    MessageSentStatusSended=1,//送达
    MessageSentStatusUnSended, //未发送
    MessageSentStatusSending, //正在发送
    
};

/*
 消息接收状态
 */

typedef NS_OPTIONS(NSUInteger, MessageReadStatus) {
    MessageReadStatusRead=1,//消息已读
    MessageReadStatusUnRead //消息未读
    
};

@interface ChatInfo : NSObject

@property (nonatomic, assign) MessageType         messageType;
@property (nonatomic, assign) MessageSenderType   messageSenderType;
//@property (nonatomic, assign) MessageSentStatus   messageSentStatus;
//@property (nonatomic, assign) MessageReadStatus   messageReadStatus;

/**
 用户头像
 */
@property (nonatomic,copy) NSString *userIcon;

/**
 用户聊天内容
 */
@property (nonatomic,copy) NSString *chatText;

/**
 聊天时间戳
 */
@property (nonatomic,copy) NSString *chatTime;
/*
 音频时间
 */

@property (nonatomic, assign) NSInteger duringTime;
/*
 消息音频url
 */
@property (nonatomic, copy) NSString *voiceUrl;

/*
 图片文件
 */
@property (nonatomic, copy) NSString *imageUrl;

/*
 图片文件
 */
@property (nonatomic, retain)  UIImage *imageSmall;

@property (nonatomic,assign) NSUInteger ID;

- (instancetype)initWithMessage:(NSString *)str;
- (instancetype)initWithImage:(UIImage *)image WithNumber:(NSUInteger)number;
- (instancetype)initWithVoice:(NSInteger)duringTime withVoiceUrl:(NSString *)url;
//- (instancetype)initWithDict:(NSDictionary *)dict;
//+ (instancetype)squareInfoWithDict:(NSDictionary *)dict;

@end
