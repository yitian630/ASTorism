//
//  AOTabbarView.m
//  testCustomTabbar
//
//  Created by akria.king on 13-4-12.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "AOTabbarView.h"
#import "UIDevice+Resolutions.h"
#import "ASGlobal.h"
@implementation AOTabbarView
@synthesize aoDelegate;
@synthesize  selectedImage=_selectedImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//实现初始化视图方法
-(id)initWithIconNumber:(int)number  messArr:(NSString *)messStr{
   
    self=[super initWithFrame:CGRectMake(0, [ASGlobal getApplicationBoundsHeight]-54, TABBARWIDTH, 54)];
    if (self) {
        self.backgroundColor=[UIColor clearColor];//设置背景颜色为透明色
              //计算每个tabbarItem宽度
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 320, 49)];
        image.image=[UIImage imageNamed:@"gongjulan.png"];
        [self addSubview:image];
        [image release];
        _selectedImage=[[UIImageView alloc]init];
        _selectedImage.frame=CGRectMake(33, 0, 14, 5);
        _selectedImage.image=[UIImage  imageNamed:@"工具栏选中.png"] ;
        [self addSubview:_selectedImage];

        int btnW=TABBARWIDTH/number;
        // 创建内容
        for (int i=1; i<=number; i++) {
           
           //初始化点击按钮
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake( (i-1)*btnW, 0, btnW, self.frame.size.height)];
            //添加按钮事件
            [btn addTarget:self action:@selector(switchButton:) forControlEvents:UIControlEventTouchUpInside];
            //设置按钮tag
            btn.tag=i;
            //添加进item
            [self addSubview:btn];

            [btn release];
        }
    }
    UIButton *button=[[UIButton alloc]init];
    button.tag=1;
    [self switchButton:button];
    [button release];
    return self;
}
//实现切换方法
-(void)switchButton:(id)sender{
    UIButton *btn =(UIButton *)sender;
    int checktag=btn.tag;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(33+80*(btn.tag-1), 0, 14, 5);
    }];
//    [self.aoDelegate switchButton:checktag];
    switch (checktag) {
        case 1:
            if (!recommandVC) {
                recommandVC = [[ASRecommandViewController alloc]initWithNibName:@"ASRecommandViewController" bundle:nil];
            }
            [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
            [[ASGlobal getNavigationController]pushViewController:recommandVC animated:NO];
            
            break;
        case 2:
            if (!nearVC) {
                nearVC = [[ASNearViewController alloc]initWithNibName:@"ASNearViewController" bundle:nil];
            }
            [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
            [[ASGlobal getNavigationController]pushViewController:nearVC animated:NO];
            
            break;
        case 3:
            
            if (!infoVC) {
                infoVC = [[ASInfomationViewController alloc]initWithNibName:@"ASInfomationViewController" bundle:nil];
            }
            [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
            [[ASGlobal getNavigationController]pushViewController:infoVC animated:NO];
            
            break;
        case 4:
            if (!setVC) {
                setVC = [[ASSetViewController alloc]initWithNibName:@"ASSetViewController" bundle:nil];
            }
            [[ASGlobal getNavigationController]popToRootViewControllerAnimated:NO];
            [[ASGlobal getNavigationController]pushViewController:setVC animated:NO];
            
            break;
        default:
            break;
    }

}
-(void)dealloc{
    [super dealloc];
    [aoDelegate release];
    [_selectedImage release];
}
@end
