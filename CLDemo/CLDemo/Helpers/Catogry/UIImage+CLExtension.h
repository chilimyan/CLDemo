//
//  UIImage+CLExtension.h
//  Labor
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CLExtension)

+ (UIImage *)getNameImage:(NSString *)name;
+ (UIImage *)clipImage:(UIImage *)image userName:(NSString *)userName;

- (UIImage *)clipImage:(CGSize)newSize;

@end
