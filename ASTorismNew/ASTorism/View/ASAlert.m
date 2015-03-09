
//
//  ASAlert.m
//  ASBestLife
//
//  Created by apple  on 13-7-18.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASAlert.h"

#define X2  30
#define Y2  150
#define WIDTH2 230
#define HEIGHT2 100
CGPoint center;
@interface ASAlert ()
{
    UIImageView *imageView;
    NSTimer *myTimer;
    UILabel *AStitle;
    UILabel *ASSubTitle;
}
//销毁视图
-(void) dismissAlert;
@end

@implementation ASAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) dealloc
{
    [imageView release];
    [AStitle release];
    [ASSubTitle release];
    [myTimer release];
     [super dealloc];
}
-(id) init:(NSString *)title SUBTITLE:(NSString *)subTitle 
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    center.x = self.frame.size.width/2;
    center.y = self.frame.size.height/2;
    self.backgroundColor=[UIColor clearColor];

  
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(center.x-WIDTH2/2, center.y-HEIGHT2/2, WIDTH2, HEIGHT2)];
    imageView.image=[UIImage imageNamed:@"友情提示.png"];
    imageView.alpha=1.0;
    [self addSubview:imageView];
    
    /*
     定义标题label
     */
     AStitle=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x,imageView.frame.origin.y+14, imageView.frame.size.width, 26)];
    if (title!=nil&&title.length>0) {
         AStitle.text=title;
    }
    else{
    AStitle.text=@"提示";
    }
    AStitle.font=[UIFont fontWithName:@"Helvetica" size:15];
    [AStitle setBackgroundColor:[UIColor clearColor]];
    AStitle.textAlignment= UITextAlignmentCenter;//居中
    //自动换行
    AStitle.lineBreakMode= UILineBreakModeWordWrap;
    AStitle.numberOfLines= 0;
    AStitle.textColor=[UIColor whiteColor];
    [self addSubview:AStitle];
    
    /*
     自定副标题label
     */
    ASSubTitle=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+10,imageView.frame.origin.y+30,imageView.frame.size.width-20, 60)];
    ASSubTitle.text=subTitle;
    ASSubTitle.font=[UIFont fontWithName:@"Helvetica" size:15];
    [ASSubTitle setBackgroundColor:[UIColor clearColor]];
    ASSubTitle.textColor=[UIColor whiteColor];
    ASSubTitle.textAlignment= UITextAlignmentCenter;//居中
    //自动换行     
    ASSubTitle.lineBreakMode= UILineBreakModeWordWrap;
    ASSubTitle.numberOfLines= 0;
    [self addSubview:ASSubTitle];
    AStitle.hidden=YES;
    ASSubTitle.hidden=YES;
    
       return self;
}
//显示弹出视图
-(void) showAlert:(float)time
{
//    [UIApplication sharedApplication].keyWindow.alpha=0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    imageView.frame=CGRectMake(center.x, center.y, 0, 0);
    [UIView animateWithDuration:0.3 animations:^{
    imageView.frame=CGRectMake(center.x-WIDTH2/2, center.y-HEIGHT2/2, WIDTH2, HEIGHT2);
    } completion:^(BOOL finished){
        AStitle.hidden=NO;
        ASSubTitle.hidden=NO;
    }];
    
      myTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(dismissAlert) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];//放入自动释放池中
        
}

//销毁视图
-(void) dismissAlert
{   
    if ([myTimer isValid]) {
        [myTimer invalidate];
        myTimer = nil;
    }
    [self removeFromSuperview];
}

@end
