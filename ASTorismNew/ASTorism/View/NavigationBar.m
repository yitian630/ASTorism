//
//  NavigationBar.m
//  iFootPrint
//
//  Created by tyc on 13-1-16.
//  Copyright (c) 2013年 tyc. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar
@synthesize  Delegate;
@synthesize BackButton;
@synthesize cityButton;
@synthesize titleLabel;
@synthesize searchButton;
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

-(IBAction)BackButtonClick:(id)sender{
    [self.Delegate NavBarBackClick];
}
-(IBAction)CityButtonClick:(id)sender{
    [self.Delegate NavCityButtonClick];
}
-(IBAction)SearButtonClick:(id)sender{
 [self.Delegate NavSearchButtonClick];
}
@end
