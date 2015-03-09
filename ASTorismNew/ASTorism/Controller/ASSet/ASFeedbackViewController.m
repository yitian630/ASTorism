//
//  ASFeedbackViewController.m
//  ASBestLife
//
//  Created by Jill on 13-7-14.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ASFeedbackViewController.h"
#import "UIDevice+Resolutions.h"
#import "ASAlert.h"
#import "ASGlobal.h"
@interface ASFeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    NavigationBar *navBar;
}
//View Controller Life Cycle


//Control
- (void)dismissKeyboard;
-(void)submitFeedback;
@end

@implementation ASFeedbackViewController
@synthesize  backgroundmageView;
@synthesize  feedbackTextView;
@synthesize  indcatorView;
@synthesize button;
#pragma mark - View Controller Life Cycle
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
    navBar.titleLabel.text=@"意见反馈";
    //适配navBar
    if ([UIDevice systemMajorVersion] < 7) {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }else {
        navBar.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    }
        
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
    if ([UIDevice systemMajorVersion] < 7) {
        NSLog(@"iphone4");
        rect=CGRectMake(backgroundmageView.frame.origin.x, 64, backgroundmageView.frame.size.width, backgroundmageView.frame.size.height + 5);
    
    }else{
        NSLog(@"iphone5");
        rect=CGRectMake(backgroundmageView.frame.origin.x, 84, backgroundmageView.frame.size.width, backgroundmageView.frame.size.height + 5);
        
    }
    backgroundmageView.frame = rect;
    feedbackTextView.frame = CGRectMake(backgroundmageView.frame.origin.x, backgroundmageView.frame.origin.y, feedbackTextView.frame.size.width, feedbackTextView.frame.size.height);
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
    
   feedbackTextView.text = @"请提出您的宝贵的意见";
    
    //设置TextField的高度
    
       //添加单击键盘消失手势
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissKeyboard)];
//    [self.view addGestureRecognizer: tapGestureRecognizer];
//    
//    [tapGestureRecognizer release];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [ASGlobal hiddenBottomMenuView];//隐藏tabbar
    [self Adaptation];
     [self setNavBar];
 
    
    button=[[UIButton alloc]initWithFrame:CGRectMake(backgroundmageView.frame.origin.x, backgroundmageView.frame.origin.y + backgroundmageView.frame.size.height + 30, 280, 35)];//CGRectMake(23, 354, 275, 35)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"带我到.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitFeedback) forControlEvents:UIControlEventTouchUpInside];
    

    [self.view addSubview:button];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [self Adaptation];
    [self setNavBar];
    [self dismissKeyboard];
}
- (void)viewDidUnload
{
    [self setButton:nil];
    [self setBackgroundmageView:nil];
    [self setFeedbackTextView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [button release];
    [indcatorView release];
    [backgroundmageView release];
    [feedbackTextView release];
//    [request release];
    [super dealloc];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    feedbackTextView.text = @"";
    
    [UIView beginAnimations:@"repostion" context:nil];
    [UIView setAnimationDuration:0.5];
    feedbackTextView.frame =CGRectMake(backgroundmageView.frame.origin.x, backgroundmageView.frame.origin.y, feedbackTextView.frame.size.width, feedbackTextView.frame.size.height);
     backgroundmageView.frame =CGRectMake(backgroundmageView.frame.origin.x, backgroundmageView.frame.origin.y, backgroundmageView.frame.size.width, backgroundmageView.frame.size.height - 50) ;
    button.frame = CGRectMake(button.frame.origin.x, backgroundmageView.frame.origin.y + backgroundmageView.frame.size.height, button.frame.size.width, button.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{

    [UIView beginAnimations:@"repostion" context:nil];
    [UIView setAnimationDuration:0.5];
    feedbackTextView.frame =CGRectMake(backgroundmageView.frame.origin.x, backgroundmageView.frame.origin.y, feedbackTextView.frame.size.width, feedbackTextView.frame.size.height);
    backgroundmageView.frame =CGRectMake(backgroundmageView.frame.origin.x, backgroundmageView.frame.origin.y, backgroundmageView.frame.size.width, backgroundmageView.frame.size.height + 50) ;
    button.frame = CGRectMake(button.frame.origin.x, backgroundmageView.frame.origin.y + backgroundmageView.frame.size.height, button.frame.size.width, button.frame.size.height);
    
    
    [UIView commitAnimations];
}
#pragma mark - Control
- (void)dismissKeyboard
{
    [feedbackTextView resignFirstResponder];
}
//点击空白键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //如果是绑定手机按钮
    UITouch *touch = [touches anyObject];
    CGPoint p =[touch locationInView:self.view];
    
    
        if (p.y>44.0&&p.y<354.0) {
            [self dismissKeyboard];
            return;
        }
   
    
}

#pragma mark - Submit
-(void)submitFeedback{
     [feedbackTextView resignFirstResponder];
    if (nil!=feedbackTextView.text&&feedbackTextView.text.length>0) {
        //        [self showAlert:@"您的意见已发送成功！"];
        if (feedbackTextView.text.length>140) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"意见信息长度不能超过140！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else{
            if ([feedbackTextView.text isEqualToString:@"请提出您的宝贵的意见"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请提出您的宝贵的意见！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [alert release];

            }else{
                //开启加载动画
                [self startAnimating];
                NSDictionary *parametersDic=[[NSDictionary alloc]initWithObjectsAndKeys:feedbackTextView.text,@"content",nil];
//                NSLog(@"%@",parametersDic);
//                NSLog(@"%@",FEEDBACKURL);
                
                ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:FEEDBACKURL]];
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
        }
        
    }else{
        //        [self showAlert:@"反馈信息不能为空！"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"反馈信息不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

}
/*
 加载动画开始
 */
-(void)startAnimating{
    //加载动画
    
    if (nil == indcatorView)
    {
        indcatorView  = [[ASActivityIndcatorView alloc] init];
    }
    [indcatorView showIndicator];
    
}
/*
 加载动画结束
 */
-(void)stopAnimating{
    [indcatorView dimissIndicator];
}
//网络请求返回的方法
//-(void)ASIRequestFinished:(NSString *)requestResult{
//       NSLog(@"%@",requestResult);
//    [self stopAnimating];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:requestResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//}
//-(void)ASIRequestFailed:(NSString *)requestResult
//{
//    NSLog(@"%@",requestResult);
//    [self stopAnimating];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"连接服务器失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//    
//}
//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *string = [request responseString];
    NSLog(@"%@",string);
    //去掉字符串的 引号
    NSString *message = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    [self stopAnimating];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];

}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"%@",requestResult);
    [self stopAnimating];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"连接服务器失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}


@end
