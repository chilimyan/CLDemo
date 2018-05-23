//
//  CLNetworkManager.h
//  LocationAndNetwork
//
//  Created by Apple on 2017/9/7.
//  Copyright © 2017年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const NNetworkReachWIFI = @"NNetworkReachWIFI";
static NSString * const NNetworkNotReach = @"NNetworkNotReach";
static NSString * const NNetworkReachWLAN = @"NNetworkReachWLAN";

typedef NS_ENUM(NSInteger, CLNetworkReachablityStatus) {
    CLNetworkReachabilityStatusUnknown          = -1,
    CLNetworkReachabilityStatusNotReachable     = 0,
    CLNetworkReachabilityStatusReachableViaWWANGPRS = 1,
    CLNetworkReachabilityStatusReachableViaWWAN2G = 2,
    CLNetworkReachabilityStatusReachableViaWWAN3G = 3,
    CLNetworkReachabilityStatusReachableViaWWAN4G = 4,
    CLNetworkReachabilityStatusReachableViaWiFi = 5,
};


@interface CLNetworkManager : NSObject

/**
 *  网络连接状态
 */
@property (nonatomic , assign) CLNetworkReachablityStatus networkReachabiltyStatus;

+ (instancetype)manager;
- (void)checkNetWork;

@end
