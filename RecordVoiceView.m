//
//  RecordVoiceView.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/8.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "RecordVoiceView.h"
#import "Common.h"
#import "UIView+Common.h"

@interface RecordVoiceView ()

@end

@implementation RecordVoiceView
- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"%s",__func__);
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = WhiteColor;
        [self addSubview:_hintLabel];
        
        _warningLabel = [[UILabel alloc] init];
        _warningLabel.layer.cornerRadius = 5;
        _warningLabel.clipsToBounds = true;
        _warningLabel.textColor = WhiteColor;
        [self addSubview:_warningLabel];
        
        _MICImageView = [[UIImageView alloc] init];
        _MICImageView.contentMode = UIViewContentModeBottom;
        [self addSubview:_MICImageView];
        
        _cancelView = [[UIImageView alloc] init];
        _cancelView.contentMode = UIViewContentModeCenter;
        [self addSubview:_cancelView];
        
        _volumeView = [[UIImageView alloc] init];
        _volumeView.contentMode = UIViewContentModeBottomLeft;
        [self addSubview:_volumeView];
    }
    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 10;
    
    
    self.hintLabel.text = @"手指上滑,取消发送";
    _hintLabel.frame = CGRectMake(PADDING*2, self.getHeight -WarningLabelHeight-10, self.getWidth-PADDING*4, WarningLabelHeight);
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _warningLabel.backgroundColor = RedColor;
    _warningLabel.text = @"松开手指,取消发送";
    _warningLabel.frame = CGRectMake(PADDING*2, self.getHeight -WarningLabelHeight-10, self.getWidth-PADDING*4, WarningLabelHeight);
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    
    _MICImageView.frame = CGRectMake(self.getWidth*0.5 - 50, self.getHeight*0.5 - 50, 40, 90);
    _MICImageView.image = [UIImage imageNamed:@"MICImage"];
    
    _cancelView.frame = CGRectMake(0, 0, 80, 80);
    _cancelView.center = CGPointMake(self.getWidth*0.5, self.getHeight*0.5);
    _cancelView.image = [UIImage imageNamed:@"CancelImage"];
    
//    _volumeView.image = [UIImage imageNamed:@"volume1"];
    _volumeView.frame = CGRectMake(CGRectGetMaxX(_MICImageView.frame) +20, self.getHeight *0.5-50, 40, 90);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
