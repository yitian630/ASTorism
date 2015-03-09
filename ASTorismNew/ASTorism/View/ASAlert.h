//
//  ASAlert.h
//  ASBestLife
//
//  Created by apple  on 13-7-18.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAlert : UIView


-(id) init:(NSString *)title SUBTITLE:(NSString *)subTitle ;
//显示弹出视图
-(void) showAlert:(float)time;
@end
