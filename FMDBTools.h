//
//  FMDBTools.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/8.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatInfo;
@interface FMDBTools : NSObject
/**
 * 获取单例对象
 */
+ (instancetype)FMDBToolsShareInstance;
/**
 * 添加一条数据
 */
- (BOOL)addRecordWithChatInfo:(ChatInfo *)chatInfo;
/**
 * 删除一条数据
 */
- (BOOL)removeRecordWithChatInfo:(ChatInfo *)chatInfo;
/**
 * 检查某件商品是否被记录过
 */
- (BOOL)isExistRecordWithChatInfo:(ChatInfo *)chatInfo;
/**
 * 获取记录的列表
 */
- (NSMutableArray *)recordList;
/**
 *  删除所有数据
 */
- (void)removeAllRecord;
@end
