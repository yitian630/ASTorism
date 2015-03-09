//
//  slideView.h
//  testScrollViewViewController
//
//  Created by apple  on 13-8-16.
//  Copyright (c) 2013年 imac . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol slideViewDelegate <NSObject>

-(void)whichOneIsSelected:(int)page;
@end

@interface slideView : UIView<UIScrollViewDelegate>
@property (retain,nonatomic)NSMutableArray *slideImages;//存放图片数组
@property (retain,nonatomic)id<slideViewDelegate> delegate;


/*-(void)initScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame
 *参数：(CGRect)scrollFrame  ScrollView的Frame     PageControllerFrame:(CGRect)pageCFrame pageConreoller的Frame
 *初始化scorllView和pageController  并设定时间
 *无返回值
 */
-(void)initScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame ;
/*-(void)startSlide:(NSInteger)time
 *参数：滑动的时间(NSInteger)time
 *控制视图滑动的开始
 *无返回值
 */
-(void)startSlide:(NSInteger)time;
/*-(void)endSlide
 *参数：无参数
 *控制视图滑动的结束
 *无返回值
 */
-(void)endSlide;

@end
