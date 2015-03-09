//
//  slideView.m
//  testScrollViewViewController
//
//  Created by apple  on 13-8-16.
//  Copyright (c) 2013年 imac . All rights reserved.
//

#import "slideView.h"
//#import "UrlImageView.h"
#import "UIImageView+AFNetworking.h"
@interface slideView (){
 
  NSTimer *timer;//滚动的时间
}
@property (retain,nonatomic)UIScrollView *scrollView;

@property (retain,nonatomic)UIPageControl *pageControl;
@end

@implementation slideView
@synthesize scrollView=_scrollView;
@synthesize  slideImages=_slideImages;
@synthesize delegate=_delegate;
@synthesize pageControl=_pageControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [_scrollView release];
    [_slideImages release];

    [_pageControl release];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void)initScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame ;{
    
    // 初始化 scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    // 初始化 pagecontrol
    _pageControl = [[UIPageControl alloc]initWithFrame:pageCFrame]; // 初始化mypagecontrol
    //    添加颜色只能在ios6上使用
    //    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    //    [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    _pageControl.numberOfPages = [_slideImages count];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self addSubview:_pageControl];
    // 创建四个图片 imageview
    for (int i = 0;i<[_slideImages count];i++)
    {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((320 * i) + 320, 0, scrollFrame.size.width, scrollFrame.size.height)];
//        [image setImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        image.backgroundColor=[UIColor clearColor];
        [image setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:i]]placeholderImage:nil];

        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake((320 * i) + 320, 0, scrollFrame.size.width, scrollFrame.size.height)];
        [button addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
//        [button setBackgroundImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTag:i];
        [_scrollView addSubview:image];
        [_scrollView addSubview:button]; // 首页是第0页,默认从第1页开始的。所以+320。。。
        [button release];
        [image release];
    }
    // 取数组最后一张图片 放在第0页
    
    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height)];
    image1.backgroundColor=[UIColor clearColor];
    [image1 setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:([_slideImages count]-1)]]placeholderImage:nil];
    
    UIButton *button1=[[UIButton alloc]initWithFrame: CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height)];
    [button1 addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];

    [button1 setTag:[_slideImages count]-1];
    [_scrollView addSubview:image1];
    [_scrollView addSubview:button1]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    [button1 release];
    [image1 release];
    
     // 取数组第一张图片 放在最后1页
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake((320 * ([self.slideImages count] + 1)) , 0, scrollFrame.size.width, scrollFrame.size.height)];
    image2.backgroundColor=[UIColor clearColor];
    [image2 setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:0]]placeholderImage:nil];
    UIButton *button2=[[UIButton alloc]init];
   
    button2.frame=CGRectMake((320 * ([self.slideImages count] + 1)) , 0, scrollFrame.size.width, scrollFrame.size.height);// 添加第1页在最后 循环
    [button2 setTag:0];
    [_scrollView addSubview:image2];
    [_scrollView addSubview:button2];
    [button2 release];
     [image2 release];
    
    [_scrollView setContentSize:CGSizeMake(320 * ([_slideImages count] + 2), scrollFrame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(320,0,scrollFrame.size.width,scrollFrame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
}
/*-(void)startSlide:(NSInteger)time
 *参数：滑动的时间(NSInteger)time
 *控制视图滑动的开始
 *无返回值
 */
-(void)startSlide:(NSInteger)time{
    // 定时器 循环
    timer= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}
/*-(void)endSlide
 *参数：无参数
 *控制视图滑动的结束
 *无返回值
 */
-(void)endSlide{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
//    CGFloat pagewidth = self.scrollView.frame.size.width;
//    int page = floor((self.scrollView.contentOffset.x - pagewidth/([_slideImages count]+2))/pagewidth)+1;
//    page --;  // 默认从第二页开始
//    _pageControl.currentPage = page;
    
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([_slideImages count]+2)) / pagewidth) + 1;
    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    _pageControl.currentPage=currentPage_-1;
   
    if (currentPage==0)
    {
        //手动滑到最后一页
        _pageControl.currentPage=[_slideImages count]-1;
        [self.scrollView scrollRectToVisible:CGRectMake(0,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 序号0 最后1页
     
        [self.scrollView scrollRectToVisible:CGRectMake(320 * [_slideImages count],0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];       
    }
    else if (currentPage==([_slideImages count]+1))
    {
        //手动滑到第一页
        _pageControl.currentPage=0;
        [self.scrollView scrollRectToVisible:CGRectMake(320,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = _pageControl.currentPage; // 获取当前的page
    [self.scrollView scrollRectToVisible:CGRectMake(320*(page+1),0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1

}
//循环时跳转到第一页
-(void)turnFirstPage{
 [self.scrollView scrollRectToVisible:CGRectMake(320*1,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
//    _pageControl.currentPage=0;
}
//跳转到最后一页的下一页
-(void)turnNextPage{
    _pageControl.currentPage=0;
    [UIView animateWithDuration:0.3 animations:^{
         [self.scrollView scrollRectToVisible:CGRectMake(320*([_slideImages count]+1),0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
    } completion:^(BOOL finished){
        [self turnFirstPage];
    }];
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = _pageControl.currentPage; // 获取当前的page

        page++;
    //判断是否已到最后一页实现循环
    if (page==[_slideImages count]) {
        _pageControl.currentPage=0;
//        page=0;
        [self turnNextPage];
        
    }else{
        _pageControl.currentPage = page ;
        [self turnPage];
    }
//    page = page > _slideImages.count-1? 0 : page ;
}
//button  点击事件
-(void)imageClick:(id)sender{
    UIButton *button=(UIButton *)sender;
    NSLog(@"wobeidianle=====tag==%d",button.tag);
    [self.delegate whichOneIsSelected:button.tag];
}




@end
