//
//  ASGlobal.h
//  ASTorism
//
//  Created by apple  on 13-8-21.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASMerchantDetailInfo.h"
#import <sqlite3.h>
#import "AOTabbarView.h"
#define CITYPATH @"saveCity"

//#define BASEURL @"http://10.7.10.39:8080/yhkj/"@"http://60.29.113.54:8010/yhkj/"@"http://122.0.66.43:8080/yhkj/"10.7.10.133:8080/huiyou  //测试
#define BASEURL @"http://122.0.66.43:9090/yhkj/"
#define appendURL(a,b)  [NSString stringWithFormat:@"%@%@",a,b]
#define REQUESTURL       appendURL(BASEURL,@"inter/querySupplier.do") //推荐和周边
#define REQUESTURL1       appendURL(BASEURL,@"business/querySupplier.do") //推荐和周边

#define REQUESTTYPERECOMMANDURL  appendURL(BASEURL,@"inter/querySupplier.do")//主页类别查询
#define CITYLISTURL      appendURL(BASEURL,@"inter/queryCity.do") //城市列表
#define PUSHURL          appendURL(BASEURL,@"pushMessage/pushMessageList.do")//消息
#define PUSHDETAILURL    appendURL(BASEURL,@"business/getBusinessMessage.do")//消息详情
//意见反馈
#define FEEDBACKURL      @"http://122.0.66.43:9090/yhkj/feedback/save.do"
////发送token
#define SAVETOKENURL  @"http://122.0.66.43:9090/yhkj/pushMessage/saveKeyValue.do"
//头像地址
#define IMAGEURL @"http://122.0.66.43:9090/yhkj/"



#define COLORFROMCODE(c,a) ([UIColor colorWithRed:(((c >> 16) & 0x000000FF)/255.0f) \
green:(((c >> 8) & 0x000000FF)/255.0f) \
blue:(((c) & 0x000000FF)/255.0f) \
alpha:a])

//每页加载数据条数
#define  PAGENUMBER  @"10"
//向服务器传的参数
//每页条数
#define PAGESIZENUMBER  @"pageSize"
//当前页数
#define PAGENONUMER  @"pageNum"




/*
 保存token
 */
#define kEchoMeDeviceTokenStringKey @"DeviceTokenStringKey"
//#define CITYPATH @"city.plist"
//城市缓存  key值
#define CID @"cityId"
#define CNAME @"cityName"
//#define PID @"proId"
//#define PNAME @"proName"




@interface ASGlobal : NSObject
{
    sqlite3 *infoDB;
}

//获取NavigationController
+ (UINavigationController*) getNavigationController;
//判断是否是第一次登陆
+(BOOL)isFirstLogin;
//获取document地址
+(NSString*)getFilePath;
//将选择的城市存放到本地
+(void)saveCityTofile:(NSString *)city  CITYID:(NSString *)cityId;
+(void)saveCityTofile:(NSMutableArray*)array;

//从本地获取已存的城市
+(NSDictionary *)getCityFromFile;
//得到省id
//+(NSString*)getProId:(NSString*)proNmae ;



//将消息列表信息添加到本地缓存
+(void)saveInfoListToFile:(NSArray *)infoListArray;
//从本地获取消息列表信息
+(NSMutableArray *)getInfoListFromFile:(int)begin  pageNUM:(int)pageNum;
//清空缓存
+(BOOL)deleteInfoFromFile;
//更新消息的读取状态
+(void)updateInfoIsRead:(NSString*)infoId ISREAD:(NSString *)isRead;



//tabbar
+ (UIWindow*) getWindow;
+ (CGFloat) getApplicationBoundsHeight;
+ (void)showAOTabbar;
+ (AOTabbarView*)getAOTabbarView;
+ (void)hiddenBottomMenuView;


//urlImageView   清空图片
//+(void)remvoeImageCacheForUrlImageView;
@end
