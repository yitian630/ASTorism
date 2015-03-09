//
//  AppDelegate.m
//  ASTorism
//
//  Created by apple  on 13-8-19.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "AppDelegate.h"
#import "ASGlobal.h"
#import "RootViewController.h"
#import "ASGuideViewController.h"
#import "ASSelectCityViewController.h"
#import "ASIFormDataRequest.h"


static const NSInteger kTotalLengthOfDeviceTokenString = 72;
static const NSInteger kInterceptionOfDeviceTokenStringLengthUpToIndex = 71;

@implementation AppDelegate
@synthesize window=_window;
@synthesize NavgationController;
@synthesize viewDelegate = _viewDelegate;
#pragma mark
- (void)initializePlat
{
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    //连接邮件
    [ShareSDK connectMail];
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"2905771735"
                               appSecret:@"cc365506e1bc0092bbe562f844167fb3"
                             redirectUri:@"http://www.lvyouykt.com"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801485709"
                                  appSecret:@"3fc4ce04fbd14a74a8e9b363b31b45fb"
                                redirectUri:@"http://www.lvyouykt.com"];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxc338130d389c02c3" wechatCls:[WXApi class]];
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    
    
}
#pragma mark -
- (id)init
{
    if(self = [super init])
    {
        _viewDelegate = [[AGViewDelegate alloc] init];
    }
    return self;
}
- (void)dealloc
{
    [_window release];
    [NavgationController release];
    [_viewDelegate release];
    [super dealloc];
}
-(void)deleteImageCache
{
    NSString *path=NSHomeDirectory();
    NSString *tmp=[path stringByAppendingString:@"/tmp"];
    NSString*    diskCachePath = [tmp stringByAppendingPathComponent:@"/ImageCache"] ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]){
        [[NSFileManager defaultManager]removeItemAtPath:diskCachePath error:NULL];
     }

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    //清空缓存图片
//    [ASGlobal remvoeImageCacheForUrlImageView];
    
    //将以前缓存的image和文件夹删除
    [self deleteImageCache];
    
    
    //    //网络通信部分初始化
//    [self configerationNetworking];
    
    isRunInBack=NO;//程序启动时，设置isRunInBack为NO，代表程序前台运行
    
    //设置推送消息显示得类型
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound |
      UIRemoteNotificationTypeAlert)];
    
    //百度地图管理
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数 97aebbadf673d4b668d7d6d24fb171ff  
    BOOL ret = [_mapManager start:@"DA5e0a954983e575fe446cd7b12f4dec"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //[_mapManager release];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    _window.backgroundColor = [UIColor whiteColor];
    RootViewController *rootVC = [[RootViewController alloc]init];
    NavgationController=[[UINavigationController alloc]initWithRootViewController:rootVC];
    //检查是否为第一次登陆，如果为第一次登陆，需要设置显示导航页
    if ([ASGlobal isFirstLogin]) {
//        ASSelectCityViewController *selectCity=[[ASSelectCityViewController alloc]init];
//        selectCity.nextViewController=self.NavgationController;
        ASGuideViewController *guide=[[ASGuideViewController alloc]init];
        guide.nextViewController=self.NavgationController;
        _window.rootViewController=guide;
        [guide release];
//        [selectCity release];
    }else{
//        ASSelectCityViewController *selectCity=[[ASSelectCityViewController alloc]init];
//        selectCity.nextViewController=self.NavgationController;
         _window.rootViewController=self.NavgationController;
    }
    [rootVC release];
    [_window makeKeyAndVisible];
    
    //参数为ShareSDK官网中添加应用后得到的AppKey
    [ShareSDK registerApp:@"14822fe2b84a"];
    
    //初始化平台
    [self initializePlat];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber=0;
    isRunInBack=YES;//进入后台
//    NSLog(@"应用程序将要进入非活动状态，即将进入后台");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//应用程序已经进入后台运行
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //清空缓存图片
//    [ASGlobal remvoeImageCacheForUrlImageView];
//    NSLog(@"如果应用程序支持后台运行，则应用程序已经进入后台运行");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//应用程序将要进入活动状态执行
- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    if (!isPushInfo) {
//        isRunInBack=NO;
//    }
    
//    NSLog(@"应用程序将要进入活动状态，即将进入前台运行");
//    if (isPushInfo) {
//         isPushInfo=NO;
//        UIButton *button=[[UIButton alloc]init];
//        button.tag=3;
//        [[ASGlobal getAOTabbarView] switchButton:button];
//        [button release];
//    }
   
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//应用程序已经进入活动状态
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self performSelector:@selector(setisRunInBackNO) withObject:nil afterDelay:10.0];
//    if (!isPushInfo) {
//      isRunInBack=NO;
//    }

//    NSLog(@"应用程序已进入前台，处于活动状态");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//应用程序将要退出，通常用于保存书架和一些推出前的清理工作，
- (void)applicationWillTerminate:(UIApplication *)application
{
    //清空缓存图片
//    [ASGlobal remvoeImageCacheForUrlImageView];

//    NSLog(@"应用程序将要退出，通常用于保存书架喝一些推出前的清理工作");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//当设备为应用程序分配了太多的内存，操作系统会终止应用程序的运行，在终止前会执行这个方法
//通常可以在这里进行内存清理工作，防止程序被终止
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
//    [ASGlobal remvoeImageCacheForUrlImageView];

//    NSLog(@"系统内存不足，需要进行清理工作");
}

//当系统时间发生改变时执行
-(void)applicationSignificantTimeChange:(UIApplication *)application
{
//    NSLog(@"当系统时间发生改变时执行");
}

//当程序载入后执行
-(void)applicationDidFinishLaunching:(UIApplication *)application
{
//    NSLog(@"当程序载入后执行");
}








- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //注册成功，将deviceToken保存到本地并注册到应用服务器数据库中
    //将device token转换为字符串
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    
    //去掉"<, >"
    deviceTokenString = [[deviceTokenString substringWithRange:NSMakeRange(0, kTotalLengthOfDeviceTokenString)] substringWithRange:NSMakeRange(1, kInterceptionOfDeviceTokenStringLengthUpToIndex)];
    
    //去掉空格
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //保存device token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceTokenString forKey:kEchoMeDeviceTokenStringKey];
    [userDefaults synchronize];
//    NSLog(@"%@",deviceTokenString);
    
    
    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:SAVETOKENURL]];
    [request setDelegate:self];
    [request setTimeOutSeconds:5];
    
       [request setPostValue:deviceTokenString forKey:@"keyValue"];


    [request startAsynchronous];//异步加载

//    [request release];

    
    
    
}
//得到推送通知
// received remote notification when application is running
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
//    NSLog(@"111111111111============");
    
    if (isRunInBack) {
        isRunInBack=NO;
        UIButton *button=[[UIButton alloc]init];
        button.tag=3;
            [[ASGlobal getAOTabbarView] switchButton:button];
            [button release];
        
        NSDictionary *apsDic=[userInfo objectForKey:@"aps"];        
        
        application.applicationIconBadgeNumber = [[apsDic objectForKey:@"badge"] integerValue];
        NSLog(@"apsDic is %@",apsDic);
        NSLog(@"badge is %@",[apsDic objectForKey:@"badge"]);
    }else{
        NSDictionary *apsDic=[userInfo objectForKey:@"aps"];
        NSString *info=[apsDic objectForKey:@"alert"];
        
        
        application.applicationIconBadgeNumber = [[apsDic objectForKey:@"badge"] integerValue];
        NSLog(@"apsDic is %@",apsDic);
        NSLog(@"badge is %@",[apsDic objectForKey:@"badge"]);
//        UIButton *button=[[UIButton alloc]init];
//        button.tag=3;
//        [[ASGlobal getAOTabbarView] switchButton:button];
//        [button release];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag=101;
        [alert show];
        [alert release];
    }
//     NSLog(@"Received Remote Message: %@",userInfo);
}
//延迟设置isRunInBack为NO
-(void)setisRunInBackNO{
    isRunInBack=NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==101) {
        if (buttonIndex==0) {
            UIButton *button=[[UIButton alloc]init];
            button.tag=3;
            [[ASGlobal getAOTabbarView] switchButton:button];
            [button release];
        }
    }
}

////网络通信部分初始化
//- (void)configerationNetworking
//{
//    //设置缓存
//    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
//    [NSURLCache setSharedURLCache:URLCache];
//    [URLCache release];
//    
//    //设置状态栏网络图标显示
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
//    
//    //初始化网络客户端
//    [ASBestLifeAPIClient sharedClient];
//}
//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    NSString *string = [request responseString];
//    NSLog(@"%@",string);
}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
//    NSString *string = [request responseString];
        //    NSLog(@"失败咯!!!!!");
}
#pragma mark - Wei Xin
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

@end