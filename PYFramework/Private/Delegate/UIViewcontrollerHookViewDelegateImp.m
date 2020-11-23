//
//  UIViewcontrollerHookViewDelegateImp.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIViewcontrollerHookViewDelegateImp.h"
#import "UIViewController+CurrentInterfaceOrientation.h"
#import "PYFrameworkUtile.h"
#import <objc/runtime.h>

void * PYFWKeyboardPointer = &PYFWKeyboardPointer;
void * PYFWViewBottomTagPointer = &PYFWViewBottomTagPointer;
void * PYFWImageBottomPointer = &PYFWImageBottomPointer;

void __py_framework_popvc(UIViewController * self, SEL _cmd){
    [self.navigationController popViewControllerAnimated:YES];
}

void __py_framework_dismissvc(UIViewController * self, SEL _cmd){
    [(self.navigationController ? : self) dismissViewControllerAnimated:YES completion:^{}];
}

//static Class __PY_FM_TEMP_CLASS;
@implementation UIViewcontrollerHookViewDelegateImp{
}



-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
    
    target.navigationController.interactivePopGestureRecognizer.enabled =  [UIViewController isSameOrientationInParentForTargetController:target];
    if(![target conformsToProtocol:@protocol(PYFrameworkOrientationTag)]) return;
    UIInterfaceOrientation interfaceOrientation = [PYOrientationNotification instanceSingle].interfaceOrientation;
    if (![PYOrientationNotification isSupportInterfaceOrientation:interfaceOrientation targetController:target]) {
        interfaceOrientation = [target preferredInterfaceOrientationForPresentation];
    }
    UIDeviceOrientation deviceOrientation = parseInterfaceOrientationToDeviceOrientation(interfaceOrientation);
    if ([self.class isSupportDeviceOrientation:deviceOrientation targetController:target]){
        target.currentInterfaceOrientation = interfaceOrientation;
        [[PYOrientationNotification instanceSingle] attemptRotationToDeviceOrientation:deviceOrientation completion:^(NSTimer * _Nonnull timer) {
            kNOTIF_POST(@"PYFWRefreshLayout", nil);
        }];
    }
}

//-(void) afterExcuteViewWillDisappearWithTarget:(nonnull UIViewController *) target{
//    if([target conformsToProtocol:@protocol(PYKeyboradShowtag)]){
//        PYKeybordHeadView * keybordHead = [self.class keybordHead:target];
////        keybordHead.hasAppeared = false;
////        keybordHead.hidden = YES;
//
//    }
//}
//
//-(void) afterExcuteViewDidDisappearWithTarget:(nonnull UIViewController *) target{
//    if([target conformsToProtocol:@protocol(PYKeyboradShowtag)]){
//        PYKeybordHeadView * keybordHead = [self.class keybordHead:target];
////        [keybordHead removeKeybordNotify];
////        keybordHead.hasAppeared = false;
////        keybordHead.hidden = YES;
//    }
//}


/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportDeviceOrientation:(UIDeviceOrientation) orientation targetController:(nonnull UIViewController *) targetController{
    UIInterfaceOrientationMask interfaceOrientationMask = 1 << orientation;
    
    UIInterfaceOrientationMask supportedInterfaceOrientations = [targetController supportedInterfaceOrientations];
    if (!(supportedInterfaceOrientations & interfaceOrientationMask)) {
        return false;
    }
    return true;
}

-(void) afterExcuteViewDidLayoutSubviewsWithTarget:(nonnull UIViewController *) target{
    if (@available(iOS 11.0, *)) {
        if(target.view.safeAreaInsets.bottom > 0){
            if([target conformsToProtocol:@protocol(PYFrameworkUnsafeAreaFit)]){
                UIView * viewBottomTag = objc_getAssociatedObject(target, PYFWViewBottomTagPointer);
                if(viewBottomTag == nil){
                    viewBottomTag = [UIView new];
                    viewBottomTag.backgroundColor = [UIColor clearColor];
                    [target.view addSubview:viewBottomTag];
                    [viewBottomTag setAutotLayotDict:@{@"bottom":@(0), @"left":@(0), @"right":@(0), @"bottomActive":@(YES), @"h":@(.5)}];
                    objc_setAssociatedObject(target, PYFWViewBottomTagPointer, viewBottomTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
                UIImageView * imageBottom = objc_getAssociatedObject(target, PYFWImageBottomPointer);
                if(imageBottom == nil){
                    imageBottom = [UIImageView new];
                    imageBottom.backgroundColor = [UIColor clearColor];
                    imageBottom.contentMode = UIViewContentModeScaleToFill;
                    [target.view addSubview:imageBottom];
                    [imageBottom setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"bottom":@(0), @"right":@(0),@"topPoint":viewBottomTag}];
                    objc_setAssociatedObject(target, PYFWImageBottomPointer, imageBottom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
                CGRect bounds = CGRectMake(0, boundsHeight() - ABS(target.view.safeAreaInsets.bottom ) - .5, target.view.frameWidth, .5);
                imageBottom.image = [[UIApplication sharedApplication].keyWindow drawViewWithBounds:bounds];
                [target.view bringSubviewToFront:viewBottomTag];
                [target.view bringSubviewToFront:imageBottom];
            }
        }
    }
}

@end
