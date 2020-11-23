//
//  PYFrameworkUtile.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/24.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkUtile.h"
#import "pyutilea.h"
#import <objc/runtime.h>
#import "UIViewcontrollerHookViewDelegateImp.h"
#import "UIViewcontrollerHookOrientationDelegateImp.h"
#import "UIViewController+CurrentInterfaceOrientation.h"
#import "pykita.h"

static UIViewcontrollerHookOrientationDelegateImp * xUIViewcontrollerHookOrientationDelegateImp;
static UIViewcontrollerHookViewDelegateImp * xUIViewcontrollerHookViewDelegateImp;

@implementation PYFrameworkUtile

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        [PYKeyboardControll setControllType:PYKeyboardControllTag];
        xUIViewcontrollerHookOrientationDelegateImp = [UIViewcontrollerHookOrientationDelegateImp new];
        xUIViewcontrollerHookViewDelegateImp = [UIViewcontrollerHookViewDelegateImp new];
        [UIResponder hookWithMethodNames:nil];
        [UINavigationController hookMethodWithName:@"preferredStatusBarStyle"];
    });
}

///**
// 返回按钮图片
// */
//+(void) setBackItemForPopvc:(nullable UIImage *) popvc dismissvc:(nullable UIImage *) dismissvc{
//    [PYNavigationControll setBackItemWithPopImage:popvc dismissImage:dismissvc];
//}
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYFrameworkParamOrientation *) frameworkOrientation{
    xUIViewcontrollerHookOrientationDelegateImp.frameworkOrientation = frameworkOrientation;
    [UIViewController hookMethodOrientation];
    [UIViewController hookMethodView];
    if (![[UIViewController delegateOrientations] containsObject:xUIViewcontrollerHookOrientationDelegateImp]) {
        [UIViewController addDelegateOrientation:xUIViewcontrollerHookOrientationDelegateImp];
    }
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
}
@end





