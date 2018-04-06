//
//  PYFrameworkUtile.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/24.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFrameworkParam.h"

@interface PYFrameworkUtileOrientation : NSObject
@property (nonatomic) BOOL shouldAutorotate;
@property (nonatomic) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property (nonatomic) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;
@end

@interface UIViewController(currentInterfaceOrientation)
@property (nonatomic, readwrite) UIInterfaceOrientation currentInterfaceOrientation;
@end

@interface PYFrameworkUtileBarButtonItem : NSObject

@property (nonatomic, assign) CGSize shadowOffset;      // offset in user space of the shadow from the original drawing
@property (nonatomic, assign) CGFloat shadowBlurRadius; // blur radius of the shadow in default user space units
@property (nullable, nonatomic, strong) id shadowColor;     // color used for the shadow (default is black with an alpha value of 1/3)

@property (nonatomic, strong, nullable) UIColor * nameColor;
@property (nonatomic, strong, nullable) UIFont * nameFont;

@property (nonatomic) UIControlState currentState;

+(nullable instancetype) defaut;

@end

@interface PYFrameworkUtileNavigationbar : NSObject

@property (nonatomic, assign) CGSize shadowOffset;      // offset in user space of the shadow from the original drawing
@property (nonatomic, assign) CGFloat shadowBlurRadius; // blur radius of the shadow in default user space units
@property (nullable, nonatomic, strong) UIColor * shadowColor;     // color used for the shadow (default is black with an alpha value of 1/3)

@property (nonatomic, strong, nullable) UIColor * nameColor;
@property (nonatomic, strong, nullable) UIFont * nameFont;

@property (nonatomic, strong, nullable) UIColor * tintColor;
@property (nonatomic, strong, nullable) UIColor * backgroundColor;
@property (nonatomic, strong, nullable) UIImage * backgroundImage;
@property (nonatomic, strong, nullable) UIImage * lineButtomImage;
@property (nonatomic, assign) UIBarMetrics barMetrics;

@property (nonatomic, assign)UIStatusBarStyle statusBarStyle;
+(nullable instancetype) defaut;

@end



@interface PYFrameworkUtile : NSObject
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYFrameworkUtileOrientation *) frameworkOrientation;
/**
 导航栏默认设置
 */
+(void) setViewControllerNavigationbarData:(nullable NSArray<PYFrameworkUtileNavigationbar*> *) managerNavigationbarDatas;
/**
 导航栏默认设置
 */
+(void) setViewControllertBarButtonItemData:(nullable NSArray<PYFrameworkUtileBarButtonItem*> *) managerBarButtonItemData;
/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem managerBarButtonItemData:(nonnull PYFrameworkUtileBarButtonItem *) managerBarButtonItemData;
/**
 设置导航栏样式
 */
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar managerNavigationbarData:(nonnull PYFrameworkUtileNavigationbar *) managerNavigationbarData;
/**
 将button的image和title纵向显示
 #param offH:间距
 #param maxHeight:imageSize.height的最大高度，主要用于多个button的image 和 title 的协调
 #param direction:0 title在上 1 title在下
 */
+(void) parseImagetitleForButton:(nonnull UIButton *) button offH:(CGFloat) offH maxHeight:(CGFloat) maxHeight direction:(short) direction;
/**
 创建上下结构的文字图片结构
 direction：(0:top, 1:left, 2:bottom, 3:right)
 */
+(nonnull UIImage *) createImageWithTitle:(nonnull NSString *) title font:(nonnull UIFont *) font color:(nonnull UIColor *) color image:(nonnull UIImage *) image offH:(CGFloat) offH imageOffH:(CGFloat) imageOffH direction:(short) direction;
@end
