//
//  ASAboutViewController.m
//  ASBestLife
//
//  Created by apple  on 13-7-17.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASAboutViewController.h"
#import "UIDevice+Resolutions.h"
#import "ASGlobal.h"




@interface ASAboutViewController ()
{
//    IBOutlet  UIImageView *backImage;
//    IBOutlet UIImageView *logoImage;
//    IBOutlet UIImageView *logoBack;
//    IBOutlet  UIImageView *bestLifeImage;
//    IBOutlet  UILabel *versionLabel;
//    IBOutlet  UILabel *version;
//    IBOutlet  UILabel *MailBoxLabel;
//    IBOutlet  UILabel *mail;
//    IBOutlet  UILabel *telephoneLabel;
    IBOutlet UILabel *telephone;
//    IBOutlet  UILabel *officialWebsiteLabel;
    IBOutlet  UILabel *officialWebsite;
//    IBOutlet  UILabel *Remind;
//    IBOutlet UIButton *telButton;
//    IBOutlet UIButton *urlButton;
//    IBOutlet UIView *telLine;
//    IBOutlet UIView *officialWebsiteLine;
    IBOutlet UIScrollView *scrollView;
    NavigationBar *navBar;
}

/**
 *拨打电话点击
 */
- (IBAction)callPhone:(id)sender;
/**
 *打开官网
 */
- (IBAction)openUrl:(id)sender;

@end

@implementation ASAboutViewController


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
    navBar.titleLabel.text=@"关于我们";
    
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }else
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
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
    
//    if ([UIDevice isRunningOniPhone5]) {
//        scrollView.frame=CGRectMake(0, 44, 320, 504);
//    }else{
//        NSLog(@"iphone4");
//        scrollView.frame=CGRectMake(0, 44, 320, 416);
//    }
//    [scrollView setContentSize:CGSizeMake(320,656)];
 
    CGRect rect;
    [self setNavBar];
    if ([UIDevice systemMajorVersion] < 7.0) {
        NSLog(@"iphone4");
        //self.view.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44);
        rect=CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-44);
    }else{
        NSLog(@"iphone5");
        //self.view.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
        rect=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    }
    [scrollView setContentSize:CGSizeMake(320,656)];
    scrollView.frame=rect;
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
    
    [self setNavBar];
    [self Adaptation];
}
-(void)viewDidAppear:(BOOL)animated{
    [self setNavBar];
    [self Adaptation];
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
[ASGlobal hiddenBottomMenuView];//隐藏tabbar
    [self setNavBar];
    [self Adaptation];
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *拨打电话点击
 */
- (IBAction)callPhone:(id)sender
{
    NSString *phoneNum = [NSString stringWithFormat:@"tel://%@",telephone.text];
    NSURL *phoneUrl = [NSURL URLWithString:phoneNum];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}
/**
 打开官网
 */
-(IBAction)openUrl:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",officialWebsite.text]]];

}
-(void)dealloc{
    [super dealloc];
//    [navBar release];
    [scrollView release];
//    [backImage release];
//    [logoImage release];
//    [logoBack release];
//   [bestLifeImage release];
//   [versionLabel release];
//    [version release];
//    [MailBoxLabel release];
//    [mail release];
//    [telephoneLabel release];
//    [telephone release];
//   [officialWebsiteLabel release] ;
//    [officialWebsite release];
//    [Remind release];
//    [telButton release];;
//    [urlButton release];
}
@end
