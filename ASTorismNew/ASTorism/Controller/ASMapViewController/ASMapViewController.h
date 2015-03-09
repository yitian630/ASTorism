//
//  ASMapViewController.h
//  ASBestLife
//
//  Created by Jerome峻峰 on 13-6-26.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "NavigationBar.h"
@interface ASMapViewController : UIViewController<NavigationBarDelegate>
{
    UISegmentedControl *segements;
    
    //mapView
//    BMKMapView *_mapView;
    BMKSearch  *_search;
    
    //route start point and end point
//    BMKPointAnnotation     *_startPoint;
//    BMKPointAnnotation     *_endPoint;
    NavigationBar *navBar;
    int buttonTag;//用来记录当前segements选中的button
     
    
    //自定义导航按钮
    UIButton *ziJiaBtu;//自驾车按钮
    UIButton *gongJiaoBtu;//公交车按钮
    UIButton *buXingBtu;//步行按钮
}

@property (nonatomic, retain) IBOutlet BMKMapView *mapView;

@property (nonatomic, retain) BMKPointAnnotation  *startPoint;
@property (nonatomic, retain) BMKPointAnnotation  *endPoint;
@property (nonatomic, retain) NSString      *city;

//tian
@property (nonatomic,retain) NSString *business;


- (void)segementSeleted:(id)sender;
@end
