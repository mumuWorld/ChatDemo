//
//  BottomView.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/6.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "BottomView.h"
#import "Common.h"

@interface BottomView ()<UITextFieldDelegate>


@end

@implementation BottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
//    NSLog(@"%s",__func__);
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = WhiteColor;
        
        _keyboardInput = [[UIButton alloc] init];
        _VoiceInput = [[UIButton alloc] init];
        _chooseImage = [[UIButton alloc] init];
        _longPressVoice = [[UIButton alloc] init];
        _messageInputField = [[UITextField alloc] init];
    }
    
    return self;
}
- (void)layoutSubviews
{
//    NSLog(@"%s",__func__);
    [super layoutSubviews];
    
    _keyboardInput.frame = CGRectMake(10, 0, 44, 44);
    _keyboardInput.backgroundColor = [UIColor blueColor];
    [_keyboardInput setTitle:@"键盘" forState:UIControlStateNormal];
    _keyboardInput.tag = 1;
    [_keyboardInput addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _VoiceInput.frame = CGRectMake(10, 0, 44, 44);
    _VoiceInput.backgroundColor = [UIColor greenColor];
    [_VoiceInput setTitle:@"声音" forState:UIControlStateNormal];
    _VoiceInput.tag = 2;
    [_VoiceInput addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _chooseImage.frame = CGRectMake(59, 0, 44, 44);
    _chooseImage.backgroundColor = [UIColor greenColor];
    [_chooseImage setTitle:@"照片" forState:UIControlStateNormal];
    _chooseImage.tag = 3;
    [_chooseImage addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _longPressVoice.frame = CGRectMake( 108, 0, 200, 44);
    _longPressVoice.backgroundColor = [UIColor greenColor];
    [_longPressVoice setTitle:@"长按说话" forState:UIControlStateNormal];
    _longPressVoice.tag = 4;
    UILongPressGestureRecognizer *longTap =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startRecordVoice:)];
    [_longPressVoice addGestureRecognizer:longTap];
//    [_longPressVoice addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    _messageInputField.frame = CGRectMake( 108, 5, 200, 34);
    _messageInputField.delegate = self;
    _messageInputField.backgroundColor = ChatColor;
    
    [self addSubview:_keyboardInput];
    [self addSubview:_VoiceInput];
    [self addSubview:_chooseImage];
    [self addSubview:_longPressVoice];
    [self addSubview:_messageInputField];
//        _keyboardInput.hidden = YES;
//        _longPressVoice.hidden = YES;
//    _VoiceInput.hidden = YES;
//    _messageInputField.hidden = YES;
}
- (void)buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(BottomViewDelegateWithButtonTag:)]) {
        [self.delegate BottomViewDelegateWithButtonTag:button.tag];
    }
}
- (void)startRecordVoice:(UILongPressGestureRecognizer *)longPGR
{
    if([self.delegate respondsToSelector:@selector(LongPressVoiceBtnDelegateWithGesture:)]){
        [self.delegate LongPressVoiceBtnDelegateWithGesture:longPGR];
    }
}

#pragma mark - UITextFieldDelegate-------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"结束编辑----------");
    
    NSDictionary *userInfo = @{
                               @"messageInputField":self.messageInputField.text
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageInputFieldDidEndEditingNotification" object:self.messageInputField userInfo:userInfo];
    return true;
}
@end
