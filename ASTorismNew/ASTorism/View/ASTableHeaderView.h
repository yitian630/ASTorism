//
//  ASTableHeaderView.h
//  ASTorism
//
//  Created by apple  on 13-9-2.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,
} EGOPullRefreshState;

@protocol EGORefreshTableHeaderDelegate;
@interface ASTableHeaderView : UIView
{
	
	id _delegate;
	EGOPullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
    
}

@property(nonatomic,assign) id <EGORefreshTableHeaderDelegate> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(ASTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(ASTableHeaderView*)view;
//上啦加载更多
-(void)egoUploadMoreWithPull;
//上啦过程中
-(void)egoUploadMoreWithIsPulling;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(ASTableHeaderView*)view;

@end
