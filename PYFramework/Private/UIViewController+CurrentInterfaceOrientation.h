//
//  UIViewController+CurrentInterfaceOrientation.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(CurrentInterfaceOrientation)
@property (nonatomic, readwrite) UIInterfaceOrientation currentInterfaceOrientation;
+(BOOL) isSameOrientationInParentForTargetController:(nonnull UIViewController *) targetController;
@end
