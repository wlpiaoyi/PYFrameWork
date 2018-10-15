//
//  UIViewcontrollerHookViewDelegateImp.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYFrameworkParamNavigationBar.h"
#import "PYFrameworkParamNavigationItem.h"
#import "PYKeybordHeadView.h"

extern UIImage * xImageFrameworkPopvc;
extern UIImage * xImageFrameworkdismissvc;

@interface UIViewcontrollerHookViewDelegateImp : NSObject<UIViewcontrollerHookViewDelegate>
@property (nonatomic, strong, nullable) NSArray<PYFrameworkParamNavigationBar*> * managerNavigationbarDatas;
@property (nonatomic, strong, nullable) NSArray<PYFrameworkParamNavigationItem*> * managerBarButtonItemDatas;
-(void) afterExcuteViewWillAppearWithTarget:(UIViewController *)target;
-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target;
+(PYKeybordHeadView *) keybordHead:(UIViewController *) target;
@end
