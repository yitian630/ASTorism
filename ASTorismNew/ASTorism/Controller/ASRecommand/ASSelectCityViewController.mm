//
//  ASSelectCityViewController.m
//  ASBestLife
//
//  Created by Jill on 13-7-12.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASSelectCityViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASImage.h"
#import "ASGlobal.h"
#import "ASAlert.h"
#import "UIDevice+Resolutions.h"
#import "ASActivityIndcatorView.h"
#import "CityClassModel.h"

static CGFloat KTableViewCellHeight = 44.0;

@interface ASSelectCityViewController ()
{
    NavigationBar *navBar;
    
    BOOL _reloading;//主要是记录是否在刷新中
//    ASTableHeaderView *_refreshHeaderView;
}
//要定位的话需要用到这个view

@property(nonatomic,retain) ASActivityIndcatorView *indicatorView;
@property(nonatomic,retain) NSArray *provinceArray;//本地城市数组

@property(nonatomic, strong) CityClassModel *cityClass;
//View Controller Life Cycle
- (void)setupAllObjectNil;


@end

@implementation ASSelectCityViewController

@synthesize cityTableView = _cityTableView;
@synthesize nextViewController;

@synthesize city=_city;
@synthesize cityId=_cityId;
@synthesize provinceArray = _provinceArray;

@synthesize indicatorView=_indicatorView;
@synthesize isFirstTimeIn = _isFirstTimeIn;

#pragma mark - View Controller Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isFirstTimeIn = YES;
        self.cityArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //读取本地plist文件
    NSString *cityPath=[[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    self.provinceArray=[NSArray arrayWithContentsOfFile:cityPath];

}
- (void)viewWillAppear:(BOOL)animated
{
    [ASGlobal hiddenBottomMenuView];//隐藏tabbar
    [super viewWillAppear:YES];
    //设置导航栏并且做适配
    [self setNavBar];
    [self Adaptation];
    //改变索引的颜色
  
    
    //网络请求加载数据
    [self reloadTableViewDataSource];
    
}
-(void)viewDidUnload
{
    [self setupAllObjectNil];
    
    [super viewDidUnload];
}



- (void) reloadTableViewDataSource
{
    //开启加载动画
    [self startAnimating];
    _reloading=YES;
    //_cityTableView.userInteractionEnabled=NO;
    
    NSDictionary *parametersDic=[[NSDictionary alloc]initWithObjectsAndKeys:_cityId,@"cityId",_city,@"city", nil];
    
    NSLog(@"city is %@, cityID is %@", _city, _cityId);
    
    
    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CITYLISTURL]];
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
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self setupAllObjectNil];
}
-(void) dealloc
{
    [_cityTableView release];

    [_cityId release];
    [nextViewController release];

    [_city release];
    [super dealloc];
}





// 加载动画开始
// */
-(void)startAnimating
{
    //加载动画
    
    if (nil == _indicatorView)
    {
        _indicatorView = [[ASActivityIndcatorView alloc] init];
    }
    [_indicatorView showIndicator];
    
}
/*
 加载动画结束
 */
-(void)stopAnimating
{
    [_indicatorView dimissIndicator];    
}


- (void)setupAllObjectNil
{

    self.cityTableView = nil;
    navBar = nil;
    self.nextViewController = nil;
    self.cityArray =nil;
    
}
/*
 *设置navigationBar
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
    navBar.searchButton.hidden=YES;
    navBar.cityButton.hidden=YES;
    navBar.searchImage.hidden=YES;
    navBar.cityImage.hidden=YES;
    //适配navBar
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }else
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    
    if (nextViewController) {
        navBar.BackButton.hidden=YES;
        navBar.backImage.hidden=YES;
    }else{
        navBar.BackButton.hidden=NO;
        navBar.backImage.hidden=NO;
    }
    
    navBar.titleLabel.text=@"选择城市";
    [self.view addSubview:navBar];
}
#pragma NavigationBarDelegate
-(void)NavBarBackClick{
    [self.navigationController popViewControllerAnimated: YES];
}
#pragma navigationBarDelegate
-(void)NavSearchButtonClick{
}
-(void)NavCityButtonClick{
}


#pragma Adaptation 适配
-(void)Adaptation{
    CGRect rect;
    if ([UIDevice systemMajorVersion] < 7.0) {
        NSLog(@"iphone4");
        //self.view.frame=CGRectMake(0, 0, 320, 548);
        rect=CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-44);
    }else{
        NSLog(@"iphone5");
        //self.view.frame=CGRectMake(0, 0, 320, 460);
        rect=CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-44);
    }
    _cityTableView.frame=rect;
}


#pragma mark - UITableViewDatasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellReuseIndentifier = @"CityCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIndentifier] autorelease];
        UILabel * cityName = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 300, 25)];
        cityName.tag = 1010;
        [cell addSubview:cityName];
        [cityName release];
        [cell  setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *sperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, KTableViewCellHeight-1, 300, 1)];
        [sperator setImage:[UIImage imageNamed:@"cutoffline.png"]];
        [cell addSubview:sperator];
        [sperator release];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        //设置选中图片
        UIImageView *selectImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"libiaoxuanzhong.png"]];
        cell.selectedBackgroundView = selectImageView;
        [selectImageView release];
        
    }
    UILabel *cityName =(UILabel*)[cell viewWithTag:1010];
    cityName.text = [self.cityArray objectAtIndex:indexPath.row];
    
    //从本地plist获取的城市列表
     
//    NSMutableArray *cityArr = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in self.provinceArray) {
//        [cityArr addObject:[dic objectForKey:@"name"]];
//    }
//    NSString *cityNameStr = [cityArr objectAtIndex:indexPath.row];
//    cityName.text = cityNameStr;
    
    
    return  cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    NSDictionary *cityDic = [self.provinceArray objectAtIndex:indexPath.row];

    //获得用户选择的城市之后，利用全局方法保存到本地文件中
    self.city = [cityDic objectForKey:@"name"];
    self.cityId = [cityDic objectForKey:@"id"];
    [ASGlobal saveCityTofile:self.city CITYID:self.cityId];
    

    [tableView deselectRowAtIndexPath: indexPath
                             animated: YES];
    if (nextViewController)
    {
                nextViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

        [self presentModalViewController: nextViewController
                                animated: YES];
    }
    else
    {
        [self NavBarBackClick];

    }
    
}

//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *string = [request responseString];

    NSMutableArray *responseArray = [string objectFromJSONString];
    
    //保存网络获取的数组到本地
    [ASGlobal saveCityTofile:responseArray];
    
    for(NSDictionary *dic in responseArray)
    {
        [self.cityArray addObject:[dic objectForKey:@"name"]];
    }


    //刷新显示
    [self.cityTableView reloadData];
    [self stopAnimating];

}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSString *string = [request responseString];
    //    NSLog(@"%@",request.error);
//    if (currentPage>1) {
//        currentPage--;
//    }
//    _reloading = NO;
//    if (isPullRefresh) {
//        isPullRefresh=NO;
//    }else{
//        if (currentPage==1) {
//            [recommandTable setContentOffset:CGPointMake(0, 0) animated:NO];
//        }
//    }
//    [recommandTable reloadData];
//    if (totalPage==currentPage) {
//        moreLabel.text=@"没有更多数据";
//    }else{
//        moreLabel.text=@"加载更多";
//    }
    
    [self stopAnimating];
   
    //    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，网络不给力！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

@end
