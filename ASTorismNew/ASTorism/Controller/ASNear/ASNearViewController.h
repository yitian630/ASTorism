//
//  ASNearViewController.h
//  ASTourism
//
//  Created by apple  on 13-8-13.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "ASCategoryChooseView.h"
#import "ASdistanceChooseView.h"
#import "ASTableHeaderView.h"
#import "BMapKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
@interface ASNearViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NavigationBarDelegate,MainCategoryChooseDelegate,DistanceChooseDelegate,EGORefreshTableHeaderDelegate,BMKMapViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>

@end
