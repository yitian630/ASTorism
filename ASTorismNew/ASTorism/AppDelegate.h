//
//  AppDelegate.h
//  ASTorism
//
//  Created by apple  on 13-8-19.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "BMapKit.h"
#import "AGViewDelegate.h"
#import "WXApi.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate, WXApiDelegate>
{
    BMKMapManager* _mapManager;
    BOOL  isPushInfo;//用来判断当前是否有未读推送消息  YES代表有
    BOOL   isRunInBack;//用来判断程序目前是前台运行还是后台运行    YES为后台运行
    AGViewDelegate *_viewDelegate;
}
@property(retain,nonatomic)UINavigationController *NavgationController;
@property (retain, nonatomic) UIWindow *window;
@property (nonatomic,readonly) AGViewDelegate *viewDelegate;


@end
