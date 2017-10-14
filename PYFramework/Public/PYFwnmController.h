//
//  PYFwnmController.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkController.h"
#import "PYUtile.h"
#import "PYFwnmParam.h"

@interface PYFwnmController : PYFrameworkController
kPNA CGFloat menuHeight;
kPNSNN id menuIdentify;
kPNSNA UIColor * colorSeletedBg;
kPNSNA NSArray<NSDictionary *> * menuStyle;
kPNCNA BOOL (^blockOnclickMenu)(id _Nullable menuIdentify);
@end
