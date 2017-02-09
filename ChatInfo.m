//
//  ChatInfo.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "ChatInfo.h"

@interface ChatInfo ()
@property (nonatomic,assign) NSString *systemTime;

@end


@implementation ChatInfo
//- (instancetype)initWithDict:(NSDictionary *)dict
//{
//    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dict];
//    }
//    return self;
//}
//+ (instancetype)squareInfoWithDict:(NSDictionary *)dict
//{
//    return [[self alloc] initWithDict:dict];
//}
- (NSString *)getDocumentPath
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return docDir;
}
- (instancetype)initWithMessage:(NSString *)str
{
    if (self = [super init]) {
        self.messageSenderType = MessageSenderByUser;
        self.messageType = MessageTypeText;
        self.chatText = str;
        self.chatTime = self.systemTime;
//        NSLog(@"systemTIme= %@",self.systemTime);
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image WithNumber:(NSUInteger)number
{
    if (self = [super init]) {
        self.messageSenderType = MessageSenderByUser;
        self.messageType = MessageTypeImage;
        self.chatTime = self.systemTime;
        NSData *data;
        self.imageUrl = [NSString stringWithFormat:@"image_%i.jpg",(short)number];
//        if (UIImagePNGRepresentation(image)==nil) {
            data = UIImageJPEGRepresentation(image, 0.2);
//        } else  {
//            data = UIImagePNGRepresentation(image);
//        }
        [data writeToFile:[NSString stringWithFormat:@"%@/%@",[self getDocumentPath],self.imageUrl] atomically:YES];
    }
    return self;
}
- (instancetype)initWithVoice:(NSInteger)duringTime withVoiceUrl:(NSString *)url
{
    if (self = [super init]) {
        self.messageSenderType = MessageSenderByUser;
        self.messageType = MessageTypeVoice;
        if (duringTime < 1) {
            self.duringTime = 1;
        } else {
            self.duringTime = duringTime;
        }
        self.voiceUrl = url;
        self.chatTime = self.systemTime;
    }
    return self;
}
- (NSString *)systemTime
{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
@end
