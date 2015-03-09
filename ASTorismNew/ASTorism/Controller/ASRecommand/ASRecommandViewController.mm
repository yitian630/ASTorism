//
//  ASRecommandViewController.m
//  ASTourism
//
//  Created by apple  on 13-8-13.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASRecommandViewController.h"
#import "NavigationBar.h"
#import "ASSearchListController.h"
#import "ASSelectCityViewController.h"
#import "UIDevice+Resolutions.h"
#import "ASMerchantInfoViewController.h"
#import "ASRecommandCell.h"
#import "ASClassRecommandViewController.h"
#import "ASGlobal.h"
#import "ASMerchantDetailInfo.h"
#import "ASActivityIndcatorView.h"
#import "ASAlert.h"
//#import "UrlImageView.h"
#import "ASIFormDataRequest.h"
#import "ASInfoListDeatail.h"
#import "ASPushInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIDevice+Resolutions.h"

@interface ASRecommandViewController ()
{
//    UIButton *cityButton;//城市选择按钮
    NavigationBar *navBar;
    
   
//    ASClassRecommandViewController *classRecommand;//分类推荐
    BOOL isRequestNow;//判断是否正在请求网络
    
    
    ASTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
   
    BOOL isCityBack;//判断是否从切换城市返回  yes为是从切换城市返回
    UILabel *moreLabel;//加载更多label
    BOOL isPullRefresh;//判断是否是下拉刷新    yes为下拉刷新
    
    //要定位的话需要用到这个view
//    BMKMapView *BDmapView;
   
}
@property (retain, nonatomic) IBOutlet BMKMapView *BDMapView;

@property(nonatomic,assign) int currentPage; //加载当前页数
@property(nonatomic,assign) int totalPage;

@property (nonatomic,retain) IBOutlet UITableView *recommandTable;//推荐table


//下拉刷新
//@property(nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
//进入页面时的加载提示
@property (nonatomic,retain) ASActivityIndcatorView *indcatorView;
@property (nonatomic,retain)NSMutableArray *recommandArray;//存放推荐数组
@property (nonatomic,retain)NSMutableArray* slideInfoArray;//存放消息滚动栏数组
@end

@implementation ASRecommandViewController
//@synthesize searchListController;
//@synthesize  selectCityController;
@synthesize isFirstTimeIn = _isFirstTimeIn;
@synthesize recommandTable;
@synthesize city=_city;
@synthesize BDMapView = _BDMapView;
@synthesize currentPage;
@synthesize totalPage;
@synthesize cityId=_cityId;
@synthesize indcatorView=_indcatorView;

@synthesize recommandArray=_recommandArray;
@synthesize slideInfoArray=_slideInfoArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isFirstTimeIn = YES;
    }
    return self;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [super dealloc];
    [_BDMapView release];

    [_cityId release];
    [recommandTable release];
    [_city release];
    [_recommandArray release];
    [_indcatorView release];
    [_refreshHeaderView release];
    [_slideInfoArray release];
    [moreLabel release];
}


#pragma mark - self methods
/*
 *-(void)setNavBar
 *无参数
 *设置navigationBar
 *无返回
 */
-(void)setNavBar{
    //设置导航栏背景
//    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;

    /*
     自定义NavgationBar
     */
    if (nil==navBar) {
        navBar=[ [[NSBundle mainBundle]loadNibNamed:@"NavigationBar" owner:nil options:nil]objectAtIndex:0];
        
    }
   navBar.titleLabel.font=[UIFont boldSystemFontOfSize:19];
    navBar.Delegate=self;
    navBar.backImage.hidden=YES;
    navBar.BackButton.hidden=YES;//隐藏返回按钮
    navBar.titleLabel.text=@"慧游天下";
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }else
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
       
    [self.view addSubview:navBar];
}
#pragma NavigationBarDelegate
-(void)NavCityButtonClick{
    isCityBack=YES;
    NSLog(@"切换城市");

    ASSelectCityViewController*   selectCityController = [[ASSelectCityViewController alloc] init];
    

    selectCityController.hidesBottomBarWhenPushed = YES;
    selectCityController.isFirstTimeIn = NO;
    [self.navigationController pushViewController:selectCityController  animated:YES];
    [selectCityController release];
}
-(void)NavBarBackClick{
}
-(void)NavSearchButtonClick{
    
      ASSearchListController*  searchListController = [[ASSearchListController alloc] init];
    searchListController.cityId=_cityId;
  
    searchListController.hidesBottomBarWhenPushed = YES;
    searchListController.isBack=NO;
    [self.navigationController pushViewController: searchListController
                                                  animated: YES];
    [searchListController release];
}

-(void)viewWillAppear:(BOOL)animated{
    [ASGlobal showAOTabbar];//显示tabbar
    //    [super viewWillAppear:YES];
    
    //设置导航栏
    //[self setNavBar];
    //适配
    
    if(YES == self.isFirstTimeIn)
    {
        //最初进入的时候要询问是否自动定位当前所在城市
        NSString *message = @"您是否要自动定位当前所在城市？";
        UIAlertView *askAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [askAlert show];
        [askAlert release];
        self.isFirstTimeIn = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self Adaptation];
//    if (isCityBack) {
//        isCityBack=NO;
//        [self reloadInfos];
//    }
    [self reloadInfos];

    [super viewDidAppear:YES];
}

-(void)reloadInfos
{
    NSDictionary *cityDic=[ASGlobal getCityFromFile];
    if (nil!=cityDic)
    {
        NSString *cStr=[cityDic objectForKey:CNAME];
        NSString *cId=[cityDic objectForKey:CID];
        
        //
        //            NSLog(@"%@",PROID);
        //            NSLog(@"%@",_proID);
        if (![_cityId isEqualToString:cId]||![_city isEqualToString:cStr])
        {
            self.city = [NSString stringWithString:cStr];
            self.cityId = [NSString stringWithString:cId];
            [navBar.cityButton setTitle:_city forState:UIControlStateNormal];
            currentPage=1;
            totalPage=-1;
            //网络请求加载数据
            [self reloadTableViewDataSource];
        }
    }
    else
    {
        self.city=[NSString stringWithFormat:@"%@",@"石家庄"];
        self.cityId=[NSString stringWithFormat:@"%@",@"20"];
        
        [ASGlobal saveCityTofile:_city CITYID:_cityId];
        [navBar.cityButton setTitle:_city forState:UIControlStateNormal];
        currentPage=1;
        totalPage=-1;
        //网络请求加载数据
        [self reloadTableViewDataSource];
    }
}

- (void)reloadCity
{
    [navBar.cityButton setTitle:self.city forState:UIControlStateNormal];
    currentPage=1;
    totalPage=-1;
    //网络请求加载数据
    [self reloadTableViewDataSource];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(nil != self.BDMapView)
    {
        [self.BDMapView viewWillDisappear];
        self.BDMapView.delegate = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ASGlobal showAOTabbar];
    moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,12,320, 20)];
    [moreLabel setFont:[UIFont systemFontOfSize:13]];
    moreLabel.tag = 1010;
    
    [moreLabel setTextAlignment:NSTextAlignmentCenter];
    
    currentPage=1;
    totalPage=-1;
    isPullRefresh=NO;
    if(_refreshHeaderView == nil)
    {
        ASTableHeaderView *view = [[ASTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - recommandTable.bounds.size.height, self.view.frame.size.width, recommandTable.bounds.size.height)];
        
        view.delegate = self;
        [recommandTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
//    isCityBack=NO;
//    //测试
//    NSDictionary *cityDic=[ASGlobal getCityFromFile];
//    if (nil!=cityDic)
//    {
//        self.city=[cityDic objectForKey:CNAME];
//        self.cityId=[cityDic objectForKey:CID];
//    }
//    else
//    {
//        self.city=[NSString stringWithFormat:@"%@",@"石家庄"];
//        self.cityId=[NSString stringWithFormat:@"%@",@"20"];
//        [ASGlobal saveCityTofile:_city CITYID:_cityId];
//    }
//    
//    [navBar.cityButton setTitle:_city forState:UIControlStateNormal];
//    //网络请求加载数据
//    [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:1.0];
    
}

#pragma mark - UIAlertViewDelegate
//用户在提示消息框上点击“确定”或者“取消”的处理结果
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //对取消结果不作处理
    if(0 == buttonIndex)
    {
        
    }
    //如果用户点击确定，则开始自动定位
    else
    {
        //启动mapView
        
        self.BDMapView.delegate = self;
        //设置完YES之后百度定位功能就已经启动了
        [self.BDMapView setShowsUserLocation:YES];
        
    }
}

#pragma mark - BMKMapViewDelegate

//百度地图的代理实现方法，用来自动定位当前的坐标，并返回当前城市

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [self startAnimating];
    CLGeocoder *Geocoder=[[CLGeocoder alloc]init];CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
        for (CLPlacemark *placemark in place) {
            //定位得到当前城市
            self.city=placemark.locality;
            //把城市名称后缀去掉“市”
            if ([self.city hasSuffix:@"市"]) {
                self.city = [self.city substringToIndex:self.city.length - 1];
            }
            
            [self getCityInfoForCity:self.city];
            [self stopAnimating];
            break;
        }
    };
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    [Geocoder reverseGeocodeLocation:loc completionHandler:handler];
    
    [self.BDMapView setShowsUserLocation:NO];
    
    
}

- (void)getCityInfoForCity:(NSString *)city
{
//    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
//    NSArray *cityArr = [NSArray arrayWithContentsOfFile:cityPath];
//    
//    for (NSDictionary *dic in cityArr) {
//        NSString *cityName = [dic objectForKey:@"name"];
//        if ([cityName isEqualToString:city]) {
//            self.city = city;
//            self.cityId = [dic valueForKey:@"id"];
//            [ASGlobal saveCityTofile:self.city CITYID:self.cityId];
//            [self reloadCity];
//            return ;
//        }
//    }
    NSString *cityPath = [[ASGlobal getFilePath] stringByAppendingPathComponent:@"city.plist"];
    NSArray *cityArr = [NSArray arrayWithContentsOfFile:cityPath];
    
    for (NSDictionary *dic in cityArr) {
        NSString *cityName = [dic objectForKey:@"name"];
        if ([cityName isEqualToString:city]) {
            self.city = city;
            self.cityId = [dic valueForKey:@"id"];
            [ASGlobal saveCityTofile:self.city CITYID:self.cityId];
            [self reloadCity];
            return ;
        }
    }
 
}

- (void)deleteMapView
{
    //[self.BDMapView release];
    self.BDMapView = nil;
}

#pragma Adaptation 适配
-(void)Adaptation{
    CGRect rect;
    [self setNavBar];
    if ([UIDevice systemMajorVersion] < 7.0) {
        NSLog(@"iphone4");
        rect=CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-44);
    }else{
        NSLog(@"iphone5");
        rect=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    }
    recommandTable.frame=rect;
}


#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    id cell=nil;
    int row=indexPath.row;
    if (row==0) {
         static NSString *identifier=@"slide";
        ASAdvertisingCell *AdvertisingCell=nil;
        AdvertisingCell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (nil==AdvertisingCell) {
            AdvertisingCell=[[[NSBundle mainBundle]loadNibNamed:@"ASAdvertisingCell" owner:nil options:nil]objectAtIndex:0] ;
            [AdvertisingCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            AdvertisingCell.contentView.backgroundColor=[UIColor whiteColor];
            
            
            //添加广告栏的图片
            NSMutableArray*    slideImages = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i=0; i<_slideInfoArray.count; i++) {
              ASInfoListDeatail *  info=  [_slideInfoArray objectAtIndex:i];

                NSString *str = [NSString stringWithFormat:@"%@%@",IMAGEURL,info.imageURL];
                
                [slideImages addObject:str];
            }
            if (slideImages.count>0) {
                slideView *view=[[slideView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
                view.slideImages=slideImages;
                [view initScrollViewAndPageController:view.frame PageControllerFrame:CGRectMake((320-10*slideImages.count)/2, view.frame.size.height-20 ,10*slideImages.count, 18)];
                [view startSlide:3];
                view.delegate=self;
                [AdvertisingCell addSubview:view];
                [view release];
                
            }
            [slideImages release];
        }
   
        return AdvertisingCell;
//    cell=AdvertisingCell;
    }else if (row==1){
         static NSString *identifierC=@"category";
        ASCategoryInRommendCell *CategoryCell=nil;
        CategoryCell=[tableView dequeueReusableCellWithIdentifier:identifierC];
        if (nil==CategoryCell) {
            CategoryCell=[[[NSBundle mainBundle]loadNibNamed:@"ASCategoryInRommendCell" owner:nil options:nil]objectAtIndex:0] ;
            [CategoryCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CategoryCell.delegate=self;
           
           [ CategoryCell.fuwuButton setBackgroundImage:[UIImage imageNamed:@"xuanzhongfuwu.png"] forState:UIControlStateSelected];
            
            CategoryCell.contentView.backgroundColor=[UIColor whiteColor];
            
        }
        return CategoryCell;
//         cell=CategoryCell;
       
    }
    else if (row==_recommandArray.count+2){
    static NSString *identifierMore=@"more";
        UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:identifierMore];
        if (nil==moreCell )
        {
            moreCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierMore] autorelease];
            if (nil==moreLabel) {
             moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,12,320, 20)];
//                [moreLabel setFrame:CGRectMake(0,12,320, 20)];
                [moreLabel setFont:[UIFont systemFontOfSize:13]];
                moreLabel.tag = 1010;
              
                [moreLabel setTextAlignment:NSTextAlignmentCenter];
                
            }
            
//             moreLabel.text=@"加载更多";
           [moreCell addSubview:moreLabel];
            [moreCell  setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return moreCell;
//        cell=moreCell;
    }else{
        static NSString *identifierRecommand=@"recomand";
        ASRecommandCell *recommandCell=nil;
        recommandCell=[tableView dequeueReusableCellWithIdentifier:identifierRecommand];
        if (nil==recommandCell) {
            recommandCell=[[[NSBundle mainBundle]loadNibNamed:@"ASRecommandCell" owner:nil options:nil]objectAtIndex:0] ;
            
            //设置选中图片
            UIImageView *selectImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"libiaoxuanzhong.png"]];
            selectImageView.alpha=0.8;
            recommandCell.selectedBackgroundView = selectImageView;
            [selectImageView release];
            //设置cell的背景颜色
             recommandCell.contentView.backgroundColor=[UIColor whiteColor];
        }
        ASMerchantDetailInfo *info= [_recommandArray objectAtIndex:indexPath.row-2];
        NSString *name=info.name;
        recommandCell.name.text=name;
        recommandCell.addres.text=info.address;
        recommandCell.info.text=info.discount;//折扣信息
        if (nil!=info.imageURL&&info.imageURL.length>0) {
           
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 11, 88, 71)];
//            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.backgroundColor=[UIColor clearColor];
            [imageView setImageWithURL:[NSURL URLWithString:info.imageURL]placeholderImage:nil];
            [recommandCell addSubview:imageView];
            [imageView release];
        }
//        cell=recommandCell;
        return recommandCell;
    }
//    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height;
    if (indexPath.row==0) {
        height=120.0;
    }else if (indexPath.row==1){
        height=245.0;
    }
    else if (indexPath.row==_recommandArray.count+2){
        height=44.0;
    }else{
        height=93.0;
    }
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_recommandArray.count>0) {
         return _recommandArray.count+3;
    }else{
        return 2;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"进入详情");
    
    int row=indexPath.row;
    if (row>1&&row<_recommandArray.count+2) {

         ASMerchantInfoViewController *merchantInfoViewController    = [[ASMerchantInfoViewController alloc] initWithNibName:@"ASMerchantInfoViewController" bundle:nil];
        merchantInfoViewController.merchantDetail=[_recommandArray objectAtIndex:row-2];
        
        @try {
            [self.navigationController pushViewController: merchantInfoViewController animated: YES];
        }
        @catch (NSException * ex) {
            //“Pushing the same view controller instance more than once is not supported”
            //NSInvalidArgumentException
            //Full error includes class pointer address so only care if it starts with this error
            NSRange range = [ex.reason rangeOfString:@"Pushing the same view controller instance more than once is not supported"];
            
            if([ex.name isEqualToString:@"NSInvalidArgumentException"] &&
               range.location != NSNotFound)
            {
                //view controller already exists in the stack - just pop back to it
                [self.navigationController pushViewController: merchantInfoViewController
                                                     animated: YES];
            }else{
                NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
            }
        }
        @finally {
            //NSLog(@"finally");
        }

        [merchantInfoViewController release];
        [tableView deselectRowAtIndexPath: indexPath
                                 animated: YES];
    }else if (indexPath.row==_recommandArray.count+2){
        if (currentPage!=totalPage&&moreLabel&&_recommandArray.count>0) {
            currentPage++;
            moreLabel.text=@"正在加载中";
            [self reloadTableViewDataSource];
        }
    }
}

#pragma ASCategoryInRecommandDelegate
-(void)CategoryClick:(NSString *)category categoryID:(NSString *)CId{
    NSLog(@"category==========%@",category);
//    if (nil==classRecommand) {
      ASClassRecommandViewController *  classRecommand=[[ASClassRecommandViewController alloc]init];
//    }
    classRecommand.category=category;
    classRecommand.categoryId=CId;
//    classRecommand.city=_city;
    classRecommand.cityId=_cityId;


    [self.navigationController pushViewController:classRecommand  animated:YES];
    [classRecommand release];
}

#pragma slideViewDelegate
-(void)whichOneIsSelected:(int)page{
//    ASInfoListDeatail *info=[[ASInfoListDeatail alloc]init];
   ASInfoListDeatail * info=[_slideInfoArray objectAtIndex:page];
   
    //更改本地消息的读取状态
    [ASGlobal updateInfoIsRead:info.ids ISREAD:@"0"];
    if (nil!=info.businessId&&![info.businessId isEqualToString:@""]&&![info.businessId isEqualToString:@"0"]) {
        ASMerchantInfoViewController *merchatInfoVC = [[ASMerchantInfoViewController alloc] initWithNibName:@"ASMerchantInfoViewController" bundle:nil];
        merchatInfoVC.isInfoPush=YES;
        merchatInfoVC.businessId=info.businessId;
        [self.navigationController pushViewController: merchatInfoVC
                                                      animated: YES];
        [merchatInfoVC release];
    }else{
        ASPushInfoViewController *pushInfoVC=[[ASPushInfoViewController alloc]initWithNibName:@"ASPushInfoViewController" bundle:nil];
        pushInfoVC.pushInfoStr=info.content ;
        pushInfoVC.time=info.createTime;
        pushInfoVC.imageUrl=info.imageURL;
        [self.navigationController  pushViewController: pushInfoVC
                                                      animated: YES];
        [pushInfoVC release];
        
    }
}

//-----//请求网络加载数据
-(void)reloadTableViewDataSource
{
    //开启加载动画
    [self startAnimating];
    _reloading=YES;
    recommandTable.userInteractionEnabled=NO;
    
    NSString *pageCountStr = [[NSString alloc] initWithFormat: @"%d",currentPage];    
    
    NSDictionary *parametersDic=[[NSDictionary alloc]initWithObjectsAndKeys:_cityId,@"cityId",@YES,@"isRecommend",pageCountStr,PAGENONUMER,PAGENUMBER,PAGESIZENUMBER,@1,@"isIndex",nil];

    NSLog(@"city is %@, cityID is %@", _city, _cityId);

    
    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:REQUESTURL]];
//    NSLog(@"%@",REQUESTURL);
    
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request setTimeOutSeconds:5];
    for (NSString *key in [parametersDic allKeys]) {
        NSString *value=[parametersDic objectForKey:key];
        [request setPostValue:value forKey:key];
    }
     [request startAsynchronous];//异步加载
   [request release];
    [parametersDic release];
    [pageCountStr release];
}

- (void)doneLoadingTableViewData
{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:recommandTable];
}

#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{   
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(ASTableHeaderView*)view{
    currentPage=1;
    totalPage=-1;
    isPullRefresh=YES;
    [self reloadTableViewDataSource];
    
    
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(ASTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(ASTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}
//上啦加载更多
-(void)egoUploadMoreWithPull{
    NSLog(@"上啦加载");
   
    if (currentPage!=totalPage&&moreLabel&&_recommandArray.count>0) {
        currentPage++;
        moreLabel.text=@"正在加载中";
        [self reloadTableViewDataSource];
    }
}
-(void)egoUploadMoreWithIsPulling{
//    if (moreLabel&&currentPage!=totalPage) {
//         moreLabel.text=@"松开加载更多";
//    }

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
    recommandTable.userInteractionEnabled=YES;
    [_indcatorView dimissIndicator];
    
}

//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *string = [request responseString];
    //    NSLog(@"%@",requestResult);
    NSDictionary *responseDict = [string objectFromJSONString];
    NSLog(@"-------%@",responseDict);
    
    
    /*
     获取广告栏中的信息
     */
    NSDictionary *pageImageDic=[responseDict objectForKey:@"pageImage"];//存放推荐列表中的字典
    NSArray *recommandArray=[pageImageDic objectForKey:@"root"];//存放推荐列表数组信息
    NSLog(@"=============%@",recommandArray);
    NSMutableArray *imgArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary *dic in recommandArray) {
        ASInfoListDeatail *info=[[ASInfoListDeatail alloc]init];
        NSString *ids=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        if ([ids isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
            ids=@"";
        }
        info.ids=ids;
        NSLog(@"ids---:%@",info.ids);
        NSString *title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        if ([title isEqualToString:@"<null>"]||[title isEqualToString:@""]) {
            title=@"";
        }
        info.title=title;
        NSLog(@"infotitle:%@",info.title);
        
        NSString *businessId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessId"]];
        if ([businessId isEqualToString:@"<null>"]||[businessId isEqualToString:@""]) {
            businessId=@"";
        }
        info.businessId= businessId;
        
        NSString *changed=[NSString stringWithFormat:@"%@",[dic objectForKey:@"changed"]];
        if ([changed isEqualToString:@"<null>"]||[changed isEqualToString:@""]) {
            changed=@"";
        }
        info.changed=changed;
        NSString *content=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        if ([content isEqualToString:@"<null>"]||[content isEqualToString:@""]) {
            content=@"";
        }
        info.content=content;
        NSLog(@"content:%@",info.content);
        
        NSString *createTime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
        if ([createTime isEqualToString:@"<null>"]||[createTime isEqualToString:@""]) {
            createTime=@"";
        }
        info.createTime=createTime;
        NSString *start=[NSString stringWithFormat:@"%@",[dic objectForKey:@"startTime"]];
        if ([start isEqualToString:@"<null>"]||[start isEqualToString:@""]) {
            info.startTime=@"";
        }else{
            info.startTime=start;
        }
        NSString *end=[NSString stringWithFormat:@"%@",[dic objectForKey:@"endTime"]];
        if ([end isEqualToString:@"<null>"]||[end isEqualToString:@""]) {
            info.endTime=@"";
        }else{
            info.endTime=end;
        }
        
        NSString *type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        if ([type isEqualToString:@"<null>"]||[type isEqualToString:@""]) {
            type=@"";
        }
        info.type=type;
        
        NSString *status=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        if ([status isEqualToString:@"<null>"]||[status isEqualToString:@""]) {
            status=@"";
        }
        info.status=status;
        
        NSString *visible=[NSString stringWithFormat:@"%@",[dic objectForKey:@"visible"]];
        if ([visible isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
            visible=@"";
        }
        info.visible=visible;
        
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"imageURL"]];
        if ([imageUrl isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
            imageUrl=@"";
        }
        info.imageURL= imageUrl;
        NSLog(@"imageURL:%@",info.imageURL);
        //        info.isRead=@"1";
        [imgArr addObject:info];
        [info release];
    }
    [_slideInfoArray removeAllObjects];
    self.slideInfoArray =[NSMutableArray arrayWithArray:imgArr];
    [imgArr release];
    /*
     获取推荐列表中的信息
     */
    NSDictionary *pageBusinessDic=[responseDict objectForKey:@"pageBusiness"];//存放推荐列表中的字典
    
    
    NSArray *arr=[pageBusinessDic objectForKey:@"root"];//存放推荐列表数组信息
    
    if (_recommandArray.count>0&&currentPage==1) {
        //        moreLabel.hidden=YES;
        [_recommandArray removeAllObjects];
    }
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:_recommandArray ];
    
    
    for (NSDictionary *dic in arr) {
        ASMerchantDetailInfo *info=[[ASMerchantDetailInfo alloc]init];
        NSString *ids=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        if ([ids isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
            ids=@"";
        }
        info.ids=ids;
        NSString *name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        if ([name isEqualToString:@"<null>"]||[name isEqualToString:@""]) {
            name=@"";
        }
        info.name=name;
        NSString *city=[NSString stringWithFormat:@"%@",[dic objectForKey:@"cityName"]];
        if ([city isEqualToString:@"<null>"]||[city isEqualToString:@""]) {
            city=@"";
        }
        info.city=city;
        NSString *address=[NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
        if ([address isEqualToString:@"<null>"]||[address isEqualToString:@""]) {
            address=@"";
        }
        info.address=address;
        NSString *discount=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ly_ykt"]];
        if ([discount isEqualToString:@"<null>"]||[discount isEqualToString:@""]) {
            discount=@"";
        }
        info.discount=discount;
        
        NSString *createTime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
        if ([createTime isEqualToString:@"<null>"]||[createTime isEqualToString:@""]) {
            createTime=@"";
        }
        info.createTime=createTime;
        NSString *imageURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"preview"]];
        if ([imageURL isEqualToString:@"<null>"]||[imageURL isEqualToString:@""]) {
            imageURL=@"";
        }
        info.imageURL=imageURL;
        NSString *imageURLMAX=[NSString stringWithFormat:@"%@",[dic objectForKey:@"preview"]];
        if ([imageURLMAX isEqualToString:@"<null>"]||[imageURLMAX isEqualToString:@""]) {
            imageURLMAX=@"";
        }
        info.imageURLMAX=imageURLMAX;
        NSString *introduction=[NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile_brief"]];
        if ([introduction isEqualToString:@"<null>"]||[introduction isEqualToString:@""]) {
            introduction=@"";
        }
        info.introduction=introduction;
        NSString *latitude=[NSString stringWithFormat:@"%@",[dic objectForKey:@"latitude"]];
        if ([latitude isEqualToString:@"<null>"]||[latitude isEqualToString:@""]) {
            latitude=@"";
        }
        info.latitude=latitude;
        NSString *longitude=[NSString stringWithFormat:@"%@",[dic objectForKey:@"longitude"]];
        if ([longitude isEqualToString:@"<null>"]||[longitude isEqualToString:@""]) {
            longitude=@"";
        }
        info.longitude=longitude;
        NSString *remark=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
        if ([remark isEqualToString:@"<null>"]||[remark isEqualToString:@""]) {
            remark=@"";
        }
        info.remark=remark;
        NSString *stars=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avg_point"]];
        if ([stars isEqualToString:@"<null>"]||[stars isEqualToString:@""]) {
            stars=@"";
        }
        info.stars=stars;
        NSString *status=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        if ([status isEqualToString:@"<null>"]||[status isEqualToString:@""]) {
            status=@"";
        }
        info.status=status;
        
        NSString *tel=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
        if ([tel isEqualToString:@"<null>"]||[tel isEqualToString:@""]) {
            tel=@"";
        }
        info.tel=tel;
        NSString *type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        if ([type isEqualToString:@"<null>"]||[type isEqualToString:@""]) {
            type=@"";
        }
        info.type=type;
        NSString *visible=[NSString stringWithFormat:@"%@",[dic objectForKey:@"visible"]];
        if ([visible isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
            visible=@"";
        }
        info.visible=visible;
        NSString *changed=[NSString stringWithFormat:@"%@",[dic objectForKey:@"changed"]];
        if ([changed isEqualToString:@"<null>"]||[changed isEqualToString:@""]) {
            changed=@"";
        }
        info.changed=changed;
        [array addObject:info];
        [info release];
    }
    

    [_recommandArray removeAllObjects];
    self.recommandArray=[NSMutableArray arrayWithArray:array];

    [array release];
    if (arr.count<[PAGENUMBER intValue]) {
        totalPage=currentPage;
    }
    
    if (_recommandArray.count>0) {
        
    }else{
        [self stopAnimating];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"目前没有精品推荐！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    //    moreLabel.hidden=NO;
    _reloading = NO;
    
    
    if (isPullRefresh) {
        isPullRefresh=NO;
    }else{
        if (currentPage==1) {
            [recommandTable setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    [recommandTable reloadData];
    if (totalPage==currentPage) {
        moreLabel.text=@"没有更多数据";
    }else{
        moreLabel.text=@"加载更多";
    }
    
    
    [self stopAnimating];
     [self doneLoadingTableViewData];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
   
}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
//    NSString *string = [request responseString];
//    NSLog(@"%@",request.error);
    if (currentPage>1) {
        currentPage--;
    }
    _reloading = NO;
    if (isPullRefresh) {
        isPullRefresh=NO;
    }else{
        if (currentPage==1) {
            [recommandTable setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    [recommandTable reloadData];
    if (totalPage==currentPage) {
        moreLabel.text=@"没有更多数据";
    }else{
        moreLabel.text=@"加载更多";
    }
    
    [self stopAnimating];
     [self doneLoadingTableViewData];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，网络不给力！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];

}


@end
