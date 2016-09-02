//
//  PYUtileManager.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/24.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYUtileManagerOrientationData : NSObject
@property (nonatomic) BOOL shouldAutorotate;
@property (nonatomic) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property (nonatomic) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;
@end

@interface UIViewController(currentInterfaceOrientation)
@property (nonatomic, readwrite) UIInterfaceOrientation currentInterfaceOrientation;
@end

@interface PYUtileManagerBarButtonItemData : NSObject

@property (nonatomic, assign) CGSize shadowOffset;      // offset in user space of the shadow from the original drawing
@property (nonatomic, assign) CGFloat shadowBlurRadius; // blur radius of the shadow in default user space units
@property (nullable, nonatomic, strong) id shadowColor;     // color used for the shadow (default is black with an alpha value of 1/3)

@property (nonatomic, strong, nullable) UIColor * nameColor;
@property (nonatomic, strong, nullable) UIFont * nameFont;

@property (nonatomic) UIControlState currentState;

+(nullable instancetype) defaut;

@end

@interface PYUtileManagerNavigationbarData : NSObject

@property (nonatomic, assign) CGSize shadowOffset;      // offset in user space of the shadow from the original drawing
@property (nonatomic, assign) CGFloat shadowBlurRadius; // blur radius of the shadow in default user space units
@property (nullable, nonatomic, strong) UIColor * shadowColor;     // color used for the shadow (default is black with an alpha value of 1/3)

@property (nonatomic, strong, nullable) UIColor * nameColor;
@property (nonatomic, strong, nullable) UIFont * nameFont;

@property (nonatomic, strong, nullable) UIColor * tintColor;
@property (nonatomic, strong, nullable) UIColor * backgroundColor;
@property (nonatomic, strong, nullable) UIImage * backgroundImage;

@property (nonatomic, assign)UIBarPosition  barPosition;
@property (nonatomic, assign)UIBarMetrics barMetrics;

@property (nonatomic, assign)UIStatusBarStyle statusBarStyle;
+(nullable instancetype) defaut;

@end



@interface PYUtileManager : NSObject
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYUtileManagerOrientationData *) managerOrientationData;
/**
 导航栏默认设置
 */
+(void) setViewControllerNavigationbarData:(nullable NSArray<PYUtileManagerNavigationbarData*> *) managerNavigationbarDatas;
/**
 导航栏默认设置
 */
+(void) setViewControllertBarButtonItemData:(nullable NSArray<PYUtileManagerBarButtonItemData*> *) managerBarButtonItemData;
/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem managerBarButtonItemData:(nonnull PYUtileManagerBarButtonItemData *) managerBarButtonItemData;

/**
 设置导航栏样式
 */
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar managerNavigationbarData:(nonnull PYUtileManagerNavigationbarData *) managerNavigationbarData;
@end
