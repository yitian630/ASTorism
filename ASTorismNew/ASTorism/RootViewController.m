//
//  RootViewController.m
//  testCustomTabbar
//
//  Created by akria.king on 13-4-12.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "RootViewController.h"
#import "AOTabbarView.h"
#import "UIDevice+Resolutions.h"
#import "ASGlobal.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
//    [tabbar release];
//    [viewArr release];
//    [informationNC release];
//    [nearNC release];
//    [recommandNC release];
//    [settingNC release];
}
- (void)viewDidLoad
{
    
    self.view.backgroundColor=[UIColor blackColor];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.frame=CGRectMake(0, 0,SCREENWIDTH,SCREENHEIGHT);
    
//    viewArr =[[NSMutableArray alloc]init];
//    tabbar = [[AOTabbarView alloc]initWithIconNumber:4  messArr:nil];
//    tabbar.aoDelegate=self;
      [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIButton *button =[[UIButton alloc]init];
    button.tag=1;
    [[ASGlobal getAOTabbarView] switchButton:button];
    
    [button release];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#pragma AOTabbar Delegate
//-(void)switchButton:(int)btnTag{
////    switch (btnTag) {
////        case 1:
////            if (!recommandVC) {
////                recommandVC = [[ASRecommandViewController alloc]initWithNibName:@"ASRecommandViewController" bundle:nil];
////            }
////            [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
////            [[ASGlobal getNavigationController]pushViewController:recommandVC animated:NO];
////            
////            break;
////        case 2:
////            if (!nearVC) {
////                recommandVC = [[ASRecommandViewController alloc]initWithNibName:@"ASRecommandViewController" bundle:nil];
////            }
////            [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
////            [[ASGlobal getNavigationController]pushViewController:recommandVC animated:NO];
////            
////            break;
////        case 3:
////            
////            if (!infoVC) {
////            recommandVC = [[ASRecommandViewController alloc]initWithNibName:@"ASRecommandViewController" bundle:nil];
////        }
////              [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
////            [[ASGlobal getNavigationController]pushViewController:recommandVC animated:NO];
////    
////           break;
////        case 4:
////            if (!nearVC) {
////                recommandVC = [[ASRecommandViewController alloc]initWithNibName:@"ASRecommandViewController" bundle:nil];
////            }
////            [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
////            [[ASGlobal getNavigationController]pushViewController:recommandVC animated:NO];
////            
////            break;
////        default:
////            break;
////    }
////    
////    [self showView:btnTag];
//}
//
//-(void)showView:(int)checkId{
//    UIView *view =nil;
//    for (int i=0; i<viewArr.count; i++) {
//       view = [viewArr objectAtIndex:i];
//        if (checkId==view.tag) {
//            view.hidden=NO;
//        }else{
//            view.hidden=YES;
//        }
//        
//    }
//     view=nil;
//   [view release];
//}

@end
