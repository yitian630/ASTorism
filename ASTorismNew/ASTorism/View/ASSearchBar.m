//
//  ASSearchBar.m
//  modelView
//
//  Created by Jerome峻峰 on 13-6-24.
//  Copyright (c) 2013年 Junfeng. All rights reserved.
//

#import "ASSearchBar.h"

@interface ASSearchBar()


@end

@implementation ASSearchBar

@synthesize searchField = _searchField;
@synthesize delegate = _delegate;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 265
        , 44)];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 255, 30)];
        //设置searchBar的背景图片
        _imageView.image = [UIImage imageNamed:@"sousuo.png"];
        [self addSubview:_imageView];
        
        
        _searchField = [[UITextField alloc]initWithFrame:CGRectMake(15, 7, 200, 30)];
        _searchField.borderStyle = UITextBorderStyleNone;
        _searchField.font = [UIFont fontWithName:@"System" size:14];
        _searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searchField.delegate = self;
        _searchField.returnKeyType = UIReturnKeySearch;
        [self addSubview:_searchField];
        UIButton *searchButton=[[UIButton alloc]initWithFrame:CGRectMake(215, 0, 50, 44)];
        [searchButton setBackgroundColor:[UIColor clearColor]];
        [searchButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchButton];
        [searchButton release];
    }
    return self;
}

-(void)dealloc
{
    [_imageView release];
    [_searchField release];
   
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



/**
 *关闭输入
 */
- (void)resignSearchField
{
    [_searchField resignFirstResponder];
}



#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(asSearchBarBeginEditing:)])
    {
        [_delegate asSearchBarBeginEditing:self];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self resignSearchField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(asSearchBarDidSearch:)])
    {
        [_delegate asSearchBarDidSearch:self];
    }
    return YES;
}
-(void)buttonClick{
    NSLog(@"sousuo ");
    if ([_delegate respondsToSelector:@selector(asSearchBarDidSearch:)])
    {
        [_delegate asSearchBarDidSearch:self];
    }

}
@end
