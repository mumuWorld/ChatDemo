//
//  ChatTableViewCell.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "ChatInfo.h"
#import "Common.h"

@interface ChatTableViewCell ()
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *iconView;
/**
 *  time
 */
@property (nonatomic, strong) UILabel *timeView;
/**
 *  图片
 */
@property (nonatomic, strong) UIButton *pictureView;
/**
 *  文字
 */
//@property (nonatomic, strong) UIButton *messageView;
@property (nonatomic, strong) UIImageView *messageView;
@property (nonatomic, strong) UILabel *message;
/**
 *  voice
 */
@property (nonatomic, strong) UIImageView *voiceView;
@property (nonatomic, strong) UILabel *voiceTime;
@property (nonatomic, strong) UILabel *voiceUrl;

@property (nonatomic, strong) UIImage *chatBackgroundUser;
@property (nonatomic, strong) UIImage *chatBackgroundService;

@property (nonatomic, strong) UIImage *chatBackgroundUserCover;
@property (nonatomic, strong) UIImage *chatBackgroundServiceCover;
@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIndex:(NSIndexPath *)indexPath
{
     NSString *identifier = [NSString stringWithFormat:@"chatTableView_%li",(long)indexPath.row];
   
    
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    if (cell != nil) {
//        cell = nil;
//    }
//    cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    

    
    return cell;
}
/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        self.iconView.image = [UIImage imageNamed:@"collection4_10"];

        _timeView = [[UILabel alloc] init];
        _timeView.textColor = [UIColor lightGrayColor];
//        _timeView.textAlignment = NSTextAlignmentCenter;
        _timeView.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeView];
        
        _pictureView = [[UIButton alloc] init];
//        [_pictureView setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:_pictureView];
        
        _messageView = [[UIImageView alloc] init];
//        _messageView.numberOfLines = 0;
        [self.contentView addSubview:_messageView];
        
        _message = [[UILabel alloc] init];
        _message.numberOfLines = 0;
        _message.font = TextFont;
        _message.lineBreakMode = NSLineBreakByCharWrapping;
        _message.tintColor = [UIColor blackColor];
        [self.messageView addSubview:_message];
        
        _voiceView = [[UIImageView alloc] init];
//        _voiceView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_voiceView];
        
        _voiceTime = [[UILabel alloc] init];
        _voiceTime.textColor = [UIColor grayColor];
        _voiceTime.font = [UIFont systemFontOfSize:15];
        [self.voiceView addSubview:_voiceTime];
        
        _voiceUrl = [[UILabel alloc] init];
        [self.voiceView addSubview:_voiceUrl];
        
        _voiceAnimationImageView = [[UIImageView alloc] init];
        self.voiceAnimationImageView.animationRepeatCount = 0;
        self.voiceAnimationImageView.animationDuration = 1;
        [self.voiceView addSubview:_voiceAnimationImageView];
        
        _chatBackgroundUser = [UIImage imageNamed:@"wechatback2"];
        _chatBackgroundService = [UIImage imageNamed:@"wechatback1"];
        _chatBackgroundUser = [_chatBackgroundUser stretchableImageWithLeftCapWidth:15 topCapHeight:30];
        _chatBackgroundService = [_chatBackgroundService stretchableImageWithLeftCapWidth:15 topCapHeight:30];
        _chatBackgroundUserCover = [UIImage imageNamed:@"wechatback2cover"];
        _chatBackgroundServiceCover = [UIImage imageNamed:@"wechatback1cover"];
        _chatBackgroundUserCover = [_chatBackgroundUserCover stretchableImageWithLeftCapWidth:15 topCapHeight:30];
        _chatBackgroundServiceCover = [_chatBackgroundServiceCover stretchableImageWithLeftCapWidth:15 topCapHeight:30];
        _common = [Common commonShareInstance];
    }
    return self;
    
}
- (void)setChatInfo:(ChatInfo *)chatInfo
{
    _chatInfo = chatInfo;
    
    if (_chatInfo.messageSenderType == MessageSenderByUser) {
        _iconView.frame = CGRectMake(SCREEN_WIDTH-PADDING *2-ICON_SIZE,PADDING*2, ICON_SIZE, ICON_SIZE);
        _timeView.frame = CGRectMake(SCREEN_WIDTH-70-200, 8, 200, 10);
        _timeView.text = chatInfo.chatTime;
        _timeView.textAlignment = NSTextAlignmentRight;
        
        if (_chatInfo.messageType == MessageTypeText) {
            [self setMessageAboutMessageType:chatInfo];
            
//            CGFloat chatTextMaxWidth = SCREEN_WIDTH - PADDING *8 - ICON_SIZE*2;
//            
//            CGSize chatTextSize = [_common sizeWithString:_chatInfo.chatText font:TextFont maxSize:CGSizeMake(chatTextMaxWidth, MAXFLOAT)];
//
//            CGFloat chatTextX = SCREEN_WIDTH - PADDING*6 - ICON_SIZE - chatTextSize.width;
//
//            CGFloat chatTextY = PADDING *2;
//        
//            self.messageView.frame = CGRectMake(chatTextX , chatTextY, chatTextSize.width + 30, chatTextSize.height + 20);
//
//            UIImage *image = [[UIImage alloc] init];
//            image = [UIImage imageNamed:@"wechatback2"];
//            image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:30];
//            [_messageView setImage:image];
//            _message.text = _chatInfo.chatText;
//            _message.frame = CGRectMake(5, 5, chatTextSize.width+10, chatTextSize.height+10);
            
        } else if(_chatInfo.messageType == MessageTypeImage) {
            NSString *path = [NSString stringWithFormat:@"%@/%@",[self getDocumentPath],chatInfo.imageUrl];
            CGSize imageSize=[self imageShowSize:[UIImage imageWithContentsOfFile:path]];
//            CAShapeLayer *layer = [CAShapeLayer layer];
            _pictureView.frame = CGRectMake(SCREEN_WIDTH -PADDING*2-PADDING -ICON_SIZE -imageSize.width, 20, imageSize.width, imageSize.height);
            [_pictureView setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
            
            UIImage *bubble = [UIImage imageNamed:@"wechatback2"];
            UIImageView *imageview = [UIImageView new];
            [imageview setFrame:_pictureView.frame];
            [imageview setImage:[bubble stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
            
            
            CALayer *layer              = imageview.layer;
            layer.frame                 = (CGRect){{0,0},imageview.layer.frame.size};
            _pictureView.layer.mask = layer;
            [_pictureView setNeedsDisplay];
            
            [_pictureView addTarget:self action:@selector(pictureViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            

        } else if (chatInfo.messageType == MessageTypeVoice) {
            [self setVoiceAboutMessageType:chatInfo];
//            CGFloat voiceMaxWidth = SCREEN_WIDTH - PADDING *8 - ICON_SIZE*2;
//            CGFloat voiceMinWidth = voiceMaxWidth*0.4;
//            CGFloat voiceBackgroundWidth;
//            if(chatInfo.duringTime<4){
//                voiceBackgroundWidth = voiceMinWidth;
//            } else if(chatInfo.duringTime<10){
//                voiceBackgroundWidth = voiceMaxWidth*0.1*chatInfo.duringTime;
//            } else {
//                voiceBackgroundWidth = voiceMaxWidth;
//            }
//            _voiceView.frame = CGRectMake(SCREEN_WIDTH - PADDING*3-ICON_SIZE - voiceBackgroundWidth, PADDING*2, voiceBackgroundWidth, 40);
//            UIImage *image = [[UIImage alloc] init];
//            image = [UIImage imageNamed:@"wechatback2"];
//            image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:30];
//            UIImage *image2 = [[UIImage alloc] init];
//            image2 = [UIImage imageNamed:@"wechatback2cover"];
//            image2 = [image2 stretchableImageWithLeftCapWidth:image2.size.width/2 topCapHeight:30];
//            _voiceView.image = image;
//            _voiceView.highlightedImage = image2;
//            
//            _voiceTime.text = [NSString stringWithFormat:@"%li \"",chatInfo.duringTime];
//            _voiceTime.frame = CGRectMake(5, 10, _voiceView.frame.size.width-5-30, 20);
//  
//            _voiceAnimationImageView.frame = CGRectMake(voiceBackgroundWidth-30, 13, 12, 14);
//            _voiceAnimationImageView.image = [UIImage imageNamed:@"wechatvoice4"];
//            _voiceAnimationImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wechatvoice4"],[UIImage imageNamed:@"wechatvoice4_1"],[UIImage imageNamed:@"wechatvoice4_0"],[UIImage imageNamed:@"wechatvoice4_1"],[UIImage imageNamed:@"wechatvoice4"],nil];
//            _voiceUrl.text = chatInfo.voiceUrl;//语音文件名
//            _voiceView.userInteractionEnabled = YES;
//            UITapGestureRecognizer *singleTap =
//            [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickVoice:)];
//            [_voiceView addGestureRecognizer:singleTap];
//            UILongPressGestureRecognizer *longTap =
//            [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(whenLongPressVoice:)];
//            [_voiceView addGestureRecognizer:longTap];
//            [singleTap requireGestureRecognizerToFail:longTap];

        }
#pragma mark --------------- 客服--------------------------------
    } else if (_chatInfo.messageSenderType == MessageSenderByService) {
        _iconView.frame = CGRectMake(PADDING *2,PADDING*2, ICON_SIZE, ICON_SIZE);
        _timeView.frame = CGRectMake(70, 8, 200, 10);
        _timeView.text = chatInfo.chatTime;
        _timeView.textAlignment = NSTextAlignmentLeft;
        
        if (_chatInfo.messageType == MessageTypeText) {
            [self setMessageAboutMessageType:chatInfo];
//            CGFloat chatTextMaxWidth = SCREEN_WIDTH - PADDING *8 - ICON_SIZE*2;
//            
//            CGSize chatTextSize = [_common sizeWithString:_chatInfo.chatText font:TextFont maxSize:CGSizeMake(chatTextMaxWidth, MAXFLOAT)];
//            
//            CGFloat chatTextX = SCREEN_WIDTH - PADDING*6 - ICON_SIZE - chatTextSize.width;
//            
//            CGFloat chatTextY = PADDING *2;
//            
//            self.messageView.frame = CGRectMake(chatTextX , chatTextY, chatTextSize.width + 30, chatTextSize.height + 20);
//            
//            UIImage *image = [[UIImage alloc] init];
//            image = [UIImage imageNamed:@"wechatback1"];
//            image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:30];
//            [_messageView setImage:image];
//            _message.text = _chatInfo.chatText;
//            _message.frame = CGRectMake(10, 5, chatTextSize.width+10, chatTextSize.height+10);
            
        } else if(_chatInfo.messageType == MessageTypeImage) {
            [self setImageAboutMessageType:chatInfo];
//            NSString *path = [NSString stringWithFormat:@"%@/%@",[self getDocumentPath],chatInfo.imageUrl];
//            CGSize imageSize=[self imageShowSize:[UIImage imageWithContentsOfFile:path]];
//            //            CAShapeLayer *layer = [CAShapeLayer layer];
//            _pictureView.frame = CGRectMake(SCREEN_WIDTH -PADDING*2-PADDING -ICON_SIZE -imageSize.width, 20, imageSize.width, imageSize.height);
//            [_pictureView setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
//            
//            UIImage *bubble = [UIImage imageNamed:@"wechatback1"];
//            UIImageView *imageview = [UIImageView new];
//            [imageview setFrame:_pictureView.frame];
//            [imageview setImage:[bubble stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
//            
//            
//            CALayer *layer              = imageview.layer;
//            layer.frame                 = (CGRect){{0,0},imageview.layer.frame.size};
//            _pictureView.layer.mask = layer;
//            [_pictureView setNeedsDisplay];
//            
//            [_pictureView addTarget:self action:@selector(pictureViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
#pragma mark----------语音消息-------------
        } else if (chatInfo.messageType == MessageTypeVoice) {
            CGFloat voiceMaxWidth = SCREEN_WIDTH - PADDING *8 - ICON_SIZE*2;
            CGFloat voiceMinWidth = voiceMaxWidth*0.4;
            CGFloat voiceBackgroundWidth;
            if(chatInfo.duringTime<4){
                voiceBackgroundWidth = voiceMinWidth;
            } else if(chatInfo.duringTime<10){
                voiceBackgroundWidth = voiceMaxWidth*0.1*chatInfo.duringTime;
            } else {
                voiceBackgroundWidth = voiceMaxWidth;
            }
            _voiceView.frame = CGRectMake(SCREEN_WIDTH - PADDING*3-ICON_SIZE - voiceBackgroundWidth, PADDING*2, voiceBackgroundWidth, 40);
            UIImage *image = [[UIImage alloc] init];
            image = [UIImage imageNamed:@"wechatback1"];
            image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:30];
            [_voiceView setImage:image];
            
            _voiceTime.text = [NSString stringWithFormat:@"%li \"",chatInfo.duringTime];
            _voiceTime.frame = CGRectMake(5, 10, _voiceView.frame.size.width-5-30, 20);
            
            _voiceAnimationImageView.frame = CGRectMake(voiceBackgroundWidth-30, 13, 12, 14);
            _voiceAnimationImageView.image = [UIImage imageNamed:@"wechatvoice3"];
            _voiceAnimationImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wechatvoice3"],[UIImage imageNamed:@"wechatvoice3_1"],[UIImage imageNamed:@"wechatvoice3_0"],[UIImage imageNamed:@"wechatvoice3_1"],[UIImage imageNamed:@"wechatvoice3"],nil];
            _voiceUrl.text = chatInfo.voiceUrl;//语音文件名
            _voiceView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap =
            [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickVoice:)];
            [_voiceView addGestureRecognizer:singleTap];
        }
    }
    
}
- (void)pictureViewBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(pictureViewBtnClickDelegateWithBtn:)]) {
        [self.delegate pictureViewBtnClickDelegateWithBtn:btn];
    }
}
- (void)whenClickVoice:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(chatTableViewDelegateWithGestureRecognizer:)]) {
        [self.delegate chatTableViewDelegateWithGestureRecognizer:gesture];
        
    }
}
- (void)whenLongPressVoice:(UILongPressGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        _voiceView.highlighted = YES;
    } else if ([gesture state] == UIGestureRecognizerStateEnded){
        _voiceView.highlighted = NO;
        if ([self.delegate respondsToSelector:@selector(chatTableViewDelegateWithGestureRecognizer:)]) {
            [self.delegate chatTableViewDelegateWithGestureRecognizer:(UITapGestureRecognizer*)gesture];
            
        }
    }
}
- (void)whenLongPressText:(UILongPressGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        _voiceView.highlighted = YES;
    } else if ([gesture state] == UIGestureRecognizerStateEnded){
        _voiceView.highlighted = NO;
        if ([self.delegate respondsToSelector:@selector(chatTableViewDelegateWithGestureRecognizer:)]) {
            [self.delegate chatTableViewDelegateWithGestureRecognizer:(UITapGestureRecognizer*)gesture];
            
        }
    }
}
+ (CGFloat)tableHeightWithModel:(ChatInfo *)chatInfo{
    if (chatInfo.messageSenderType == MessageSenderByUser) {
        if (chatInfo.messageType == MessageTypeText) {
            CGFloat chatTextMaxWidth = SCREEN_WIDTH - PADDING *8 - ICON_SIZE*2;
//            CGFloat chatTextX;
            CGSize chatTextSize = [[Common commonShareInstance] sizeWithString:chatInfo.chatText font:TextFont maxSize:CGSizeMake(chatTextMaxWidth, MAXFLOAT)];

            return chatTextSize.height+PADDING*5;
        } else if (chatInfo.messageType == MessageTypeImage) {
            
//            NSString *path = [NSString stringWithFormat:@"%@/%@",[self getDocumentPath],chatInfo.imageUrl];
//            CGSize imageSize=[self imageShowSize:[UIImage imageWithContentsOfFile:path]];
            NSString *image = [[Common commonShareInstance] getImageDocumentPathWith:chatInfo.imageUrl];

            CGSize imageSize=[[Common commonShareInstance] imageShowSize:[UIImage imageWithContentsOfFile:image]];
            return imageSize.height +PADDING*3;
        } else if (chatInfo.messageType == MessageTypeVoice) {
            return 40 +PADDING*3;
        }
    }
    return 0;
}
- (void)setImageAboutMessageType:(ChatInfo *)chatInfo
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self getDocumentPath],chatInfo.imageUrl];
    CGSize imageSize=[self imageShowSize:[UIImage imageWithContentsOfFile:path]];
    
    UIImageView *imageview = [UIImageView new];
    CGFloat pictureViewX;
    if (chatInfo.messageSenderType == MessageSenderByService) {
        [imageview setImage:[_chatBackgroundService stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
        pictureViewX = PADDING *6;
    } else if(chatInfo.messageSenderType == MessageSenderByUser) {
        [imageview setImage:[_chatBackgroundUserCover stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
        pictureViewX = SCREEN_WIDTH -PADDING*2-PADDING -ICON_SIZE -imageSize.width;
    }
    _pictureView.frame = CGRectMake(pictureViewX, 20, imageSize.width, imageSize.height);
    [_pictureView setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    
    [imageview setFrame:_pictureView.frame];
    
    CALayer *layer              = imageview.layer;
    layer.frame                 = (CGRect){{0,0},imageview.layer.frame.size};
    _pictureView.layer.mask = layer;
    [_pictureView setNeedsDisplay];
    
    [_pictureView addTarget:self action:@selector(pictureViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setVoiceAboutMessageType:(ChatInfo *)chatInfo
{
    CGFloat voiceMaxWidth = SCREEN_WIDTH - PADDING *8 - ICON_SIZE*2;
    CGFloat voiceMinWidth = voiceMaxWidth*0.4;
    CGFloat voiceBackgroundWidth;
    if(chatInfo.duringTime<4){
        voiceBackgroundWidth = voiceMinWidth;
    } else if(chatInfo.duringTime<10){
        voiceBackgroundWidth = voiceMaxWidth*0.1*chatInfo.duringTime;
    } else {
        voiceBackgroundWidth = voiceMaxWidth;
    }
    CGFloat voiceViewX;
    if (chatInfo.messageSenderType == MessageSenderByService) {
        voiceViewX = PADDING*6;
        _voiceView.image = _chatBackgroundService;
        _voiceView.highlightedImage = _chatBackgroundServiceCover;
        _voiceAnimationImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wechatvoice3"],[UIImage imageNamed:@"wechatvoice3_1"],[UIImage imageNamed:@"wechatvoice3_0"],[UIImage imageNamed:@"wechatvoice3_1"],[UIImage imageNamed:@"wechatvoice3"],nil];
        _voiceAnimationImageView.image = [UIImage imageNamed:@"wechatvoice3"];
        _voiceAnimationImageView.frame = CGRectMake(18, 13, 12, 14);
        
    } else if(chatInfo.messageSenderType == MessageSenderByUser) {
        voiceViewX = SCREEN_WIDTH - PADDING*3-ICON_SIZE - voiceBackgroundWidth;
        _voiceView.image = _chatBackgroundUser;
        _voiceView.highlightedImage = _chatBackgroundUserCover;
        _voiceAnimationImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wechatvoice4"],[UIImage imageNamed:@"wechatvoice4_1"],[UIImage imageNamed:@"wechatvoice4_0"],[UIImage imageNamed:@"wechatvoice4_1"],[UIImage imageNamed:@"wechatvoice4"],nil];
        _voiceAnimationImageView.image = [UIImage imageNamed:@"wechatvoice4"];
        _voiceAnimationImageView.frame = CGRectMake(voiceBackgroundWidth-30, 13, 12, 14);

    }

    _voiceView.frame = CGRectMake(voiceViewX, PADDING*2, voiceBackgroundWidth, 40);
    
    _voiceTime.frame = (chatInfo.messageSenderType == MessageSenderByUser) ?CGRectMake(5, 10, _voiceView.frame.size.width-5-30, 20) :CGRectMake(_voiceView.frame.size.width-5-30, 10, 30, 20);
    
    _voiceTime.text = [NSString stringWithFormat:@"%li \"",chatInfo.duringTime];
    
    _voiceUrl.text = chatInfo.voiceUrl;//语音文件名
    _voiceView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickVoice:)];
    [_voiceView addGestureRecognizer:singleTap];
    UILongPressGestureRecognizer *longTap =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(whenLongPressVoice:)];
    [_voiceView addGestureRecognizer:longTap];
    [singleTap requireGestureRecognizerToFail:longTap];

}
/**
 根据类型设置文字消息

 @param chatInfo 数据
 */
- (void)setMessageAboutMessageType:(ChatInfo *)chatInfo
{
    CGFloat chatTextMaxWidth = SCREEN_WIDTH - PADDING *8 - ICON_SIZE*2;
    CGSize chatTextSize = [_common sizeWithString:_chatInfo.chatText font:TextFont maxSize:CGSizeMake(chatTextMaxWidth, MAXFLOAT)];
    CGFloat chatTextX;
    CGFloat chatTextY = PADDING *2;
    CGFloat chatTextH;
    if (chatInfo.messageSenderType == MessageSenderByService) {
        chatTextX = PADDING *6;
        _messageView.image = _chatBackgroundService;
        
    } else if(chatInfo.messageSenderType == MessageSenderByUser) {
       chatTextX  = SCREEN_WIDTH - PADDING*5 - ICON_SIZE - chatTextSize.width;
        _messageView.image = _chatBackgroundUser;
        
    }
    if (chatTextSize.height +10 <40) {
        chatTextH = 40;
    } else {
        chatTextH = chatTextSize.height + 20;
    }
    self.messageView.frame = CGRectMake(chatTextX, chatTextY, chatTextSize.width +20, chatTextH);
    _message.text = _chatInfo.chatText;
//    _message.textAlignment = NSTextAlignmentCenter;
    _message.frame = CGRectMake(10, 10, chatTextSize.width, chatTextSize.height);
    _message.center = CGPointMake(_messageView.frame.size.width *0.5, _messageView.frame.size.height *0.5);
    UILongPressGestureRecognizer *longTap =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(whenLongPressText:)];
    [_messageView addGestureRecognizer:longTap];
}
/*
 判断图片长度&宽度
 
 */
-(CGSize)imageShowSize:(UIImage *)image{
    
    CGFloat imageWith=image.size.width;
    CGFloat imageHeight=image.size.height;
    
    //宽度大于高度
    if (imageWith>=imageHeight) {
        return CGSizeMake(MAX_IMAGE_WH, imageHeight*MAX_IMAGE_WH/imageWith);

    }else{
        return CGSizeMake(imageWith*MAX_IMAGE_WH/imageHeight, MAX_IMAGE_WH);
    }
    return CGSizeZero;
}
- (NSString *)getDocumentPath
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return docDir;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
