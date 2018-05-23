//
//  CLNetworkBase.h
//  CLNetworking
//
//  Created by Apple on 2017/6/30.
//  Copyright © 2017年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>

@class NSURLSessionTask;

typedef NS_ENUM(NSUInteger, CLHttpMethodType){
    CLHttpGet = 1, // GET请求
    CLHttpPost = 2, // POST请求
    CLFilePost = 3,   //附件上传
    CLFileDownload = 4 //附件下载
};
typedef NS_ENUM(NSUInteger, CLResponseType){
    CLResponseTypeJSON = 1, // 默认
    CLResponseTypeXML  = 2, // xml
    // 特殊情况，一转换服务器就无法识别的，默认会尝试装换成JSON，若识别则需要自己去转换
    CLResponseTypeData = 3
};


typedef NS_ENUM(NSUInteger, CLRequestType){
    CLRequestTypeJSON = 1, // 默认
    CLRequestTypePlainText = 2 // text/html
};
// 所有接口返回的类型都是基于NSURLSessionTask，若要接收返回值处理，转换成对应的子类类型
@protocol AFMultipartFormData;
typedef NSURLSessionTask CLURLSessionTask;
typedef void(^CLResponseSuccess)(id object);
typedef void(^CLResponseFailed)(id object);
typedef void(^AFConstructingBodyBlock)(id<AFMultipartFormData> data);
typedef void(^AFURLSessionTaskProgressBlock)(NSProgress *progress);


@interface CLNetworkBase : NSObject

@property (nonatomic, assign)CLHttpMethodType httpMethodType;
@property (nonatomic, strong)CLURLSessionTask *currentTask;
@property (nonatomic, assign) BOOL refreshCache;//YES更新缓存，NO不更新，默认NO

//发起请求
- (CLURLSessionTask *)requestWithModel:(id)model success:(CLResponseSuccess)success failed:(CLResponseFailed)failed;
///发起SQL配置请求
- (CLURLSessionTask *)requestSQLWithModel:(id)model success:(CLResponseSuccess)success failed:(CLResponseFailed)failed;
/**
 带进度的图片上传
 
 @param success 成功回调
 @param failed 失败回调
 @param progress 进度回调
 */
- (CLURLSessionTask *)requestWithModel:(id)model progress:(AFURLSessionTaskProgressBlock)progress success:(CLResponseSuccess)success failed:(CLResponseFailed)failed;

/**
 获取服务器路径子类重写更改

 @return 返回服务器路径
 */
- (NSString *)getServerPath;

/**
 请求参数子类必须重写

 @return 参数
 */
- (NSDictionary *)requestParams;

/**
 是否需要携带token

 @return YES，参数拼接token
 */
- (BOOL)isAddToken;
/**
 请求接口名称子类必须重写

 @return 接口名称
 */
- (NSString *)requestAPI;

/**
 请求类型

 @return 默认POST请求
 */
- (CLHttpMethodType)getHttpMethod;

/**
 设置接口数据是否缓存

 @return YES缓存数据，NO不缓存，默认NO
 */
- (BOOL)isCache;

/**
 是否统一处理返回成功的错误
 
 @return YES统一处理，NO不处理，默认YES
 */
- (BOOL)isShowResponseError;

/**
 设置请求超时时间

 @return 超时时间
 */
- (NSInteger)timeout;

/**
 设置请求头部

 @return 请求头部
 */
- (NSDictionary *)configHeaders;

///**
// 自动取消请求
//
// @return 默认YES
// */
//- (BOOL)autoCancelRequest;

/**
 根据url取消请求

 @param url <#url description#>
 */
- (void)cancelRequestWithURL:(NSString *)url;

/**
 取消所有请求
 */
- (void)cancelAllRequest;

/**
 图片上传body数据

 @return 默认返回nil
 */
- (AFConstructingBodyBlock)constructingBodyBlock;

@end
