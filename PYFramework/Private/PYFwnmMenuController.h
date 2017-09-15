//
//  PYFwnmMenuController.h
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFwnmParam.h"

@interface PYFwnmMenuController : UIViewController
@property (nonatomic, strong, nullable) UIColor * colorSeletedBg;
@property (nonatomic, strong, nullable) NSArray<NSDictionary *> * menuStyle;
@property (nonatomic, copy, nullable) BOOL (^blockOnclickMenu)(id _Nullable menuIdentify);
-(void) setSelectedMenuWithIdentify:(nonnull id) identify;
@end
