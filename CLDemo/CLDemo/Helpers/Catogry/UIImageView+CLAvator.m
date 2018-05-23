//
//  UIImageView+CLAvator.m
//  Labor
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "UIImageView+CLAvator.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <objc/runtime.h>
#import "UIImage+CLExtension.h"

static char *userInfo;
static char *showDetail;

@implementation UIImageView (CLAvator)

- (void)setUser:(CLUser *)user{
    objc_setAssociatedObject(self, &userInfo, user, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CLUser *)user{
    return objc_getAssociatedObject(self, &userInfo);
}

- (void)setUserDetail:(showDetailBlock)userDetail{
    objc_setAssociatedObject(self, &showDetail, userDetail, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (showDetailBlock)userDetail{
    return objc_getAssociatedObject(self, &showDetail);
}

- (void)displayUser:(CLUser *)user {
    
    UIImage *nameImage = [UIImage getNameImage:user.userName];
    self.image = nameImage;
    self.contentMode = UIViewContentModeScaleAspectFit;
    // 下载图片
    if ([user.userPhoto isEqualToString:@""]) {
        self.image = nameImage;
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:[user.userPhoto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                placeholderImage:nameImage
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (image) {
                               self.image = [UIImage clipImage:image userName:user.userName];
                           } else {
                               self.image = nameImage;
                           }
                       }];
    }
}

//显示头像并且点击查看大图
- (void)displayUser:(CLUser *)user withTouchBigImage:(BOOL)isTouch isCircle:(BOOL)isCircle{
    self.user = user;
    [self displayUser:self.user];
    if (isCircle) {
        self.cl_cornerRadius = self.frame.size.width/2;
        self.cl_cornerPosition = CLCornerPositionAll;
    }
    if (isTouch) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)];
        [self addGestureRecognizer:tapGesture];
    }
}

//显示头像并且点击查看用户详情
- (void)displayUser:(CLUser *)user withTouchDetail:(BOOL)isTouch isCircle:(BOOL)isCircle{
    self.user = user;
    [self displayUser:self.user];
    if (isCircle) {
        self.cl_cornerRadius = self.frame.size.width/2;
        self.cl_cornerPosition = CLCornerPositionAll;
    }
    if (isTouch) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)];
        [self addGestureRecognizer:tapGesture];
    }
}

- (void)showDetail{
    if (self.userDetail) {
        self.userDetail();
    }
}

- (void)showImage{
    UIView *view = [[UIView alloc] init];
    view.frame = [UIScreen mainScreen].bounds;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0;
    view.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    
    if (self.user.userPhoto && ![self.user.userPhoto isEqualToString:@""]) {
        [imageView displayImage:self.user.userPhoto];
    } else {
        imageView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-[UIScreen mainScreen].bounds.size.width)/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        [imageView displayUser:self.user];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
        [view addGestureRecognizer:tapGesture];
    }];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
}

- (void)hideImage:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.4 animations:^{
        gesture.view.alpha = 0;
    } completion:^(BOOL finished) {
        [gesture.view removeFromSuperview];
    }];
}

-(void)displayImage:(NSString*)photo{
    [self sd_setImageWithURL:[NSURL URLWithString:photo]
            placeholderImage:[UIImage imageNamed:@"common_default_pic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.image = image;
            }];
}

- (void)displayPhotoUpload:(Attachment *)attachment{
    [self sd_setImageWithURL:[NSURL URLWithString:attachment.hrefUrl]
            placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image){
                    self.image = [image clipImage:CGSizeMake(50, 50)];
                }
            }];
}

@end
