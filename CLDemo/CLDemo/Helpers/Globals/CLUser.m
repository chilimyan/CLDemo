//
//  CLUser.m
//  Labor
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "CLUser.h"

@implementation CLUser

- (NSString *)userId{
    if (_userId) {
        return _userId;
    }
    return @"严济林";
}

- (NSString *)userName{
    if (_userName) {
        return _userName;
    }
    return @"严济林";
}

- (NSString *)userPhoto{
    if (_userPhoto) {
        return _userPhoto;
    }
    return @"";
}

+ (instancetype)userWithUserId:(NSString *)userId userName:(NSString *)userName userPhoto:(NSString *)userPhoto{
    return [[self alloc] initWithUserId:userId userName:userName userPhoto:userPhoto];
}

- (instancetype)initWithUserId:(NSString *)userId userName:(NSString *)userName userPhoto:(NSString *)userPhoto{
    if (self = [super init]) {
        _userId = userId;
        _userName = userName;
        _userPhoto = userPhoto;
    }
    return self;
}

@end
