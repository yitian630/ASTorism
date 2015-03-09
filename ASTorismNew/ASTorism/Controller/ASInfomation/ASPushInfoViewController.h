//
//  ASPushInfoViewController.h
//  ASTorism
//
//  Created by apple  on 13-9-20.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
@interface ASPushInfoViewController : UIViewController<NavigationBarDelegate>

@property(nonatomic,retain)NSString *pushInfoStr;
@property(nonatomic,retain)NSString *time;
@property(nonatomic,retain)NSString *imageUrl;
@end
