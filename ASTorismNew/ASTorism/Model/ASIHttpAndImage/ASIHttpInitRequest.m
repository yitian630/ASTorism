//
//  ASIHttpInitRequest.m
//  ASIrequest
//
//  Created by apple  on 13-9-20.
//  Copyright (c) 2013年 han. All rights reserved.
//

#import "ASIHttpInitRequest.h"
#import "UrlImageView.h"
@implementation ASIHttpInitRequest
@synthesize ASIDelegate=_ASIDelegate;
-(ASIHttpInitRequest *)initASIRequest:(id<ASIRequestFinishedDelegate>)delegate{
    self=[super init];
    if (self) {
        self.ASIDelegate=delegate;
    }
    return self;
}
-(void)startRequest:(NSString *)url PARAMETER:(NSDictionary *)Parameterdic{
    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setTimeOutSeconds:5];
    for (NSString *key in [Parameterdic allKeys]) {
        NSString *value=[Parameterdic objectForKey:key];
        [request setPostValue:value forKey:key];
    }
    //    //上传图片
    //    [requstS setData:imageData withFileName:@"s.png" andContentType:@"image/png" forKey:@"upLoad"];
    [request startAsynchronous];//异步加载
    [request release];
}
//成功回调
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *string = [request responseString];
//    NSDictionary *dic = [string objectFromJSONString];
    if (_ASIDelegate) {
        [_ASIDelegate ASIRequestFinished:string];
    }
//    NSLog(@"成功 %@",string);
}

//失败回调
-(void)requestFailed:(ASIHTTPRequest *)request
{
     NSString *string = [request responseString];
    if (_ASIDelegate) {
        [_ASIDelegate ASIRequestFailed:string];
    }
//    NSLog(@"失败咯!!!!!");
}

//
//-(UIImage *)getImageFromUrl:(NSString *)imageURL placeholderImage:(UIImage*)placeholderImage{
////    ASIFormDataRequest *request= [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
////    [request setDelegate:self];
////    [request setTimeOutSeconds:7];
////    for (NSString *key in [Parameterdic allKeys]) {
////        NSString *value=[Parameterdic objectForKey:key];
////        [request setPostValue:value forKey:key];
////    }
////    //    //上传图片
////    //    [requstS setData:imageData withFileName:@"s.png" andContentType:@"image/png" forKey:@"upLoad"];
////    [request startAsynchronous];//异步加载
//    UrlImageView *imageView = [[UrlImageView alloc]init ];
//    [imageView setImageFromUrl:NO withUrl:imageURL];
//    NSData *imageData=UIImageJPEGRepresentation(imageView.image, 0.3);//1.0压缩系数
//    UIImage *image=nil;
//    if (nil!=imageData&&imageData.length>0) {
//        image=[[UIImage alloc]initWithData:imageData scale:1.0];
//    }else{
//        return placeholderImage;
//    }
//    return image;
//}
////上传图片方法
//-(void)imageLoad:(UIImage *)image URL:(NSString *)serverUrl{
//    
//    
//    //得到图片的data
//   NSData *imageData=nil;
//    
//    NSString *extension;
//    if (UIImagePNGRepresentation(image)) {
//        //            data = UIImagePNGRepresentation(temp);
//        imageData = UIImageJPEGRepresentation(image, 0.2);
//        extension = @".jpeg";
//    }else{
//        imageData = UIImageJPEGRepresentation(image, 0.5);
//        extension = @".jpeg";
//    }
//    NSString *urlStr = serverUrl;
//    NSURL * url = [NSURL URLWithString:urlStr];
//    //    NSString * str_userid = [[NSString alloc]initWithFormat:@"%d",user_id];
//    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
//    [request setData:imageData forKey:@"image"];
//    [request setPostValue:@"userImage" forKey:@"category_name"];
//    //    [request1 setPostValue:str_userid forKey:@"user_id"];
//    [request setDelegate:self];
//    [request setTimeOutSeconds:20];
//    
//    //异步请求
//    [request startSynchronous];
//    NSError *error = [request error];
//    if (!error) {
//        NSString *response = [request responseString];
//        NSLog(@"%@",response);
//    }
//}

@end
