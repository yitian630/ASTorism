//
//  ASCategoryChooseView.h
//  ASTourism
//
//  Created by apple  on 13-8-14.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MainCategoryChooseDelegate <NSObject>

-(void)MainCategoryChoose:(NSString *)mainCategory mainID:(NSString *)mainId;
-(void)categoryChoose:(NSString *)category ID:(NSString *)cid;//参数类别名字和id
@end

@interface ASCategoryChooseView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)id<MainCategoryChooseDelegate> delegate;
@property(nonatomic,retain)IBOutlet UITableView *mainCategoryTable;
@property(nonatomic,retain)NSMutableArray *maincategoryArray;//存放主类的数组
@property(nonatomic,retain)NSArray *categoryDetailArray;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;

/*
 *-(void)setButtons:(NSArray *)categoryDetailArr
 *种类详细数组 (NSArray *)categoryDetailArr
 *设置按钮
 *无返回值
 */
-(void)setButtons;
/*
 *-(NSString *)chooseCategory
 *(id)sender
 *选择种类
 *返回种类  NSString *
 */
-(void )chooseCategory:(id)sender;


@end
