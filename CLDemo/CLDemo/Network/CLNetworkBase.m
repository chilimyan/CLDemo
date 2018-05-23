//
//  CLNetworkBase.m
//  CLNetworking
//
//  Created by Apple on 2017/6/30.
//  Copyright © 2017年 chilim. All rights reserved.
//

#import "CLNetworkBase.h"
#import "CLResponseObject.h"
#import "CLNetworkManager.h"
#import "CLDemoConfig.h"
#import <MJExtension.h>

NSString *const defaultServerPath = @"/RedseaPlatform/MobileInterface/ios.mb";
NSInteger const requestTimeout = 30;

static CLResponseType responseType = CLResponseTypeJSON;
static CLRequestType requestType = CLRequestTypePlainText;

static NSMutableArray *requestTasks;//正在请求的的任务列表

@implementation CLNetworkBase

- (instancetype)init{
    if (self = [super init]) {
        self.refreshCache = NO;
    }
    return self;
}

- (NSString *)getServerPath{
    return defaultServerPath;
}

- (NSString *)baseUrl{
    return nil;
}

- (NSDictionary *)requestParams{
    NSAssert([self isMemberOfClass:[CLNetworkBase class]], @"子类必须实现requestParams");
    return nil;
}

- (NSString *)requestAPI{
    NSAssert([self isMemberOfClass:[CLNetworkBase class]], @"子类必须实现requestAPI");
    return nil;
}

- (NSString *)postURL{
     NSString *url = [[NSString stringWithFormat:@"%@%@?method=%@", [CLDemoConfig config].URL,[self getServerPath], [self requestAPI]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}

- (NSString *)get_sql_url{
    //    sqlServer_root
    NSMutableString *paraString = [[NSMutableString alloc]init];
    for (NSString *key in [self requestParams]) {
        NSString *temp = [NSString stringWithFormat:@"%@=%@&",key,[[self requestParams] objectForKey:key]];
        [paraString appendString:temp];
    }
    paraString = [NSMutableString stringWithString:[paraString substringToIndex:paraString.length - 1]];
    
    NSString *baseUrl = [NSString stringWithFormat:[self getServerPath],[CLDemoConfig config].URL,[self requestAPI]];
    NSString *urlString = [[NSString stringWithFormat:@"%@?%@",baseUrl,paraString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return urlString;
}

- (NSString *)post_sql_url{
    NSString *baseUrl = [NSString stringWithFormat:[self getServerPath],[CLDemoConfig config].URL,[self requestAPI]];
    NSString *urlString = [[NSString stringWithFormat:@"%@",baseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

- (NSDictionary *)configHeaders{
    return nil;
}

- (NSInteger)timeout{
    return requestTimeout;
}

- (NSString *)postParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self requestParams]];
    [params setObject:[NSString stringWithFormat:@"%@,%@",CLSystemDeviceName,CLSystemVersion] forKey:@"mobileModel"];
    /*param对象转换*/
    if(params){
        for(NSString* key in params.allKeys){
            if(![params valueForKey:key]){
                [params setValue:@"" forKey:key];
            }
        }
    }
    
    NSError *error;
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    if(error){
        [CLHudTool cl_alertError:error];
        return nil;
    }
    NSString *paramString = [[NSString alloc]initWithData:paramData encoding:NSUTF8StringEncoding];
    //    NSLog(@"post_paramString：%@", paramString);
    /*url构造*/
    NSString *paramNew = [[NSString stringWithFormat:@"%@", paramString]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return paramNew;
}

- (void)process_error:(NSError*)error{
    [CLHudTool cl_alertError:error];
}

- (CLHttpMethodType)getHttpMethod{
    return CLHttpPost;
}

- (AFConstructingBodyBlock)constructingBodyBlock {
    return nil;
}

//配置公共请求参数
- (NSDictionary *)configCommonParams{
    
    if ([self isAddToken]) {
        NSDictionary *input_params = @{@"params":[self postParams],
                                       @"token":@""};
        return input_params;
    }else{
        NSDictionary *input_params = @{@"params":[self postParams]};
        return input_params;
    }
}

- (BOOL)isAddToken{
    return YES;
}

- (BOOL)isShowResponseError{
    return YES;
}

- (CLURLSessionTask *)requestWithModel:(id)model success:(CLResponseSuccess)success failed:(CLResponseFailed)failed{
   CLURLSessionTask *task = [self requestWithModel:model progress:nil success:success failed:failed];
    return task;
}

- (CLURLSessionTask *)requestSQLWithModel:(id)model success:(CLResponseSuccess)success failed:(CLResponseFailed)failed{
    CLURLSessionTask *task = [self requestSQLWithModel:model progress:nil success:success failed:failed];
    return task;
}

- (CLURLSessionTask *)requestSQLWithModel:(id)model progress:(AFURLSessionTaskProgressBlock)progress success:(CLResponseSuccess)success failed:(CLResponseFailed)failed{
    //缓存设置,如果接口数据需要缓存，并且不需要更新缓存，且本地已有缓存数据时返回缓存数据否则拉取新数据
    if ([self isCache] && !self.refreshCache && [[CLShareObject shared].cache.diskCache objectForKey:[self requestAPI]]) {
        if (success) {
            success([[CLShareObject shared].cache.diskCache objectForKey:[self requestAPI]]);
        }
        return nil;
    }
    AFHTTPSessionManager *manager  = [self getManager];
    NSAssert([[self postURL] hasPrefix:@"http://"] || [[self postURL] hasPrefix:@"https://"], @"非法的URL");
    if ([self getHttpMethod] == CLHttpGet) {
        NSLog(@"接口URL====\n%@&token=%@",[self get_sql_url],@"");
        self.currentTask = [manager GET:[self get_sql_url] parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
            [self successResponse:responseObject model:model callback:success];
            [[self allTasks] removeObject:task];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [[CLHudTool shared] cl_syncStopLoading];
            [[self allTasks] removeObject:task];
            //是否需要统一处理error
            if (failed) {
                failed(error);
            }else{
                [self handleCallbackWithError:error];
            }
        }];
    }else if([self getHttpMethod] == CLHttpPost){
        NSLog(@"接口URL====\n%@&token=%@",[self get_sql_url],@"");
        self.currentTask = [manager POST:[self post_sql_url] parameters:[self requestParams] progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
            [self successResponse:responseObject model:model callback:success];
            [[self allTasks] removeObject:task];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [[CLHudTool shared] cl_syncStopLoading];
            [[self allTasks] removeObject:task];
            //是否需要统一处理error
            if (failed) {
                failed(error);
            }else{
                [self handleCallbackWithError:error];
            }
        }];
    }else if([self getHttpMethod] == CLFilePost){
        self.currentTask = [manager POST:[self postURL] parameters:[self configCommonParams] constructingBodyWithBlock:[self constructingBodyBlock] progress:^(NSProgress *_Nonnull uploadProgress){
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask *task, id responseObject){
            [self successResponse:responseObject model:model callback:success];
            [[self allTasks] removeObject:task];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [[CLHudTool shared] cl_syncStopLoading];
            [[self allTasks] removeObject:task];
            //是否需要统一处理error
            if (failed) {
                failed(error);
            }else{
                [self handleCallbackWithError:error];
            }
        }];
    }
    //    NSLog(@"%@",self.currentTask.currentRequest.URL.absoluteString);
    if(self.currentTask)
    {
        [[self allTasks] addObject:self.currentTask];
    }
    //    NSLog(@"%@",[self allTasks]);
    return self.currentTask;
}


- (CLURLSessionTask *)requestWithModel:(id)model progress:(AFURLSessionTaskProgressBlock)progress success:(CLResponseSuccess)success failed:(CLResponseFailed)failed{
    //缓存设置,如果接口数据需要缓存，并且不需要更新缓存，且本地已有缓存数据时返回缓存数据否则拉取新数据
    if ([self isCache] && !self.refreshCache && [[CLShareObject shared].cache.diskCache objectForKey:[self requestAPI]]) {
        if (success) {
           success([[CLShareObject shared].cache.diskCache objectForKey:[self requestAPI]]);
        }
        return nil;
    }
    AFHTTPSessionManager *manager  = [self getManager];
    NSAssert([[self postURL] hasPrefix:@"http://"] || [[self postURL] hasPrefix:@"https://"], @"非法的URL");
    if ([self getHttpMethod] == CLHttpGet) {

    }else if([self getHttpMethod] == CLHttpPost){
        NSLog(@"接口URL====\n%@&params=%@&token=%@",[self postURL],[self postParams],@"");
        self.currentTask = [manager POST:[self postURL] parameters:[self configCommonParams] progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
            [self successResponse:responseObject model:model callback:success];
            [[self allTasks] removeObject:task];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [[CLHudTool shared] cl_syncStopLoading];
            [[self allTasks] removeObject:task];
            //是否需要统一处理error
            if (failed) {
                failed(error);
            }else{
                [self handleCallbackWithError:error];
            }
        }];
    }else if([self getHttpMethod] == CLFilePost){
        self.currentTask = [manager POST:[self postURL] parameters:[self configCommonParams] constructingBodyWithBlock:[self constructingBodyBlock] progress:^(NSProgress *_Nonnull uploadProgress){
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask *task, id responseObject){
            [self successResponse:responseObject model:model callback:success];
            [[self allTasks] removeObject:task];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            [[CLHudTool shared] cl_syncStopLoading];
            [[self allTasks] removeObject:task];
            //是否需要统一处理error
            if (failed) {
                failed(error);
            }else{
                [self handleCallbackWithError:error];
            }
        }];
    }
//    NSLog(@"%@",self.currentTask.currentRequest.URL.absoluteString);
    if(self.currentTask)
    {
        [[self allTasks] addObject:self.currentTask];
    }
//    NSLog(@"%@",[self allTasks]);
    return self.currentTask;
}

- (void)startUploadTaskWithSuccess:(CLResponseSuccess)success
                           failure:(CLResponseFailed)failure
                    uploadProgress:(AFURLSessionTaskProgressBlock)uploadProgress{
    
}

- (void)successResponse:(id)responseData model:(id)model callback:(CLResponseSuccess)success
{
    [[CLHudTool shared] cl_syncStopLoading];
    NSError *error;
    if(error){
        /**如果出现json结构异常**/
        [CLHudTool cl_alertError:error];
        return ;
    }
    CLResponseObject *remoteObject = [CLResponseObject mj_objectWithKeyValues:responseData];
    if (![remoteObject.state isEqualToString:@"1"] && [self isShowResponseError]) {
        [CLHudTool cl_alert:remoteObject.meg];
        return ;
    }
    if(success)
    {
        //需要缓存的接口则缓存数据
        if ([self isCache] && [self process_jsondata:responseData class:[model class]]) {
            [[CLShareObject shared].cache.diskCache setObject:[self process_jsondata:responseData class:[model class]] forKey:[self requestAPI]];
        }
        success([self process_jsondata:responseData class:[model class]]);
    }
}

- (void)handleCallbackWithError:(NSError *)error
{
    NSInteger statusCode = error.code;
    NSString *status_str = error.localizedFailureReason;
    NSLog(@"http状态码:%ld状态描述:%@",statusCode,status_str);
    if (error.code == NSURLErrorTimedOut || error.code == NSURLErrorNotConnectedToInternet) {
        return;
    }
    [CLHudTool cl_alertError:error];
}

- (id)process_jsondata:(NSData *)jsonData class:(Class)class{
    CLResponseObject *remoteObject = [CLResponseObject mj_objectWithKeyValues:jsonData];
    /**正确的json，进行回掉前的类反射处理**/
    if(class==[CLResponseObject class]){
        return remoteObject;
    }else{
        if(remoteObject.result){
            if([remoteObject.result isKindOfClass:[NSArray class]]){
                return [class mj_objectArrayWithKeyValuesArray:remoteObject.result];
            }else{
                return [class mj_objectWithKeyValues:remoteObject.result];
            }
        }else if(remoteObject.datas){
            if([remoteObject.datas isKindOfClass:[NSArray class]]){
                return [class mj_objectArrayWithKeyValuesArray:remoteObject.datas];
            }else{
                return [class mj_objectWithKeyValues:remoteObject.datas];
            }
        }else if (remoteObject.jsonList){
            if([remoteObject.jsonList isKindOfClass:[NSArray class]]){
                return [class mj_objectArrayWithKeyValuesArray:remoteObject.jsonList];
            }else{
                return [class mj_objectWithKeyValues:remoteObject.jsonList];
            }
        }else{
            return nil;
        }
    }
}


- (AFHTTPSessionManager *)getManager{
    AFHTTPSessionManager *manager = nil;
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    }else{
        manager = [AFHTTPSessionManager manager];
    }
    switch (requestType) {
        case CLRequestTypeJSON:{
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case CLRequestTypePlainText:{
            
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default:{
            break;
        }
    }
    
    switch (responseType) {
        case CLResponseTypeJSON:{
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case CLResponseTypeXML:{
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case CLResponseTypeData:{
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default:
            break;
    }
    //设置请求头部
    if ([self configHeaders]) {
        for(NSString *key in [self configHeaders].allKeys) {
            if([self configHeaders][key] != nil)
            {
                [manager.requestSerializer setValue:[self configHeaders][key] forHTTPHeaderField:key];
            }
        }
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    manager.requestSerializer.timeoutInterval = [self timeout];
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 10;
    
    return manager;
}


- (BOOL)isCache{
    return NO;
}

- (void)cancelAllRequest
{
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(CLURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if([task isKindOfClass:[CLURLSessionTask class]] && task.state == NSURLSessionTaskStateRunning){
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    };
}

- (void)cancelRequestWithURL:(NSString *)url
{
    if(url == nil)
    {
        return;
    }
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(CLURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if([task isKindOfClass:[CLURLSessionTask class]] && [task.currentRequest.URL.absoluteString hasSuffix:url]){
                [task cancel];
                [[self allTasks] removeObject:task];
                return ;
            }
        }];
    };
}

//- (BOOL)autoCancelRequest{
//    return NO;
//}
//
//- (void)dealloc{
//    if ([self autoCancelRequest]) {
//        @synchronized (self) {
//            [[self allTasks] enumerateObjectsUsingBlock:^(CLURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
//                if([task isKindOfClass:[CLURLSessionTask class]] && task.taskIdentifier == self.currentTask.taskIdentifier && task.state == NSURLSessionTaskStateRunning){
//                    [task cancel];
//                    [[self allTasks] removeObject:task];
//                    return ;
//                }
//            }];
//        };
//    }
//}

- (NSMutableArray *)allTasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(requestTasks == nil){
            requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return requestTasks;
}

@end
