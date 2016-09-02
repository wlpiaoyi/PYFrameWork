//
//  RegexPredicate.h
//  Common
//
//  Created by wlpiaoyi on 14/12/31.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.===
//


#import <Foundation/Foundation.h>
/**
 正则表达式
 */
@interface PYRegexPredicate : NSObject
/**
 整数
 */
+(BOOL) matchInteger:(NSString*) arg;
/**
 小数
 */
+(BOOL) matchFloat:(NSString*) arg;
/**
 手机号码
 */
+(BOOL) matchMobliePhone:(NSString*) arg;
/**
 座机号码
 */
+(BOOL) matchHomePhone:(NSString*) arg;
/**
 邮箱
 */
+(BOOL) matchEmail:(NSString*) arg;
/**
 身份证
 */
+(BOOL) matchIDCard:(NSString*) arg;
/**
 港澳通行证
 */
+(BOOL) matchHkMacCard:(NSString*) arg;
/**
 台湾通行证
 */
+(BOOL) matchTWCard:(NSString*) arg;
/**
 护照
 */
+(BOOL) matchPassport:(NSString*) arg;
+(BOOL) matchArg:(NSString*) arg regex:(NSString*) regex;

@end
