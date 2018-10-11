//
//  PYFwMenuController.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFrameworkParam.h"

@interface PYFwMenuController : UIViewController
/**
 目录选中的背景高度
 */
kPNA CGFloat colorSeletedHeight;
@property (nonatomic, strong, nullable) UIColor * colorSeletedBg;
@property (nonatomic, strong, nullable) NSArray<NSDictionary *> * menuStyle;
@property (nonatomic, copy, nullable) BOOL (^blockOnclickMenu)(id _Nullable menuIdentify);
-(void) setSelectedMenuWithIdentify:(nonnull id) identify;
-(void) setMenuStyle:(NSArray<NSDictionary *> *)menuStyle maxHeight:(CGFloat) maxHeight;
@end
