//
//  AppDelegate.h
//  CLDemo
//
//  Created by Apple on 2018/5/23.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedAppdelegate;

@end

