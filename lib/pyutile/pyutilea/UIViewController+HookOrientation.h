//
//  UIViewController+Orientation.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/1/16.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 hook 转屏 delegate
 */
@protocol UIViewcontrollerHookOrientationDelegate<NSObject>
@optional
//重写父类方法判断是否可以旋转
-(void) beforeExcuteShouldAutorotate:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target result:(BOOL) result;

//重写父类方法判断支持的旋转方向
-(void) beforeExcuteSupportedInterfaceOrientations:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(UIInterfaceOrientationMask) afterExcuteSupportedInterfaceOrientationsWithTarget:(nonnull UIViewController *) target;

//重写父类方法返回当前方向
-(void) beforeExcutePreferredInterfaceOrientationForPresentation:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(UIInterfaceOrientation) afterExcutePreferredInterfaceOrientationForPresentationWithTarget:(nonnull UIViewController *) target;

// ==> 重写父类方法旋转开始和结束
-(void) beforeExcuteViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nullable id<UIViewControllerTransitionCoordinator>)coordinator isExcute:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target;
-(void) afterExcuteViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nullable id<UIViewControllerTransitionCoordinator>)coordinator target:(nonnull UIViewController *)target;

-(void) beforeExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration isExcute:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target NS_DEPRECATED_IOS(2_0,8_0, "Implement beforeExcuteViewWillTransitionToSize:withTransitionCoordinator: instead") __TVOS_PROHIBITED;
-(void) afterExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration target:(nonnull UIViewController *) target NS_DEPRECATED_IOS(2_0,8_0, "Implement afterExcuteViewWillTransitionToSize:withTransitionCoordinator: instead") __TVOS_PROHIBITED;
-(void) beforeExcuteDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation isExcute:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target NS_DEPRECATED_IOS(2_0,8_0) __TVOS_PROHIBITED;
-(void) afterExcuteDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation target:(nonnull UIViewController *) target NS_DEPRECATED_IOS(2_0,8_0) __TVOS_PROHIBITED;

// <== 重写父类方法旋转开始和结束

#pragma 废弃的方法
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target NS_DEPRECATED_IOS(2_0, 7_0, "Use aftlerExcuteShouldAutorotateWithTarget:result");
@end
/**
 hook 转屏的实体
 */
@interface UIViewController(HookOrientation)
+(nullable NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> *) delegateOrientations;
+(void) addDelegateOrientation:(nullable id<UIViewcontrollerHookOrientationDelegate>) delegateOrientation;
+(BOOL) hookMethodOrientation;
@end
