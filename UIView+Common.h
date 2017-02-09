//
//  UIView+Common.h
//  KillingSpree
//
//  Copyright (c) 2015年 ZhengChaoJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)

@end

@interface UIView (Postion)

/**
 * 获取屏幕宽度
 *
 * @return 屏幕宽度
 */
CGFloat screenWidth();
/**
 * 获取屏幕高度
 *
 * @return 屏幕高度
 */
CGFloat screenHeight();
/**
 *  根据 frame 返回宽高
 *
 *  @param rect 视图的 frame
 *
 *  @return frame 的宽高
 */
CGFloat width(CGRect rect);
CGFloat height(CGRect rect);

/**
 *  返回当前视图的宽
 *
 *  @return 视图的宽
 */
- (CGFloat)getWidth;
/**
 *  返回当前视图的高
 *
 *  @return 视图的高
 */
- (CGFloat)getHeight;

CGFloat maxX(UIView *view);
CGFloat minX(UIView *view);
CGFloat midX(UIView *view);
CGFloat maxY(UIView *view);
CGFloat minY(UIView *view);
CGFloat midY(UIView *view);
/**
 *  获取子视图的父视图
 *
 *  @return 11111
 */
- (UIViewController*)myViewController;



@end
