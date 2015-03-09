//
//  UIDevice+Resolutions.m
//  ASBestLife
//
//  Created by Jill on 13-7-18.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "UIDevice+Resolutions.h"

#import "UIDevice+Resolutions.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@implementation UIDevice (Resolutions)

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (UIDeviceResolution) currentResolution
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)])
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height <= 480.0f)
            {
                return UIDevice_iPhoneStandardRes;
            }
            return (result.height > 960 ? UIDevice_iPhoneTallerHiRes : UIDevice_iPhoneHiRes);
        }
        else
        {
            return UIDevice_iPhoneStandardRes;
        }
    }
    else
    {
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
    }
}

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5
{
    if ([self currentResolution] == UIDevice_iPhoneTallerHiRes)
    {
        return YES;
    }
    return NO;
}

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}



+ (NSUInteger)systemMajorVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}
/*
 *-(BOOL)isIOS6
 *判断是否是ios6
 * 无参数
 *返回  BOOL  yes代表ios6   no代表ios6以下
 */
+(BOOL)isIOS6{
   
     BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        accessGranted=YES;
        }
    else { // we're on iOS 5 or older
        
    }
    return accessGranted;
}

/*
 *-(BOOL)isAboveIOS51
 *判断是否是ios5.1以上
 * 无参数
 *返回  BOOL  yes代表ios5.1以上   no代表ios5.1以下
 */
+(BOOL)isAboveIOS51{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
        // iOS 5.1以上 code
        return YES;
        }
    else {
        // iOS 4.x code
        return NO;
            }
}

@end