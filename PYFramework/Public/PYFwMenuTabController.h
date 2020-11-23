//
//  PYFwMenuTabController.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkController.h"
/**
 普通目录式框架结构
 */
@interface PYFwMenuTabController : PYFrameworkController
/**
 目录高度
 */
kPNA CGFloat menuHeight;
/**
 目录选中的背景颜色
 */
kPNSNA UIColor * colorSeletedBg;
/**
 目录选中的背景高度
 */
kPNA CGFloat colorSeletedHeight;
/**
 目录背景图片
 */
kPNSNA UIImage * imageMenuBg;
/**
 目录样式
 */
kPNCNA BOOL (^blockOnclickMenu)(id _Nullable menuIdentify);

-(void) showMenu:(nonnull id)menuIdentify;

-(void) setMenuStyle:(NSArray<NSDictionary *> *)menuStyle maxHeight:(CGFloat) maxHeight;

@end
