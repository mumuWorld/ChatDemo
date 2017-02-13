//
//  BottomView.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/6.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "BottomView.h"
#import "Common.h"

@interface BottomView ()<UITextViewDelegate>

@property (nonatomic,strong) Common *common;

@end
static float currentInputHeight;
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
        _messageInputField = [[UITextView alloc] init];
//        _messageInputField.backgroundColor = [UIColor redColor];
        _messageInputField.backgroundColor = ChatColor;
        [_messageInputField setFont:[UIFont systemFontOfSize:15]];
        
        [self addSubview:_keyboardInput];
        [self addSubview:_VoiceInput];
        [self addSubview:_chooseImage];
        [self addSubview:_longPressVoice];
        [self addSubview:_messageInputField];
        _common = [Common commonShareInstance];
         currentInputHeight = 34.0f;
        
    }
    
    return self;
}
- (void)layoutSubviews
{
//    NSLog(@"%s",__func__);
    [super layoutSubviews];
    
    _keyboardInput.frame = CGRectMake(10, self.frame.size.height-44, 44, 44);
    _keyboardInput.backgroundColor = [UIColor blueColor];
    [_keyboardInput setTitle:@"键盘" forState:UIControlStateNormal];
    _keyboardInput.tag = 1;
    [_keyboardInput addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _VoiceInput.frame = CGRectMake(10, self.frame.size.height-44, 44, 44);
    _VoiceInput.backgroundColor = [UIColor greenColor];
    [_VoiceInput setTitle:@"声音" forState:UIControlStateNormal];
    _VoiceInput.tag = 2;
    [_VoiceInput addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _chooseImage.frame = CGRectMake(59, self.frame.size.height-44, 44, 44);
    _chooseImage.backgroundColor = [UIColor greenColor];
    [_chooseImage setTitle:@"照片" forState:UIControlStateNormal];
    _chooseImage.tag = 3;
    [_chooseImage addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _longPressVoice.frame = CGRectMake( 108, self.frame.size.height-44, 200, 44);
    _longPressVoice.backgroundColor = [UIColor greenColor];
    [_longPressVoice setTitle:@"长按说话" forState:UIControlStateNormal];
    _longPressVoice.tag = 4;
    UILongPressGestureRecognizer *longTap =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startRecordVoice:)];
    [_longPressVoice addGestureRecognizer:longTap];
//    [_longPressVoice addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    _messageInputField.frame = CGRectMake( 108, 5, 200, currentInputHeight);
    NSLog(@"--------------------------------");
    NSLog(@"currentInputHeight=%f",currentInputHeight);
    _messageInputField.layer.cornerRadius = 5;
    _messageInputField.returnKeyType = UIReturnKeySend;
    _messageInputField.delegate = self;
    

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

#pragma mark - UITextViewDelegate-------------
- (void)textViewDidEndEditing:(UITextView *)textView
{
//    NSLog(@"结束编辑----------");
//    
//    NSDictionary *userInfo = @{
//                               @"messageInputField":self.messageInputField.text
//                               };
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageInputFieldDidEndEditingNotification" object:self.messageInputField userInfo:userInfo];
}
-(void)textViewDidChange:(UITextView *)textView{
    
//    NSLog(@"%@",NSStringFromUIEdgeInsets(textView.textContainerInset));
    static CGFloat maxHeight =100.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
//    NSLog(@"%f",size.height);
    if (size.height <= 34) {
        textView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
        currentInputHeight = 34;
    }else{
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (size.height >= maxHeight)
        {
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
            [textView sizeToFit];
            CGSize size2 = [textView sizeThatFits:constraintSize];
            currentInputHeight = size2.height;
//            textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size2.height);
            
        }
    }
    if([self.delegate respondsToSelector:@selector(BottomViewDelegateShouldChangHeight:)]){
        NSLog(@"textView.frame.size.height=%f",textView.frame.size.height);
        [self.delegate BottomViewDelegateShouldChangHeight:currentInputHeight];
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,currentInputHeight);
   
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSDictionary *userInfo = @{
                                   @"messageInputField":self.messageInputField.text
                                   };
        currentInputHeight = 34;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageInputFieldDidEndEditingNotification" object:self.messageInputField userInfo:userInfo];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (CGFloat)getCurrentViewHeight
{
    return currentInputHeight +10;
}
@end
