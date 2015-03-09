//
//  AOTabbarView.h
//  testCustomTabbar
//
//  Created by akria.king on 13-4-12.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TABBARWIDTH 320
#import "ASRecommandViewController.h"
#import "ASNearViewController.h"
#import "ASInfomationViewController.h"
#import "ASSetViewController.h"
@protocol AOTabDelegate <NSObject>

-(void)switchButton:(int)btnTag;

@end

@interface AOTabbarView : UIView
{
    ASRecommandViewController *recommandVC;
    ASNearViewController *nearVC;
    ASInfomationViewController *infoVC;
    ASSetViewController *setVC;
}
//委托
@property(nonatomic,retain)id<AOTabDelegate> aoDelegate;
//选中图片
@property(nonatomic,retain)UIImageView *selectedImage;
//初始化视图
-(id)initWithIconNumber:(int)number  messArr:(NSString *)messStr;
//切换按钮点击事件
-(void)switchButton:(id)sender;
@end
