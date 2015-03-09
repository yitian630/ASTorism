//
//  ASGuideViewController.m
//  ASBestLife
//
//  Created by Jill on 13-7-10.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASGuideViewController.h"
#import "UIDevice+Resolutions.h"
#import "ASAlert.h"
@interface ASGuideViewController ()

@end

@implementation ASGuideViewController

@synthesize animating = _animating;
@synthesize pageScroll = _pageScroll;
@synthesize nextViewController;

#pragma mark - View Controller Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray;
    if ([UIDevice isRunningOniPhone5])
    {
        imageNameArray = [NSArray arrayWithObjects:@"1.引导页.png", @"2.引导页.png", @"3.引导页.png", nil];
    }
    else
    {
        NSLog(@"sRunningOniPhone4");
        imageNameArray = [NSArray arrayWithObjects:@"引导页1.png", @"引导页2.png", @"引导页3.png", nil];
    }
    
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.bounces = NO;
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
    
    [self.view addSubview: self.pageScroll];
    
    NSString *imgNameStr = nil;
    UIImageView *imageView;
    for (int i = 0; i < imageNameArray.count; i++)
    {
        imgNameStr = [imageNameArray objectAtIndex:i];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = [UIImage imageNamed: imgNameStr];
        
        [self.pageScroll addSubview: imageView];
        
        //引导页面最后一页
        if (i == imageNameArray.count - 1)
        {
            UIButton *enterButton = [UIButton buttonWithType: UIButtonTypeCustom];
            
            if ([UIDevice isRunningOniPhone5])
            {
                enterButton.frame = CGRectMake(55,280,210,180);
            }
            else
            {
                enterButton.frame = CGRectMake(55,280,210,180);
            }
            
            enterButton.backgroundColor = [UIColor clearColor];
            
            [enterButton addTarget: self
                            action: @selector(pressEnterButton:) 
                  forControlEvents: UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview: enterButton];
            
        }
        [imageView release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_pageScroll release];
    
    [super dealloc];
}
#pragma mark - Screen Frame

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

#pragma mark - Button Click

- (void)pressEnterButton:(UIButton *)enterButton
{

    if([[UIApplication sharedApplication] isIgnoringInteractionEvents]==TRUE)
    {
        [self performSelector:@selector(presentModalViewController:animated:) withObject:nextViewController afterDelay:1];
    }
    else
    {
        [self presentModalViewController: nextViewController
                                animated: YES];
    }   
}


@end

