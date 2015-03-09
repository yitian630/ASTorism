//
//  RatingViewController.h
//  RatingController
//
//  Created by Jermoe峻峰.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASRatingViewDelegate
@optional
-(void)ratingChanged:(float)newRating;
@end


@interface ASRatingView : UIView {
	UIImageView *s1, *s2, *s3, *s4, *s5;
	UIImage *unselectedImage, *partlySelectedImage, *fullySelectedImage;
	id<ASRatingViewDelegate> viewDelegate;

	float starRating, lastRating;
	float height, width; // of each image of the star!
}

@property (nonatomic, retain) UIImageView *s1;
@property (nonatomic, retain) UIImageView *s2;
@property (nonatomic, retain) UIImageView *s3;
@property (nonatomic, retain) UIImageView *s4;
@property (nonatomic, retain) UIImageView *s5;
@property (nonatomic, retain) UIImage *unselectedImage;
@property (nonatomic, retain) UIImage *partlySelectedImage;
@property (nonatomic, retain) UIImage *fullySelectedImage;
/**
 *设定评分视图的基本设置
 *@param unselectedImage 灰色五角星图片名称
 *@param partlySelectedImage 半高亮五角星图片名称
 *@param fullSelectedImage 全高亮五角星图片名称
 *@param d 设置代理
 */
-(void)setImagesDeselected:(NSString *)unselectedImage partlySelected:(NSString *)partlySelectedImage 
			  fullSelected:(NSString *)fullSelectedImage andDelegate:(id<ASRatingViewDelegate>)d;

/**
 *设定评分
 *@param rating 分数
 */
-(void)displayRating:(float)rating;

/**
 *获得评分
 */
-(float)rating;

/**
 *是否可触摸
 *@param aFlag 是否可触摸
 */
-(void)userInteractionEnabled:(BOOL)aFlag;
@end
