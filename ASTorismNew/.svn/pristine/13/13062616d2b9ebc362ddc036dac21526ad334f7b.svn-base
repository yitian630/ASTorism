//
//  ASMainCategoryTbaleCell.m
//  ASTourism
//
//  Created by apple  on 13-8-14.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASMainCategoryTbaleCell.h"
#import "ASGlobal.h"
@interface ASMainCategoryTbaleCell ()


@end
@implementation ASMainCategoryTbaleCell
@synthesize mainCategoryLabel=_mainCategoryLabel;
@synthesize categoryImg=_categoryImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
       if (selected) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"fenleixuanzhong.png"]];
          [self.mainCategoryLabel setTextColor:COLORFROMCODE(0xfe8a01, 1.0f)];
       }else{
        [self.mainCategoryLabel setTextColor:[UIColor blackColor]];
        self.backgroundColor=[UIColor whiteColor];
    }
   
}

@end
