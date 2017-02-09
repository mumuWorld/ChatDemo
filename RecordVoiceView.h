//
//  RecordVoiceView.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/8.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordVoiceView : UIView

/**
 提示label
 */
@property (nonatomic,strong) UILabel *hintLabel;
/**
 警告label
 */
@property (nonatomic,strong) UILabel *warningLabel;

@property (nonatomic,strong) UIImageView *MICImageView;

@property (nonatomic,strong) UIImageView *cancelView;

@property (nonatomic,strong) UIImageView *volumeView;

@end
