//
//  ASSearchBar.h
//  modelView
//
//  Created by Jerome峻峰 on 13-6-24.
//  Copyright (c) 2013年 Junfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASSearchBarDelegate;


@interface ASSearchBar : UIView<UITextFieldDelegate>
{
    UITextField *_searchField;
    UIImageView *imageView;

    
    id          _delegate;
}

@property (nonatomic, retain) UITextField *searchField;
@property (nonatomic, retain) UIImageView *imageView;
@property(nonatomic,assign) id<ASSearchBarDelegate> delegate;

/**
 *关闭输入
 */
- (void)resignSearchField;



@end


@protocol ASSearchBarDelegate <NSObject>

@optional

/**
 *searchBar 开始编辑
 */
- (void)asSearchBarBeginEditing:(ASSearchBar *)searchBar;
/**
 *search按钮点击事件
 */
- (void)asSearchBarDidSearch:(ASSearchBar *)searchBar;


@end