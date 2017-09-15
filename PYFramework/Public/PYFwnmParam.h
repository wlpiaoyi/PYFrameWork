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

extern NSString * _Nonnull PYFwnmMenuTitleFontNormal;
extern NSString * _Nonnull PYFwnmMenuTitleFontHigthlight;
extern NSString * _Nonnull PYFwnmMenuTitleFontSelected;

extern NSString * _Nonnull PYFwnmMenuTitleColorNormal;
extern NSString * _Nonnull PYFwnmMenuTitleColorHigthlight;
extern NSString * _Nonnull PYFwnmMenuTitleColorSelected;

extern NSString * _Nonnull PYFwnmMenuImageNormal;
extern NSString * _Nonnull PYFwnmMenuImageHigthlight;
extern NSString * _Nonnull PYFwnmMenuImageSelected;

extern NSString * _Nonnull PYFwnmMenuBGImageNormal;
extern NSString * _Nonnull PYFwnmMenuBGImageHigthlight;
extern NSString * _Nonnull PYFwnmMenuBGImageSelected;



@protocol PYFrameworkNormalTag <NSObject> @end
@protocol PYFrameworkOrientationTag <NSObject> @end
@protocol PYFrameworkAttemptRotationTag <NSObject> @end
@protocol PYFrameworkAllTag <PYFrameworkNormalTag, PYFrameworkOrientationTag, PYFrameworkAttemptRotationTag> @end


