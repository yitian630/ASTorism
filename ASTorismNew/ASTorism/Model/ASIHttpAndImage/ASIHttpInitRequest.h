//
//  ASIHttpInitRequest.h
//  ASIrequest
//
//  Created by apple  on 13-9-20.
//  Copyright (c) 2013年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"


@protocol ASIRequestFinishedDelegate <NSObject>

-(void)ASIRequestFailed:(NSString *)requestResult;
-(void)ASIRequestFinished:(NSString *)requestResult;

@end

@interface ASIHttpInitRequest : NSObject<ASIHTTPRequestDelegate>
//{
//    ASIFormDataRequest *requstS;
//}
@property(nonatomic,retain)id<ASIRequestFinishedDelegate> ASIDelegate;

/*
 *参数：(id<ASIRequestFinishedDelegate>)delegate
 *initASIRequest:
 *初始化并且设置委托对象
 *返回：ASIHttpInitRequest *
 */
-(ASIHttpInitRequest *)initASIRequest:(id<ASIRequestFinishedDelegate>)delegate;
/*
 *参数：(NSString *)url PARAMETER:(NSDictionary *)Parameterdic
 *startRequest:
 *初始化Request并且喜爱那个服务器发送请求，调用委托对象的协议方法
 *返回：返回json字符串
 */
-(void)startRequest:(NSString *)url PARAMETER:(NSDictionary *)Parameterdic;
///*
// *参数：(NSString *)imageURL placeholderImage:(UIImage*)placeholderImage
// *getImageFromUrl:
// *从服务器获取图片并且返回，若获取失败，则使用placeholderImage
// *返回：image
// */
//-(UIImage *)getImageFromUrl:(NSString *)imageURL placeholderImage:(UIImage*)placeholderImage;
///*
//*参数：(UIImage *)image URL:(NSString *)serverUrl
//*imageLoad:
//*向指定地址的服务器上传图片
//*返回：无
//*/
//
//-(void)imageLoad:(UIImage *)image URL:(NSString *)serverUrl;
@end
