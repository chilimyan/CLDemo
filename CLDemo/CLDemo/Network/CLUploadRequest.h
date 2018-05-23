//
//  CLUploadRequest.h
//  CLNetworking
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLNetworkBase.h"

@interface CLUploadImageRequest : CLNetworkBase

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *wid;

@end

@interface CLUploadRequest : NSObject

+ (void)uploadRequestWithImageName:(NSString *)fileName
                          filePath:(NSString *)filePath
                               wid:(NSString *)wid
                          fileType:(NSString *)fileType
                          mimeType:(NSString *)mimeType
                     completeBlock:(void(^)(Attachment * attachment))completeBlock;

@end
