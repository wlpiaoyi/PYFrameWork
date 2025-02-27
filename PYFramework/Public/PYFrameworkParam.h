//
//  PYFrameworkParam.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "pykita.h"
#import <objc/runtime.h>

typedef enum _PYFrameworkShow{
    PYFrameworkShowUnkownShow = 0,
    PYFrameworkMenuHidden = 0b10,
    PYFrameworkMenuShow = PYFrameworkMenuHidden << 1,
    PYFrameworkRootHidden = PYFrameworkMenuHidden << 2,
    PYFrameworkRootFitShow = PYFrameworkMenuHidden << 3,
    PYFrameworkRootFillShow = PYFrameworkMenuHidden << 4
} PYFrameworkShow;


extern NSString * _Nonnull PYFwMenuIdentify;
extern NSString * _Nonnull PYFwMenuTitle;

extern NSString * _Nonnull PYFwMenuTitleFontNormal;
extern NSString * _Nonnull PYFwMenuTitleFontHigthlight;
extern NSString * _Nonnull PYFwMenuTitleFontSelected;

extern NSString * _Nonnull PYFwMenuTitleColorNormal;
extern NSString * _Nonnull PYFwMenuTitleColorHigthlight;
extern NSString * _Nonnull PYFwMenuTitleColorSelected;

extern NSString * _Nonnull PYFwMenuImageNormal;
extern NSString * _Nonnull PYFwMenuImageHigthlight;
extern NSString * _Nonnull PYFwMenuImageSelected;

extern NSString * _Nonnull PYFwMenuBGImageNormal;
extern NSString * _Nonnull PYFwMenuBGImageHigthlight;
extern NSString * _Nonnull PYFwMenuBGImageSelected;

extern NSString * _Nonnull PYFwMenusImgDirection;


typedef struct PYFwlayoutParams {
//    BOOL isAutoLayout;
    CGRect frame;
//    PYFwlayoutContent layoutContent;
    CGFloat alpha;
    CATransform3D transform3D;
    CGAffineTransform transform2D;
} PYFwlayoutParams;
kUTILE_STATIC_INLINE PYFwlayoutParams PYFwlayoutParamsMake(CGRect frame, CGFloat  alpha, CATransform3D transform3D, CGAffineTransform transform2D) {
    PYFwlayoutParams params = {frame, alpha, transform3D, transform2D};
    return params;
}

@protocol PYFrameworkNormalTag <PYNavigationSetterTag> @end
@protocol PYFrameworkOrientationTag <NSObject> @end

@protocol PYFrameworkUnsafeAreaFit <NSObject> @end

@protocol PYFrameworkAllTag <PYFrameworkNormalTag, PYFrameworkOrientationTag, PYFrameworkUnsafeAreaFit> @end


