//
//  ASSetViewController.h
//  ASTourism
//
//  Created by apple  on 13-8-13.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"

@class AppDelegate;
@interface ASSetViewController : UIViewController<NavigationBarDelegate>
{
    AppDelegate *_appDelegate;
}

@end
