//
//  PYFwnmParam.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import <objc/runtime.h>

typedef enum _PYFrameworkShow{
    PYFrameworkShowUnkownShow = 0,
    PYFrameworkMenuShow = 0b1,
    PYFrameworkRootShow = 0b10,
    PYFrameworkAllShow = PYFrameworkMenuShow | PYFrameworkRootShow
} PYFrameworkShow;

extern NSString * _Nonnull PYFwnmMenuIdentify;
extern NSString * _Nonnull PYFwnmMenuTitle;
extern NSString * _Nonnull PYFwnmMenuTitleFont;
extern NSString * _Nonnull PYFwnmMenuTitleNormalColor;
extern NSString * _Nonnull PYFwnmMenuTitleHigthlightColor;
extern NSString * _Nonnull PYFwnmMenuImageNormal;
extern NSString * _Nonnull PYFwnmMenuImageHigthlight;


@protocol PYFrameworkNormalTag <NSObject> @end
@protocol PYFrameworkNavigationTag <NSObject> @end
@protocol PYFrameworkOrientationTag <NSObject> @end
@protocol PYFrameworkAttemptRotationTag <NSObject> @end
@protocol PYFrameworkAllTag <PYFrameworkNormalTag, PYFrameworkNavigationTag, PYFrameworkOrientationTag, PYFrameworkAttemptRotationTag> @end


