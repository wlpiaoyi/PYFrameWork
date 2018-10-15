//
//  UIViewcontrollerHookOrientationDelegateImp.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "PYFrameworkParamOrientation.h"

@interface UIViewcontrollerHookOrientationDelegateImp : NSObject<UIViewcontrollerHookOrientationDelegate>
@property (nonatomic, strong, nullable) PYFrameworkParamOrientation * frameworkOrientation;
//重写父类方法判断是否可以旋转
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target;

//重写父类方法判断支持的旋转方向
-(UIInterfaceOrientationMask) afterExcuteSupportedInterfaceOrientationsWithTarget:(nonnull UIViewController *) target;

//重写父类方法返回当前方向
-(UIInterfaceOrientation) afterExcutePreferredInterfaceOrientationForPresentationWithTarget:(nonnull UIViewController *) target;
//⇒ 重写父类方法旋转开始和结束
-(void) afterExcuteViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator target:(nonnull UIViewController *)target;
@end
