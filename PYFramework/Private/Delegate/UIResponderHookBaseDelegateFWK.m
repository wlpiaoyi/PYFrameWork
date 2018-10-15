//
//  UIResponderHookBaseDelegateFWK.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIResponderHookBaseDelegateFWK.h"
#import "UIViewcontrollerHookViewDelegateImp.h"

@implementation UIResponderHookBaseDelegateFWK

-(void) beforeExcuteDeallocWithTarget:(nonnull NSObject *) target{
    if(![target conformsToProtocol:@protocol(PYKeyboradShowtag)]) return;
    PYKeybordHeadView * keybordHead = [UIViewcontrollerHookViewDelegateImp keybordHead:(UIViewController *)target];
    if(keybordHead)[PYKeyboardNotification removeKeyboardNotificationWithResponder:keybordHead];
}

@end
