//
//  ASSearchListController.h
//  ASBestLife
//
//  Created by csl on 13-7-1.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
@class ASSearchBar;
@protocol ASSearchBarDelegate;

@interface ASSearchListController : UIViewController<NavigationBarDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>

@property (nonatomic, retain) ASSearchBar          *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *searchListTable;
@property (nonatomic, retain) NSString *searchKeywordStr;
@property(nonatomic, retain) NSString *cityId;
@property(nonatomic, retain) NSString *proId;
@property(nonatomic, assign) BOOL isBack;

@end
