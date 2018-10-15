//
//  UIViewcontrollerHookOrientationDelegateImp.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIViewcontrollerHookOrientationDelegateImp.h"
#import "UIViewController+CurrentInterfaceOrientation.h"
#import "PYFrameworkUtile.h"


@implementation UIViewcontrollerHookOrientationDelegateImp

//重写父类方法判断是否可以旋转
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController*)target).viewControllers.lastObject shouldAutorotate];
    }else{
        return self.frameworkOrientation.shouldAutorotate;
    }
}
//重写父类方法判断支持的旋转方向
-(UIInterfaceOrientationMask) afterExcuteSupportedInterfaceOrientationsWithTarget:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]] && ((UINavigationController *)target).viewControllers.count) {
        return [((UINavigationController*)target).viewControllers.lastObject supportedInterfaceOrientations];
    }else{
        return self.frameworkOrientation.supportedInterfaceOrientations;
    }
}

//重写父类方法返回当前方向
-(UIInterfaceOrientation) afterExcutePreferredInterfaceOrientationForPresentationWithTarget:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController*)target).viewControllers.lastObject  preferredInterfaceOrientationForPresentation];
    }else{
        return self.frameworkOrientation.preferredInterfaceOrientationForPresentation;
    }
}
//⇒ 重写父类方法旋转开始和结束

-(void) afterExcuteViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator target:(nonnull UIViewController *)target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)target).viewControllers.lastObject viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
    UIInterfaceOrientation toInterfaceOrientation;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            toInterfaceOrientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            toInterfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeRight:
            toInterfaceOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        default:
            toInterfaceOrientation = UIInterfaceOrientationUnknown;
            break;
    }
    target.currentInterfaceOrientation = toInterfaceOrientation;
    [PYOrientationNotification instanceSingle].duration = [coordinator transitionDuration];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            target.navigationController.interactivePopGestureRecognizer.enabled =  [UIViewController isSameOrientationInParentForTargetController:target];
        });
    });
}

@end
