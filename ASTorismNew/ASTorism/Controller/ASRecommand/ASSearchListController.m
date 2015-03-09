//
//  ASSearchListController.m
//  ASBestLife
//
//  Created by csl on 13-7-1.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASSearchListController.h"
#import "ASSearchBar.h"
#import "ASImage.h"
#import "UIDevice+Resolutions.h"
#import <QuartzCore/QuartzCore.h>
#import "ASMerchantInfoViewController.h"
#import "ASActivityIndcatorView.h"
#import "ASAlert.h"
#import "ASRecommandCell.h"
#import "ASGlobal.h"
#import "ASMerchantDetailInfo.h"
//#import "UrlImageView.h"
#import "UIImageView+AFNetworking.h"
@interface ASSearchListController ()
{
    NavigationBar *navBar;
    UILabel *moreLabel;//加载更多
}
@property (nonatomic,retain) NSMutableArray *searchResultArray;
@property(nonatomic,assign) int currentPage;
@property(nonatomic,assign) int totalPage;
//下拉刷新
//@property(nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
//进入页面时的加载提示
@property (nonatomic,retain) ASActivityIndcatorView *indcatorView;
@property (nonatomic,retain) NSString *lastSearchKeywordStr;


@end

@interface ASSearchListController ()<ASSearchBarDelegate>



@end

@implementation ASSearchListController
@synthesize searchBar = _searchBar;
@synthesize searchListTable = _searchListTable;
@synthesize searchResultArray = _searchResultArray;
@synthesize searchKeywordStr;
@synthesize currentPage;
@synthesize totalPage;
@synthesize indcatorView=_indcatorView;
@synthesize lastSearchKeywordStr;
//@synthesize activityIndicatorView=_activityIndicatorView;
@synthesize cityId=_cityId;
@synthesize proId=_proId;
@synthesize isBack;
#pragma mark - View Controller Life Cycle
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
    
//    moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,12,320, 20)];

     moreLabel.text=@"加载更多";
       // Do any additional setup after loading the view from its nib.
       

    
//    _searchResultArray=[[NSMutableArray alloc]initWithCapacity:0];

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
    navBar.titleLabel.hidden=YES;
    //适配navBar
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }else
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    
    //添加ASSearchBar
    if ([UIDevice systemMajorVersion] < 7) {
        //iphone4
        _searchBar = [[ASSearchBar alloc] initWithFrame:CGRectMake(55, 0, 265,44)];
    }else
        _searchBar = [[ASSearchBar alloc] initWithFrame:CGRectMake(55, 20, 265,44)];
    _searchBar.delegate = self;
    _searchBar.backgroundColor=[UIColor clearColor];//测试用

    _searchBar.searchField.placeholder = @"请输入关键字";
    _searchBar.searchField.text = searchKeywordStr;
   
    [navBar addSubview:_searchBar];
    
    
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
        rect=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    }
    _searchListTable.frame=rect;
}
-(void)viewWillAppear:(BOOL)animated
{
    //设置导航栏并做适配
    [ASGlobal hiddenBottomMenuView];//隐藏tabbar
    [self setNavBar];
    [self Adaptation];
    if (!isBack) {
        self.lastSearchKeywordStr = searchKeywordStr;
        self.currentPage = 1;
        self.totalPage=-1;
    }else{
        isBack=NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [ASGlobal hiddenBottomMenuView];//隐藏tabbar
    if (!isBack) {
        currentPage = 1;
        totalPage=-1;
        [_searchResultArray removeAllObjects];
        [_searchListTable reloadData];
        _searchBar.searchField.text=@"";
        _searchBar.searchField.placeholder=@"请输入您要搜索的关键字";
        searchKeywordStr=@"";
        _cityId=@"";
    }
     [_searchBar resignSearchField];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.searchResultArray = nil;
    self.searchListTable = nil;
    self.searchBar = nil;
   
}
-(void) dealloc
{
    [_proId release];
    [_searchBar release];;
    [_searchListTable release];
    [searchKeywordStr release];
    [_searchResultArray release];
//    [_activityIndicatorView release];
    [_indcatorView release];
    [lastSearchKeywordStr release];
//    [navBar release];
    [_cityId release];
    
    [super dealloc];
}



#pragma mark - ASSearchBarDelegate


-(void)asSearchBarDidSearch:(ASSearchBar *)searchBar
{
     [_searchBar resignSearchField];
    self.searchKeywordStr = _searchBar.searchField.text;
  
    if (![@"" isEqualToString: self.searchKeywordStr]&&self.searchKeywordStr.length>0)
    {
        if (self.searchKeywordStr.length>50) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"关键字太长" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else{
            self.lastSearchKeywordStr = searchKeywordStr;
            [_searchResultArray removeAllObjects];
            [_searchListTable reloadData];
            currentPage=1;
            totalPage=-1;
            moreLabel.text=@"加载更多";
            //        moreLabel.hidden=YES;
            //网络请求  加载数据
            [self requestSearchList];
        }
        
       
        
    }
    else
    {
        searchBar.searchField.placeholder = @"关键字不能为空";
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchResultArray.count>0) {
        return _searchResultArray.count+1;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *identifier=@"searchResultCellIdentifier";
    id cell=nil;

          if (_searchResultArray.count>indexPath.row) {
              ASRecommandCell *recommandCell=nil;
              recommandCell=[tableView dequeueReusableCellWithIdentifier:identifier];
              if (nil==recommandCell) {
                  recommandCell=[[[NSBundle mainBundle]loadNibNamed:@"ASRecommandCell" owner:nil options:nil]objectAtIndex:0];
                  //设置cell的背景颜色
                  recommandCell.contentView.backgroundColor=[UIColor whiteColor];
                  //设置选中图片
                  UIImageView *selectImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"libiaoxuanzhong.png"]];
                  recommandCell.selectedBackgroundView = selectImageView;
                  [selectImageView release];
              }

        ASMerchantDetailInfo *info= [_searchResultArray objectAtIndex:indexPath.row];
        recommandCell.name.text=info.name;
        recommandCell.addres.text=info.address;
        
        
        //测试===============
//        NSArray *discountArr=[info.discount componentsSeparatedByString:@"_"];
//        NSString *yuan=[discountArr objectAtIndex:1];
//        NSString *xian=[discountArr objectAtIndex:0];
        recommandCell.info.text=info.discount;
        
        if (nil!=info.imageURL&&info.imageURL.length>0) {
            NSString *strImgURL=[NSString stringWithFormat:@"%@",info.imageURL];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(recommandCell.image.frame.origin.x, recommandCell.image.frame.origin.y, recommandCell.image.frame.size.width, recommandCell.image.frame.size.height)];
            //            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor=[UIColor clearColor];
            [imageView setImageWithURL:[NSURL URLWithString:strImgURL]placeholderImage:nil];
            [recommandCell addSubview:imageView];
            
            [imageView release];
        }
        
        
        cell=recommandCell;

        
    }else{
        static NSString *identifierMore=@"more";
        UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:identifierMore];
        if (nil==moreCell )
        {
            moreCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierMore] autorelease] ;
            if (nil==moreLabel) {
                moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,12,320, 20)];
//                [moreLabel setFrame:CGRectMake(0,12,320, 20)];
                [moreLabel setFont:[UIFont systemFontOfSize:13]];
                moreLabel.tag = 1010;
                [moreLabel setTextAlignment:NSTextAlignmentCenter];
                
            }
            
            [moreCell addSubview:moreLabel];
            [moreCell  setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (currentPage==totalPage) {
            moreLabel.text=@"没有更多数据";
        }else{
            moreLabel.text=@"加载更多";
        }

        cell=moreCell;
        

    }
        
    
       
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_searchResultArray.count){
        return 93;
    }else{
        return  44;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第%d行",indexPath.row);
    if (indexPath.row==_searchResultArray.count) {
        if (currentPage!=totalPage&&moreLabel&&_searchResultArray.count>0) {
            currentPage++;
            moreLabel.text=@"正在加载中";
            [self requestSearchList];
        }
          
    }else{
        isBack=YES;
         ASMerchantInfoViewController*   merchantInfoViewController = [[ASMerchantInfoViewController alloc] init];
        merchantInfoViewController.merchantDetail=[_searchResultArray objectAtIndex:indexPath.row] ;
        
        
        
        @try {
            [self.navigationController pushViewController: merchantInfoViewController
                                                 animated: YES];
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
    }
    [tableView deselectRowAtIndexPath: indexPath
                             animated: YES];
    
    

}
-(void)requestSearchList{
    //开始加载动画
    [self startAnimating];
    _searchListTable.userInteractionEnabled=NO;
    
    NSString *pageCountStr = [[NSString alloc] initWithFormat: @"%d",currentPage];
//    NSDictionary *parametersDic=[[NSDictionary alloc]initWithObjectsAndKeys:self.searchKeywordStr,@"keyword",_cityId,@"city",pageCountStr,PAGENONUMER,PAGENUMBER,PAGESIZENUMBER,_proId,@"province",nil];
    //搜索范围改为全部
    NSDictionary *parametersDic=[[NSDictionary alloc]initWithObjectsAndKeys:self.searchKeywordStr,@"keyword",_cityId,@"city",pageCountStr,PAGENONUMER,PAGENUMBER,PAGESIZENUMBER,@"",@"province",nil];
    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:REQUESTURL]];
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
    [pageCountStr release];
    
    


}
//上啦加载更多
//下拉tableview加载商家列表下一页
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 
    CGPoint offset = scrollView.contentOffset;
	CGRect bounds = scrollView.bounds;
	CGSize size = scrollView.contentSize;
	UIEdgeInsets inset = scrollView.contentInset;
    
	float y = offset.y + bounds.size.height - inset.bottom;
	float h = size.height;
    
	float reload_distance = 67;
	if(y > h + reload_distance)
    {
        if (currentPage!=totalPage&&moreLabel&&_searchResultArray.count>0) {
            //上啦
            currentPage++;
            moreLabel.text=@"正在加载中";
            [self requestSearchList];
        }
 
    }
}




/*
 加载动画开始
 */
-(void)startAnimating{
    //加载动画
    
    if (nil == _indcatorView)
    {
        _indcatorView = [[ASActivityIndcatorView alloc] init];
    }
    [_indcatorView showIndicator];
//    [_activityIndicatorView startAnimating];
//    [_searchListTable addSubview: _activityIndicatorView];
//    [_searchListTable sendSubviewToBack: _activityIndicatorView];
   
}
/*
 加载动画结束
 */
-(void)stopAnimating{
//    moreLabel.hidden=NO;//显示加载更多
//    [_activityIndicatorView stopAnimating];
//    [_activityIndicatorView removeFromSuperview];
    _searchListTable.userInteractionEnabled=YES;
    [_indcatorView dimissIndicator];
    
}
//网络请求返回的方法
//-(void)ASIRequestFinished:(NSString *)requestResult{
////    NSLog(@"%@",requestResult);
//    NSDictionary *responseDict = [requestResult objectFromJSONString];
////   NSLog(@"responseObject = %@", responseDict);
//    /*
//     获取推荐列表中的信息
//     */
////    NSDictionary *pageBusinessDic=[responseDict objectForKey:@"pageBusiness"];//存放推荐列表中的字典
//    
//    
//    NSArray *arr=[responseDict objectForKey:@"root"];//存放推荐列表数组信息
//
//    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:_searchResultArray];
//    for (NSDictionary *dic in arr) {
//        ASMerchantDetailInfo *info=[[ASMerchantDetailInfo alloc]init];
//        NSString *ids=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ids"]];
//        if ([ids isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
//            ids=@"";
//        }
//        info.ids=ids;
//        NSString *name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//        if ([name isEqualToString:@"<null>"]||[name isEqualToString:@""]) {
//            name=@"";
//        }
//        info.name=name;
//        NSString *city=[NSString stringWithFormat:@"%@",[dic objectForKey:@"cityName"]];
//        if ([city isEqualToString:@"<null>"]||[city isEqualToString:@""]) {
//            city=@"";
//        }
//        info.city=city;
//        NSString *address=[NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
//        if ([address isEqualToString:@"<null>"]||[address isEqualToString:@""]) {
//            address=@"";
//        }
//        info.address=address;
//        NSString *discount=[NSString stringWithFormat:@"%@",[dic objectForKey:@"discount"]];
//        if ([discount isEqualToString:@"<null>"]||[discount isEqualToString:@""]) {
//            discount=@"";
//        }
//        info.discount=discount;
//        NSString *createTime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
//        if ([createTime isEqualToString:@"<null>"]||[createTime isEqualToString:@""]) {
//            createTime=@"";
//        }
//        info.createTime=createTime;
//        NSString *imageURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"imageURL"]];
//        if ([imageURL isEqualToString:@"<null>"]||[imageURL isEqualToString:@""]) {
//            imageURL=@"";
//        }
//        info.imageURL=imageURL;
//        NSString *imageURLMAX=[NSString stringWithFormat:@"%@",[dic objectForKey:@"imageURLMAX"]];
//        if ([imageURLMAX isEqualToString:@"<null>"]||[imageURLMAX isEqualToString:@""]) {
//            imageURLMAX=@"";
//        }
//        info.imageURLMAX=imageURLMAX;
//        NSString *introduction=[NSString stringWithFormat:@"%@",[dic objectForKey:@"introduction"]];
//        if ([introduction isEqualToString:@"<null>"]||[introduction isEqualToString:@""]) {
//            introduction=@"";
//        }
//        info.introduction=introduction;
//        NSString *latitude=[NSString stringWithFormat:@"%@",[dic objectForKey:@"latitude"]];
//        if ([latitude isEqualToString:@"<null>"]||[latitude isEqualToString:@""]) {
//            latitude=@"";
//        }
//        info.latitude=latitude;
//        NSString *longitude=[NSString stringWithFormat:@"%@",[dic objectForKey:@"longitude"]];
//        if ([longitude isEqualToString:@"<null>"]||[longitude isEqualToString:@""]) {
//            longitude=@"";
//        }
//        info.longitude=longitude;
//        NSString *remark=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
//        if ([remark isEqualToString:@"<null>"]||[remark isEqualToString:@""]) {
//            remark=@"";
//        }
//        info.remark=remark;
//        NSString *stars=[NSString stringWithFormat:@"%@",[dic objectForKey:@"stars"]];
//        if ([stars isEqualToString:@"<null>"]||[stars isEqualToString:@""]) {
//            stars=@"";
//        }
//        info.stars=stars;
//        NSString *status=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
//        if ([status isEqualToString:@"<null>"]||[status isEqualToString:@""]) {
//            status=@"";
//        }
//        info.status=status;
//        
//        NSString *tel=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
//        if ([tel isEqualToString:@"<null>"]||[tel isEqualToString:@""]) {
//            tel=@"";
//        }
//        info.tel=tel;
//        NSString *type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
//        if ([type isEqualToString:@"<null>"]||[type isEqualToString:@""]) {
//            type=@"";
//        }
//        info.type=type;
//        NSString *visible=[NSString stringWithFormat:@"%@",[dic objectForKey:@"visible"]];
//        if ([visible isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
//            visible=@"";
//        }
//        info.visible=visible;
//        NSString *changed=[NSString stringWithFormat:@"%@",[dic objectForKey:@"changed"]];
//        if ([changed isEqualToString:@"<null>"]||[changed isEqualToString:@""]) {
//            changed=@"";
//        }
//        info.changed=changed;
//        
//        [array addObject:info];
//        [info release];
//    }
//    _searchResultArray =[[NSMutableArray alloc]initWithArray:array];
//    [array release];
//    //设置moreLabel内容
//    moreLabel.text=@"加载更多";
//    if (arr.count<[PAGENUMBER intValue]) {
//        totalPage=currentPage;
//        moreLabel.text=@"没有更多数据";
//    }
//    
//    if (_searchResultArray.count>0) {
//        _searchListTable.hidden=NO;
//        
//    }else{
//        _searchListTable.hidden=YES;
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有您要找的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
////    moreLabel.hidden=NO;
//    if (totalPage==currentPage) {
//        moreLabel.text=@"没有更多数据";
//    }else{
//        moreLabel.text=@"加载更多";
//    }
//    
//
//    [_searchListTable reloadData];
//    //停止加载动画
//    [self stopAnimating];
////    if (currentPage==1) {
////        [_searchListTable setContentOffset:CGPointMake(0, 0) animated:YES];
////    }
//    _searchListTable.userInteractionEnabled=YES;
//    
//}
//-(void)ASIRequestFailed:(NSString *)requestResult
//{
////    NSLog(@"%@",requestResult);
//    //    NSDictionary *responseDict = [requestResult objectFromJSONString];
//    //    //        NSLog(@"responseObject = %@", responseDict);
////    moreLabel.hidden=NO;
//    if (totalPage==currentPage) {
//        moreLabel.text=@"没有更多数据";
//    }else{
//        moreLabel.text=@"加载更多";
//    }
////    if (currentPage==1) {
////        [_searchListTable setContentOffset:CGPointMake(0, 0) animated:YES];
////    }
//    [_searchListTable reloadData];
//
//    [self stopAnimating];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//    _searchListTable.userInteractionEnabled=YES;
//}
//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *string = [request responseString];
    //    NSLog(@"%@",requestResult);
    NSDictionary *responseDict = [string objectFromJSONString];
//       NSLog(@"responseObject = %@", responseDict);
    /*
     获取推荐列表中的信息
     */
    //    NSDictionary *pageBusinessDic=[responseDict objectForKey:@"pageBusiness"];//存放推荐列表中的字典
    
    
    NSArray *arr=[responseDict objectForKey:@"root"];//存放推荐列表数组信息
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:_searchResultArray];
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
    [_searchResultArray removeAllObjects];
    self.searchResultArray=[NSMutableArray arrayWithArray:array];
//    [_searchResultArray addObjectsFromArray:array];
//    _searchResultArray =[[NSMutableArray alloc]initWithArray:array];
    [array release];
    //设置moreLabel内容
    moreLabel.text=@"加载更多";
    if (arr.count<[PAGENUMBER intValue]) {
        totalPage=currentPage;
        moreLabel.text=@"没有更多数据";
    }
    
    if (_searchResultArray.count>0) {
        _searchListTable.hidden=NO;
        
    }else{
        _searchListTable.hidden=YES;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有您要找的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    //    moreLabel.hidden=NO;
    if (totalPage==currentPage) {
        moreLabel.text=@"没有更多数据";
    }else{
        moreLabel.text=@"加载更多";
    }
    
    
    [_searchListTable reloadData];
    //停止加载动画
    [self stopAnimating];
    //    if (currentPage==1) {
    //        [_searchListTable setContentOffset:CGPointMake(0, 0) animated:YES];
    //    }
    _searchListTable.userInteractionEnabled=YES;
}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
    if (currentPage>1) {
        currentPage--;
    }
    if (totalPage==currentPage) {
        moreLabel.text=@"没有更多数据";
    }else{
        moreLabel.text=@"加载更多";
    }
    //    if (currentPage==1) {
    //        [_searchListTable setContentOffset:CGPointMake(0, 0) animated:YES];
    //    }
    [_searchListTable reloadData];
    
    [self stopAnimating];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，网络不给力！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
    _searchListTable.userInteractionEnabled=YES;
}

@end
