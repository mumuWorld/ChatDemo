//
//  ServiceViewController.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 输入类型
 */
typedef NS_OPTIONS(NSUInteger, InputType) {
    InputTypeText=0,
    InputTypeVoice,
};
/*
 输入类型
 */
typedef NS_OPTIONS(NSUInteger, RecoredViewType) {
    RecoredViewRecording=0,
    RecoredViewCancel,
};
typedef NS_OPTIONS(NSUInteger, ImageChoooseType) {
    ImageChooseFromSystem=0,
    ImageChooseFromShoot,
};
@interface ServiceViewController : UIViewController
/**
 输入类型
 */
@property (nonatomic, assign)  InputType  inputType;
@property (nonatomic, assign)  ImageChoooseType  imageChooseType;
@property (nonatomic, assign)  RecoredViewType  recordViewType;
@end
