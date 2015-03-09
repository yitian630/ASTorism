//
//  ASCategoryInRommendCell.m
//  ASTourism
//
//  Created by apple  on 13-8-15.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASCategoryInRommendCell.h"

@interface ASCategoryInRommendCell ()

-(IBAction)ButtonClick:(id)sender;

@end

@implementation ASCategoryInRommendCell
@synthesize delegate;
@synthesize fuwuButton;
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
-(IBAction)ButtonClick:(id)sender{
    UIButton *button=(UIButton*)sender;
    NSString *cid=[[NSString alloc]initWithFormat:@"%d",button.tag+19];
    switch (button.tag) {
        case 0:
            [self.delegate CategoryClick:@"旅  游"  categoryID:cid];
            [button setImage:[UIImage imageNamed:@"旅游.png"] forState:UIControlStateNormal];

            break;
        case 1:
            [self.delegate CategoryClick:@"餐饮美食" categoryID:cid];
            [button setImage:[UIImage imageNamed:@"美食.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.delegate CategoryClick:@"休闲娱乐" categoryID:cid];
            [button setImage:[UIImage imageNamed:@"休闲.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.delegate CategoryClick:@"酒店住宿" categoryID:cid];
            [button setImage:[UIImage imageNamed:@"酒店.png"] forState:UIControlStateNormal];
            break;
        case 4:
            
            [self.delegate CategoryClick:@"生活服务" categoryID:@"6"];
            [button setImage:[UIImage imageNamed:@"生活.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [button setImage:[UIImage imageNamed:@"时尚.png"] forState:UIControlStateNormal];
            [self.delegate CategoryClick:@"时尚购物" categoryID:@"7"];
            break;
        default:
            break;
    }
    [cid release];

}
-(IBAction)ButtonClick1:(id)sender{
    UIButton *button=(UIButton*)sender;
    switch (button.tag) {
        case 0:
        [button setImage:[UIImage imageNamed:@"xuanzhonglvyou.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [button setImage:[UIImage imageNamed:@"xuanzhongmeishi.png"] forState:UIControlStateNormal];
                       break;
        case 2:
            [button setImage:[UIImage imageNamed:@"xuanzhongxiuxian.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [button setImage:[UIImage imageNamed:@"xuanzhongjiudian.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [button setImage:[UIImage imageNamed:@"xuanzhongfuwu.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [button setImage:[UIImage imageNamed:@"xuanzhonggouwu.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}
//取消点击
-(IBAction)clickCancel:(id)sender{
    UIButton *button=(UIButton*)sender;
    switch (button.tag) {
        case 0:
            [button setImage:[UIImage imageNamed:@"旅游.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [button setImage:[UIImage imageNamed:@"美食.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [button setImage:[UIImage imageNamed:@"休闲.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [button setImage:[UIImage imageNamed:@"酒店.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [button setImage:[UIImage imageNamed:@"生活.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [button setImage:[UIImage imageNamed:@"时尚.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}

@end
