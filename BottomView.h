//
//  BottomView.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/6.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

- (void)BottomViewDelegateWithButtonTag:(NSInteger)btnTag;
- (void)LongPressVoiceBtnDelegateWithGesture:(UILongPressGestureRecognizer *)gesture;
- (void)BottomViewDelegateShouldChangHeight:(CGFloat)height;
@end

@interface BottomView : UIView




@property (nonatomic, strong) UIButton *keyboardInput;

@property (nonatomic, strong) UIButton *VoiceInput;

@property (nonatomic, strong) UIButton *chooseImage;

@property (nonatomic, strong) UIButton *longPressVoice;

@property (nonatomic, strong) UITextView *messageInputField;

@property (nonatomic,weak) id<BottomViewDelegate> delegate;

- (CGFloat)getCurrentViewHeight;

@end
