//
//  PYFrameworkUtile.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/24.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pykita.h"
#import "PYFrameworkParam.h"
#import "PYFrameworkParamOrientation.h"


@interface PYFrameworkUtile : NSObject
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYFrameworkParamOrientation *) frameworkOrientation;
@end
