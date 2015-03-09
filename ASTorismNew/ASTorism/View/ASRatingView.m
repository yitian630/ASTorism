//
//  RatingViewController.m
//  RatingController
//
//  Created by Jerome峻峰.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ASRatingView.h"

@implementation ASRatingView

@synthesize s1, s2, s3, s4, s5;
@synthesize unselectedImage;
@synthesize partlySelectedImage;
@synthesize fullySelectedImage;

- (void)dealloc {
	[s1 release];
	[s2 release];
	[s3 release];
	[s4 release];
	[s5 release];
    [unselectedImage release];
    [partlySelectedImage release];
    [fullySelectedImage release];
    [super dealloc];
}

/**
 *设定评分视图的基本设置
 *@param unselectedImage 灰色五角星图片名称
 *@param partlySelectedImage 半高亮五角星图片名称
 *@param fullSelectedImage 全高亮五角星图片名称
 *@param d 设置代理
 */
-(void)setImagesDeselected:(NSString *)deselectedImage
			partlySelected:(NSString *)halfSelectedImage
			  fullSelected:(NSString *)fullSelectedImage
			   andDelegate:(id<ASRatingViewDelegate>)d {
    
	self.unselectedImage = [UIImage imageNamed:deselectedImage];
	self.partlySelectedImage = halfSelectedImage == nil ? unselectedImage : [UIImage imageNamed:halfSelectedImage];
	self.fullySelectedImage = [UIImage imageNamed:fullSelectedImage];
	viewDelegate = d;
	
	height=16; width=16;
	
	starRating = 0;
	lastRating = 0;
	s1 = [[UIImageView alloc] initWithImage:unselectedImage];
	s2 = [[UIImageView alloc] initWithImage:unselectedImage];
	s3 = [[UIImageView alloc] initWithImage:unselectedImage];
	s4 = [[UIImageView alloc] initWithImage:unselectedImage];
	s5 = [[UIImageView alloc] initWithImage:unselectedImage];
	
	[s1 setFrame:CGRectMake(0,         1, width, height)];
	[s2 setFrame:CGRectMake(width,     1, width, height)];
	[s3 setFrame:CGRectMake(2 * width, 1, width, height)];
	[s4 setFrame:CGRectMake(3 * width, 1, width, height)];
	[s5 setFrame:CGRectMake(4 * width, 1, width, height)];
	
	[s1 setUserInteractionEnabled:NO];
	[s2 setUserInteractionEnabled:NO];
	[s3 setUserInteractionEnabled:NO];
	[s4 setUserInteractionEnabled:NO];
	[s5 setUserInteractionEnabled:NO];
	
	[self addSubview:s1];
	[self addSubview:s2];
	[self addSubview:s3];
	[self addSubview:s4];
	[self addSubview:s5];
	
	CGRect frame = [self frame];
	frame.size.width = width * 5;
	frame.size.height = height;
	[self setFrame:frame];
}

/**
 *设定评分
 *@param rating 分数
 */
-(void)displayRating:(float)rating {
	[s1 setImage:unselectedImage];
	[s2 setImage:unselectedImage];
	[s3 setImage:unselectedImage];
	[s4 setImage:unselectedImage];
	[s5 setImage:unselectedImage];
	
	if (rating >= 0.5) {
		[s1 setImage:partlySelectedImage];
	}
	if (rating >= 1) {
		[s1 setImage:fullySelectedImage];
	}
	if (rating >= 1.5) {
		[s2 setImage:partlySelectedImage];
	}
	if (rating >= 2) {
		[s2 setImage:fullySelectedImage];
	}
	if (rating >= 2.5) {
		[s3 setImage:partlySelectedImage];
	}
	if (rating >= 3) {
		[s3 setImage:fullySelectedImage];
	}
	if (rating >= 3.5) {
		[s4 setImage:partlySelectedImage];
	}
	if (rating >= 4) {
		[s4 setImage:fullySelectedImage];
	}
	if (rating >= 4.5) {
		[s5 setImage:partlySelectedImage];
	}
	if (rating >= 5) {
		[s5 setImage:fullySelectedImage];
	}
	
	starRating = rating;
	lastRating = rating;
    if (viewDelegate) {
        [viewDelegate ratingChanged:rating];
    }
}

/**
 *触摸更改评分
 */
-(void) touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
}

-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    float newRating = (float) (pt.x / width) +0.2;
    if (newRating < 0 || newRating > 6)
        return;
    
    if (newRating != lastRating)
        [self displayRating:newRating];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
}

/**
 *获得评分
 */
-(float)rating {
	return starRating;
}

/**
 *是否可触摸
 *@param aFlag 是否可触摸
 */
-(void)userInteractionEnabled:(BOOL)aFlag
{
    self.userInteractionEnabled = aFlag;
}

@end
