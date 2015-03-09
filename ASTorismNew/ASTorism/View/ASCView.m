//
//  ASCView.m
//  ASTorism
//
//  Created by apple  on 13-10-21.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import "ASCView.h"
@implementation ASCView
@synthesize table,array;
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
    [array release];
    [table release];
}
#pragma DynamicTableDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString *identifierMore=@"cell";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:identifierMore];
    if (nil==Cell )
    {
        Cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierMore] autorelease] ;
        [Cell  setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    UILabel *cName = (UILabel*)[Cell viewWithTag:1001];
    if (!cName) {
        cName=[[UILabel alloc]initWithFrame:CGRectMake(0,12, self.frame.size.width , 20)];
        cName.tag = 1001;
        [Cell addSubview:cName];
        [cName release];
    }
    
    NSDictionary *dic=[self.array objectAtIndex:indexPath.row];
    cName.text=@"";
    cName.text=[[dic allKeys] objectAtIndex:0];
    [cName setFont:[UIFont systemFontOfSize:14]];
    cName.textAlignment = UITextAlignmentCenter;
    [cName setTextColor:[UIColor blackColor]];

    return Cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.array count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cid=nil;
    
    NSDictionary *dic=[self.array objectAtIndex:indexPath.row];
    NSString *cName=[[dic allKeys] objectAtIndex:0];
    cid=[dic objectForKey:cName];
    [self.delegate getCid:cid cName:cName];//将选中的种类id传给
}

@end
