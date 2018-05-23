//
//  CLResponseObject.m
//  Labor
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "CLResponseObject.h"

@implementation CLResponseObject

@end

@implementation Attachment

- (BOOL)isImageFile{
    if ([_fileSuffix isEqualToString:@".jpg"] || [_fileSuffix isEqualToString:@".JPEG"] || [_fileSuffix isEqualToString:@".jpeg"] || [_fileSuffix isEqualToString:@".png"] || [_fileSuffix isEqualToString:@".PNG"]) {
        return YES;
    }
    return NO;
}


@end
