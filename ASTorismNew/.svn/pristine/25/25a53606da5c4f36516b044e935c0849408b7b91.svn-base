//
//  ASPushInfoViewController.m
//  ASTorism
//
//  Created by apple  on 13-9-20.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASPushInfoViewController.h"
#import "UIDevice+Resolutions.h"
#import "ASGlobal.h"
//#import "UrlImageView.h"
#import "UIImageView+AFNetworking.h"
@interface ASPushInfoViewController ()
{
   NavigationBar *navBar;
    IBOutlet UITextView *infoTextView;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIImageView *yuanjiaozhong;
    IBOutlet UIImageView *yuanjiaoxia;
    IBOutlet UIImageView *infoImage;
}

@end

@implementation ASPushInfoViewController
@synthesize pushInfoStr=_pushInfoStr;
@synthesize time=_time;
@synthesize imageUrl=_imageUrl;
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
    navBar.BackButton.hidden=NO;
    navBar.backImage.hidden=NO;
    navBar.searchImage.hidden=YES;
    navBar.cityButton.hidden=YES;
    navBar.cityImage.hidden=YES;
    
    navBar.titleLabel.text=@"消息";
    [self.view addSubview:navBar];
}
#pragma navigationBarDelegate
-(void)NavSearchButtonClick{
}
-(void)NavCityButtonClick{
}
-(void)NavBarBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Adaptation 适配
-(void)Adaptation{

    NSString *date=[_time substringWithRange:NSMakeRange(0, 10)];
    NSString *Time=[_time substringWithRange:NSMakeRange(11, _time.length-11)];
    timeLabel.text=[NSString stringWithFormat:@"%@ %@",date,Time];
    
    infoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiaoxi.png"]];
    infoImage.frame=CGRectMake(0, 62, 320, 11);
    [self.view addSubview:infoImage];
    if (nil!=_imageUrl&&_imageUrl.length>0&&![_imageUrl isEqualToString:@""]&&![_imageUrl isEqualToString:@"<null>"]) {
        //有图片
        infoTextView.frame=CGRectMake(infoTextView.frame.origin.x, 235, infoTextView.frame.size.width, 205);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 130, 280, 95)];
        //            imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.backgroundColor=[UIColor clearColor];
        NSString *strImgURL=[[NSString alloc]initWithFormat:@"%@%@",IMAGEURL,_imageUrl ];
        [imageView setImageWithURL:[NSURL URLWithString:strImgURL]placeholderImage:nil];
        [self.view addSubview:imageView];
        [imageView release];
        [strImgURL release];

    }
//    NSLog(@"%@",_pushInfoStr);
    infoTextView.text=_pushInfoStr;
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
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_imageUrl release];
    [_time release];
    [timeLabel release];
    [infoTextView release];
    [yuanjiaozhong release];
//    [navBar release];
    [_pushInfoStr release];
    [yuanjiaoxia release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [ASGlobal hiddenBottomMenuView];
    [self.view setBackgroundColor:COLORFROMCODE(0xf6f6f6,1.0)];
    
    //设置导航栏并适配
    [self setNavBar];
    [self Adaptation];
}
//得到消息
-(void)InfoAlert{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您收到一条新通知！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.tag=101;
    [alert show];
    [alert release];
}


@end
