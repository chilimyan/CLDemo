//
//  CLUploadRequest.m
//  CLNetworking
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 chilim. All rights reserved.
//

#import "CLUploadRequest.h"

@implementation CLUploadImageRequest

- (instancetype)initWithFileName:(NSString *)fileName
                        filePath:(NSString *)filePath
                             wid:(NSString *)wid
                        fileType:(NSString *)fileType
                        mimeType:(NSString *)mimeType{
    if (self = [super init]) {
        _fileType = fileType;
        _fileName = fileName;
        _filePath = filePath;
        _wid = wid;
        _mimeType = mimeType;
    }
    return self;
}

- (NSDictionary *)requestParams{
    return @{@"userId":[CLShareObject shared].loginUser.userId,
             @"fileName":_fileName ? _fileName : @"",
             @"filePath":_filePath ? _filePath : @"",
             @"wid":_wid ? _wid : @"",
             @"fileType":_fileType ? _fileType : @"",
             @"mimeType":_mimeType ? _mimeType : @""
             };
}

- (NSString *)requestAPI{
    return @"selectAttachmentUpload";
}

- (CLHttpMethodType)getHttpMethod{
    return CLFilePost;
}

- (NSInteger)timeout{
    return 30;
}

- (AFConstructingBodyBlock)constructingBodyBlock{
    WS(weakSelf);
    void (^bodyBlock)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        NSDictionary *newParams = [weakSelf requestParams];
        NSString *filePath = [newParams objectForKey:@"filePath"];
        NSString *fileName = [newParams objectForKey:@"fileName"];
        NSString *mimeType = [newParams objectForKey:@"mimeType"];
        NSData *imageData = [[NSData alloc]initWithContentsOfFile:filePath];
        [formData appendPartWithFileData:imageData name:@"fj_file" fileName:fileName mimeType:mimeType];
    };
    return bodyBlock;
}

@end

@implementation CLUploadRequest

+ (void)uploadRequestWithImageName:(NSString *)fileName
                          filePath:(NSString *)filePath
                               wid:(NSString *)wid
                          fileType:(NSString *)fileType
                          mimeType:(NSString *)mimeType
                     completeBlock:(void(^)(Attachment * attachment))completeBlock {
    CLUploadImageRequest *request = [[CLUploadImageRequest alloc] initWithFileName:fileName
                                                                          filePath:filePath
                                                                               wid:wid
                                                                          fileType:fileType
                                                                          mimeType:mimeType];
    [request requestWithModel:[Attachment class] success:completeBlock failed:nil];
}

@end
