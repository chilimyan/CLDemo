//
//  CLDemoConfig.h
//  CLDemo
//
//  Created by Apple on 2018/5/23.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLDemoConfig : NSObject

@property (nonatomic, copy) NSString *URL;

+ (instancetype)config;

+ (void)getConfig;

@end
