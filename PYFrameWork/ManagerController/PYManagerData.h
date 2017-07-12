//
//  PYManagerData.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/23.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat PYManagerControllerHeadOffavg;
extern CGFloat PYManagerControllerHeadNorHeight;

typedef enum _PYManagerControllerShow{
    PYManagerUnkownConrollerShow = 0,
    PYManagerHeadConrollerShow = 1,
    PYManagerRootConrollerShow = 1<<1,
    PYManagerAllControllerShow = PYManagerHeadConrollerShow | PYManagerRootConrollerShow
} PYManagerControllerShow;

typedef enum _PYManagerControllerStyle{
    PYManagerUnkownConrollerStyle = 0,
    PYManagerNormalConrollerStyle = 1,
    PYManagerSpecialConrollerStyle= 2
} PYManagerControllerStyle;

@class PYManagerData;
@class PYManagerView;

@interface PYManagerData : NSObject

/**
 当前显示Controller的状态
 */
@property (nonatomic) PYManagerControllerShow enumShow;
/**
 当前显示Controller的方式
 */
@property (nonatomic) PYManagerControllerStyle enumStyle;
/**
 是否在运动中
 */
//===>
@property (nonatomic, readonly) bool isRootAnimated;
@property (nonatomic, readonly) bool isHeadAnimated;
//<==
/**
 是否移除Controller
 */
//===>
@property (nonatomic, readwrite) bool isImageRoot;
@property (nonatomic, readwrite) bool isImageHead;
//<==
/**
 控制器
 */
//==>
@property (nonatomic, strong, nonnull) UIViewController * rootController;
@property (nonatomic, strong, nonnull) UIViewController * headController;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSLayoutConstraint *> * rootConstraintDict;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSLayoutConstraint *> * headConstraintDict;
//<==
/**
 显示方式block设置
 */
//==>
@property (nonatomic, copy, nonnull) void (^blockRootAnimate)(UIViewController * _Nonnull  managerController, CGFloat value);
@property (nonatomic, copy, nonnull) void (^blockHeadAnimate)(UIViewController * _Nonnull  managerController, CGFloat value);
@property (nonatomic, copy, nonnull) void (^blockLayoutAnimate)(UIViewController * _Nonnull  managerController);
//<==

@property (nonatomic, strong, nonnull, readonly) PYManagerView * rootView;
@property (nonatomic, strong, nonnull, readonly) PYManagerView * headView;

@end

@interface PYManagerView : UIView
@property (nonatomic, strong, readonly, nonnull) UIView * viewContain;
-(BOOL) hasDisplayImageData;
-(BOOL) hasAddDisplayImage;
-(void) addDisplayImage:(nullable UIImage*) image;
-(void) reFreshDisplayImage:(nullable UIImage*) image;
-(void) removeDisplayImage;
@end
