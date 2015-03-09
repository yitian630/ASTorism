//
//  ASdistanceChooseView.m
//  ASTourism
//
//  Created by apple  on 13-8-14.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASdistanceChooseView.h"

@interface ASdistanceChooseView ()

@end

@implementation ASdistanceChooseView
@synthesize delegate;
@synthesize image1,image2,image3,image4;
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
-(void)dealloc{

    [super dealloc];
    [image3 release];
    [image2 release];
    [image1 release];
   
}
-(IBAction)click:(id)sender{
    UIButton *button=(UIButton *)sender;
    switch (button.tag) {
        case 0:
            image1.image=[UIImage imageNamed:@"julixuanzhong.png"];
            image2.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image3.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image4.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            [self.delegate distanceChoose:@"500"];
            break;
        case 1:
            image1.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image2.image=[UIImage imageNamed:@"julixuanzhong.png"];
            image3.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image4.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            [self.delegate distanceChoose:@"1000"];
            break;
        case 2:
            image1.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image2.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image3.image=[UIImage imageNamed:@"julixuanzhong.png"];
            image4.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            [self.delegate distanceChoose:@"2000"];
            break;
        case 3:
            image1.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image2.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image3.image=[UIImage imageNamed:@"juliweixuanzhong.png"];
            image4.image=[UIImage imageNamed:@"julixuanzhong.png"];
            
            [self.delegate distanceChoose:@""];
            break;
 
        default:
            break;
    }
}

@end
