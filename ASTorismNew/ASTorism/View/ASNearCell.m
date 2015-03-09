//
//  ASNearCell.m
//  ASTourism
//
//  Created by apple  on 13-8-15.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASNearCell.h"

@implementation ASNearCell
@synthesize distance,name,info,image;
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
   
    
}

@end
