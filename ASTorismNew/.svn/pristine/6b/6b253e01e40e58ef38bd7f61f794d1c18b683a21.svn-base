//
//  ASMerchantInfoViewController.h
//  modelView
//
//  Created by Jerome峻峰 on 13-6-24.
//  Copyright (c) 2013年 Junfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "NavigationBar.h"
#import "ASMerchantDetailInfo.h"
#import "ASRatingView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
@interface ASMerchantInfoViewController : UIViewController<NavigationBarDelegate,ASRatingViewDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate>

@property (nonatomic, retain) ASMerchantDetailInfo  *merchantDetail;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


//top of the scrollview
@property (nonatomic, retain) IBOutlet UIImageView  *merchantLogo;
@property (nonatomic, retain) IBOutlet ASRatingView *ratingView;



//view of position
@property (nonatomic, retain) IBOutlet UIView       *positionView;
//detail
@property (nonatomic, retain) IBOutlet BMKMapView   *mapView;
@property (nonatomic, retain) IBOutlet UILabel      *phoneTitle;
@property (nonatomic, retain) IBOutlet UILabel      *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel      *phoneLabel;
@property (nonatomic, retain) IBOutlet UIButton     *mapNavButton;
@property (retain, nonatomic) IBOutlet UILabel *staticAddressLabel;


//detail
//view of merchant info
@property (nonatomic, retain) IBOutlet UIView       *infoView;
//detail
@property (nonatomic, retain) IBOutlet UILabel      *infoLabel;



@property (nonatomic, retain) IBOutlet UIButton     *phoneButton;

//tian
@property(nonatomic,assign)BOOL isBack;
//PreferentialView  优惠政策View
@property(nonatomic,retain)IBOutlet UIView *preferentialView;
//优惠标题
@property(nonatomic,retain)IBOutlet UILabel *preferentialTitleLabel;
//优惠信息
@property(nonatomic,retain)IBOutlet UILabel *preferentialInfoLabel;



//
@property(nonatomic,assign)BOOL isInfoPush;//判断是否是从消息界面push
@property(nonatomic,retain)NSString *businessId;//商家id

//展开商家信息button点击事件安
-(IBAction)UnfoldClick:(id)sender;

@end
