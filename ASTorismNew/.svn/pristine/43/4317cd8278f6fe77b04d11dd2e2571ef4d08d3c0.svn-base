//
//  NavigationBar.h
//  iFootPrint
//
//  Created by tyc on 13-1-16.
//  Copyright (c) 2013年 tyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarDelegate <NSObject>
-(void)NavBarBackClick;
-(void)NavCityButtonClick;
-(void)NavSearchButtonClick;
@end
@interface NavigationBar : UIView
@property(nonatomic,retain)id<NavigationBarDelegate> Delegate;
@property(nonatomic,retain)IBOutlet UIButton *BackButton;//返回按钮
@property(nonatomic,retain)IBOutlet UIButton *cityButton;//城市切换按钮
@property(nonatomic,retain)IBOutlet UIButton *searchButton;//搜索按钮
@property(nonatomic,retain)IBOutlet UILabel *titleLabel; //标题
@property(nonatomic,retain)IBOutlet UIImageView *backImage;//返回图片
@property(nonatomic,retain)IBOutlet UIImageView *searchImage;//搜索图片
@property(nonatomic,retain)IBOutlet UIImageView *cityImage;//城市图片

-(IBAction)BackButtonClick:(id)sender;
-(IBAction)CityButtonClick:(id)sender;
-(IBAction)SearButtonClick:(id)sender;
@end
