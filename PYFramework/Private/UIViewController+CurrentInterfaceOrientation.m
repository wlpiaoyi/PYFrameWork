//
//  UIViewController+CurrentInterfaceOrientation.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIViewController+CurrentInterfaceOrientation.h"
#import <objc/runtime.h>
#import "pyutilea.h"

void * UIViewControllerCurrentInterfaceOrientationPointer;
@implementation UIViewController(CurrentInterfaceOrientation)
-(UIInterfaceOrientation) currentInterfaceOrientation{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController*)self).viewControllers.lastObject.currentInterfaceOrientation;
    }
    if ([self.childViewControllers count]) {
        return self.childViewControllers.lastObject.currentInterfaceOrientation;
    }
    NSNumber * number = objc_getAssociatedObject(self, &UIViewControllerCurrentInterfaceOrientationPointer);
    if (number) {
        return [number integerValue];
    }else{
        return [self preferredInterfaceOrientationForPresentation];
    }
}
-(void) setCurrentInterfaceOrientation:(UIInterfaceOrientation) currentInterfaceOrientation{
    NSNumber * objCurrentInterfaceOrientation = @(currentInterfaceOrientation);
    objc_setAssociatedObject(self, &UIViewControllerCurrentInterfaceOrientationPointer, objCurrentInterfaceOrientation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+(BOOL) isSameOrientationInParentForTargetController:(nonnull UIViewController *) targetController{
    if (!targetController.navigationController) {
        return false;
    }
    
    NSArray<UIViewController *> * viewControllers = targetController.navigationController.viewControllers;
    if (viewControllers.count < 2) {
        return false;
    }
    
    UIViewController * preVc =  viewControllers[viewControllers.count - 2];
    if (![PYOrientationNotification isSupportInterfaceOrientation:[PYOrientationNotification instanceSingle].interfaceOrientation targetController:preVc]){
        return false;
    }
    
    return true;
}
@end
