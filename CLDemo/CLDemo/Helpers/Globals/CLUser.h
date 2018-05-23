//
//  CLUser.h
//  Labor
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUser : NSObject

@property (nonatomic, copy) NSString *userPhoto;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

+ (instancetype)userWithUserId:(NSString *)userId userName:(NSString *)userName userPhoto:(NSString *)userPhoto;

- (instancetype)initWithUserId:(NSString *)userId userName:(NSString *)userName userPhoto:(NSString *)userPhoto;

@end
