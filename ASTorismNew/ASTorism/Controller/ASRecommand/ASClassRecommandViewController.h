//
//  ASClassRecommandViewController.h
//  ASTorism
//
//  Created by apple  on 13-8-20.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "ASTableHeaderView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "ASCView.h"
@interface ASClassRecommandViewController : UIViewController<NavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,ASIHTTPRequestDelegate,ASCidChooseDlegate>
@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UIImageView *lineView;
@property(nonatomic,retain) IBOutlet UIButton *categoryButton;
@property(nonatomic,retain)NSString *category;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,retain)NSString *cityId;
@property(nonatomic,retain)NSString *categoryId;


@property (nonatomic,retain)NSString *distanceStr;//距离
@property (nonatomic,copy)NSString  *longitude;//精度
@property (nonatomic,copy)NSString *latitude;//纬度

@end
