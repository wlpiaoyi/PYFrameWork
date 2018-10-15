//
//  UIResponderHookBaseDelegateFWK.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFrameworkUtile.h"
#import "PYKeybordHeadView.h"


@interface UIResponderHookBaseDelegateFWK : NSObject<UIResponderHookBaseDelegate>
-(void) beforeExcuteDeallocWithTarget:(nonnull NSObject *) target;
@end
