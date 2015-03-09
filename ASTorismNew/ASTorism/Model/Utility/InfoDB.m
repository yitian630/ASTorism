//
//  InfoDB.m
//  sou8
//
//  Created by 玉城 田 on 13-4-15.
//  Copyright (c) 2013年 xujia. All rights reserved.
//

#import "InfoDB.h"
#import "ASInfoListDeatail.h"
#import "UIDevice+Resolutions.h"

@implementation InfoDB
/*
 *打开或创建数据库,并创建表
 */
-(BOOL)sqlite3_open_createTabel{
    
    BOOL isOpen;
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [pathArray objectAtIndex:0];
    NSString *databaseFilePath = [documentDirectory stringByAppendingPathComponent:INFOPATH];
    //打开或创建数据库
    NSFileManager *filemanager = [NSFileManager defaultManager];
     const char *dbpath = [databaseFilePath UTF8String];
    if ([filemanager fileExistsAtPath:databaseFilePath] == NO) {
        if (sqlite3_open(dbpath, &infoDb)==SQLITE_OK) {
            char *errmsg;
            NSString *sql= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT )",INFOTABLENAME,InfoTableIdsName,InfoTableTitleName,InfoTableVisibleName,InfoTableContentName,InfoTableBusinessIdName,InfoTableCreateTimeName,InfoTableEndTimeName,InfoTableStartTimeName,InfoTableChangedName,InfoTableIsReadName,InfoTableImageURLName];
            const char *createsql =[sql UTF8String];
            if (sqlite3_exec(infoDb, createsql, NULL, NULL, &errmsg)!=SQLITE_OK) {
//                status.text = @"create table failed.";
                isOpen=NO;
            }else{
                isOpen=YES;
            }
            //设置文件不在icloud上面备份
                 //设置文件不备份到icloud上
            NSURL *url=[[NSURL alloc]initFileURLWithPath:databaseFilePath];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
               //5.1以上防止备份
                assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
                    NSError *error = nil;
                BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                               forKey: NSURLIsExcludedFromBackupKey error: &error];
                 if(!success){
                     NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
                  }
             }else if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"5.0.1"] ){
                  assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
     
                  const char* filePath = [[url path] fileSystemRepresentation];
                  const char* attrName = "com.apple.MobileBackup";
                   u_int8_t attrValue = 1;
                
                  int result = setxattr(filePath, attrName, &attrValue, sizeof (attrValue), 0, 0);
                   NSLog(@"%d",result);
             }
         
             [url release];
    


            
            
            
        }
        else {
//            status.text = @"create/open failed.";
            isOpen=NO;
        }
    }else{
        if (sqlite3_open(dbpath, &infoDb)==SQLITE_OK){
         isOpen=YES;
        }else{
         isOpen=NO;
        }
    
    }
    return isOpen;
//    if (sqlite3_open([databaseFilePath UTF8String], &infoDb)==SQLITE_OK) {
//        
//    } //打开数据库
}

//向数据库中保存消息数组
-(void)insertInfoToTable:(NSArray *)infoArray{
    //打开数据库
  BOOL isOpen=  [self sqlite3_open_createTabel];
    
    if (isOpen) {
        static NSString* saveInfoArraySqlTemplate = @"INSERT OR REPLACE  INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?,?,?);";
        
        //  判断statement是否使用过  使用过未YES
        BOOL IFuse=NO;
        NSString *query=[[NSString alloc]initWithFormat:saveInfoArraySqlTemplate,INFOTABLENAME,InfoTableIdsName,InfoTableTitleName,InfoTableVisibleName,InfoTableContentName,InfoTableBusinessIdName,InfoTableCreateTimeName,InfoTableEndTimeName,InfoTableStartTimeName,InfoTableChangedName,InfoTableIsReadName,InfoTableImageURLName];
        sqlite3_stmt *statement;//准备sql文
        for (int i=0; i<infoArray.count; i++) {
            ASInfoListDeatail *info=[infoArray objectAtIndex:i];
            BOOL Exist=[self ifInfoExist:info.ids];//判断消息是否存在
            if (Exist) {
                if (sqlite3_prepare_v2(infoDb, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
                    IFuse=YES;
                    
                    sqlite3_bind_text(statement, 1, [info.ids UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 2, [info.title UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 3, [info.visible UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 4, [info.content UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 5, [info.businessId UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 6, [info.createTime UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 7, [info.endTime UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 8, [info.startTime UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 9, [info.changed UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 10, [info.isRead UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 11, [info.imageURL UTF8String], -1, NULL);
                }
                if (sqlite3_step(statement)!=SQLITE_DONE) {
                    NSLog(@"%s",sqlite3_errmsg(infoDb));
                }
            }else{
                
            }
        }
        if (IFuse) {
            sqlite3_finalize(statement);//释放sql文资源
        }
        
        sqlite3_close(infoDb);
        [query release];
    }else{
        NSLog(@"打开失败");
    }

    
}
/*
 *判断好友是否存在
 *如果不存在则返回YES
 *@param userID当前用户的id
 */
-(BOOL)ifInfoExist:(NSString *)mids{
    
//    [self sqlite3_open_createTabel];//打开数据库
    BOOL result=NO;
    NSString *query1 = [[NSString alloc]initWithFormat:@"select * from %@ where ids='%@' ;",INFOTABLENAME,mids];
    
    sqlite3_stmt *statement;//准备sql文
    if (sqlite3_prepare_v2(infoDb, [query1 UTF8String], -1, &statement, nil)==SQLITE_OK) {
        if (sqlite3_step(statement)!=SQLITE_ROW) {
            result = YES;
        }
        else{
            result = NO;
        }
    }
    sqlite3_finalize(statement);//释放sql文
        [query1 release];
    return result;
}
//从数据库中获取消息列表数据
-(NSMutableArray*)selectInfoListFromTable:(NSString*)begin withNum:(NSString*)num{
    
    //打开数据库
    BOOL isOpen=  [self sqlite3_open_createTabel];
    
    if (isOpen) {
    static NSString* getInfoListSqlTemplate = @"SELECT * FROM %@  order by %@ desc limit %@  offset %@;";

    
    //定义一个数组接收查询的内容信息
    NSMutableArray *MArray=[[[NSMutableArray alloc]initWithCapacity:0] autorelease];
    NSString *query=[[NSString alloc]initWithFormat:getInfoListSqlTemplate,INFOTABLENAME,InfoTableCreateTimeName,num,begin];
    sqlite3_stmt *statement;//准备sql文
    if (sqlite3_prepare_v2(infoDb, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {//执行sql文
            ASInfoListDeatail *info=[[ASInfoListDeatail alloc]init];
            char *ids1 = (char *)sqlite3_column_text(statement, 1);
            if (NULL!=ids1) {
                
                info.ids=[NSString stringWithUTF8String:ids1];
            }
            
            
            char *title=(char *)sqlite3_column_text(statement,2 );
            if (NULL!=title) {
                 info.title =[NSString stringWithUTF8String:title];
            }
           
             
            char *visible=(char *)sqlite3_column_text(statement,3 );
            if (NULL!=visible) {
                info.visible = [[NSString alloc]initWithUTF8String:visible];
            }
            
           
           
            char *content=(char *)sqlite3_column_text(statement,4 );
            if (NULL!=content) {
                info.content = [NSString stringWithUTF8String:content];
            }
            
            
            char *businessid=(char *)sqlite3_column_text(statement,5 );
            if (NULL!=businessid) {
                 info.businessId = [NSString stringWithUTF8String:businessid];
            }
           
            
            
            char *createtime=(char *)sqlite3_column_text(statement,6 );
            if (NULL!=createtime) {
                info.createTime = [NSString stringWithUTF8String:createtime];
            }
            
            
            char *endTime=(char *)sqlite3_column_text(statement,7 );
            if (NULL!=endTime) {
                info.endTime = [NSString stringWithUTF8String:endTime];
            }
            
            
            char *startTime=(char *)sqlite3_column_text(statement,8 );
            if (NULL!=startTime) {
                info.startTime = [NSString stringWithUTF8String:startTime];
            }
            
             
            
            
             char *changed=(char *)sqlite3_column_text(statement,9 );
            if (NULL!=changed) {
                info.changed = [NSString stringWithUTF8String:changed] ;
            }
            
             
            char *isRead=(char *)sqlite3_column_text(statement,10 );
            if (NULL!=isRead) {
                info.isRead = [NSString stringWithUTF8String:isRead] ;
            }
            char *imageURL=(char *)sqlite3_column_text(statement,11 );
            if (NULL!=imageURL) {
                info.imageURL = [NSString stringWithUTF8String:imageURL] ;
            }

            if (nil!=info.businessId&&info.businessId.length>0) {
                [MArray addObject:info];
            }

        }
    }
    sqlite3_finalize(statement);//释放sql文资源
    sqlite3_close(infoDb);
    [query release];
        return MArray;
    }
    return nil;
}
/*
删除所有消息
 */
-(BOOL)deleteAllInfo{
    
    //打开数据库
    BOOL isOpen=  [self sqlite3_open_createTabel];
    
    if (isOpen)
    {
    BOOL isDelete=NO;
    static NSString* delAllInfoSqlTemplate = @"DELETE FROM %@ ;";
    
    NSString *query=[[NSString alloc]initWithFormat:delAllInfoSqlTemplate,INFOTABLENAME];
    char *errorMsg;
    if (sqlite3_exec(infoDb, [query UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        isDelete=YES;
    }else{
        NSString *param=[[NSString alloc]initWithFormat:delAllInfoSqlTemplate,INFOTABLENAME];
        char *errormsg;
        if (sqlite3_exec(infoDb, [param UTF8String], NULL, NULL, &errormsg)==SQLITE_OK) {
            isDelete=YES;
            
        }else{
            
        }
        [param release];
       
        sqlite3_free(errormsg);
    }
    sqlite3_free(errorMsg);//释放
    sqlite3_close(infoDb);
    [query release];
    return isDelete;
    }
    return NO;
}
/*
 更新消息的读取状态
 */
-(void)updateInfoIsRead:(NSString *)infoId  ISREAD:(NSString *)isRead{
    //打开数据库
    BOOL isOpen=  [self sqlite3_open_createTabel];
    
    if (isOpen)
    {
    static NSString* updateInfoSqlTemplate = @"UPDATE %@ SET %@='%@' WHERE %@='%@' ;";
  
   NSString *query=[[NSString alloc]initWithFormat:updateInfoSqlTemplate,INFOTABLENAME,InfoTableIsReadName,@"0",InfoTableIdsName,infoId ];
    sqlite3_stmt *statement;
    int result = sqlite3_prepare_v2(infoDb, [query UTF8String], -1, &statement, nil);
    
    if (result == SQLITE_OK)
    {
        sqlite3_step(statement);
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(infoDb);
    [ query release];
    }
}
@end

