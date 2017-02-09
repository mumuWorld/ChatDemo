//
//  TopView.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

- (void)topViewDelegateBackBtnClick:(UIButton *)button;

@end

@interface TopView : UIView

@property (nonatomic,weak) id <TopViewDelegate>delegate;
@end
