//
//  ASCategoryInRommendCell.h
//  ASTourism
//
//  Created by apple  on 13-8-15.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryDelegate <NSObject>

-(void)CategoryClick:(NSString *)category categoryID:(NSString *)CId;

@end

@interface ASCategoryInRommendCell : UITableViewCell
@property(nonatomic ,retain)id<CategoryDelegate> delegate;
@property(nonatomic,retain)IBOutlet UIButton *fuwuButton;

-(IBAction)ButtonClick1:(id)sender;
-(IBAction)ButtonClick:(id)sender;
//取消点击
-(IBAction)clickCancel:(id)sender;
@end
