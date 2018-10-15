//
//  PYFrameworkParamNavigationItem.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFrameworkParam.h"

@interface PYFrameworkParamNavigationItem : NSObject

kPNA CGSize shadowOffset;      // offset in user space of the shadow from the original drawing
kPNA CGFloat shadowBlurRadius; // blur radius of the shadow in default user space units
kPNSNA id shadowColor;     // color used for the shadow (default is black with an alpha value of 1/3)

kPNSNA UIColor * nameColor;
kPNSNA UIFont * nameFont;

kPNA UIControlState currentState;


+(nullable instancetype) defaut;

@end
