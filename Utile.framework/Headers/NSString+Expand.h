//
//  NSString+Convenience.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Expand)
-(NSComparisonResult) compareVersion:(nullable NSString *) version;
-(nullable NSString *)filterHTML;
/**
 将字符串转换成日期
 */
-(nullable NSDate*) dateFormateString:(nullable NSString *) formatePattern;
/**
 判断字符串是否有效 "",nil,NO,NSNull
 */
+(bool) isEnabled:(nullable id) target;
/**
 将Data转换成64位对应的字符串
 */
+(nullable NSString *) base64forData:(nullable NSData *)theData;


///**
// 当前字符串是否是以suffix结尾
// */
//-(bool) stringEndWith:(nonnull NSString*) suffix;
///**
// 当前字符串是否是以suffix开头
// */
//-(bool) stringStartWith:(nonnull NSString*) suffix;
///**
// 当前字符串对应字符最后出现的位置
// */
//-(int) intLastIndexOf:(char) suffix;
///**
// 当前字符串对应字符出现的位置
// */
//-(int) intIndexOf:(int) index Suffix: (char) suffix;
//-(nullable NSString*) replaceAll:(nonnull NSString*) target replcement:(nonnull NSString*) replcement;
@end
