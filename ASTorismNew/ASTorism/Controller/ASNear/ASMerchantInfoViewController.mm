//
//  ASMerchantInfoViewController.m
//  modelView
//
//  Created by Jerome峻峰 on 13-6-24.
//  Copyright (c) 2013年 Junfeng. All rights reserved.
//

#import "ASMerchantInfoViewController.h"

#import "ASRatingView.h"
#import "ASMapViewController.h"
#import "ASActivityIndcatorView.h"
#import "ASGlobal.h"
#import "ASAlert.h"
#import "UIDevice+Resolutions.h"
//#import "UrlImageView.h"
#import "UIImageView+AFNetworking.h"
@interface ASMerchantInfoViewController ()<BMKMapViewDelegate>
{
    NavigationBar *navBar;
    BOOL isBack;
    IBOutlet UIButton *UnfoldButton;//展开商家信息
    IBOutlet UIImageView *foldImage;//遮盖ImageView
    IBOutlet UIView *foldView;//遮盖view
    BOOL isFold;//判断信息是否已经展开
    IBOutlet UIView *TELlineView;
    IBOutlet UIButton *mapBtu;//map上面的button
}
@property (nonatomic,retain) BMKPointAnnotation* merchantAnnotation;
@property (nonatomic,retain) NSMutableArray *discountArray;
//下拉刷新
//@property(nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
//进入页面时的加载提示
@property (nonatomic,retain) ASActivityIndcatorView *indcatorView;


//life circle
- (void)setupAllObjectNil;


//计算布局
- (void)setTheRequestValues;

//layout the scrollview
- (void)layoutTheEmptyWholeView;
- (void)layoutTheWholeView;
//设置红火指数
- (void)layoutTopOfTheScrollViewWithDiscount: (CGFloat)rate;
//设置优惠政策View
- (void)layoutPreferentialView:(NSString *)preferencetialStr;
//设置地址View
- (void)layoutPositionViewForAddress:(NSString *)addStr andPhone:(NSString *)phoneStr  andButtonTitle:(NSString *)btnTitle;
//设置介绍view
- (void)layoutMerchantInfoView:(NSString *)infoString;


@end

@implementation ASMerchantInfoViewController

@synthesize merchantDetail=_merchantDetail;

@synthesize merchantAnnotation=_merchantAnnotation;
@synthesize indcatorView=_indcatorView;

@synthesize scrollView = _scrollView;

@synthesize discountArray;

//top of the scrollview
@synthesize merchantLogo = _merchantLogo;
@synthesize ratingView = _ratingView;
//view of position
@synthesize positionView = _positionView;
@synthesize mapView = _mapView;
@synthesize addressLabel = _addressLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize mapNavButton = _mapNavButton;
@synthesize staticAddressLabel= _staticAddressLabel;


//view of merchant info
@synthesize infoView = _infoView;
@synthesize infoLabel = _infoLabel;


@synthesize isBack;
@synthesize phoneButton=_phonelButton;

//view  for preferential
@synthesize preferentialInfoLabel=_preferentialInfoLabel;
@synthesize preferentialView=_preferentialView;
@synthesize preferentialTitleLabel=_preferentialTitleLabel;

@synthesize isInfoPush=_isInfoPush;
@synthesize businessId=_businessId;
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
    navBar.titleLabel.font=[UIFont boldSystemFontOfSize:19];
    navBar.Delegate=self;
    navBar.backgroundColor=[UIColor redColor];
    navBar.searchButton.hidden=YES;
    navBar.cityButton.hidden=YES;
    navBar.searchImage.hidden=YES;
    navBar.cityImage.hidden=YES;
    //适配navBar
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }else
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
   
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
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect rect=screen.bounds;
    if ([UIDevice isRunningOniPhone5]) {
        NSLog(@"iphone5");
        rect=CGRectMake(0,44, rect.size.width, rect.size.height-44 );
    }else{
        NSLog(@"iphone4");
        rect=CGRectMake(0,44, rect.size.width, rect.size.height-44 );
    }
    _scrollView.frame=rect;
    
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
    // Do any additional setup after loading the view from its nib.
    isBack=NO;//初始化isBack
    mapBtu=[[UIButton alloc]init];//初始化地图上面的BUTTON
    
    
    
    //初始设置ASRatingView
    [_ratingView setImagesDeselected:@"star0.png" partlySelected:@"star1.png" fullSelected:@"star2.png" andDelegate:nil];
    [_ratingView userInteractionEnabled:NO];
    
    _mapView.mapType = BMKMapTypeStandard;//设置百度地图显示形式（普通、卫星……）
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [ASGlobal hiddenBottomMenuView];//隐藏tabbar
    [_mapView viewWillAppear];
    //设置导航栏并适配
    [self setNavBar];
    [self Adaptation];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    //设置mapview属性
    _mapView.zoomLevel = 13;
    //    _merchantLogo.image = nil;
    [super viewWillAppear:YES];
    [_mapView addAnnotation:_merchantAnnotation];
    

    if (!isBack) {
        [self layoutTheEmptyWholeView];
        if (!_isInfoPush) {
            //按数据布局
            navBar.titleLabel.text=_merchantDetail.name;
            [self setTheRequestValues];
        }else{
            [self requestBusinessInfo:_businessId];
        }

    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
//    [self layoutTheEmptyWholeView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
//    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//	[_mapView removeAnnotations:array];
//	array = [NSArray arrayWithArray:_mapView.overlays];
//	[_mapView removeOverlays:array];
}

- (void)viewDidUnload
{
//    [self setupAllObjectNil];
//    [self setStaticAddressLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //    [self setupAllObjectNil];
}

-(void)dealloc
{
    [UnfoldButton release];
    [_merchantDetail release];
    [_merchantAnnotation release];
    [_indcatorView release];
    [_scrollView release];
    [foldImage release];
    [_businessId release];
    
    //top of the scrollview
    [_merchantLogo release];
    [_ratingView release];
    //view of position
    [_positionView release];
    [_mapView release];
    [_phoneTitle release];
    [_staticAddressLabel release];
    [_addressLabel release];
    [_phoneLabel release];
    [_mapNavButton release];
    [mapBtu release];
    
    
    //view of merchant info
    [_infoView release];
    [_infoLabel release];
    
    [_phonelButton release];
    
    [discountArray release];
    
    [TELlineView release];
    //view  for preferential
    [_preferentialView release];
    [_preferentialTitleLabel release];
    [_preferentialInfoLabel release];
    [super dealloc];
}

- (void)setupAllObjectNil
{
    mapBtu=nil;
    self.merchantDetail = nil;
    UnfoldButton=nil;
    self.merchantAnnotation = nil;
    _indcatorView = nil;
    self.scrollView = nil;
    foldImage =nil;
    //top of the scrollview
    self.merchantLogo = nil;
    self.ratingView = nil;
    
    //view of position
    self.positionView = nil;
    self.mapView = nil;
    self.phoneTitle = nil;
    self.addressLabel = nil;
    self.phoneLabel = nil;
    self.mapNavButton = nil;
    
    
    //view of merchant info
    self.infoView = nil;
    self.infoLabel = nil;
    self.phoneButton = nil;
    //view  for preferential
    self.preferentialView=nil;
    self.preferentialTitleLabel=nil;
    self.preferentialInfoLabel=nil;
}


#pragma mark - Request
/*
 连接服务器之后的提示
 */
///*
// alert提示
// */
//-(void)showAlert:(NSString *)message{
//    ASAlert *alert=[[ASAlert alloc]init:nil SUBTITLE:message];
//    [alert showAlert:1.5];
//    [alert release];
//}




- (void)setTheRequestValues
{
    if (_merchantDetail) {
        navBar.titleLabel.text=_merchantDetail.name;
        //计算布局位置
        [self layoutTheWholeView];
        //添加logo
//
//        [_merchantLogo setImage:[request getImageFromUrl:[NSString stringWithFormat:@"%@%@",IMAGEURL,_merchantDetail.imageURL] placeholderImage:[UIImage imageNamed:@"xiangqingjizaitupian.png"] ]];
        
        if (nil!=_merchantDetail.imageURL&&_merchantDetail.imageURL.length>0) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _merchantLogo.frame.size.width,_merchantLogo.frame.size.height)];
            imageView.backgroundColor=[UIColor clearColor];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView setImageWithURL:[NSURL URLWithString:_merchantDetail.imageURL]placeholderImage:nil];
            [_merchantLogo addSubview:imageView];
            [imageView release];
        }
        
        
        
        //添加标注
        if (_merchantAnnotation) {
            [_mapView removeAnnotation:_merchantAnnotation];
        }
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        self.merchantAnnotation = pointAnnotation;
        [pointAnnotation release];
        
        CLLocationCoordinate2D coor;
//         if (nil!=_merchantDetail.latitude&&nil!=_merchantDetail.longitude) {
        
        if (self.merchantDetail.latitude!=nil&&self.merchantDetail.latitude.length>0&&self.merchantDetail.longitude!=nil&&self.merchantDetail.longitude.length>0) {
             _mapView.hidden=NO;
             _mapNavButton.hidden=NO;
            mapBtu.hidden=NO;
            coor.latitude = [_merchantDetail.latitude doubleValue];
            coor.longitude = [_merchantDetail.longitude doubleValue ];
            NSLog(@"coor is %f and %f", coor.latitude, coor.longitude);
             [_mapView setCenterCoordinate:coor animated:YES];
            NSLog(@"asdfasf");
             self.merchantAnnotation.coordinate = coor;
             self.merchantAnnotation.title = self.merchantDetail.name;
             //        merchantAnnotation.subtitle = @"此Annotation可拖拽!";
             [_mapView addAnnotation:_merchantAnnotation];

//            NSLog(@"1");
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有获得该商家的位置信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag=1;
            [alert show];
            [alert release];
            mapBtu.hidden=YES;
            _mapView.hidden=YES;
            _mapNavButton.hidden=YES;
//            coor.latitude = 38.040989;
//            coor.longitude = 114.506149;
//            NSLog(@"2");
        }
    }else{
        
    }
}

#pragma mark - layout

/**
 *scrollView 布局
 */
- (void)layoutTheEmptyWholeView
{
    [_merchantLogo setImage:[UIImage imageNamed:@"xiangqingjizaitupian.png"]];
    //top of the scrollview
    [self layoutTopOfTheScrollViewWithDiscount :0];
    //设置优惠view 为空
    NSString* preferentialInfo=@"";
    
    [self layoutPreferentialView:preferentialInfo];
    
    
    //view of position
    NSString *addStr = @"";
    NSString *phoneStr = @"";
    NSString *btnTitle = @"带我到";
    [self layoutPositionViewForAddress:addStr andPhone:phoneStr andButtonTitle:btnTitle];
    
    //view of merchant info
    
    [self layoutMerchantInfoView:@""];
    
}

/**
 *scrollView 布局
 */
- (void)layoutTheWholeView
{
    //top of the scrollview
    
    //红火指数  用来控制星级评价
    [self layoutTopOfTheScrollViewWithDiscount:[_merchantDetail.stars floatValue]];
    //设置优惠View
    [self layoutPreferentialView:_merchantDetail.discount];
    
    
    //view of position
    NSString *addStr = _merchantDetail.address;
    NSString *phoneStr = _merchantDetail.tel;
    NSString *btnTitle = nil;
//    if (_merchantDetail.name) {
        btnTitle = [NSString stringWithFormat:@"带我到%@",_merchantDetail.name];
    [self layoutPositionViewForAddress:addStr andPhone:phoneStr  andButtonTitle:btnTitle];
    
    
    //    //view of merchant info
    
    [self layoutMerchantInfoView:_merchantDetail.introduction];
    //    //scrollview 滚动区域设置
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _infoView.frame.origin.y + _infoView.frame.size.height + 70);
//    }
}

/**
 *layoutTopOfTheScrollView
 */
- (void)layoutTopOfTheScrollViewWithDiscount:(CGFloat)rate
{
    [_ratingView displayRating:rate];
}
//==================================
//设置优惠View
- (void)layoutPreferentialView:(NSString *)preferencetialStr{
    
    float y=_preferentialView.frame.origin.y;
    float height=_preferentialView.frame.size.height;
    
    
    
    
//    //测试
//    NSString *discountStr=nil;
//    if (nil!=preferencetialStr&&preferencetialStr.length>0) {
//        NSArray *arr=[preferencetialStr componentsSeparatedByString:@"_"];
//        NSString *yuanjia=[arr objectAtIndex:1];
//        NSString *youhui=[arr objectAtIndex:0];
//        //测试===============
//        discountStr=[NSString stringWithFormat:@"原价%@元，持京津冀旅游一卡通享%@元优惠价（每张卡本优惠限使一次）",yuanjia,youhui];
//    }else{
//    
//    }
//    NSLog(@"%@",discountStr);
    //计算字体所需size
    CGSize preferentialInfoSize = [preferencetialStr sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(_infoLabel.frame.size.width, 500.0f) lineBreakMode:NSLineBreakByWordWrapping];
    if (preferentialInfoSize.height != 0)
    {
        _preferentialInfoLabel.frame = CGRectMake(_preferentialInfoLabel.frame.origin.x, 55, _preferentialInfoLabel.frame.size.width, preferentialInfoSize.height+5);
        int lineNum=ceilf(preferentialInfoSize.height/16);
        _preferentialInfoLabel.numberOfLines = lineNum;
        _preferentialTitleLabel.frame=CGRectMake(_preferentialTitleLabel.frame.origin.x, _preferentialTitleLabel.frame.origin.y, _preferentialTitleLabel.frame.size.width, 21);
        _preferentialInfoLabel.text =preferencetialStr ;
        _preferentialInfoLabel.hidden = NO;
        _preferentialTitleLabel.hidden = NO;
        height=_preferentialInfoLabel.frame.origin.y+preferentialInfoSize.height+5;
        
    }else
    {
        //无内容时
        height=50;
        //空值设高度为0
        _preferentialInfoLabel.frame = CGRectMake(_preferentialInfoLabel.frame.origin.x, 55, _preferentialInfoLabel.frame.size.width, 0);
         _preferentialTitleLabel.frame = CGRectMake(_preferentialTitleLabel.frame.origin.x, _preferentialTitleLabel.frame.origin.y, _preferentialInfoLabel.frame.size.width, 0);
        _preferentialTitleLabel.hidden = YES;
        _preferentialInfoLabel.hidden = YES;
    }
    
    _preferentialView.frame=CGRectMake(_preferentialView.frame.origin.x, y, 320, height);
    
    
}
/**
 *layoutPositionView
 */
- (void)layoutPositionViewForAddress:(NSString *)addStr andPhone:(NSString *)phoneStr  andButtonTitle:(NSString *)btnTitle
{
    float y=_preferentialView.frame.origin.y+_preferentialView.frame.size.height;
    float height=_positionView.frame.size.height;
    float yy=35;
    _positionView.frame = CGRectMake(_positionView.frame.origin.x, y, _positionView.frame.size.width, height);
    
    
    //计算字体所需size
    CGSize addSize = [addStr sizeWithFont:_addressLabel.font constrainedToSize:CGSizeMake(_addressLabel.frame.size.width, 500.0f) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize phoneSize = [phoneStr sizeWithFont:_phoneLabel.font constrainedToSize:CGSizeMake(_phoneLabel.frame.size.width, 500.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    if (addSize.height != 0)
    {
        
        _addressLabel.numberOfLines = ceilf(addSize.height/16);
        _addressLabel.text = addStr;
        _addressLabel.frame = CGRectMake(_addressLabel.frame.origin.x, yy, _addressLabel.frame.size.width, addSize.height+5);
        _staticAddressLabel.frame=CGRectMake( _staticAddressLabel.frame.origin.x,  _addressLabel.frame.origin.y, _staticAddressLabel.frame.size.width, 24);
        _addressLabel.hidden = NO;
        _staticAddressLabel.hidden = NO;
        yy+=_addressLabel.frame.size.height+5;
    }
    else
    {
        //无地址信息时
        _addressLabel.frame = CGRectMake(_addressLabel.frame.origin.x, yy, _addressLabel.frame.size.width,0);
//        _addressLabel.numberOfLines = ceilf(addSize.height/16);
        _staticAddressLabel.frame=CGRectMake( _staticAddressLabel.frame.origin.x,  _addressLabel.frame.origin.y, _staticAddressLabel.frame.size.width, 0);
        
        _addressLabel.hidden = YES;
        _staticAddressLabel.hidden = YES;
        
    }
    if (phoneSize.height != 0)
    {
        _phoneLabel.text = phoneStr;
        CGSize sizeX = [_phoneLabel.text sizeWithFont:_phoneLabel.font];
        _phoneLabel.numberOfLines = ceilf(phoneSize.height/16);
        _phoneLabel.frame = CGRectMake(_phoneLabel.frame.origin.x, yy + 5, _phoneLabel.frame.size.width, phoneSize.height+5);
        
        _phoneTitle.frame = CGRectMake(_phoneTitle.frame.origin.x, yy + 5, _phoneTitle.frame.size.width, 24);
        
        
        
        
        _phoneTitle.hidden = NO;
        _phoneLabel.hidden = NO;
        _phonelButton.hidden=NO;
        _phonelButton.frame=CGRectMake(_phonelButton.frame.origin.x, _phoneLabel.frame.origin.y-3,  _phoneLabel.frame.size.width+10, _phoneLabel.frame.size.height+7);
        TELlineView.hidden=NO;
        TELlineView.frame=CGRectMake(_phoneLabel.frame.origin.x, _phoneLabel.frame.origin.y+22, sizeX.width, 1);
        yy+=phoneSize.height+10;
    }
    else
    {
        //空值是设置为高度o
        _phoneLabel.frame = CGRectMake(_phoneLabel.frame.origin.x, yy + 3, _phoneLabel.frame.size.width, 0);
        _phoneTitle.frame = CGRectMake(_phoneTitle.frame.origin.x, yy + 3, _phoneTitle.frame.size.width, 0);
        _phonelButton.frame=CGRectMake(_phonelButton.frame.origin.x, _phoneLabel.frame.origin.y-3,  _phoneLabel.frame.size.width+10, 0);
          TELlineView.frame=CGRectMake(_phoneLabel.frame.origin.x, _phoneLabel.frame.origin.y+22, 0, 0);
        _phonelButton.hidden=YES;
        TELlineView.hidden=YES;
        _phoneTitle.hidden = YES;
        _phoneLabel.hidden = YES;
//        _phoneLabel.frame = CGRectMake(_phoneLabel.frame.origin.x, _addressLabel.frame.origin.y + _addressLabel.frame.size.height + 3, _phoneLabel.frame.size.width, _phoneLabel.frame.size.height);
//        
//        _phoneTitle.frame = CGRectMake(_phoneTitle.frame.origin.x, _addressLabel.frame.origin.y + _addressLabel.frame.size.height + 3, _phoneTitle.frame.size.width, _phoneTitle.frame.size.height);
        
    }
    if ( nil!=_merchantDetail.latitude&&![_merchantDetail.latitude isEqualToString:@""]&&nil!=_merchantDetail.longitude&&![_merchantDetail.longitude isEqualToString:@""]) {
//    if ( nil!=_merchantDetail.latitude&&nil!=_merchantDetail.longitude) {
        _mapView.hidden=NO;
        _mapNavButton.hidden=NO;
        mapBtu.hidden=NO;
        _mapView.frame=CGRectMake(_mapView.frame.origin.x, yy+15, _mapView.frame.size.width, 110);
        yy+=_mapView.frame.size.height+15;
        [_mapNavButton setTitle:btnTitle forState:UIControlStateNormal];
        _mapNavButton.frame=CGRectMake(_mapNavButton.frame.origin.x,yy+15, _mapNavButton.frame.size.width, 35);
        yy+=_mapNavButton.frame.size.height+15;
        
        mapBtu.frame=CGRectMake(15, _mapView.frame.origin.y, 291, 110);
//        mapBtu.backgroundColor=[UIColor blackColor];
        
        
    }else{
        _mapView.frame=CGRectMake(_mapView.frame.origin.x, yy+15, _mapView.frame.size.width, 0);
        mapBtu.frame=_mapView.frame;
        _mapNavButton.frame=CGRectMake(_mapNavButton.frame.origin.x,yy+15, _mapNavButton.frame.size.width, 0);
        mapBtu.hidden=YES;
        _mapView.hidden=YES;
        _mapNavButton.hidden=YES;
    }
        
     _positionView.frame = CGRectMake(_positionView.frame.origin.x, y, _positionView.frame.size.width,yy+15);
}



/**
 *layoutMerchantInfoView
 */
- (void)layoutMerchantInfoView:(NSString *)infoString
{
    float y=_positionView.frame.origin.y+_positionView.frame.size.height;
    float height=_infoView.frame.size.height;
    
    //计算字体所需size
    CGSize infoSize = [infoString sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(_infoLabel.frame.size.width, 500.0f) lineBreakMode:NSLineBreakByWordWrapping];
    if (infoSize.height != 0)
    {
        int lineNum=ceilf(infoSize.height/16);
    
        _infoLabel.numberOfLines = lineNum;
        if (lineNum>2) {
            _infoLabel.numberOfLines = 2;
            _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, 35, _infoLabel.frame.size.width, infoSize.height/lineNum*2+10);
        }else{
            _infoLabel.numberOfLines = lineNum;
            _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, 35, _infoLabel.frame.size.width, infoSize.height+10);
        }
        foldView.frame=CGRectMake(foldView.frame.origin.x, _infoLabel.frame.origin.y+infoSize.height/lineNum*2+5, foldView.frame.size.width, infoSize.height+10);
        
        if (lineNum>2) {
            
        }else{
            foldView.frame=CGRectMake(foldView.frame.origin.x, _infoLabel.frame.origin.y+_infoLabel.frame.size.height+5, foldView.frame.size.width, infoSize.height+10);
        }
        _infoLabel.text = infoString;
        _infoView.hidden = NO;
        foldImage.hidden=NO;
        UnfoldButton.hidden=NO;
    }
    else
    {
        foldImage.hidden=YES;
        UnfoldButton.hidden=YES;
        _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x,35, _infoLabel.frame.size.width,0 );
    }
    foldImage.image=[UIImage imageNamed:@"商家介绍1.png"];
    height=foldView.frame.origin.y+foldView.frame.size.height;
    _infoView.frame=CGRectMake(_infoView.frame.origin.x, y, _infoView.frame.size.width,height);
    if (infoSize.height == 0) {
        _infoView.frame=CGRectMake(_infoView.frame.origin.x, y, _infoView.frame.size.width,50);
    }
}
#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"] autorelease];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = YES;
		return newAnnotation;
	}
	return nil;
}

#pragma mark - button clicked

/**
 *显示地图导航页面
 */
- (IBAction)showMapViewNavigation
{
    
    if (self.merchantDetail.latitude!=nil&&self.merchantDetail.latitude!=nil&&self.merchantDetail.longitude.length>0 &&self.merchantDetail.longitude.length>0) {
        isBack=YES;
        ASMapViewController *mapVC = [[ASMapViewController alloc]init];
        [self.navigationController pushViewController:mapVC animated:YES];
        mapVC.business=self.merchantDetail.name;
        CLLocationCoordinate2D coor;
        coor.latitude = [self.merchantDetail.latitude floatValue];
        coor.longitude = [self.merchantDetail.longitude floatValue];
        
        
        [_mapView setCenterCoordinate:coor];
        
        BMKPointAnnotation *annotation=[[BMKPointAnnotation alloc]init];
        
        annotation.coordinate = coor;
        annotation.title = mapVC.business;
        mapVC.endPoint = annotation;
        mapVC.city=_merchantDetail.city;
        [annotation release];
        [mapVC release];

    }	
}


/**
 *拨打电话点击
 */
- (IBAction)callPhone:(id)sender
{
    //    NSRange range = [_phoneLabel.text rangeOfString:@"-"];
    //    NSString *callN =nil;
    //    if (range.location>0) {
    //       callN = [_phoneLabel.text substringToIndex:range.location];
    //    }
    
    NSString *phoneNum = [NSString stringWithFormat:@"tel://%@",_phoneLabel.text];
    NSURL *phoneUrl = [NSURL URLWithString:phoneNum];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}

//展开商家信息button点击事件安
-(IBAction)UnfoldClick:(id)sender{
    if (!isFold) {
        [self foldInfoView];
    }else{
        [self unfoldInfoView];
    }
    isFold=!isFold;
}
//展开信息并控制——infoView的大小
-(void)foldInfoView{
    float y=_positionView.frame.origin.y+_positionView.frame.size.height;
    //计算字体所需size
    CGSize infoSize = [_infoLabel.text sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(_infoLabel.frame.size.width, 500.0f) lineBreakMode:NSLineBreakByWordWrapping];
    int lineNum=ceilf(infoSize.height/16);
    _infoLabel.numberOfLines = lineNum;
    if (infoSize.height != 0)
    {
        
        _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, 35, _infoLabel.frame.size.width, infoSize.height+10);
        _infoLabel.numberOfLines = lineNum;
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        if (infoSize.height != 0)
        {
            
            foldView.frame=CGRectMake(foldView.frame.origin.x, _infoLabel.frame.origin.y+_infoLabel.frame.size.height+5, foldView.frame.size.width, infoSize.height+10);
            
            _infoView.hidden = NO;
            foldImage.hidden=NO;
            UnfoldButton.hidden=NO;
        }
        
        foldImage.image=[UIImage imageNamed:@"商家介绍2.png"];
        _infoView.frame=CGRectMake(_infoView.frame.origin.x, y, _infoView.frame.size.width,foldView.frame.origin.y+foldView.frame.size.height);
        
        
    }];
    
}
//合并信息并调整—infoView的大小
-(void)unfoldInfoView{
    float y=_positionView.frame.origin.y+_positionView.frame.size.height;
    //计算字体所需size
    CGSize infoSize = [_infoLabel.text sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(_infoLabel.frame.size.width, 500.0f) lineBreakMode:NSLineBreakByWordWrapping];
    int lineNum=ceilf(infoSize.height/16);
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        if (infoSize.height != 0)
        {
            
            if (lineNum>2) {
                foldView.frame=CGRectMake(foldView.frame.origin.x, _infoLabel.frame.origin.y+infoSize.height/lineNum*2+5, foldView.frame.size.width, infoSize.height+10);
                
            }else{
                foldView.frame=CGRectMake(foldView.frame.origin.x, _infoLabel.frame.origin.y+_infoLabel.frame.size.height+5, foldView.frame.size.width, infoSize.height+10);
                
            }
            foldImage.image=[UIImage imageNamed:@"商家介绍1.png"];
            _infoView.hidden = NO;
            foldImage.hidden=NO;
            UnfoldButton.hidden=NO;
        }
        
    } completion:^(BOOL finished){
        if (finished) {
            if (lineNum>2) {
                _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, 35, _infoLabel.frame.size.width, infoSize.height/lineNum*2+10);
            }
            _infoLabel.numberOfLines = 2;
            _infoView.frame=CGRectMake(_infoView.frame.origin.x, y, _infoView.frame.size.width,foldView.frame.origin.y+foldView.frame.size.height);
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _infoView.frame.origin.y + _infoView.frame.size.height + 70);
        }
        
    }];
}
-(void)setLabelLine{
    
}


//从网络获取商家信息
-(void)requestBusinessInfo:(NSString *)businessID{
    [self startAnimating];
    NSDictionary *parametersDic=[[NSDictionary alloc]initWithObjectsAndKeys:businessID,@"businessId",nil];
    
    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:PUSHDETAILURL]];
    
    [request setDelegate:self];
    [request setTimeOutSeconds:5];
    for (NSString *key in [parametersDic allKeys]) {
        NSString *value=[parametersDic objectForKey:key];
        [request setPostValue:value forKey:key];
    }
    //    //上传图片
    //    [requstS setData:imageData withFileName:@"s.png" andContentType:@"image/png" forKey:@"upLoad"];
    [request startAsynchronous];//异步加载
    [request release];
    [parametersDic release];
    


}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //请求商家失败   返回页面
    if (alertView.tag==0) {
        if (buttonIndex==0) {
            [self NavBarBackClick];
        }
    }
    
}

///*
// 加载动画开始
// */
-(void)startAnimating{
    //加载动画
    
    if (nil == _indcatorView)
    {
        _indcatorView = [[ASActivityIndcatorView alloc] init];
    }
    [_indcatorView showIndicator];
    //    [activityIndicatorView startAnimating];
    //    [certificateTableView addSubview: activityIndicatorView];
    //    [certificateTableView sendSubviewToBack: activityIndicatorView];
}
/*
 加载动画结束
 */
-(void)stopAnimating{
    //    [activityIndicatorView stopAnimating];
    //    [activityIndicatorView removeFromSuperview];
    [_indcatorView dimissIndicator];
    
}

//网络请求返回的方法
//-(void)ASIRequestFinished:(NSString *)requestResult{
////    NSLog(@"%@",requestResult);
//    NSDictionary *responseDict = [requestResult objectFromJSONString];
////    NSLog(@"%@",responseDict);
//    _merchantDetail=[[ASMerchantDetailInfo alloc]init];
//    NSString *ids=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"ids"]];
//    if ([ids isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
//        ids=@"";
//    }
//    _merchantDetail.ids=ids;
//    NSString *name=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"name"]];
//    if ([name isEqualToString:@"<null>"]||[name isEqualToString:@""]) {
//        name=@"";
//    }
//    _merchantDetail.name=name;
//    NSString *city=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"cityName"]];
//    if ([city isEqualToString:@"<null>"]||[city isEqualToString:@""]) {
//        city=@"";
//    }
//    _merchantDetail.city=city;
//    NSString *address=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"address"]];
//    if ([address isEqualToString:@"<null>"]||[address isEqualToString:@""]) {
//        address=@"";
//    }
//    _merchantDetail.address=address;
//    NSString *discount=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"discount"]];
//    if ([discount isEqualToString:@"<null>"]||[discount isEqualToString:@""]) {
//        discount=@"";
//    }
//    _merchantDetail.discount=discount;
//    NSString *createTime=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"createTime"]];
//    if ([createTime isEqualToString:@"<null>"]||[createTime isEqualToString:@""]) {
//        createTime=@"";
//    }
//    _merchantDetail.createTime=createTime;
//    NSString *imageURL=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"imageURL"]];
//    if ([imageURL isEqualToString:@"<null>"]||[imageURL isEqualToString:@""]) {
//        imageURL=@"";
//    }
//    _merchantDetail.imageURL=imageURL;
//    NSString *imageURLMAX=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"imageURLMAX"]];
//    if ([imageURLMAX isEqualToString:@"<null>"]||[imageURLMAX isEqualToString:@""]) {
//        imageURLMAX=@"";
//    }
//    _merchantDetail.imageURLMAX=imageURLMAX;
//    NSString *introduction=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"introduction"]];
//    if ([introduction isEqualToString:@"<null>"]||[introduction isEqualToString:@""]) {
//        introduction=@"";
//    }
//    _merchantDetail.introduction=introduction;
//    NSString *latitude=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"latitude"]];
//    if ([latitude isEqualToString:@"<null>"]||[latitude isEqualToString:@""]) {
//        latitude=@"";
//    }
//    _merchantDetail.latitude=latitude;
//    NSString *longitude=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"longitude"]];
//    if ([longitude isEqualToString:@"<null>"]||[longitude isEqualToString:@""]) {
//        longitude=@"";
//    }
//    _merchantDetail.longitude=longitude;
//    NSString *remark=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"remark"]];
//    if ([remark isEqualToString:@"<null>"]||[remark isEqualToString:@""]) {
//        remark=@"";
//    }
//    _merchantDetail.remark=remark;
//    NSString *stars=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"stars"]];
//    if ([stars isEqualToString:@"<null>"]||[stars isEqualToString:@""]) {
//        stars=@"";
//    }
//    _merchantDetail.stars=stars;
//    NSString *status=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"status"]];
//    if ([status isEqualToString:@"<null>"]||[status isEqualToString:@""]) {
//        status=@"";
//    }
//    _merchantDetail.status=status;
//    
//    NSString *tel=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"tel"]];
//    if ([tel isEqualToString:@"<null>"]||[tel isEqualToString:@""]) {
//        tel=@"";
//    }
//    _merchantDetail.tel=tel;
//    NSString *type=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"type"]];
//    if ([type isEqualToString:@"<null>"]||[type isEqualToString:@""]) {
//        type=@"";
//    }
//    _merchantDetail.type=type;
//    NSString *visible=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"visible"]];
//    if ([visible isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
//        visible=@"";
//    }
//    _merchantDetail.visible=visible;
//    
//    [self stopAnimating];
//    
//    if (![_merchantDetail.name isEqualToString:@""]&&![_merchantDetail.ids isEqualToString:@""]) {
//        //获取商家信息以后填充布局
//        [self setTheRequestValues];
//    }else{
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有商家信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//    
//   
//}
//-(void)ASIRequestFailed:(NSString *)requestResult
//{
////    NSLog(@"%@",requestResult);
//    //    NSDictionary *responseDict = [requestResult objectFromJSONString];
//    //    //        NSLog(@"responseObject = %@", responseDict);
//    [self stopAnimating];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    alert.tag=0;
//    [alert show];
//    [alert release];
//    
//}
//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *string = [request responseString];

    NSDictionary *responseDict = [string objectFromJSONString];
    
    NSLog(@"---=====responseDict:%@",responseDict);
    
    _merchantDetail=[[ASMerchantDetailInfo alloc]init];
    NSString *ids=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"id"]];
    if ([ids isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
        ids=@"";
    }
    _merchantDetail.ids=ids;
    NSString *name=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"name"]];
    if ([name isEqualToString:@"<null>"]||[name isEqualToString:@""]) {
        name=@"";
    }
    _merchantDetail.name=name;
    NSString *city=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"cityName"]];
    if ([city isEqualToString:@"<null>"]||[city isEqualToString:@""]) {
        city=@"";
    }
    _merchantDetail.city=city;
    NSString *address=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"address"]];
    if ([address isEqualToString:@"<null>"]||[address isEqualToString:@""]) {
        address=@"";
    }
    _merchantDetail.address=address;
    NSString *discount=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"ly_ykt"]];
    if ([discount isEqualToString:@"<null>"]||[discount isEqualToString:@""]) {
        discount=@"";
    }
    _merchantDetail.discount=discount;
    NSString *createTime=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"createTime"]];
    if ([createTime isEqualToString:@"<null>"]||[createTime isEqualToString:@""]) {
        createTime=@"";
    }
    _merchantDetail.createTime=createTime;
    NSString *imageURL=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"preview"]];
    if ([imageURL isEqualToString:@"<null>"]||[imageURL isEqualToString:@""]) {
        imageURL=@"";
    }
    _merchantDetail.imageURL=imageURL;
    NSString *imageURLMAX=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"preview"]];
    if ([imageURLMAX isEqualToString:@"<null>"]||[imageURLMAX isEqualToString:@""]) {
        imageURLMAX=@"";
    }
    _merchantDetail.imageURLMAX=imageURLMAX;
    NSString *introduction=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"mobile_brief"]];
    if ([introduction isEqualToString:@"<null>"]||[introduction isEqualToString:@""]) {
        introduction=@"";
    }
    _merchantDetail.introduction=introduction;
    NSString *latitude=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"latitude"]];
    if ([latitude isEqualToString:@"<null>"]||[latitude isEqualToString:@""]) {
        latitude=@"";
    }
    _merchantDetail.latitude=latitude;
    NSString *longitude=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"longitude"]];
    if ([longitude isEqualToString:@"<null>"]||[longitude isEqualToString:@""]) {
        longitude=@"";
    }
    _merchantDetail.longitude=longitude;
    NSString *remark=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"remark"]];
    if ([remark isEqualToString:@"<null>"]||[remark isEqualToString:@""]) {
        remark=@"";
    }
    _merchantDetail.remark=remark;
    NSString *stars=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"stars"]];
    if ([stars isEqualToString:@"<null>"]||[stars isEqualToString:@""]) {
        stars=@"";
    }
    _merchantDetail.stars=stars;
    NSString *status=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"status"]];
    if ([status isEqualToString:@"<null>"]||[status isEqualToString:@""]) {
        status=@"";
    }
    _merchantDetail.status=status;
    
    NSString *tel=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"tel"]];
    if ([tel isEqualToString:@"<null>"]||[tel isEqualToString:@""]) {
        tel=@"";
    }
    _merchantDetail.tel=tel;
    NSString *type=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"type"]];
    if ([type isEqualToString:@"<null>"]||[type isEqualToString:@""]) {
        type=@"";
    }
    _merchantDetail.type=type;
    NSString *visible=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"visible"]];
    if ([visible isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
        visible=@"";
    }
    _merchantDetail.visible=visible;
    
    [self stopAnimating];
    
    if (![_merchantDetail.name isEqualToString:@""]&&![_merchantDetail.ids isEqualToString:@""]) {
        //获取商家信息以后填充布局
        [self setTheRequestValues];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有商家信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSLog(@"%@",requestResult);
    //    NSDictionary *responseDict = [requestResult objectFromJSONString];
    //    //        NSLog(@"responseObject = %@", responseDict);
    [self stopAnimating];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag=0;
    [alert show];
    [alert release];
}


@end
