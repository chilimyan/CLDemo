//
//  CLShareObject.h
//  Labor
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLResponseObject.h"
#import "UIImageView+CLAvator.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <Masonry.h>
#import "CLUser.h"
#import <YYCache/YYCache.h>

@interface CLShareObject : NSObject

@property (nonatomic , strong)CLUser *loginUser;
/**
 *  app数据缓存
 */
@property (nonatomic, strong)YYCache *cache;


+(instancetype) shared;


@end
