//
//  PYFrameworkController.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
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
 显示和动作delegate设置
 */
kPNANA id<PYFrameworkDelegate> pyfwDelegate;
/**
 当前显示Controller的状态
 */
@property (nonatomic, readonly) PYFrameworkShow pyfwShow;

/**
 是否在运动中
 */
//===>
@property (nonatomic, readonly) bool isRootAnimated;
@property (nonatomic, readonly) bool isMenuAnimated;
///<==

/**
 控制器
 */
//==>
@property (nonatomic, strong, nonnull) UIViewController * rootController;
@property (nonatomic, strong, nonnull) UIViewController * menuController;
///<==

/**
 显示和动作block设置
 */
//==>
@property (nonatomic, copy, nullable) void (^blockLayoutAnimate)(PYFrameworkShow pyfwShow, PYFwlayoutParams * _Nullable rootsParams, PYFwlayoutParams * _Nullable menusParams);
///<==

-(BOOL) refreshChildControllerWithShow:(PYFrameworkShow) show delayTime:(NSTimeInterval) delayTime;
-(BOOL) removeRootController;
-(BOOL) removeMenuController;
-(void) refreshLayout;
@end
