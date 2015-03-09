//
//  ASInfoListDeatail.h
//  ASTorism
//
//  Created by apple  on 13-9-17.
//  Copyright (c) 2013年 AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject-Dictionary.h"


@interface ASInfoListDeatail : NSObject
@property(nonatomic,retain) NSString *status;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSString *businessId;   //商家的id
@property(nonatomic,retain) NSString *content;      //内容
@property(nonatomic,retain) NSString *createTime;    //创建时间
@property(nonatomic,retain) NSString *endTime;             //结束时间
@property(nonatomic,retain) NSString *startTime;     //开始时间
@property(nonatomic,retain) NSString *ids;             //id
@property(nonatomic,retain) NSString *title;       //标题
@property(nonatomic,retain) NSString *isRead;    //是否已读   1为未读
@property(nonatomic,retain) NSString *visible;   
@property(nonatomic,retain) NSString *imageURL;//图片
@property(nonatomic,retain)NSString *changed;  //推送信息
@end
