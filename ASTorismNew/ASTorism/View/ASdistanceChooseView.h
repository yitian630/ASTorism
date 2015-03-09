//
//  ASdistanceChooseView.h
//  ASTourism
//
//  Created by apple  on 13-8-14.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DistanceChooseDelegate <NSObject>

-(void)distanceChoose:(NSString *)distance;

@end

@interface ASdistanceChooseView : UIView
@property(nonatomic,retain)id<DistanceChooseDelegate>delegate;
@property(nonatomic,retain)IBOutlet UIImageView *image1;
@property(nonatomic,retain)IBOutlet UIImageView *image2;
@property(nonatomic,retain)IBOutlet UIImageView *image3;
@property(nonatomic,retain)IBOutlet UIImageView *image4;
-(IBAction)click:(id)sender;
@end
