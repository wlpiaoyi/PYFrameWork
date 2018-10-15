//
//  PYFrameworkUtile.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/24.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFrameworkParam.h"
#import "PYFrameworkParamOrientation.h"
#import "PYFrameworkParamNavigationBar.h"
#import "PYFrameworkParamNavigationItem.h"


@interface PYFrameworkUtile : NSObject
/**
 返回按钮图片
 */
+(void) setBackItemForPopvc:(nullable UIImage *) popvc dismissvc:(nullable UIImage *) dismissvc;
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYFrameworkParamOrientation *) frameworkOrientation;
/**
 导航栏默认设置
 */
+(void) setViewControllerNavigationbarData:(nullable NSArray<PYFrameworkParamNavigationBar*> *) managerNavigationbarDatas;
/**
 导航栏默认设置
 */
+(void) setViewControllertBarButtonItemData:(nullable NSArray<PYFrameworkParamNavigationItem*> *) managerBarButtonItemData;
/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem managerBarButtonItemData:(nonnull PYFrameworkParamNavigationItem *) managerBarButtonItemData;
/**
 设置导航栏样式
 */
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar managerNavigationbarData:(nonnull PYFrameworkParamNavigationBar *) managerNavigationbarData;
/**
 将button的image和title纵向显示
 #param offH:间距
 #param maxHeight:imageSize.height的最大高度，主要用于多个button的image 和 title 的协调
 #param direction:0 title在上 1 title在下
 */
+(void) parseImagetitleForButton:(nonnull UIButton *) button offH:(CGFloat) offH maxHeight:(CGFloat) maxHeight direction:(short) direction;
/**
 创建上下结构的文字图片结构
 direction：(0:top, 1:bottom)
 */
+(nonnull UIImage *) createImageWithTitle:(nonnull NSString *) title font:(nonnull UIFont *) font color:(nonnull UIColor *) color image:(nonnull UIImage *) image offH:(CGFloat) offH imageOffH:(CGFloat) imageOffH direction:(short) direction;
@end
