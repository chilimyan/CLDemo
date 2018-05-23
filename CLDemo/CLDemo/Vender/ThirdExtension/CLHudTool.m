//
//  CLHudTool.m
//  CLProgressTip
//
//  Created by Apple on 2018/1/30.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "CLHudTool.h"
#import "NSObject+CLTool.h"

@implementation CLHudTool

+(instancetype) shared{
    static CLHudTool *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[CLHudTool alloc] init];
    });
    return sharedObj;
}

+ (void)cl_alert:(NSString *)msg{
    [CLHudTool cl_alert:msg cancel:@"确定"];
}

+ (void)cl_alert:(NSString *)msg action:(CLCommonVoidBlock)actionBlock
{
    [CLHudTool cl_alert:msg cancel:@"确定" action:actionBlock];
}

+ (void)cl_alertWithCancel:(NSString *)msg action:(CLCommonVoidBlock)actionBlock
{
    [CLHudTool cl_alertTitleWithCancel:@"提示" message:msg cancel:@"确定" action:actionBlock];
}

+ (void)cl_alert:(NSString *)msg cancel:(NSString *)cancel
{
    [CLHudTool cl_alertTitle:@"提示" message:msg cancel:cancel];
}
+ (void)cl_alert:(NSString *)msg cancel:(NSString *)cancel action:(CLCommonVoidBlock)actionBlock
{
    [CLHudTool cl_alertTitle:@"提示" message:msg cancel:cancel action:actionBlock];
}

+ (void)cl_alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

+ (void)cl_alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel action:(CLCommonVoidBlock)actionBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (actionBlock)
        {
            actionBlock();
        }
    }]];
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

+ (void)cl_alertTitleWithCancel:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel action:(CLCommonVoidBlock)actionBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (actionBlock)
        {
            actionBlock();
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

+ (void)cl_alertTitleWithCancel:(NSString *)title message:(NSString *)msg sure:(NSString *)sure sureAction:(CLCommonVoidBlock)actionBlock cancelAction:(CLCommonVoidBlock)cancelActionBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (actionBlock)
        {
            actionBlock();
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if (cancelActionBlock)
        {
            cancelActionBlock();
        }
    }]];
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

+ (void)cl_alertError:(NSError *) error{
    NSMutableArray *messageArray = [NSMutableArray array];
    if ([error localizedFailureReason] != nil) {
        [messageArray addObject:[error localizedFailureReason]];
    }
    if ([error localizedRecoverySuggestion] != nil) {
        [messageArray addObject:[error localizedRecoverySuggestion]];
    }
    [CLHudTool cl_alertTitle:[error localizedDescription] message:[messageArray componentsJoinedByString:@"\n"] cancel:@"确定"];
}

+ (void)cl_alertError:(NSError *)error action:(CLCommonVoidBlock)actionBlock{
    NSMutableArray *messageArray = [NSMutableArray array];
    if ([error localizedFailureReason] != nil) {
        [messageArray addObject:[error localizedFailureReason]];
    }
    if ([error localizedRecoverySuggestion] != nil) {
        [messageArray addObject:[error localizedRecoverySuggestion]];
    }
    [CLHudTool cl_alertTitle:[error localizedDescription] message:[messageArray componentsJoinedByString:@"\n"] cancel:@"确定" action:actionBlock];
}


- (MBProgressHUD *)cl_loading
{
    return [self cl_loading:nil];
}

- (MBProgressHUD *)cl_loading:(NSString *)msg
{
    return [self cl_loading:msg inView:nil];
}

- (MBProgressHUD *)cl_loading:(NSString *)msg inView:(UIView *)view
{
    UIView *inView = view ? view : [AppDelegate sharedAppdelegate].window;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!CLStringIsUrl(msg))
        {
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = msg;
        }
        [inView addSubview:hud];
        [hud show:YES];
        // 超时自动消失
//         [hud hide:YES afterDelay:kRequestTimeOutTime];
    });
    return hud;
}

- (void)cl_loading:(NSString *)msg delay:(CGFloat)seconds execute:(void (^)(void))exec completion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *inView = [AppDelegate sharedAppdelegate].window;
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
        if (!CLStringIsUrl(msg))
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = msg;
        }
        [inView addSubview:hud];
        [hud show:YES];
        if (exec)
        {
            exec();
        }
        // 超时自动消失
        [hud hide:YES afterDelay:seconds];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion();
            }
        });
    });
}

- (void)cl_stopLoading:(MBProgressHUD *)hud
{
    [self cl_stopLoading:hud message:nil];
}

- (void)cl_stopLoading:(MBProgressHUD *)hud message:(NSString *)msg
{
    [self cl_stopLoading:hud message:msg delay:0 completion:nil];
}

- (void)cl_stopLoading:(MBProgressHUD *)hud message:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)(void))completion
{
    if (hud && hud.superview)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!CLStringIsUrl(msg))
            {
                hud.labelText = msg;
                hud.mode = MBProgressHUDModeText;
            }
            [hud hide:YES afterDelay:seconds];
            _syncHUD = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (completion)
                {
                    completion();
                }
            });
        });
    }
}


- (void)cl_tipMessage:(NSString *)msg
{
    [self cl_tipMessage:msg delay:2];
}

- (void)cl_tipMessage:(NSString *)msg delay:(CGFloat)seconds
{
    [self cl_tipMessage:msg delay:seconds completion:nil];
}

- (void)cl_tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)(void))completion
{
    if (CLStringIsUrl(msg))
    {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[AppDelegate sharedAppdelegate].window];
        [[AppDelegate sharedAppdelegate].window addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = msg;
        [hud show:YES];
        [hud hide:YES afterDelay:seconds];
        CommonRelease(HUD);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion();
            }
        });
    });
}

#define kSyncHUDStartTag  100000

// 网络请求
- (void)cl_syncLoading
{
    [self cl_syncLoading:nil];
}
- (void)cl_syncLoading:(NSString *)msg
{
    [self cl_syncLoading:msg inView:nil];
}
- (void)cl_syncLoading:(NSString *)msg inView:(UIView *)view
{
    if (_syncHUD)
    {
        _syncHUD.tag++;
        if (!CLStringIsUrl(msg))
        {
            _syncHUD.labelText = msg;
            _syncHUD.mode = MBProgressHUDModeText;
        }
        else
        {
            _syncHUD.labelText = nil;
            _syncHUD.mode = MBProgressHUDModeIndeterminate;
        }
        return;
    }
    _syncHUD = [self cl_loading:msg inView:view];
    _syncHUD.tag = kSyncHUDStartTag;
}

- (void)cl_syncStopLoading
{
    [self cl_syncStopLoadingMessage:nil delay:0 completion:nil];
}

- (void)cl_syncStopLoadingMessage:(NSString *)msg
{
    [self cl_syncStopLoadingMessage:msg delay:1 completion:nil];
}

- (void)cl_syncStopLoadingMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)(void))completion
{
    _syncHUD.tag--;
    if (_syncHUD.tag > kSyncHUDStartTag)
    {
        if (!CLStringIsUrl(msg))
        {
            _syncHUD.labelText = msg;
            _syncHUD.mode = MBProgressHUDModeText;
        }
        else
        {
            _syncHUD.labelText = nil;
            _syncHUD.mode = MBProgressHUDModeIndeterminate;
        }
    }
    else
    {
        [self cl_stopLoading:_syncHUD message:msg delay:seconds completion:completion];
    }
}



@end
