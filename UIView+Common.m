

#import "UIView+Common.h"

@implementation UIView (Common)

@end

@implementation UIView (Postion)

/**
 * 获取屏幕宽度
 *
 * @return 屏幕宽度
 */
CGFloat screenWidth() {
    return [[UIScreen mainScreen] bounds].size.width;
}

/**
 * 获取屏幕高度
 *
 * @return 屏幕高度
 */
CGFloat screenHeight() {
    return [[UIScreen mainScreen] bounds].size.height;
}

/**
 *  根据 frame 返回宽高
 *
 *  @param rect 视图的 frame
 *
 *  @return frame 的宽高
 */
CGFloat width(CGRect rect) {
    return rect.size.width;
}

CGFloat height(CGRect rect) {
    return rect.size.height;
}

/**
 *  返回当前视图的宽
 *
 *  @return 视图的宽
 */
- (CGFloat)getWidth {
    return self.frame.size.width;
}
/**
 *  返回当前视图的高
 *
 *  @return 视图的高
 */
- (CGFloat)getHeight {
    return self.frame.size.height;
}
/**
 *  返回当前视图的点坐标
 *
 *  @param view 当前视图
 *
 *  @return 视图的点坐标
 */

CGFloat maxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
}

CGFloat minX(UIView *view) {
    return CGRectGetMinX(view.frame);
}

CGFloat midX(UIView *view) {
    return CGRectGetMidX(view.frame);
}

CGFloat maxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

CGFloat minY(UIView *view) {
    return CGRectGetMinY(view.frame);
}

CGFloat midY(UIView *view) {
    return CGRectGetMidY(view.frame);
}

/**
 *  获取子视图的父视图
 *
 *  @return
 */
- (UIViewController*)myViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end