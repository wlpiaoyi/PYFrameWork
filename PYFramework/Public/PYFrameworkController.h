//
//  PYFrameworkController.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
#import "PYFwnmParam.h"


@interface PYFrameworkController : UIViewController

/**
 当前显示Controller的状态
 */
@property (nonatomic, readonly) PYFrameworkShow frameworkShow;

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
@property (nonatomic, copy, nonnull) void (^blockLayoutAnimate)(PYFrameworkShow frameworkShow, UIView * _Nullable rootView, UIView * _Nonnull menuView);
///<==

-(void) refreshChildControllerWithShow:(PYFrameworkShow) show delayTime:(NSTimeInterval) delayTime;
-(BOOL) removeRootController;
-(BOOL) removeMenuController;
@end
