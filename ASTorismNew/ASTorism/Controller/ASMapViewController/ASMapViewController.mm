//
//  ASMapViewController.m
//  ASBestLife
//
//  Created by Jerome峻峰 on 13-6-26.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASMapViewController.h"
#import "ASGlobal.h"
#import "UIDevice+Resolutions.h"
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


//路线节点
@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
	int _degree;
    
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

//路线节点图片旋转操作
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end



@interface ASMapViewController ()<BMKMapViewDelegate,BMKSearchDelegate,UIActionSheetDelegate>



//路线相关
- (NSString*)getMyBundlePath1:(NSString *)filename;
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation;

//路线搜索页面布局与设置
//- (void)segementSeleted:(id)sender;
//- (void)routeButtomItemClicked;



//路线查找
-(BOOL)startGetRoute:(int)btuTag;
-(void)onClickBusSearch;
-(void)onClickDriveSearch;
-(void)onClickWalkSearch;

@end

static BOOL isFistRoute = NO;




@implementation ASMapViewController


@synthesize mapView = _mapView;
@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize business=_business;
@synthesize city=_city;

/*
 *setNavBar
 *无参数
 *设置navigationBar
 *无返回
 */
-(void)setNavBar{
    //设置导航栏背景
    self.navigationController.navigationBarHidden=YES;
    /*
     自定义NavgationBar
     */
    if (nil==navBar) {
        navBar=[ [[NSBundle mainBundle]loadNibNamed:@"NavigationBar" owner:nil options:nil]objectAtIndex:0];
    }
    navBar.Delegate=self;
    navBar.backgroundColor=[UIColor redColor];
    navBar.searchButton.hidden=YES;
    navBar.cityButton.hidden=YES;
    navBar.searchImage.hidden=YES;
    navBar.cityImage.hidden=YES;
    navBar.titleLabel.hidden=YES;
    
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
        //初始化自驾车
        ziJiaBtu=[[UIButton alloc]initWithFrame:CGRectMake(93, 6, 44, 33)];
        //初始化公交车
        gongJiaoBtu=[[UIButton alloc]initWithFrame:CGRectMake(137, 6, 44, 33)];
        //初始化步行
        buXingBtu=[[UIButton alloc]initWithFrame:CGRectMake(181, 6, 44, 33)];
    }else {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
        //初始化自驾车
        ziJiaBtu=[[UIButton alloc]initWithFrame:CGRectMake(93, 26, 44, 33)];
        //初始化公交车
        gongJiaoBtu=[[UIButton alloc]initWithFrame:CGRectMake(137, 26, 44, 33)];
        //初始化步行
        buXingBtu=[[UIButton alloc]initWithFrame:CGRectMake(181, 26, 44, 33)];
    }
    
    
     //初始化自驾车
    ziJiaBtu.tag=0;
    //    [ziJiaBtu setBackgroundColor:[UIColor clearColor]];
    [ziJiaBtu setImage:[UIImage imageNamed:@"xuanzhongzijia.png"] forState:UIControlStateNormal];
    [ziJiaBtu addTarget:self action:@selector(segementSeleted:) forControlEvents:UIControlEventTouchUpInside];
    ziJiaBtu.highlighted=NO;
    [ziJiaBtu setImage:[UIImage imageNamed:@"zijia.png"] forState:UIControlStateHighlighted];
    [navBar addSubview:ziJiaBtu];
    
    //初始化公交车
    gongJiaoBtu.tag=1;
    //    [gongJiaoBtu setBackgroundColor:[UIColor clearColor]];
    [gongJiaoBtu setImage:[UIImage imageNamed:@"gongjiao.png"] forState:UIControlStateNormal];
    [gongJiaoBtu addTarget:self action:@selector(segementSeleted:) forControlEvents:UIControlEventTouchUpInside];
    gongJiaoBtu.highlighted=NO;
    [gongJiaoBtu setImage:[UIImage imageNamed:@"gongjiao.png"] forState:UIControlStateHighlighted];
    [navBar addSubview:gongJiaoBtu];
    
    //初始化步行
    
    buXingBtu.tag=2;
    //    [buXingBtu setBackgroundColor:[UIColor clearColor]];
    [buXingBtu setImage:[UIImage imageNamed:@"buxing.png"] forState:UIControlStateNormal];
    [buXingBtu addTarget:self action:@selector(segementSeleted:) forControlEvents:UIControlEventTouchUpInside];
    buXingBtu.highlighted=NO;
    [buXingBtu setImage:[UIImage imageNamed:@"buxing.png"] forState:UIControlStateHighlighted];
    [navBar addSubview:buXingBtu];
    

    
    
    [self.view addSubview:navBar];
}
#pragma NavigationBarDelegate
-(void)NavBarBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)NavCityButtonClick{
}
-(void)NavSearchButtonClick{
}
#pragma Adaptation 适配
-(void)Adaptation{

    if ([UIDevice systemMajorVersion] < 7.0) {
        NSLog(@"iphone4");
        
        self.mapView.frame = CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-64);
    }else{
        NSLog(@"iphone5");
       
        self.mapView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    }

    
}


#pragma mark - life circle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBar];
    [self Adaptation];
    
    
    // Do any additional setup after loading the view from its nib.
    
    
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 13;
    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = YES;
    
    
    
    self.startPoint = nil;
//    self.endPoint = [[BMKPointAnnotation alloc] init];
    
    _search = [[BMKSearch alloc]init];
//    [_mapView setShowsUserLocation:YES];
    
    

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [ASGlobal hiddenBottomMenuView];//隐藏tabbar
    
    buttonTag=0;
    
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self setNavBar];
    [self Adaptation];
    //判断是否开启定位功能
    
    if ([CLLocationManager locationServicesEnabled]){
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            //已开启定位功能
            [_mapView setShowsUserLocation:YES];
        }else
        {
            //本软件未开启定位功能
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有开启“慧游天下”的定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
    }else{
        //系统未开始定位
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有开启定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    [self setNavBar];
    [self Adaptation];
    
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 不用时，置nil
    isFistRoute = NO;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setNavBar];
    [self Adaptation];
    //添加标注
       [_mapView addAnnotation:_endPoint];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.mapView = nil;
    self.startPoint = nil;
    self.endPoint = nil;
}

-(void)dealloc
{
    
    //标注
    
 
    
    //百度map API
    [_mapView release];
    [_search release];
    if (_startPoint) {
        [_startPoint release];
    }
    [_endPoint release];
    [_business release];
    [_city release];
    [super dealloc];
}



/**
 *segement 选择事件处理
 */
- (void)segementSeleted:(id)sender
{
    UIButton *button=(UIButton *)sender;
    
    buttonTag=button.tag;
    
    [ziJiaBtu setImage:[UIImage imageNamed:@"zijia.png"] forState:UIControlStateNormal];
    [gongJiaoBtu setImage:[UIImage imageNamed:@"gongjiao.png"] forState:UIControlStateNormal];
    [buXingBtu setImage:[UIImage imageNamed:@"buxing.png"] forState:UIControlStateNormal];
    switch (button.tag) {
            
        case 0:
            
            [ziJiaBtu setImage:[UIImage imageNamed:@"xuanzhongzijia.png"] forState:UIControlStateNormal];
            [self onClickDriveSearch];
            break;
        case 1:
            [gongJiaoBtu setImage:[UIImage imageNamed:@"xuanzhonggognjiao.png"] forState:UIControlStateNormal];
            [self onClickBusSearch];
            break;
        case 2:
            
            [buXingBtu setImage:[UIImage imageNamed:@"xuanzhongbuxing.png"] forState:UIControlStateNormal];
            [self onClickWalkSearch];
            break;
        default:
            break;
    }
}

///**
// *进行路线搜索
// */
//- (void)routeButtomItemClicked
//{
//    if ([self startGetRoute]) {
////        [editView removeFromSuperview];
//    }
//}




#pragma mark search route
/**
 *开始路线搜索
 */
-(BOOL)startGetRoute:(int)btuTag
{
    switch (btuTag) {
        case 0:
            [self onClickDriveSearch];
            return YES;
            break;
        case 1:
            [self onClickBusSearch];
            return YES;
            break;
        case 2:
            [self onClickWalkSearch];
            return YES;
            break;
            
        default:
            break;
    }
    return NO;
}

/**
 *公交路线搜索
 */
-(void)onClickBusSearch
{
    
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"我的位置";
    start.pt = _startPoint.coordinate;
    
    if (start.pt.latitude==0.0&&start.pt.longitude==0.0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有获取当前位置，请检查网络(GPS不支持室内导航),并重新导航！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        end.name = _business;
        end.pt = _endPoint.coordinate;
        
        
        NSRange ran = [_city rangeOfString:@"市"];
        NSString *keyCity;
        if (ran.length > 0) {
            keyCity = [_city substringToIndex:ran.location];
        }else{
            keyCity = _city;
        }
        BOOL flag = [_search transitSearch:keyCity startNode:start endNode:end];
        if (!flag) {
            [self searchFailedAlert];
            NSLog(@"search failed");
            //        [self onClickBusSearch];
        }
        [end release];

    }
       [start release];
    
}

/**
 *驾车路线搜索
 */
-(void)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"我的位置";
    start.pt = _startPoint.coordinate;
    
    if (start.pt.latitude==0.0&&start.pt.longitude==0.0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有获取当前位置，请检查网络(GPS不支持室内导航),并重新导航！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        end.name = _business;
        end.pt = _endPoint.coordinate;
        
        
        NSRange ran = [_city rangeOfString:@"市"];
        NSString *keyCity;
        if (ran.length > 0) {
            keyCity = [_city substringToIndex:ran.location];
        }else{
            keyCity = _city;
        }
        BOOL flag = [_search drivingSearch:keyCity startNode:start endCity:keyCity endNode:end];
        if (!flag) {
            [self searchFailedAlert];
            NSLog(@"search failed");
        }else{
//            if (start.pt.latitude==0.0&&start.pt.longitude==0.0) {
//                //如果定位坐标为  0  0  则重新导航
//                [self onClickDriveSearch1];
//            }
        }
        [end release];
    }
    
    
    [start release];
}
//-(void)onClickDriveSearch1
//{
//    BMKPlanNode* start1 = [[BMKPlanNode alloc]init];
//    start1.name = @"我的位置";
//    start1.pt = _startPoint.coordinate;
//    
//    BMKPlanNode* end1 = [[BMKPlanNode alloc]init];
//    end1.name = business;
//    end1.pt = _endPoint.coordinate;
//    
//    
//    NSRange ran1 = [_city rangeOfString:@"市"];
//    NSString *keyCity1;
//    if (ran1.length > 0) {
//        keyCity1 = [_city substringToIndex:ran1.location];
//    }else{
//        keyCity1 = _city;
//    }
//    BOOL flag = [_search drivingSearch:keyCity1 startNode:start1 endCity:keyCity1 endNode:end1];
//    if (!flag) {
//        [self searchFailedAlert];
//        NSLog(@"search failed");
//    }
//    [end1 release];
//    [start1 release];
//}
/**
 *步行路线搜索
 */
-(void)onClickWalkSearch
{
    
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"我的位置";
    start.pt = _startPoint.coordinate;
    if (start.pt.latitude==0.0&&start.pt.longitude==0.0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有获取当前位置，请检查网络(GPS不支持室内导航),并重新导航！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        end.name = _business;
        end.pt = _endPoint.coordinate;
        
        NSRange ran = [_city rangeOfString:@"市"];
        NSString *keyCity;
        if (ran.length > 0) {
            keyCity = [_city substringToIndex:ran.location];
        }else{
            keyCity = _city;
        }
        BOOL flag = [_search walkingSearch:keyCity startNode:start endCity:keyCity endNode:end];
        if (!flag) {
            [self searchFailedAlert];
            NSLog(@"search failed");
            //        [self onClickWalkSearch];
        }
        [end release];
    }
    [start release];
}

#pragma mark - prepare for map route
/**
 *getMyBundlePath
 *@param filename Bundle名称
 */
- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        //		NSLog ( @"%@" ,s);
		return s;
	}
	return nil ;
}

/**
 *getMyBundlePath
 *@param mapview 地图视图
 *@param routeAnnotation 路线节点标注
 */
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
               
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
               
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
               
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
              			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
	}
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"] autorelease];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
        newAnnotation.draggable = NO;
		newAnnotation.animatesDrop = YES;
		
		return newAnnotation;
	}
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

//在地图View将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locating");
}

//在地图View停止定位后，会调用此函数
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"Stop locating");
    
    self.startPoint = nil;
}

//定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError:error:%d", [error code]);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败,请检查网络！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];

    self.startPoint = nil;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (nil!=userLocation  ) {
        if (!_startPoint) {
            self.startPoint = [[BMKPointAnnotation alloc]init];
        }
        if ((-180.0==userLocation.coordinate.longitude)&&(-180.0==userLocation.coordinate.latitude)) {
            
        }else{
            _startPoint.coordinate = userLocation.coordinate;

            if (!isFistRoute) {
                isFistRoute = YES;
                [self startGetRoute:buttonTag];
            }

        }
        
	}
	
}

#pragma mark - BMKSearchDelegate
- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    if (error == BMKErrorOk) {
        
		BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:0];
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.startPt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item]; // 添加起点标注
		[item release];
        
		RouteAnnotation* item1 = [[RouteAnnotation alloc]init];
		item1.coordinate = plan.endPt;
		item1.type = 1;
		item1.title = @"终点";
		[_mapView addAnnotation:item1]; // 终点标注
		[item1 release];
		
        // 计算路线方案中的点数
		int size = [plan.lines count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			planPointCounts += line.pointsCount;
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					planPointCounts += len;
				}
				break;
			}
		}
		
        // 构造方案中点的数组，用户构建BMKPolyline
		BMKMapPoint* points = new BMKMapPoint[planPointCounts];
		planPointCounts = 0;
		
        // 查询队列中的元素，构建points数组，并添加公交标注
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			memcpy(points + planPointCounts, line.points, line.pointsCount * sizeof(BMKMapPoint));
			planPointCounts += line.pointsCount;
			
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOnStopPoiInfo.pt;
			item.title = line.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			
			[_mapView addAnnotation:item]; // 上车标注
			[item release];
			route = [plan.routes objectAtIndex:i+1];
			RouteAnnotation* item1 = [[RouteAnnotation alloc]init];
			item1.coordinate = line.getOffStopPoiInfo.pt;
			item1.title = route.tip;
			if (line.type == 0) {
				item1.type = 2;
			} else {
				item1.type = 3;
			}
			[_mapView addAnnotation:item1]; // 下车标注
			[item1 release];
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
					memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
					planPointCounts += len;
				}
				break;
			}
		}
        
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []points;
	}else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"公交路线不能到达目的地！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag=-1;
        [alert show];
        [alert release];
    }
}


- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
   	if (error == BMKErrorOk) {
        
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
		
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
        NSLog(@"%f",result.startNode.pt.longitude);
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
		[item release];
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
			RouteAnnotation*	itemitem = [[RouteAnnotation alloc]init];
				itemitem.coordinate = step.pt;
				itemitem.title = step.content;
				itemitem.degree = step.degree * 30;
				itemitem.type = 4;
				[_mapView addAnnotation:itemitem];
				[itemitem release];
			}
			
		}
		
		RouteAnnotation* item1 = [[RouteAnnotation alloc]init];
		item1.coordinate = result.endNode.pt;
		item1.type = 1;
		item1.title = @"终点";
		[_mapView addAnnotation:item1];
		[item1 release];
        NSLog(@"%2f",points[0].x);
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}else{
        
    }
	
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == BMKErrorOk) {
        
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
        
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
		[item release];
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				RouteAnnotation *itemitem = [[RouteAnnotation alloc]init];
				itemitem.coordinate = step.pt;
				itemitem.title = step.content;
				itemitem.degree = step.degree * 30;
				itemitem.type = 4;
				[_mapView addAnnotation:itemitem];
				[itemitem release];
			}
			
		}
		
		RouteAnnotation* item1 = [[RouteAnnotation alloc]init];
		item1.coordinate = result.endNode.pt;
		item1.type = 1;
		item1.title = @"终点";
		[_mapView addAnnotation:item1];
		[item1 release];
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
}


- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
}
//搜索路线失败提示
-(void)searchFailedAlert{
    if (isFistRoute) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"获取路线数据失败，请重新导航！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag=100;
        [alert show];
        [alert release];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            switch (buttonTag) {
                case 0:
                    //NSLog(@"1");
                    [self onClickDriveSearch];
                    break;
                case 1:
                    //NSLog(@"0");
                    [self onClickBusSearch];
                    break;
                case 2:
                    //NSLog(@"2");
                    [self onClickWalkSearch];
                    break;
                default:
                    break;
            }
        }
    }
    
}


@end