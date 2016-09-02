//
//  UIViewController+Hook.m
//  FrameWork
//
//  Created by wlpiaoyi on 15/9/1.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "UIViewController+Hook.h"
#import <objc/runtime.h>

@implementation UIViewController(hook)

-(void) exchangeDealloc{
    objc_removeAssociatedObjects(self);
    [self exchangeDealloc];
}
//<== exchangeMethods
+(BOOL) hookWithMethodNames:(nonnull NSArray<NSString *> *) methodNames{
    if (![self isSubclassOfClass:[UIViewController class]]) {
        return false;
    }
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [UIViewController hookMethodWithName:@"dealloc"];
    });
    
    @synchronized([UIViewController class]){
        for (NSString *methodName in methodNames) {
            if([self hookMethodWithName:methodName]){
                NSLog(@"%@ hook Success",methodName);
            }else{
                NSLog(@"%@ hook Faild",methodName);
            }
        }
    }
    return true;
}

+(BOOL) hookMethodWithName:(NSString*) name{
    SEL orgSel = sel_getUid(name.UTF8String);
    SEL exchangeSel = sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]].UTF8String);
    if(![self instancesRespondToSelector:orgSel]){
        return false;
    }
    if(![self instancesRespondToSelector:exchangeSel]){
        return false;
    }
    Method orgMethod = class_getInstanceMethod(self, orgSel);
    Method exchangeMethod = class_getInstanceMethod(self, exchangeSel);
    method_exchangeImplementations(exchangeMethod, orgMethod);
    return true;
    
}


@end

