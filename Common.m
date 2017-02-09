//
//  Common.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "Common.h"

@implementation Common
/**
 *  单例
 *
 *  @return common
 */
+ (instancetype)commonShareInstance
{
    static Common *common = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        common = [[self alloc] init];
    });
    return common;
}
/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
/*
 判断图片长度&宽度
 
 */
-(CGSize)imageShowSize:(UIImage *)image{
    
    CGFloat imageWith=image.size.width;
    CGFloat imageHeight=image.size.height;
    
    //宽度大于高度
    if (imageWith>=imageHeight) {
        
        return CGSizeMake(MAX_IMAGE_WH, imageHeight*MAX_IMAGE_WH/imageWith);
        
        
    }else{
        
        return CGSizeMake(imageWith*MAX_IMAGE_WH/imageHeight, MAX_IMAGE_WH);
        
    }
    return CGSizeZero;
}
- (NSString *)getImageDocumentPathWith:(NSString *)imageUrl
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@",docDir,imageUrl];
}
@end
