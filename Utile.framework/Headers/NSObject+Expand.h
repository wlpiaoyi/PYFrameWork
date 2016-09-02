//
//  NSObejct+Expand.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(toDictionary)
/**
 通过JSON初始化对象
 */
+(nullable instancetype) objectWithDictionary:(nonnull NSDictionary*) dictionary;
/**
 通过JSON初始化对象
 */
+(nullable id) objectWithDictionary:(nonnull NSDictionary*) dictionary clazz:(nonnull Class) clazz;
/**
 通过对象生成JSON
 */
-(nullable NSDictionary*) objectToDictionary;

@end
