//
//  ASSelectCityViewController.h
//  ASBestLife
//
//  Created by Jill on 13-7-12.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "BMapKit.h"

@interface ASSelectCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NavigationBarDelegate, BMKMapViewDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) IBOutlet UITableView *cityTableView;

//用户是第一次使用
@property (nonatomic) BOOL isFirstTimeIn;
@property (nonatomic, retain) UIViewController *nextViewController;
@property(nonatomic,retain) NSString *cityId;//存放城市id
@property(nonatomic,retain) NSString *city;//存放最终选择的城市名字
@property(nonatomic,retain)NSMutableArray *cityArray;//存放城市数组

@end
