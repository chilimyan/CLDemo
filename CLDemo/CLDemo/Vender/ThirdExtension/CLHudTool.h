//
//  CLHudTool.h
//  CLProgressTip
//
//  Created by Apple on 2018/1/30.
//  Copyright © 2018年 chilim. All rights reserved.
//HUDView

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
#import "NSObject+CLBlockTool.h"
#import "CLStringMacroTool.h"
@interface CLHudTool : NSObject

@property (nonatomic, strong)MBProgressHUD *syncHUD;

+(instancetype) shared;
///========系统提示框=============////
+ (void)cl_alert:(NSString *)msg;
+ (void)cl_alert:(NSString *)msg action:(CLCommonVoidBlock)actionBlock;
+ (void)cl_alert:(NSString *)msg cancel:(NSString *)cancel;
+ (void)cl_alert:(NSString *)msg cancel:(NSString *)cancel action:(CLCommonVoidBlock)actionBlock;
+ (void)cl_alertWithCancel:(NSString *)msg action:(CLCommonVoidBlock)actionBlock;
+ (void)cl_alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel;
+ (void)cl_alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel action:(CLCommonVoidBlock)actionBlock;
+ (void)cl_alertError:(NSError *) error;
+ (void)cl_alertError:(NSError *)error action:(CLCommonVoidBlock)actionBlock;
+ (void)cl_alertTitleWithCancel:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel action:(CLCommonVoidBlock)actionBlock;
+ (void)cl_alertTitleWithCancel:(NSString *)title message:(NSString *)msg sure:(NSString *)sure sureAction:(CLCommonVoidBlock)actionBlock cancelAction:(CLCommonVoidBlock)cancelActionBlock;

///===========MBProgressHUD=============///
- (MBProgressHUD *)cl_loading;
- (MBProgressHUD *)cl_loading:(NSString *)msg;
- (MBProgressHUD *)cl_loading:(NSString *)msg inView:(UIView *)view;
- (void)cl_loading:(NSString *)msg delay:(CGFloat)seconds execute:(void (^)(void))exec completion:(void (^)(void))completion;

- (void)cl_stopLoading:(MBProgressHUD *)hud;
- (void)cl_stopLoading:(MBProgressHUD *)hud message:(NSString *)msg;
- (void)cl_stopLoading:(MBProgressHUD *)hud message:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)(void))completion;

///提示语
- (void)cl_tipMessage:(NSString *)msg;
- (void)cl_tipMessage:(NSString *)msg delay:(CGFloat)seconds;
- (void)cl_tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)(void))completion;

// 网络请求
- (void)cl_syncLoading;
- (void)cl_syncLoading:(NSString *)msg;
- (void)cl_syncLoading:(NSString *)msg inView:(UIView *)view;

- (void)cl_syncStopLoading;
- (void)cl_syncStopLoadingMessage:(NSString *)msg;
- (void)cl_syncStopLoadingMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)(void))completion;

@end
