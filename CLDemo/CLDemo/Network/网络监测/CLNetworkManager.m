//
//  CLNetworkManager.m
//  LocationAndNetwork
//
//  Created by Apple on 2017/9/7.
//  Copyright © 2017年 chilim. All rights reserved.
//

#import "CLNetworkManager.h"
#import "CLNetReachability.h"

@interface CLNetworkManager ()

@property (nonatomic) CLNetReachability *hostReachability;

@end

@implementation CLNetworkManager

+ (instancetype)manager {
    static CLNetworkManager *notification = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notification = [[CLNetworkManager alloc] init];
    });
    return notification;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:cLReachabilityChangedNotification object:nil];
        // 网络检测通知
        _hostReachability = [CLNetReachability reachabilityForInternetConnection];
        [_hostReachability startNotifier];
    }
    return self;
}

/**
 同步网络变化监测方法。app启动时将启动网络变化监测。在其他地方使用时应先调用[RemoteService shared].networkReachabiltyStatus判断当前网络环境。再通过添加通知来获取网络的变化
 */
- (void)checkNetWork{
    CLNetReachability *reach = [CLNetReachability reachabilityForInternetConnection];
    [self updateReachability:reach];
}

//通过通知实时监测网络的状态切换，通过判断当前网络状态。使用时两种结合在一起使用。
- (void)updateReachability:(CLNetReachability *)reachability{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:        {
            self.networkReachabiltyStatus = CLNetworkReachabilityStatusNotReachable;
            [[NSNotificationCenter defaultCenter] postNotificationName:NNetworkNotReach object:nil];
            [[CLHudTool shared] cl_tipMessage:@"网络已断开！"];
            break;
        }
            
        case ReachableViaWWANGPRS:        {
            self.networkReachabiltyStatus = CLNetworkReachabilityStatusReachableViaWWANGPRS;
            [[NSNotificationCenter defaultCenter] postNotificationName:NNetworkReachWLAN object:nil];
            
            break;
        }
        case ReachableViaWWAN2G:        {
            self.networkReachabiltyStatus = CLNetworkReachabilityStatusReachableViaWWAN2G;
            [[NSNotificationCenter defaultCenter] postNotificationName:NNetworkReachWLAN object:nil];
            break;
        }
        case ReachableViaWWAN3G:        {
            self.networkReachabiltyStatus = CLNetworkReachabilityStatusReachableViaWWAN3G;
            [[NSNotificationCenter defaultCenter] postNotificationName:NNetworkReachWLAN object:nil];
            break;
        }
        case ReachableViaWWAN4G:        {
            self.networkReachabiltyStatus = CLNetworkReachabilityStatusReachableViaWWAN4G;
            [[NSNotificationCenter defaultCenter] postNotificationName:NNetworkReachWLAN object:nil];
            break;
        }
        case ReachableViaWiFi:        {
            self.networkReachabiltyStatus = CLNetworkReachabilityStatusReachableViaWiFi;
            [[NSNotificationCenter defaultCenter] postNotificationName:NNetworkReachWIFI object:nil];
            break;
        }
    }
}

- (void)reachabilityChanged:(NSNotification *)note
{
    CLNetReachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[CLNetReachability class]]);
    [self updateReachability:curReach];
}


@end
