//
//  CLShareObject.m
//  Labor
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "CLShareObject.h"

static NSString *const DemoCacheKey = @"DemoCacheKey";

@implementation CLShareObject

+(instancetype) shared{
    static CLShareObject *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[CLShareObject alloc] init];
    });
    return sharedObj;
}

-(id)init{
    if(self = [super init]){
        self.cache = [[YYCache alloc]initWithName:DemoCacheKey];
    }
    return self;
}




@end
