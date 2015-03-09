//
//  ASCategoryChooseView.m
//  ASTourism
//
//  Created by apple  on 13-8-14.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASCategoryChooseView.h"
#import "ASMainCategoryTbaleCell.h"
#import "ASGlobal.h"

#define LeftX  0
#define RightX 100
#define Y 7
#define WIDTH 92
#define HEIGHT 30
#define Yy 44   //button纵坐标之间的距离

@implementation ASCategoryChooseView
@synthesize maincategoryArray;
@synthesize delegate=_delegate;
@synthesize mainCategoryTable;
@synthesize categoryDetailArray=_categoryDetailArray;
@synthesize scrollView=_scrollView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    [super dealloc];
//    [mainCategoryTable release];
//    [maincategoryArray release];
//    [_delegate release];
//    [_scrollView release];
//    [_categoryDetailArray release];
    
}
#pragma DynamicTableDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ASMainCategoryTbaleCell *cell=nil;
    cell=[mainCategoryTable dequeueReusableCellWithIdentifier:@"mainCategoryTable"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ASMainCategoryTableCell" owner:nil options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.mainCategoryLabel.text=[self.maincategoryArray objectAtIndex:[indexPath row]];
    [cell.mainCategoryLabel setTextColor:[UIColor blackColor]];
    cell.categoryImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png",[self.maincategoryArray objectAtIndex:[indexPath row]]]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return [self.maincategoryArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate MainCategoryChoose:[self.maincategoryArray objectAtIndex:[indexPath row]] mainID:[NSString stringWithFormat:@"%d",indexPath.row]];//将选中的种类传给dynamicViewContronller
//    [tableView deselectRowAtIndexPath: indexPath
//                             animated: YES];

    
    
}
/*
 *-(void)setButtons:(NSArray *)categoryDetailArr
 *无参数
 *设置按钮
 *无返回值
 */
-(void)setButtons{
    
    
    
    CGRect rect;
    //设置buttons
    for (int i=0; i<_categoryDetailArray.count; i++) {
        if (i%2==0) {
            rect=CGRectMake(LeftX, Y+(i/2)*Yy, WIDTH, HEIGHT);
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 43+44*(i/2), 192, 1)];
            view.backgroundColor=[UIColor lightGrayColor];
            view.alpha=0.2;
            [_scrollView addSubview:view];
            [view release];
        }else{
            rect=CGRectMake(RightX, Y+(i/2)*Yy, WIDTH, HEIGHT);
        }
        UIButton *button=[[UIButton alloc]init];
        button.frame=rect;
        NSDictionary *categoryDetailDic=[[NSDictionary alloc]initWithDictionary:[_categoryDetailArray objectAtIndex:i]];
        NSString *btuTitle=[[NSString alloc]initWithString: [[categoryDetailDic allKeys]objectAtIndex:0]];
        if ([btuTitle isEqualToString:@"全部"]) {
            button.tag=0;
        }else{
            button.tag=[[categoryDetailDic objectForKey:btuTitle] integerValue];;
        }
        
        [button setTitle:btuTitle forState:UIControlStateNormal];
        [btuTitle release];
        [categoryDetailDic release];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [button setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [button setTitleColor:COLORFROMCODE(0xfe8a01, 1.0f) forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [button release];
    }
}
/*
 设置scrollView的尺寸
 */
-(void)setScrollViewSize:(int )allNum{
    //隐藏导航条
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    if (allNum%2==0) {
        self.scrollView.frame=CGRectMake(128, 0, 192, 44*(allNum/2));
    }else{
        self.scrollView.frame=CGRectMake(128, 0, 192, 44*(allNum/2)+44);
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,264.0);
}
/*
 *-(NSString *)chooseCategory
 *无参数
 *选择种类
 *返回种类  NSString *
 */
-(void)chooseCategory:(id)sender{
    UIButton *button=(UIButton *)sender;
    
//    [button setTitleColor:COLORFROMCODE(0xfe8a01, 1.0f) forState:UIControlStateNormal];
    NSString *cid=[[NSString alloc]initWithFormat:@"%d", button.tag ];
    
    [self.delegate categoryChoose:button.currentTitle ID:cid];
    [cid release];
}

@end
