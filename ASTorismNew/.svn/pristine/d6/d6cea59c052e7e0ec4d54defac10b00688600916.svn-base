//
//  ASActivityIndcatorView.m
//  ASBestLife
//
//  Created by csl on 13-7-8.
//  Copyright (c) 2013年 FireflySoftware. All rights reserved.
//

#import "ASActivityIndcatorView.h"
#define X  20
#define Y  150
#define WIDTH 67
#define HEIGHT 67

@interface ASActivityIndcatorView()

@property(nonatomic,retain) UILabel * infoLabel;
@property(nonatomic,retain) UIImageView * background;

@end

@implementation ASActivityIndcatorView
@synthesize indicatorFrame = _indicatorFrame;
@synthesize actIndicator = _actIndicator;
@synthesize infoLabel = _infoLabel;
@synthesize background = _background;

-(void) dealloc
{
    [_indicatorFrame release];
    [_actIndicator release];
    [_infoLabel release];
    [_background release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    self.center =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //设置alert的背景
        _indicatorFrame = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-WIDTH)/2, (self.frame.size.height-HEIGHT)/2, WIDTH, HEIGHT)];
        //[_indicatorFrame setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"activityBackground.png"]]];
        [self addSubview:_indicatorFrame];
        
        _background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _background.image = [UIImage imageNamed:@"activityBackground.png"];
        [_indicatorFrame addSubview:_background];
        
        _actIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((WIDTH-37)/2.0,(HEIGHT-37)/2.0, 37, 37)];
        _actIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [_indicatorFrame addSubview:_actIndicator];
        
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.center = CGPointMake(_indicatorFrame.frame.size.width/2, _actIndicator.frame.origin.y + _actIndicator.frame.size.height + 15);
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = [UIFont boldSystemFontOfSize:15];
        _infoLabel.backgroundColor = [UIColor clearColor];
        [_indicatorFrame addSubview:_infoLabel];
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

-(void)setShowInfo:(NSString *)showInfo
{
    if (!self.infoLabel.text) {
        if (showInfo) {
            _background.frame = CGRectMake(_background.frame.origin.x-10, _background.frame.origin.y, _background.frame.size.width+20, _background.frame.size.height + 20);
        }
    }else
    {
        if (!showInfo) {
            _background.frame = CGRectMake(_background.frame.origin.x+10, _background.frame.origin.y, _background.frame.size.width-20, _background.frame.size.height - 20);
        }
    }
    self.infoLabel.text = showInfo;
}

-(void) showIndicator //风火轮转动
{
    [_actIndicator startAnimating];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}
-(void) dimissIndicator //隐藏风火轮
{
    [self removeFromSuperview];
}
@end
