//
//  ASInfomationViewController.m
//  ASTourism
//
//  Created by apple  on 13-8-13.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASInfomationViewController.h"
#import "ASInfoTableCell.h"
#import "UIDevice+Resolutions.h"
#import "ASMerchantInfoViewController.h"
#import "ASGlobal.h"
#import "ASActivityIndcatorView.h"
#import "ASInfoListDeatail.h"
#import "ASPushInfoViewController.h"
@interface ASInfomationViewController ()
{
    NavigationBar *navBar;
    
    ASTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    UILabel *moreLabel;//加载更多label
    BOOL isRuqest;//判断是否需要请求网络  yes为需要
    
    
    
    BOOL isBack;//判断是否是从二级页面返回   yes为是    此时不重新加载数据
    
}
@property (retain, nonatomic) IBOutlet UITableView *infoTable;
@property(nonatomic,assign) int currentPage; //加载当前页数
@property(nonatomic,assign) int totalPage;
//下拉刷新
//@property(nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
//进入页面时的加载提示
@property (nonatomic,retain) ASActivityIndcatorView *indcatorView;
@property (nonatomic,retain) NSMutableArray *infoArray;
@end

@implementation ASInfomationViewController
@synthesize currentPage=_currentPage;
@synthesize totalPage=_totalPage;
@synthesize indcatorView=_indcatorView;
@synthesize infoArray=_infoArray;
@synthesize infoTable = _infoTable;

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
    navBar.searchButton.hidden=YES;
    navBar.BackButton.hidden=YES;
    navBar.backImage.hidden=YES;
    navBar.searchImage.hidden=YES;
    navBar.cityButton.hidden=YES;
    navBar.cityImage.hidden=YES;

    navBar.titleLabel.text=@"消息";
    
    //适配navBar
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }else
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    [self.view addSubview:navBar];
}
#pragma navigationBarDelegate
-(void)NavSearchButtonClick{
}
-(void)NavCityButtonClick{
}
-(void)NavBarBackClick{
}

#pragma Adaptation 适配
-(void)Adaptation{
        CGRect rect;
    if ([UIDevice systemMajorVersion] < 7) {
        rect = CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT - 44);
    }else
        rect = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
        _infoTable.frame=rect;
}


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
    
    
//    infoArray=[[NSMutableArray alloc]initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    //设置导航栏并适配
    [self setNavBar];
    [self Adaptation];
    [self setEGO];
    if (!isBack) {
        
        _currentPage=1;
        _totalPage=-1;
        isRuqest=YES;
        //    [self  fillIntoTable];
        _infoTable.hidden=YES;
        [self reloadTableViewDataSource];
    }else{
        isBack=NO;
    }
   

}
-(void)viewWillAppear:(BOOL)animated{
   [ASGlobal showAOTabbar];//显示tabbar
    [super viewWillAppear:YES];
}
-(void)dealloc{
    [_infoTable release];
    [super dealloc];
//    [navBar release];
    [_infoArray release];
    [_infoTable release];
    [_refreshHeaderView release];
    [_indcatorView release];
}


#pragma tableDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    id cell1=nil;
    if (indexPath.row<_infoArray.count) {
        static NSString *identifier=@"infomationTableView";
        ASInfoTableCell *cell=nil;
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (nil==cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ASInfoTableCell" owner:nil options:nil]objectAtIndex:0];            
            //设置cell的背景颜色
            cell.contentView.backgroundColor=[UIColor whiteColor];
            //设置选中图片
            UIImageView *selectImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"xiaoxixuanzhong.png"]];
            selectImageView.alpha=0.8;
            cell.selectedBackgroundView = selectImageView;
            [selectImageView release];
        }
        int num=indexPath.row%5;
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(34, 9, 286, 76)];
        switch (num) {
            case 0:
                [image setImage:[UIImage imageNamed:@"xiaoxi1.png"]];
                break;
            case 1:
                [image setImage:[UIImage imageNamed:@"xiaoxi2.png"]];
                break;
            case 2:
                [image setImage:[UIImage imageNamed:@"xiaoxi3.png"]];
                break;
            case 3:
                [image setImage:[UIImage imageNamed:@"xiaoxi4.png"]];
                break;
            case 4:
                [image setImage:[UIImage imageNamed:@"xiaoxi5.png"]];
                break;
            default:
                break;
        }
        [cell insertSubview:image atIndex:1];
        ASInfoListDeatail *info=[_infoArray objectAtIndex:indexPath.row];
//        NSLog(@"time==========%@        isread=========%@",info.createTime,info.isRead);
        cell.name.text=info.title;
        cell.info.text=info.content;

        if (nil!=info.startTime&&nil!=info.endTime&& info.startTime.length>0&&info.endTime.length>0) {
//            NSLog(@"%@      %@",info.startTime,info.endTime);
            NSString  *start=[info.startTime substringWithRange:NSMakeRange(0, 10)];
            NSString *end=[info.endTime substringWithRange:NSMakeRange(0, 10)];
            cell.date.text=[NSString stringWithFormat:@"有效期:%@ 至 %@",start,end];
        }
      
        [image release];
        if ([info.isRead isEqualToString:@"1"]) {
            cell.smallImage.image=[UIImage imageNamed:@"未读.png"];
        }else{
            cell.smallImage.image=[UIImage imageNamed:@"已读.png"];
        }
        //设置字体颜色
        [cell.name setTextColor:[UIColor blackColor]];
        [cell.info setTextColor:[UIColor blackColor]];
        [cell.date setTextColor:[UIColor lightGrayColor]];
//        cell1=cell;
        return cell;
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
            
//            moreLabel.text=@"获取更多";
            
        }
        if (_currentPage==_totalPage) {
            
            moreLabel.text=@"没有更多消息";
        }else{
            moreLabel.text=@"加载更多";
        }

        [moreCell addSubview:moreLabel];
        [moreCell  setSelectionStyle:UITableViewCellSelectionStyleNone];
//        cell1=moreCell;
        return moreCell ;
    }
//    return cell1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<_infoArray.count) {
        return 85 ;
    }else{
        return 44;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_infoArray.count>0) {
        return _infoArray.count+1 ;
    }else{
        return 0;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<_infoArray.count) {
        isBack=YES;
        ASInfoTableCell *cell=(ASInfoTableCell*) [_infoTable cellForRowAtIndexPath:indexPath];
        cell.smallImage.image=[UIImage imageNamed:@"已读.png"];
//        ASInfoListDeatail *info=[[ASInfoListDeatail alloc]init];
        ASInfoListDeatail * info=[_infoArray objectAtIndex:indexPath.row];
         info.isRead=@"0";
        //更改本地消息的读取状态
        [ASGlobal updateInfoIsRead:info.ids ISREAD:@"0"];
//        NSLog(@"%@",info.businessId);
        if (nil!=info.businessId&&![info.businessId isEqualToString:@""]&&![info.businessId isEqualToString:@"0"]) {
            ASMerchantInfoViewController *merchatInfoVC = [[ASMerchantInfoViewController alloc] initWithNibName:@"ASMerchantInfoViewController" bundle:nil];
            merchatInfoVC.isInfoPush=YES;
            merchatInfoVC.businessId=info.businessId;

            @try {
                [self.navigationController pushViewController: merchatInfoVC
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
                    [self.navigationController pushViewController: merchatInfoVC
                                                         animated: YES];
                }else{
                    NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
                }
            }
            @finally {
                //NSLog(@"finally");
            }
             [merchatInfoVC release];
        }else{
            ASPushInfoViewController *pushInfoVC=[[ASPushInfoViewController alloc]initWithNibName:@"ASPushInfoViewController" bundle:nil];
            pushInfoVC.pushInfoStr=info.content ;
            pushInfoVC.time=info.createTime;
             pushInfoVC.imageUrl=info.imageURL;
            
            
            @try {
                [self.navigationController pushViewController: pushInfoVC
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
                    [self.navigationController pushViewController: pushInfoVC
                                                         animated: YES];
                }else{
                    NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
                }
            }
            @finally {
                //NSLog(@"finally");
            }
            [pushInfoVC release];
            
        }
        
        
       
        [tableView deselectRowAtIndexPath: indexPath
                                 animated: YES];
    }else{
        NSLog(@"上啦加载");
        if (_currentPage!=_totalPage) {
            _currentPage++;
            if (isRuqest) {
                [self reloadTableViewDataSource];
            }else{
                [self fillIntoTable];
            }
            moreLabel.text=@"正在获取中";
        }
    }
       
}

#pragma table滑动
//
-(void)setEGO{
    if(_refreshHeaderView == nil)
    {
        ASTableHeaderView *view = [[ASTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _infoTable.bounds.size.height, self.view.frame.size.width, _infoTable.bounds.size.height)];
        
        view.delegate = self;
        [_infoTable addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

//-----
-(void)reloadTableViewDataSource
{
    [self startAnimating];
    _reloading = YES;
    _infoTable.userInteractionEnabled=NO;
    
    NSString *pageCountStr = [[NSString alloc] initWithFormat: @"%d",_currentPage];
    NSDictionary *parametersDic=[[NSDictionary alloc]initWithObjectsAndKeys:pageCountStr,PAGENONUMER,PAGENUMBER,PAGESIZENUMBER,nil];
//    NSLog(@"%@",parametersDic);
   
    
    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:PUSHURL]];
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
- (void)doneLoadingTableViewData{
    [self stopAnimating];
    NSLog(@"===加载完数据");
   
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_infoTable];
    
    
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
    _currentPage=1;
    _totalPage=-1;
    isRuqest=YES;
    moreLabel.text=@"";
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
    if (moreLabel&&_currentPage>_totalPage&&nil !=_infoArray&&_infoArray.count>0) {
        _currentPage++;
        moreLabel.text=@"正在获取中";
        if (isRuqest) {
            [self reloadTableViewDataSource];
        }else{
            [self startAnimating];
            [self fillIntoTable];
        }
         
    }
       
}
-(void)egoUploadMoreWithIsPulling{
//    if (moreLabel&&_currentPage>_totalPage&&nil !=infoArray&&infoArray.count>0) {
//        moreLabel.text=@"松开获取更多";
//    }
}
//向table中填充数据
-(void)fillIntoTable{
    if (_infoArray.count>0&&_currentPage==1) {
        //        moreLabel.hidden=YES;
        [_infoArray removeAllObjects];
    }
    _reloading=NO;
//    moreLabel.hidden=NO;
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:[ASGlobal getInfoListFromFile:_infoArray.count pageNUM:[PAGENUMBER intValue]]];
//    NSLog(@"%@",array);
    NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:_infoArray];
//    NSLog(@"%@",arr);
    for (int i=0; i<array.count; i++) {
        ASMerchantDetailInfo *info=[array objectAtIndex:i];
        [arr addObject:info];
    }
//    NSLog(@"%@",arr);
    [_infoArray removeAllObjects];
    self.infoArray=[NSMutableArray arrayWithArray:arr];
    
//    [infoArray addObjectsFromArray:array];
//    infoArray=[[NSMutableArray alloc]initWithArray:arr];
    if (_infoArray.count>0) {
        moreLabel.text=@"获取更多";
        _infoTable.hidden=NO;
        
    }else{
        moreLabel.text=@"获取更多";
        _infoTable.hidden=YES;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有消息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [_infoTable reloadData];
    if (array.count<[PAGENUMBER intValue]) {
        isRuqest=NO;
        _totalPage= _currentPage;
        moreLabel.text=@"没有更多消息";
    }else{
//        moreLabel.text=@"加载更多";
    }
    [self stopAnimating];
//    NSLog(@"==========================%d",infoArray.count);
    
    [array release];
    [arr release];
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
    _infoTable.userInteractionEnabled=YES;
    [_indcatorView dimissIndicator];
    
}

//网络请求返回的方法
//-(void)ASIRequestFinished:(NSString *)requestResult{
//    _reloading=NO;
//    //    NSLog(@"%@",requestResult);
//    NSDictionary *responseDict = [requestResult objectFromJSONString];
////    NSLog(@"%@",responseDict);
//    NSArray *arr=[responseDict objectForKey:@"root"];
//    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0 ];
//    for (NSDictionary *dic in arr) {
//        ASInfoListDeatail *info=[[ASInfoListDeatail alloc]init];
//        NSString *ids=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
//        if ([ids isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
//            ids=@"";
//        }
//        info.ids=ids;
//        NSString *imageURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"imageURL"]];
//        if ([imageURL isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
//            imageURL=@"";
//        }
//        info.imageURL=imageURL;
//        NSString *name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
//        if ([name isEqualToString:@"<null>"]||[name isEqualToString:@""]) {
//            name=@"";
//        }
//        info.title=name;
//        NSString *businessId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessId"]];
//        if ([businessId isEqualToString:@"<null>"]||[businessId isEqualToString:@""]) {
//            businessId=@"";
//        }
//        info.businessId= businessId;
//         NSString *changed=[NSString stringWithFormat:@"%@",[dic objectForKey:@"changed"]];
//        if ([changed isEqualToString:@"<null>"]||[changed isEqualToString:@""]) {
//            changed=@"";
//        }
//        info.changed=changed;
//        NSString *content=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
//        if ([content isEqualToString:@"<null>"]||[content isEqualToString:@""]) {
//            content=@"";
//        }
//        info.content=content;
//
//        NSString *createTime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
//        if ([createTime isEqualToString:@"<null>"]||[createTime isEqualToString:@""]) {
//            createTime=@"";
//        }
//        info.createTime=createTime;
//        NSString *start=[NSString stringWithFormat:@"%@",[dic objectForKey:@"startTime"]];
//        if ([start isEqualToString:@"<null>"]||[start isEqualToString:@""]) {
//            info.startTime=@"";
//        }else{
//            info.startTime=start;
//        }
//       NSString *end=[NSString stringWithFormat:@"%@",[dic objectForKey:@"endTime"]];
//      if ([end isEqualToString:@"<null>"]||[end isEqualToString:@""]) {
//            info.endTime=@"";
//        }else{
//            info.endTime=end;
//        }
//        
//        NSString *visible=[NSString stringWithFormat:@"%@",[dic objectForKey:@"visible"]];
//        if ([visible isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
//            visible=@"";
//        }
//        info.visible=visible;
//        info.isRead=@"1";
//        [array addObject:info];
//        [info release];
//    }
//    [ASGlobal saveInfoListToFile:array];
//    if (arr.count<[PAGENUMBER intValue]) {
//        isRuqest=NO;
//    }
//     [self fillIntoTable];
//    [array release];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
//
//}
//-(void)ASIRequestFailed:(NSString *)requestResult
//{
////    NSLog(@"%@",requestResult);
//    //    NSDictionary *responseDict = [requestResult objectFromJSONString];
//    //    //        NSLog(@"responseObject = %@", responseDict);
//     [self fillIntoTable];
//    _reloading=NO;
////    moreLabel.text=@"加载更多";
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
//    
//}

//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *string = [request responseString];
    _reloading=NO;
    //    NSLog(@"%@",requestResult);
    NSDictionary *responseDict = [string objectFromJSONString];
//       NSLog(@"%@",responseDict);
    NSArray *arr=[responseDict objectForKey:@"root"];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0 ];
    for (NSDictionary *dic in arr) {
        ASInfoListDeatail *info=[[ASInfoListDeatail alloc]init];
        NSString *ids=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        if ([ids isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
            ids=@"";
        }
        info.ids=ids;
        NSString *imageURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"imageURL"]];
        if ([imageURL isEqualToString:@"<null>"]||[ids isEqualToString:@""]) {
            imageURL=@"";
        }
        info.imageURL=imageURL;
        NSString *name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        if ([name isEqualToString:@"<null>"]||[name isEqualToString:@""]) {
            name=@"";
        }
        info.title=name;
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
        
        NSString *visible=[NSString stringWithFormat:@"%@",[dic objectForKey:@"visible"]];
        if ([visible isEqualToString:@"<null>"]||[visible isEqualToString:@""]) {
            visible=@"";
        }
        info.visible=visible;
        info.isRead=@"1";
        [array addObject:info];
        [info release];
    }
//    NSLog(@"%@",array);
    [ASGlobal saveInfoListToFile:array];
    if (arr.count<[PAGENUMBER intValue]) {
        isRuqest=NO;
    }
    [self fillIntoTable];
    [array release];
     [self doneLoadingTableViewData];

}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
    if (_currentPage>1) {
        _currentPage--;
    }
    //    NSLog(@"%@",requestResult);
    //    NSDictionary *responseDict = [requestResult objectFromJSONString];
    //    //        NSLog(@"responseObject = %@", responseDict);
    [self fillIntoTable];
    _reloading=NO;
    //    moreLabel.text=@"加载更多";
     [self doneLoadingTableViewData];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    //    NSLog(@"失败咯!!!!!");
}


@end
