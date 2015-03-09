//
//  ASMerchantDetailInfo.m
//  ASBestLife
//
//  Created by Jill on 13-6-27.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASMerchantDetailInfo.h"


@implementation ASMerchantDetailInfo


@synthesize visible;
@synthesize type;
@synthesize remark;
//@synthesize radius;
@synthesize name;             //商家名称
@synthesize longitude;             //商家所在位置的经度
@synthesize latitude;         //商家所在位置的纬度
@synthesize introduction;            //商家简介
@synthesize imageURL;           //商家图片
@synthesize address;          //商家的详细地址
@synthesize ids;               //商家的ID
@synthesize discount;               //折扣
@synthesize createTime;            //有效期
@synthesize  changed;
@synthesize status;
@synthesize mid;
//@synthesize isRead;
@synthesize stars;
@synthesize imageURLMAX;
@synthesize city;
-(void)dealloc
{
    [city release];
   [visible release];
    [type release];
   [remark release];
   [status release];
    [name release];             //商家名称
   [longitude release];             //商家所在位置的经度
   [latitude release];         //商家所在位置的纬度
   [introduction release];            //商家简介
    [imageURL release];           //商家图片
     [address release];          //商家的详细地址
    [ids release];               //商家的ID
     [discount release];               //折扣
    [createTime release];            //有效期
     [changed release];
    [mid release];
//    [isRead release];
    [stars release];
    [imageURLMAX release];
    [super dealloc];
}

- (void)setValue:(id)aValue forKey:(NSString *)aKey
{
    if ([aKey isEqualToString:@"id"])
    {
        self.mid = aValue;
    }
        else
    {
        [super setValue:aValue forKey:aKey];
    }
}
@end
