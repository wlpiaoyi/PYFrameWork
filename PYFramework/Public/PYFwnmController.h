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
PYPNA CGFloat menuHeight;
PYPNSNN id menuIdentify;
PYPNSNA UIColor * colorSeletedBg;
PYPNSNA NSArray<NSDictionary *> * menuStyle;
PYPNCNA BOOL (^blockOnclickMenu)(id _Nullable menuIdentify);
@end
