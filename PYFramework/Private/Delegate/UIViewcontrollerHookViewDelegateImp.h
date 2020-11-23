//
//  UIViewcontrollerHookViewDelegateImp.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
//#import "PYFrameworkParamNavigationItem.h"


@interface UIViewcontrollerHookViewDelegateImp : NSObject<UIViewcontrollerHookViewDelegate>
//@property (nonatomic, strong, nullable) NSArray<PYFrameworkParamNavigationItem*> * managerBarButtonItemDatas;
-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target;
@end
