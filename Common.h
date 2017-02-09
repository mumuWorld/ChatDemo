//
//  Common.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NAV_ITEM_HEIGHT 44.00

//0
#define ZERO 0
//间隙
#define PADDING 10.00
//头像size
#define ICON_SIZE 30.00
//图片最大宽高
#define MAX_IMAGE_WH 141.0

#define WarningLabelHeight 30.00
//聊天字体
#define TextFont [UIFont systemFontOfSize:16]

#define CommonColor [UIColor colorWithRed:31.0/255.0 green:181.0/255.0 blue:252.0/255.0 alpha:1]
#define ChatColor [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]
#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor]
#define RedColor [UIColor redColor]
+ (instancetype)commonShareInstance;

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)imageShowSize:(UIImage *)image;
- (NSString *)getImageDocumentPathWith:(NSString *)imageUrl;
@end
