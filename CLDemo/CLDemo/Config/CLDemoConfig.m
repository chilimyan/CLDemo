
//
//  CLDemoConfig.m
//  CLDemo
//
//  Created by Apple on 2018/5/23.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "CLDemoConfig.h"

@implementation CLDemoConfig

+ (instancetype)config {
    static CLDemoConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[CLDemoConfig alloc] init];
    });
    return config;
}


+ (void)getConfig{
    //========读取工程配置,配合批量打包============
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [CLDemoConfig config].URL = [data objectForKey:@"AppEnv"];
}


@end
