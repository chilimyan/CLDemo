//
//  UIImageView+CLAvator.h
//  Labor
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUser.h"

@interface UIImageView (CLAvator)

typedef void (^showDetailBlock)();

@property (nonatomic , strong)CLUser *user;
@property (nonatomic, copy) showDetailBlock userDetail;

///设置头像无圆角
- (void)displayUser:(CLUser *)user;
///设置头像并且点击查看大图
- (void)displayUser:(CLUser *)user withTouchBigImage:(BOOL)isTouch isCircle:(BOOL)isCircle;
///设置头像并且点击跳转
- (void)displayUser:(CLUser *)user withTouchDetail:(BOOL)isTouch isCircle:(BOOL)isCircle;

///显示上传的图片
- (void)displayPhotoUpload:(Attachment *)attachment;
///显示网络图片
-(void)displayImage:(NSString*)photo;

@end
