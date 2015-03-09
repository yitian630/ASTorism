//
//  ASGlobal.m
//  ASTorism
//
//  Created by apple  on 13-8-21.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASGlobal.h"
#import "AppDelegate.h"
#import "ASMerchantDetailInfo.h"
#import "InfoDB.h"
#import "AOTabbarView.h"

#import "UIDevice+Resolutions.h"
#import "sqlite3.h"
@interface ASGlobal ()


@end

@implementation ASGlobal

+ (UINavigationController*) getNavigationController
{
    AppDelegate *appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.NavgationController;
}
//判断是否是第一次登陆
+(BOOL)isFirstLogin{
    BOOL isFirst=NO;
    NSString *cityPath=[[self getFilePath] stringByAppendingPathComponent:CITYPATH];
    NSFileManager *fileManager=[[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:cityPath]) {
        isFirst=NO;
    }else{
        isFirst=YES;
    }
        [fileManager release];
    return isFirst;
}
//获取document地址
+(NSString*)getFilePath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                    NSUserDomainMask,                                                          YES) objectAtIndex:0];
   
    NSLog(@"path:--------------%@",paths);
    return paths;
}
//将选择的城市存放到本地
+(void)saveCityTofile:(NSString *)city  CITYID:(NSString *)cityId
{
    if (nil!=city&&city.length>0) {
//        NSString *cityID = [self getCityId:city];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:cityId,CID,city,CNAME, nil];
        NSString *cityPath=[[self getFilePath] stringByAppendingPathComponent:CITYPATH];
        NSLog(@"cityPath:%@",cityPath);
        NSFileManager *fileManager=[[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:cityPath]) {
            //先取出文件内容
            NSData *data=[[NSData alloc]initWithContentsOfFile:cityPath];
            [data release];
            //存放新内容
            [dic writeToFile:cityPath atomically:YES ];
        }else{
            //不存在则创建并存入数据
          [fileManager createFileAtPath:cityPath contents:nil attributes:nil];
            
            //设置文件不备份到icloud上
            NSURL *url=[[NSURL alloc]initFileURLWithPath:cityPath];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
                //5.1以上防止备份
                assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
                
                NSError *error = nil;
                BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                              forKey: NSURLIsExcludedFromBackupKey error: &error];
                if(!success){
                    NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
                }
            }else if ([[[UIDevice currentDevice] systemVersion]  isEqualToString:@"5.0.1"]){
                assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
                
                const char* filePath = [[url path] fileSystemRepresentation];
                
                const char* attrName = "com.apple.MobileBackup";
                u_int8_t attrValue = 1;
                
                int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
                NSLog(@"%d",result);
            }
            
            [url release];
            //存放新内容
            [dic writeToFile:cityPath atomically:YES ];
        }
        [fileManager release];
        [dic release];

    }
}
+(void)saveCityTofile:(NSMutableArray*)array
{
        NSString *cityPlistPath=[[self getFilePath] stringByAppendingPathComponent:@"city.plist"];
        NSLog(@"cityPath:%@",cityPlistPath);
        NSFileManager *fileManager=[[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:cityPlistPath]) {
            //先取出文件内容
//            NSData *data=[[NSData alloc]initWithContentsOfFile:cityPlistPath];
//            [data release];
//            NSMutableArray * = [[NSMutableArray alloc] initWithContentsOfFile:cityPlistPath];
//            [newDic addEntriesFromDictionary:dic];
            //存放新内容
            [array writeToFile:cityPlistPath atomically:YES ];
        }else{
            //不存在则创建并存入数据
            [fileManager createFileAtPath:cityPlistPath contents:nil attributes:nil];
            
            //设置文件不备份到icloud上
            NSURL *url=[[NSURL alloc]initFileURLWithPath:cityPlistPath];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
                //5.1以上防止备份
                assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
                
                NSError *error = nil;
                BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                              forKey: NSURLIsExcludedFromBackupKey error: &error];
                if(!success){
                    NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
                }
            }else if ([[[UIDevice currentDevice] systemVersion]  isEqualToString:@"5.0.1"]){
                assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
                
                const char* filePath = [[url path] fileSystemRepresentation];
                
                const char* attrName = "com.apple.MobileBackup";
                u_int8_t attrValue = 1;
                
                int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
                NSLog(@"%d",result);
            }
            
            [url release];
            //存放新内容
            [array writeToFile:cityPlistPath atomically:YES ];
        }
        [fileManager release];
    
}

////5.1以上防止文件备份到icloud
//- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
//{
//    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
//    
//    NSError *error = nil;
//    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
//                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
//    if(!success){
//        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
//    }
//    return success;
//}
////5.1以下防止文件备份到icloud
//- (BOOL)addSkipBackupAttributeToItemAtURL1:(NSURL *)URL
//{
//    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
//    
//    const char* filePath = [[URL path] fileSystemRepresentation];
//    
//    const char* attrName = "com.apple.MobileBackup";
//    u_int8_t attrValue = 1;
//    
//    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//    return result == 0;
//}
//得到城市id
+(NSString*)getCityId:(NSString*)cityName {
     NSDictionary *cityDic=nil;
    
    NSString *cityPath=[[NSBundle mainBundle]pathForResource:@"city"ofType:@"plist"];
    NSLog(@"cityPath:::::::::::%@",cityPath);
    cityDic=[NSDictionary dictionaryWithContentsOfFile:cityPath];
    NSLog(@"cityDic:::::::::::%@",cityDic);
    NSString *cityID=nil;
    for (NSString *cityNameStr in [cityDic allKeys]) {
        if ([cityNameStr isEqualToString:cityName]) {
            cityID=[cityDic objectForKey:cityName];
            NSLog(@"cityID:%@",cityID);
        }
    }
    return cityID;
}
//从本地获取已存的城市
+(NSDictionary *)getCityFromFile{
    
    NSString *cityPath=[[self getFilePath] stringByAppendingPathComponent:CITYPATH];
    NSFileManager *fileManager=[[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:cityPath]) {
        [fileManager createFileAtPath:cityPath contents:nil attributes:nil];
        
        //设置文件不备份到icloud上
        NSURL *url=[[NSURL alloc]initFileURLWithPath:cityPath];
        if ([UIDevice isAboveIOS51])
        {
            //5.1以上防止备份
            assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
            
            NSError *error = nil;
            BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]                                         forKey: NSURLIsExcludedFromBackupKey error: &error];
            if(!success){
                NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
            }
        }
        else
        {
            assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
            
            const char* filePath = [[url path] fileSystemRepresentation];
            
            const char* attrName = "com.apple.MobileBackup";
            u_int8_t attrValue = 1;
            
            int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
            NSLog(@"%d",result);
        }
        
        [url release];
        
    }
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:cityPath];
    [fileManager release];
    
    
   
    if (nil!=dic) {
        return dic;
    }
    return nil;
}


//将消息列表信息添加到本地缓存
+(void)saveInfoListToFile:(NSArray *)infoListArray{
    
    
    
    InfoDB *db=[[InfoDB alloc]init];
    [db insertInfoToTable:infoListArray];
    [db release];
}
//从本地获取消息列表信息
+(NSMutableArray *)getInfoListFromFile:(int)begin  pageNUM:(int)pageNum{
    
    InfoDB *db=[[InfoDB alloc]init];
    NSArray *array=[db selectInfoListFromTable:[NSString stringWithFormat:@"%d",begin ] withNum:[NSString stringWithFormat:@"%d",pageNum] ];
    NSMutableArray *infoListArray=[[[NSMutableArray alloc]initWithArray:array ]autorelease];
    [db release];
    return infoListArray;
}
//清空缓存
+(BOOL)deleteInfoFromFile{
    BOOL isDelete=NO;
    InfoDB *db=[[InfoDB alloc]init];
        if ([db deleteAllInfo]) {
            isDelete= YES;
        }else{
           isDelete= NO;
        }
    [db release];
    return isDelete;
}
//更新消息的读取状态
+(void)updateInfoIsRead:(NSString*)infoId ISREAD:(NSString *)isRead{
     InfoDB *db=[[InfoDB alloc]init];
    [db updateInfoIsRead:infoId ISREAD:@"0"];
    [db release];
    
}


//tabbar
static  AOTabbarView *tabbar = nil;
+ (AOTabbarView*)getAOTabbarView
{
    if (tabbar == nil) {
         tabbar = [[AOTabbarView alloc]initWithIconNumber:4  messArr:nil];
    }
    
    return tabbar;
}

//tian
+ (CGFloat) getApplicationBoundsHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}
+ (UIWindow*) getWindow
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.window;
}
//+(void)setHidden{
//    AOTabbarView *tabbar = [ASGlobal getAOTabbarView];
//}
+ (void)showAOTabbar
{
    AOTabbarView *tabbar = [ASGlobal getAOTabbarView];
    
//    tabbar.frame = CGRectMake(0, [ASGlobal getApplicationBoundsHeight]-tabbar.frame.size.height, tabbar.frame.size.width, tabbar.frame.size.height);
    [UIView animateWithDuration:0.35 animations:^{
        tabbar.frame=CGRectMake(0, [ASGlobal getApplicationBoundsHeight]-tabbar.frame.size.height, tabbar.frame.size.width, tabbar.frame.size.height);
    } completion:^(BOOL finished){
//        tabbar.hidden = NO;
    }];
    [[ASGlobal getWindow] addSubview:tabbar];
}

+ (void)hiddenBottomMenuView
{
    AOTabbarView *tabar = [ASGlobal getAOTabbarView];
    [UIView animateWithDuration:0.35 animations:^{
        tabar.frame=CGRectMake(-320, [ASGlobal getApplicationBoundsHeight]-tabbar.frame.size.height, tabar.frame.size.width, tabar.frame.size.height);
    } completion:^(BOOL finished){
//        tabar.hidden = YES;
    }];
    
}

////urlImageView   清空图片
//+(void)remvoeImageCacheForUrlImageView{
////    NSString*  diskCachePath=nil;
////    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0){
////    //        diskCachePath=  [[ NSTemporaryDirectory() stringByAppendingPathComponent:@"ImageCache"] retain];
////    //    }else{
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
////    diskCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] retain];
////    //    }
////    NSArray *fileARR =nil;
////    if ([[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]){
////        fileARR= [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: diskCachePath error:nil];
////        if (nil==fileARR) {
////            fileARR = [[NSFileManager defaultManager]  subpathsAtPath: diskCachePath ];
////        }
////        //        [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:NULL];
////    }
////    NSLog(@"%@",fileARR);
////    if (fileARR.count>0) {
////        //        NSError *err;
////        for (NSString *str in fileARR) {
////            NSString *filename=[diskCachePath stringByAppendingFormat:@"/%@",str];
////            NSLog(@"%@",filename);
////            [[NSFileManager defaultManager]removeItemAtPath:filename error:nil];
////            //            if (err) {
////            //
////            //                NSLog(@"%@",err);
////            //            }
////        }
////    }
//    
//    NSString*  diskCachePath=nil;
//    NSString *path=NSHomeDirectory();
//    NSString *tmp=[path stringByAppendingString:@"/tmp"];
////    if (![[NSFileManager defaultManager] fileExistsAtPath:tmp]) {
////        [[NSFileManager defaultManager]createDirectoryAtPath:tmp
////                                 withIntermediateDirectories:YES
////                                                  attributes:nil
////                                                       error:NULL];
////    }
//    diskCachePath = [[tmp stringByAppendingPathComponent:@"/ImageCache"] retain];
//   
////diskCachePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"ImageCache"] retain];
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
////     diskCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] retain];
//       if ([[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]){
////           NSLog(@"%@",[[NSFileManager defaultManager] subpathsAtPath:diskCachePath]);
//            [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:NULL];
//            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
//                                      withIntermediateDirectories:YES
//                                                       attributes:nil
//                                                            error:NULL];
//    
//            if ([[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]){
//                //设置文件不在icloud上面备份
//                //设置文件不备份到icloud上
//                NSURL *url=[[NSURL alloc]initFileURLWithPath:diskCachePath];
//                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
//                    //5.1以上防止备份
//                    assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
//                    NSError *error = nil;
//                    BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
//                                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
//                    if(!success){
//                        NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
//                    }
//                }else if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"5.0.1"] ){
//                    assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
//    
//                    const char* filePath = [[url path] fileSystemRepresentation];
//                    const char* attrName = "com.apple.MobileBackup";
//                    u_int8_t attrValue = 1;
//    
//                    int result = setxattr(filePath, attrName, &attrValue, sizeof (attrValue), 0, 0);
//                    NSLog(@"%d",result);
//                }
//    
//                [url release];
//            }
//        }
//    
//    
//    
//    
//}
@end
