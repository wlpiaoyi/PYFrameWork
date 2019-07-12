//
//  UIViewcontrollerHookViewDelegateImp.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIViewcontrollerHookViewDelegateImp.h"
#import "PYKeybordHeadView.h"
#import "UIViewController+CurrentInterfaceOrientation.h"
#import "PYGestureRecognizerDelegate.h"
#import "PYFrameworkUtile.h"
#import <objc/runtime.h>

void * PYFWKeyboardPointer = &PYFWKeyboardPointer;
void * PYFWViewBottomTagPointer = &PYFWViewBottomTagPointer;
void * PYFWImageBottomPointer = &PYFWImageBottomPointer;

UIImage * xImageFrameworkPopvc;
UIImage * xImageFrameworkdismissvc;

void __py_framework_popvc(UIViewController * self, SEL _cmd){
    [self.navigationController popViewControllerAnimated:YES];
}

void __py_framework_dismissvc(UIViewController * self, SEL _cmd){
    [(self.navigationController ? : self) dismissViewControllerAnimated:YES completion:^{}];
}

static Class __PY_FM_TEMP_CLASS;
@implementation UIViewcontrollerHookViewDelegateImp{
}

+(PYKeybordHeadView *) keybordHead:(UIViewController *) target{
    PYKeybordHeadView * keybordHead = objc_getAssociatedObject(target, PYFWKeyboardPointer);
    if(keybordHead == nil){
        keybordHead = [PYKeybordHeadView new];
        objc_setAssociatedObject(target, PYFWKeyboardPointer, keybordHead, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if(!__PY_FM_TEMP_CLASS){
        __PY_FM_TEMP_CLASS = NSClassFromString(@"PYInterflowController");
    }
    return keybordHead;
}


-(void) afterExcuteViewDidLoadWithTarget:(nonnull UIViewController *) target{
    
    if([target conformsToProtocol:@protocol(PYKeyboradShowtag)]){
        UIWindow * window =  [UIApplication sharedApplication].delegate.window;
//        Class wClass = NSClassFromString(@"PYInterflowWindow");
//        for (UIWindow * wd in [UIApplication sharedApplication].windows) {
//            if([wd isKindOfClass:wClass]){
//                window = wd;
//            }
//        }
        PYKeybordHeadView * keybordHead = [self.class keybordHead:target];
        keybordHead.frameOrigin = CGPointMake(0, boundsHeight());
        keybordHead.frameWidth = boundsWidth();
        [window addSubview:keybordHead];
    }
}

-(void) afterExcuteViewWillAppearWithTarget:(UIViewController *)target{
    if([target conformsToProtocol:@protocol(PYKeyboradShowtag)]){
        PYKeybordHeadView * keybordHead = [self.class keybordHead:target];
        keybordHead.hasAppeared = true;
        keybordHead.hidden = NO;
        if(keybordHead.hasShowKeyboard)
            keybordHead.frameY = boundsHeight() - keybordHead.keyBoardFrame.size.height - keybordHead.frameHeight;
    }
    if([target conformsToProtocol:@protocol(PYFrameworkBackItem)]){
        if(objc_getAssociatedObject(target, (__bridge const void * _Nonnull)(target)) == nil){
            if(xImageFrameworkPopvc
               && target.navigationController
               && target.navigationItem.leftBarButtonItem == nil
               && target.navigationController.childViewControllers
               && target.navigationController.childViewControllers.count > 1){
                SEL backSel = sel_getUid("__py_framework_popvc");
                if(![target respondsToSelector:backSel]){
                    class_addMethod([target class], backSel, (IMP)__py_framework_popvc, "v@:");
                }
                UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithImage:xImageFrameworkPopvc  style:UIBarButtonItemStylePlain target:target action:backSel];
                target.navigationItem.leftBarButtonItem = bbi;
                target.navigationController.interactivePopGestureRecognizer.delegate = [PYGestureRecognizerDelegate shareDelegate];
            }else if(xImageFrameworkdismissvc
                     && target.navigationController
                     && target.navigationItem.leftBarButtonItem == nil
                     && (target.navigationController.presentedViewController || target.navigationController.presentingViewController)
                     && target.navigationController.childViewControllers.count == 1
                     && target.navigationController.childViewControllers.firstObject == target){
                SEL backSel = sel_getUid("__py_framework_dismissvc");
                if(![target respondsToSelector:backSel]){
                    class_addMethod([target class], backSel, (IMP)__py_framework_dismissvc, "v@:");
                }
                UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithImage:xImageFrameworkdismissvc  style:UIBarButtonItemStylePlain target:target action:backSel];
                target.navigationItem.leftBarButtonItem = bbi;
            }
        }
        objc_setAssociatedObject(target, (__bridge const void * _Nonnull)(target), @(YES), OBJC_ASSOCIATION_RETAIN);
    }
    
    if([target isKindOfClass:[UINavigationController class]]){
        if([target.childViewControllers.lastObject conformsToProtocol:@protocol(PYFrameworkNormalTag)]){
            UINavigationBar *navigationBar = ((UINavigationController *) target).navigationBar;
            if(navigationBar)
                for (PYFrameworkParamNavigationBar * data in self.managerNavigationbarDatas) {
                    [PYFrameworkUtile setNavigationBarStyle:navigationBar managerNavigationbarData:data];
                }
        }
    }else{
        if([target conformsToProtocol:@protocol(PYFrameworkNormalTag)]){
            UINavigationBar *navigationBar = target.navigationController.navigationBar;
            if(navigationBar)
                for (PYFrameworkParamNavigationBar * data in self.managerNavigationbarDatas) {
                    [PYFrameworkUtile setNavigationBarStyle:navigationBar managerNavigationbarData:data];
                }
        }
        if([target conformsToProtocol:@protocol(PYFrameworkBackItem)]){
            UINavigationItem *navigationItem = target.navigationItem;
            if(navigationItem){
                void (^block) (UIViewcontrollerHookViewDelegateImp * imp, UIBarButtonItem * barButtonItem) = ^ (UIViewcontrollerHookViewDelegateImp * imp, UIBarButtonItem * barButtonItem){
                    for (PYFrameworkParamNavigationItem * data in imp.managerBarButtonItemDatas) {
                        [PYFrameworkUtile setBarButtonItemStyle:barButtonItem managerBarButtonItemData:data];
                    }
                };
                if(navigationItem.leftBarButtonItems){
                    for (UIBarButtonItem * barButtonItem in navigationItem.leftBarButtonItems) {
                        block(self, barButtonItem);
                    }
                }else if(navigationItem.backBarButtonItem){
                    block(self, navigationItem.backBarButtonItem);
                }
                
                if(navigationItem.rightBarButtonItems){
                    for (UIBarButtonItem * barButtonItem in navigationItem.rightBarButtonItems) {
                        block(self, barButtonItem);
                    }
                }
            }
        }
    }
}
-(void) hiddenKeyboard{
    [PYKeyboardNotification hiddenKeyboard];
}
-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
    if([target conformsToProtocol:@protocol(PYKeyboradShowtag)]){
        UIViewController * vc = target;
//        Class wClass = NSClassFromString(@"PYInterflowWindow");
//        for (UIWindow * wd in [UIApplication sharedApplication].windows) {
//            if([wd isKindOfClass:wClass]){
//                vc = wd.rootViewController;
//            }
//        }
        PYKeybordHeadView * keybordHead = [self.class keybordHead:target];
        keybordHead.isMoveForKeyboard = ![target respondsToSelector:@selector(isMoveForKeyboradShow)] || ((NSNumber *)[target performSelector:@selector(isMoveForKeyboradShow)]).boolValue;
        [keybordHead addKeyBoardNotifyForTargetView:vc.view];
        if(keybordHead.tapGestureRecognizer){
            [vc.view removeGestureRecognizer:keybordHead.tapGestureRecognizer];
            keybordHead.tapGestureRecognizer = nil;
        };
        keybordHead.hasAppeared = true;
        keybordHead.hidden = NO;
        if(keybordHead.hasShowKeyboard)
            keybordHead.frameY = boundsHeight() - keybordHead.keyBoardFrame.size.height - keybordHead.frameHeight;
        if(![target respondsToSelector:@selector(isTouchForKeyboradHidden)] || ((NSNumber *)[target performSelector:@selector(isTouchForKeyboradHidden)]).boolValue){
            keybordHead.tapGestureRecognizer = [vc.view py_addTarget:self action:@selector(hiddenKeyboard)];
        }
    }
    
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

-(void) afterExcuteViewWillDisappearWithTarget:(nonnull UIViewController *) target{
    if([target conformsToProtocol:@protocol(PYKeyboradShowtag)]){
        PYKeybordHeadView * keybordHead = [self.class keybordHead:target];
        keybordHead.hasAppeared = false;
        keybordHead.hidden = YES;
    }
}

-(void) afterExcuteViewDidDisappearWithTarget:(nonnull UIViewController *) target{
    if([target conformsToProtocol:@protocol(PYKeyboradShowtag)]){
        PYKeybordHeadView * keybordHead = [self.class keybordHead:target];
        [keybordHead removeKeybordNotify];
        keybordHead.hasAppeared = false;
        keybordHead.hidden = YES;
    }
}

-(UIStatusBarStyle) afterExcutePreferredStatusBarStyleWithTarget:(nonnull UIViewController *) target{
    if([target isKindOfClass:[UINavigationController class]]){
        return [((UINavigationController*)(target)).viewControllers.lastObject preferredStatusBarStyle];
    }
    
    if(target.childViewControllers.count ){
        return [target.childViewControllers.lastObject preferredStatusBarStyle];
    }
    
    UIStatusBarStyle statusBarStyle = self.managerNavigationbarDatas.count ? self.managerNavigationbarDatas.firstObject.statusBarStyle : UIStatusBarStyleDefault;
    
    return statusBarStyle;
}

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
                imageBottom.image = [[UIApplication sharedApplication].delegate.window drawViewWithBounds:bounds];
                [target.view bringSubviewToFront:viewBottomTag];
                [target.view bringSubviewToFront:imageBottom];
            }
        }
    }
}

@end
