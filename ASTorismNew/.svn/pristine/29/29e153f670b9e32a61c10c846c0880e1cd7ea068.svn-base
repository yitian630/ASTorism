//
//  InfoDB.h
//  sou8
//
//  Created by 玉城 田 on 13-4-15.
//  Copyright (c) 2013年 xujia. All rights reserved.
//







#import <Foundation/Foundation.h>
#import <sqlite3.h>


#define INFOPATH @"infoTable.db"

//消息数据库
#define INFOTABLENAME @"infoTable"

#define InfoTableIdsName @"ids"
#define InfoTableTitleName @"title"
#define InfoTableVisibleName @"visible"
#define InfoTableContentName @"content"
#define InfoTableBusinessIdName @"businessid"
#define InfoTableCreateTimeName @"createtime"
#define InfoTableChangedName @"changed"
#define InfoTableEndTimeName @"endTime"
#define InfoTableStartTimeName @"startTime"
#define InfoTableIsReadName @"isRead"
#define InfoTableImageURLName @"imageURL"


@interface InfoDB : NSObject
{
    sqlite3 *infoDb;
}
//向数据库中保存消息数组
-(void)insertInfoToTable:(NSArray *)infoArray;

//从数据库中获取消息列表数据
-(NSMutableArray*)selectInfoListFromTable:(NSString*)begin withNum:(NSString*)num;
/*
 删除所有缓存数据
 */
-(BOOL)deleteAllInfo;
/*
 更新消息的读取状态
 */
-(void)updateInfoIsRead:(NSString *)infoId  ISREAD:(NSString *)isRead;
@end
