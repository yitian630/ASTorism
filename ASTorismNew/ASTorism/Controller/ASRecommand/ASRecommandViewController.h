//
//  ASRecommandViewController.h
//  ASTourism
//
//  Created by apple  on 13-8-13.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "ASCategoryInRommendCell.h"
#import "ASAdvertisingCell.h"
#import "slideView.h"
#import "ASTableHeaderView.h"
//#import "ASIHttpInitRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "BMapKit.h"

@interface ASRecommandViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NavigationBarDelegate,BMKMapViewDelegate, CategoryDelegate, slideViewDelegate, EGORefreshTableHeaderDelegate, ASIHTTPRequestDelegate>
//{
//    ASIHttpInitRequest *request;
//}
//用户是第一次使用
@property (nonatomic) BOOL isFirstTimeIn;

@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *cityId;

@end
