//
//  ASNearCell.h
//  ASTourism
//
//  Created by apple  on 13-8-15.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASNearCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *name;
@property(nonatomic,retain)IBOutlet UILabel *info;
@property(nonatomic,retain)IBOutlet UILabel *distance;
@property(nonatomic,retain)IBOutlet UIImageView *image;

@end
