//
//  ASSetViewController.m
//  ASTourism
//
//  Created by apple  on 13-8-13.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASSetViewController.h"
#import "ASAboutViewController.h"
#import "ASFeedbackViewController.h"
#import "ASGlobal.h"
#import "UIDevice+Resolutions.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "AGCustomShareViewController.h"

@interface ASSetViewController ()
{
    NavigationBar *navBar;
    IBOutlet UIImageView *usBackImage;
    IBOutlet UIView *usBackView;
    IBOutlet UIImageView *feedBackImage;
    IBOutlet UIView *feedBackView;
    IBOutlet UIImageView *deleteBackImage;//清空按钮背景
    IBOutlet UIView *deleteBackView;
    IBOutlet UIImageView *shareImageView;
    IBOutlet UIView *shareBackView;
    IBOutlet UILabel *us;
    IBOutlet UILabel *feedBack;
    IBOutlet UILabel *delete;
}
-(IBAction)aboutUsClick:(id)sender;//关于我们
-(IBAction)feedbackClick:(id)sender;//意见反馈
-(IBAction)click:(id)sender;
-(IBAction)clickCancel:(id)sender;//取消点击
//清空缓存
-(IBAction)deleteClick:(id)sender;

//分享
-(IBAction)shareClick:(id)sender;

@end

@implementation ASSetViewController

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
    
       
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{

    [usBackView release];
    [feedBackView release];
    [deleteBackView release];
    [shareBackView release];
    [super dealloc];
//    [navBar release];
    [usBackImage release];
    [feedBackImage release];
}
-(void)viewWillAppear:(BOOL)animated{
    [ASGlobal showAOTabbar];//显示tabbar
    //设置导航栏并适配
    [self setNavBar];
    [self Adaptation];
    [super viewWillAppear:YES];
}
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

    navBar.titleLabel.text=@"设置";
    
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
  
    if ([UIDevice systemMajorVersion] < 7) {
        NSLog(@"iphone4");
        feedBackView.frame=CGRectMake(feedBackView.frame.origin.x, 132, feedBackView.frame.size.width, 50);
        usBackView.frame=CGRectMake(usBackView.frame.origin.x, 62, usBackView.frame.size.width, 50);
        deleteBackView.frame=CGRectMake(deleteBackView.frame.origin.x, 202, deleteBackView.frame.size.width, 50);
        shareBackView.frame = CGRectMake(shareBackView.frame.origin.x, 272, shareBackView.frame.size.width, 50);
    }else{
        NSLog(@"iphone5");
        feedBackView.frame=CGRectMake(feedBackView.frame.origin.x, 152, feedBackView.frame.size.width, 50);
         usBackView.frame=CGRectMake(usBackView.frame.origin.x, 82, usBackView.frame.size.width, 50);
         deleteBackView.frame=CGRectMake(deleteBackView.frame.origin.x, 222, deleteBackView.frame.size.width, 50);
        shareBackView.frame = CGRectMake(shareBackView.frame.origin.x, 292, shareBackView.frame.size.width, 50);
        
    }
   
}
//关于我们
-(IBAction)aboutUsClick:(id)sender{
    NSLog( @"关于我们 ");
    [us setTextColor:[UIColor blackColor]];
        ASAboutViewController *aboutUs=[[ASAboutViewController alloc]initWithNibName:@"ASAboutViewController" bundle:nil];
    [self.navigationController pushViewController:aboutUs animated:YES];
    [aboutUs release];
    usBackImage.image=[UIImage imageNamed:@"shezhikuang.png"];

}
//意见反馈
-(IBAction)feedbackClick:(id)sender{
 NSLog( @"意见反馈 ");
   
    [feedBack setTextColor:[UIColor blackColor]];
    ASFeedbackViewController *feedBackVC=[[ASFeedbackViewController alloc]initWithNibName:@"ASFeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:feedBackVC animated:YES];
    [feedBackVC release];
     feedBackImage.image=[UIImage imageNamed:@"shezhikuang.png"];
}
//清空缓存
-(IBAction)deleteClick:(id)sender{
    //清空缓存图片
//    [ASGlobal remvoeImageCacheForUrlImageView];
    
    [delete setTextColor:[UIColor blackColor]];
   BOOL isFinished= [ASGlobal deleteInfoFromFile];
    if (isFinished) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存已清空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    deleteBackImage.image=[UIImage imageNamed:@"shezhikuang.png"];
}

//toudown
-(IBAction)click:(id)sender{
    UIButton *button=(UIButton *)sender;
    
    if (button.tag==0)
    {
        usBackImage.image=[UIImage imageNamed:@"shezhixuanzhong.png"];
    }
    else if (button.tag==1)
    {
        feedBackImage.image=[UIImage imageNamed:@"shezhixuanzhong.png"];
    }
    else if (button.tag==2)
    {
        deleteBackImage.image=[UIImage imageNamed:@"shezhixuanzhong.png"];
    }
    else
    {
        shareImageView.image=[UIImage imageNamed:@"shezhixuanzhong.png"];
    }
}
//取消点击
-(IBAction)clickCancel:(id)sender
{
   usBackImage.image=[UIImage imageNamed:@"shezhikuang.png"];
    deleteBackImage.image=[UIImage imageNamed:@"shezhikuang.png"];
    feedBackImage.image=[UIImage imageNamed:@"shezhikuang.png"];
    shareImageView.image=[UIImage imageNamed:@"shezhikuang.png"];
}

#pragma mark - Share

//分享
-(IBAction)shareClick:(id)sender
{
    shareImageView.image=[UIImage imageNamed:@"shezhikuang.png"];
    
    //创建分享内容
    UIImage *shareImage = [UIImage imageNamed:@"icon228.png"];
    //    UIImage *shareImage = [UIImage imageNamed:@"atButton.png"];
    //UIImage *shareImage = [UIImage imageNamed:@"sharesdk_img.jpg"];
    id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                       defaultContent:nil
                                                image:[ShareSDK jpegImageWithImage:shareImage quality:0.8]
                                                title:@"ShareSDK"
                                                  url:SHARE_URL
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这时一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    //定制短信信息
    [publishContent addSMSUnitWithContent:INHERIT_VALUE];
    //定制邮件信息
    [publishContent addMailUnitWithSubject:@"慧游天下"
                                   content:INHERIT_VALUE
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:NSLocalizedString (@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
                                             url:SHARE_URL
                                      thumbImage:[ShareSDK imageWithUrl:@"http://122.0.66.43:8080/yhkj/uploadFiles/huiyou114.png"]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:INHERIT_VALUE
                                            title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
                                              url:INHERIT_VALUE
                                       thumbImage:[ShareSDK imageWithUrl:@"http://122.0.66.43:8080/yhkj/uploadFiles/huiyou114.png"]
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制新浪微博信息
    [publishContent  addSinaWeiboUnitWithContent: CONTENT
                                           image: nil];
    
    //定制腾讯微博信息
    [publishContent addTencentWeiboUnitWithContent: CONTENT
                                             image: nil];
    
    //定制分享内容
    
    id clickHandler = ^{
        AGCustomShareViewController *vc = [[[AGCustomShareViewController alloc] initWithImage:shareImage content:CONTENT] autorelease];
        UINavigationController *naVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
        
        [self presentModalViewController:naVC animated:YES];
    };
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                     clickHandler:clickHandler],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                     clickHandler:clickHandler],
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          nil];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:YES
                                                        shareViewDelegate:_appDelegate.viewDelegate
                                                      friendsViewDelegate:_appDelegate.viewDelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    //隐藏tabbar
    //    [ASGlobal hiddenBottomMenuView];
    
    
}

@end
