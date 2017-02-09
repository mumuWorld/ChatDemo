//
//  FMDBTools.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/8.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "FMDBTools.h"
#import "FMDatabase.h"
#import "FMDB.h"
#import "ChatInfo.h"

#define TableName @"chat_info"
@interface FMDBTools ()
@property (nonatomic,strong) FMDatabase *database;

@end

@implementation FMDBTools
/**
 *  单例
 *
 *  @return fmdbTools
 */
+ (instancetype)FMDBToolsShareInstance
{
    static FMDBTools *fmdbTools = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        fmdbTools = [[self alloc] init];
    });
   
    return fmdbTools;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}
- (void)initDatabase
{
    
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"chatMessage.sqlite"];
    _database = [[FMDatabase alloc] initWithPath:filename];
    if(![_database open])
    {
        NSLog(@"initDatabase 失败！！！！！！");
        return;
    }
     [self creatFmdbDataBase];
}
- (void)creatFmdbDataBase
{
    // 4.创表
    BOOL result = [_database executeUpdate:@"CREATE TABLE IF NOT EXISTS chat_info (ID integer PRIMARY KEY AUTOINCREMENT, MessageSenderType int NOT NULL, MessageType int NOT NULL, chatText text ,chatTime text,duringTime int,voiceUrl text,imageUrl text);"];
    if (result) {
        NSLog(@"成功创表或已经存在");
    } else {
        NSLog(@"创表失败");
    }
    [_database close];
}
/**
 * 添加一条数据
 */
- (BOOL)addRecordWithChatInfo:(ChatInfo *)chatInfo
{
    if ([_database open]) {
        NSString *sql1 = [NSString stringWithFormat:
                          @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%i', '%i', '%@', '%@', '%i', '%@', '%@')",
                          TableName, @"MessageSenderType", @"MessageType", @"chatText", @"chatTime", @"duringTime", @"voiceUrl",@"imageUrl",(unsigned short)chatInfo.messageSenderType,(unsigned short)chatInfo.messageType,chatInfo.chatText,chatInfo.chatTime,(short)chatInfo.duringTime,chatInfo.voiceUrl,chatInfo.imageUrl];
        BOOL res = [_database executeUpdate:sql1];
        
        if (!res) {
            NSLog(@"插入数据失败");
        } else {
            NSLog(@"插入数据成功");
        }
        [_database close];
    }
    return true;
}
/**
 * 删除一条数据
 */
- (BOOL)removeRecordWithChatInfo:(ChatInfo *)chatInfo
{
    return true;
}
/**
 * 检查某件商品是否被记录过
 */
- (BOOL)isExistRecordWithChatInfo:(ChatInfo *)chatInfo
{
    return true;
}
/**
 * 获取记录的列表
 */
- (NSMutableArray *)recordList
{
    
    NSMutableArray *allChatInfo = [NSMutableArray new];
    if ([_database open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",TableName];
        FMResultSet * result = [_database executeQuery:sql];
        
        while ([result next]) {
            ChatInfo *temp = [[ChatInfo alloc] init];
            temp.messageSenderType = [result intForColumn:@"MessageSenderType"];
            temp.messageType = [result intForColumn:@"MessageType"];
            temp.chatTime = [result stringForColumn:@"chatTime"];
            temp.chatText = [result stringForColumn:@"chatText"];
            temp.duringTime = [result intForColumn:@"duringTime"];
            temp.voiceUrl = [result stringForColumn:@"voiceUrl"];
            temp.imageUrl = [result stringForColumn:@"imageUrl"];
            temp.ID = [result intForColumn:@"ID"];
            [allChatInfo addObject:temp];
        }
        [_database close];
    }
    
    return allChatInfo;
}
/**
 *  删除所有数据
 */
- (void)removeAllRecord
{
    if ([_database open]) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", TableName];
        BOOL res = [_database executeUpdate:sqlstr];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [_database close];
    }
}
@end
