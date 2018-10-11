//
//  PYFrameworkController.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//  基础框架结构
//  分为 目录控制器 和 显示控制器
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
#import "PYFrameworkParam.h"

@class PYFrameworkController;
@protocol PYFrameworkDelegate<NSObject>
@required
-(void) pyfwDelegateLayoutAnimate:(nonnull PYFrameworkController *) pyfwVc pyfwShow:(PYFrameworkShow) pyfwShow rootParams:(nonnull PYFwlayoutParams *) rootsParams menusParams:(nonnull PYFwlayoutParams *) menusParams;
@end

@interface PYFrameworkController : UIViewController
/**
 显示和动作delegate/block设置
 */
//==>
kPNANA id<PYFrameworkDelegate> pyfwDelegate;
kPNCNA void (^blockLayoutAnimate)(PYFrameworkShow pyfwShow, PYFwlayoutParams * _Nullable rootsParams, PYFwlayoutParams * _Nullable menusParams);
///<==
/**
 当前显示Controller的状态
 */
kPNAR PYFrameworkShow pyfwShow;
/**
 是否在运动中
 */
//===>
kPNAR bool isRootAnimated;
kPNAR bool isMenuAnimated;
///<==

/**
 控制器
 */
//==>
kPNSNN UIViewController * rootController;
kPNSNN UIViewController * menuController;
///<==
kPNA UIViewAnimationTransition rootAnimationTransition;

/**
 显示控制
 */
//==>
-(BOOL) refreshChildControllerWithShow:(PYFrameworkShow) show delayTime:(NSTimeInterval) delayTime;
-(void) setShow:(PYFrameworkShow) show rootsParams:(PYFwlayoutParams) rootsParams menusParams:(PYFwlayoutParams) menusParams;
-(void) refreshLayout;
///<==

-(BOOL) removeRootController;
-(BOOL) removeMenuController;
@end
