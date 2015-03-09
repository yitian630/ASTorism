//
//  ASCView.h
//  ASTorism
//
//  Created by apple  on 13-10-21.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASCidChooseDlegate <NSObject>

-(void)getCid:(NSString *)cid cName:(NSString *)name;

@end
@interface ASCView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)IBOutlet UITableView *table;
@property(nonatomic,retain)NSMutableArray *array;
@property(nonatomic,retain)id<ASCidChooseDlegate>delegate;

@end
