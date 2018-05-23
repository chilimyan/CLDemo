//
//  UIImage+CLExtension.m
//  Labor
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "UIImage+CLExtension.h"

@implementation UIImage (CLExtension)

+ (UIImage *)getNameImage:(NSString *)name{
    // 绘制背景
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[self getBgColor:name].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 200, 200));
    
    // 添加名字
    NSString *username = (name.length>2 ? [name substringFromIndex:name.length-2] : name);
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    [username drawInRect:CGRectMake(0, 60, 200, 80) withAttributes:@{NSParagraphStyleAttributeName:paragraph, NSFontAttributeName:[UIFont boldSystemFontOfSize:200/42*14], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 获取图片
    UIImage *nameImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return nameImage;
}

+ (UIImage *)clipImage:(UIImage *)image userName:(NSString *)userName{
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 200, 200));
    if (image.size.width>image.size.height) {
        [image drawInRect:CGRectMake(0, 0, 200*image.size.width/image.size.height, 200)];
    } else {
        [image drawInRect:CGRectMake(0, 0, 200, 200*image.size.height/image.size.width)];
    }
    
    UIImage *photoImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return photoImage;
}

+ (UIColor *)getBgColor:(NSString *)userName{
    if (userName) {
        NSArray *bgColor = @[CLUIColorWithHex(0xffbd0d),CLUIColorWithHex(0x00ccff),CLUIColorWithHex(0x02c579),CLUIColorWithHex(0xff5857),CLUIColorWithHex(0xffd258),CLUIColorWithHex(0x69cef3),CLUIColorWithHex(0x69e2ba),CLUIColorWithHex(0xff9594),CLUIColorWithHex(0xbfbfbf)];
        NSData *nameData = [userName dataUsingEncoding:NSUTF8StringEncoding];
        Byte *nameByte = (Byte *)[nameData bytes];
        return bgColor[nameByte[nameData.length - 1] % bgColor.count];
    }
    return CLUIColorWithHex(0xffbd0d);
}

- (UIImage *)clipImage:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
