//
//  CLResponseObject.h
//  Labor
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLResponseObject : NSObject

@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *meg;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) id datas;
///考勤打卡接口异常判断1：正常、0：异常
@property (nonatomic, strong) id result;
@property (nonatomic, strong) id jsonList;
@property (nonatomic, assign) BOOL isRecord;

- (BOOL)isImageFile;

@end

@interface Attachment : NSObject

@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *hrefUrl;
@property (nonatomic, copy) NSString *savePath;
@property (nonatomic, copy) NSString *herfUrl;
@property (nonatomic, copy) NSString *fileSuffix;
@property (nonatomic, copy) NSString *fileSize;

@end
