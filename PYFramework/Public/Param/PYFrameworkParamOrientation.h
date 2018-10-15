//
//  PYFrameworkParamOrientation.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFrameworkParam.h"

@interface PYFrameworkParamOrientation : NSObject
@property (nonatomic) BOOL shouldAutorotate;
@property (nonatomic) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property (nonatomic) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;
@end
