//
//  PYConfigManager.h
//  PYEntityManager
//
//  Created by wlpiaoyi on 15/10/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 可以存储NSDictionary ,NSArray ,NSString ,NSNumber ,NSData ,NSDate class ,(实体对象)
 动态方法必须要等到PYConfigManger回收后才会自动持久化
 静态方法存储立即持久化
 */
@interface PYConfigManager : NSObject

-(void) setValue:(nullable id) value forKey:(nonnull NSString*) key;
-(nullable id) valueForKey:(nonnull NSString*) key;
-(void) removeValueForKey:(nonnull NSString*) key;
-(BOOL) removeAll;
-(BOOL) synchronize;

+(BOOL) setConfigValue:(nullable id) value forKey:(nonnull NSString*) key;
+(nullable id) configValueForKey:(nonnull NSString*) key;
+(void) removeConfigValueForKey:(nonnull NSString*) key;
+(BOOL) removeAllConfig;


@end
