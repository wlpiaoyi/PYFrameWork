//
//  PYUtileManager.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/24.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYUtileManager.h"
#import <Utile/UIViewController+Hook.h>
#import <Utile/UIViewController+HookOrientation.h>
#import <Utile/UIViewController+HookView.h>
#import <Utile/PYOrientationListener.h>
#import <Utile/PYUtile.h>
#import <objc/runtime.h>
#import <Utile/UIImage+Expand.h>

@interface UIViewcontrollerHookViewDelegateImp : NSObject<UIViewcontrollerHookViewDelegate>
@property (nonatomic, strong, nullable) NSArray<PYUtileManagerNavigationbarData*> * managerNavigationbarDatas;
@property (nonatomic, strong, nullable) NSArray<PYUtileManagerBarButtonItemData*> * managerBarButtonItemDatas;
-(void) afterExcuteViewWillAppearWithTarget:(UIViewController *)target;
-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target;
@end

@interface UIViewcontrollerHookOrientationDelegateImp : NSObject<UIViewcontrollerHookOrientationDelegate>
@property (nonatomic, strong, nullable) PYUtileManagerOrientationData * managerOrientationData;
//重写父类方法判断是否可以旋转
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target;

//重写父类方法判断支持的旋转方向
-(NSUInteger) afterExcuteSupportedInterfaceOrientationsWithTarget:(nonnull UIViewController *) target;

//重写父类方法返回当前方向
-(UIInterfaceOrientation) afterExcutePreferredInterfaceOrientationForPresentationWithTarget:(nonnull UIViewController *) target;
//⇒ 重写父类方法旋转开始和结束
-(void) afterExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration target:(nonnull UIViewController *) target;
-(void) afterExcuteDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation target:(nonnull UIViewController *) target;
@end

UIViewcontrollerHookOrientationDelegateImp * xUIViewcontrollerHookOrientationDelegateImp;
UIViewcontrollerHookViewDelegateImp * xUIViewcontrollerHookViewDelegateImp;
@implementation PYUtileManager

+(void) initialize{
    xUIViewcontrollerHookOrientationDelegateImp = [UIViewcontrollerHookOrientationDelegateImp new];
    xUIViewcontrollerHookViewDelegateImp = [UIViewcontrollerHookViewDelegateImp new];
    [UINavigationController hookMethodWithName:@"preferredStatusBarStyle"];
}
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYUtileManagerOrientationData *) managerOrientationData{
    xUIViewcontrollerHookOrientationDelegateImp.managerOrientationData = managerOrientationData;
    [UIViewController hookMethodOrientation];
    [UIViewController hookMethodView];
    if (![[UIViewController delegateOrientations] containsObject:xUIViewcontrollerHookOrientationDelegateImp]) {
        [UIViewController addDelegateOrientation:xUIViewcontrollerHookOrientationDelegateImp];
    }
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
}
/**
 导航栏默认设置
 */
+(void) setViewControllerNavigationbarData:(nullable NSArray<PYUtileManagerNavigationbarData*> *) managerNavigationbarDatas{
    
    [UIViewController hookMethodView];
    xUIViewcontrollerHookViewDelegateImp.managerNavigationbarDatas = managerNavigationbarDatas;
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
}
/**
 导航栏默认设置
 */
+(void) setViewControllertBarButtonItemData:(nullable NSArray<PYUtileManagerBarButtonItemData*> *) managerBarButtonItemDatas{
    [UIViewController hookMethodView];
    xUIViewcontrollerHookViewDelegateImp.managerBarButtonItemDatas = managerBarButtonItemDatas;
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
    
}

/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem managerBarButtonItemData:(nonnull PYUtileManagerBarButtonItemData *) managerBarButtonItemData{
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:[barButtonItem titleTextAttributesForState:managerBarButtonItemData.currentState]];
    
    NSShadow *shadow = titleTextAttributes[NSShadowAttributeName];
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
    }
    if (managerBarButtonItemData.shadowOffset.width != CGSizeZero.width && managerBarButtonItemData.shadowOffset.height != CGSizeZero.height) {
        shadow.shadowOffset = managerBarButtonItemData.shadowOffset;
    }
    if (managerBarButtonItemData.shadowBlurRadius != CGFLOAT_MIN) {
        shadow.shadowBlurRadius = managerBarButtonItemData.shadowBlurRadius;
    }
    if (managerBarButtonItemData.shadowColor) {
        shadow.shadowColor = managerBarButtonItemData.shadowColor;
    }
    titleTextAttributes[NSShadowAttributeName] = shadow;
    if (managerBarButtonItemData.nameColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = managerBarButtonItemData.nameColor;
    }
    if (managerBarButtonItemData.nameFont) {
        titleTextAttributes[NSFontAttributeName] = managerBarButtonItemData.nameFont;
    }
    
    [barButtonItem setTitleTextAttributes:titleTextAttributes forState:managerBarButtonItemData.currentState];

}

/**
 设置导航栏样式
 */
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar managerNavigationbarData:(nonnull PYUtileManagerNavigationbarData *) managerNavigationbarData{

    
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:[navigationBar titleTextAttributes]];
    
    NSShadow *shadow = titleTextAttributes[NSShadowAttributeName];
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
    }
    if (managerNavigationbarData.shadowOffset.width != CGSizeZero.width && managerNavigationbarData.shadowOffset.height != CGSizeZero.height) {
        shadow.shadowOffset = managerNavigationbarData.shadowOffset;
    }
    if (managerNavigationbarData.shadowBlurRadius != CGFLOAT_MIN) {
        shadow.shadowBlurRadius = managerNavigationbarData.shadowBlurRadius;
    }
    if (managerNavigationbarData.shadowColor) {
        shadow.shadowColor = managerNavigationbarData.shadowColor;
    }
    titleTextAttributes[NSShadowAttributeName] = shadow;
    
    if (managerNavigationbarData.nameColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = managerNavigationbarData.nameColor;
    }
    if (managerNavigationbarData.nameFont) {
        titleTextAttributes[NSFontAttributeName] = managerNavigationbarData.nameFont;
    }
    
    [navigationBar setTitleTextAttributes:titleTextAttributes];
    
    if (managerNavigationbarData.tintColor) {
        [navigationBar setTintColor:managerNavigationbarData.tintColor];
    }
    if (managerNavigationbarData.backgroundColor) {
        [navigationBar setBackgroundColor:managerNavigationbarData.backgroundColor];
    }else if (managerNavigationbarData.backgroundImage) {
        [navigationBar setBackgroundImage:managerNavigationbarData.backgroundImage forBarPosition:managerNavigationbarData.barPosition barMetrics:managerNavigationbarData.barMetrics];
    }
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
    if (![PYOrientationListener isSupportInterfaceOrientation:[PYOrientationListener instanceSingle].interfaceOrientation targetController:preVc]){
        return false;
    }
    
    return true;
}
@end
void * UIViewControllerCurrentInterfaceOrientationPointer;
@implementation UIViewController(currentInterfaceOrientation)
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
@end

static NSArray<Class> * UIViewControllerClassesForHVDI;
@implementation UIViewcontrollerHookViewDelegateImp
+(void) initialize{
    UIViewControllerClassesForHVDI = @[
                                       NSClassFromString(@"UINavigationController"),
                                       NSClassFromString(@"PYManagerController"),
                                       NSClassFromString(@"UIInputWindowController")
                                       ];
}
-(void) afterExcuteViewWillAppearWithTarget:(UIViewController *)target{
    for (Class vcClass in UIViewControllerClassesForHVDI) {
        if ([target isKindOfClass:vcClass]) {
            return;
        }
    }
    if (target.childViewControllers.count) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = [PYOrientationListener instanceSingle].interfaceOrientation;
    if (![PYOrientationListener isSupportInterfaceOrientation:interfaceOrientation targetController:target]) {
        interfaceOrientation = [target preferredInterfaceOrientationForPresentation];
    }
    UIDeviceOrientation deviceOrientation = parseInterfaceOrientationToDeviceOrientation(interfaceOrientation);
    if ([self.class isSupportDeviceOrientation:deviceOrientation targetController:target]){
        target.currentInterfaceOrientation = interfaceOrientation;
        [[PYOrientationListener instanceSingle] attemptRotationToDeviceOrientation:deviceOrientation completion:nil];
    }
    
    if (target.navigationController) {
        for (PYUtileManagerNavigationbarData * data in self.managerNavigationbarDatas) {
            [PYUtileManager setNavigationBarStyle:target.navigationController.navigationBar managerNavigationbarData:data];
        }
        void (^block) (UIViewcontrollerHookViewDelegateImp * imp, UIBarButtonItem * barButtonItem) = ^ (UIViewcontrollerHookViewDelegateImp * imp, UIBarButtonItem * barButtonItem){
            for (PYUtileManagerBarButtonItemData * data in imp.managerBarButtonItemDatas) {
                [PYUtileManager setBarButtonItemStyle:barButtonItem managerBarButtonItemData:data];
            }
        };
        
        if(target.navigationItem.backBarButtonItem){
            block(self, target.navigationItem.backBarButtonItem);
        }
        if(target.navigationItem.leftBarButtonItems){
            for (UIBarButtonItem * barButtonItem in target.navigationItem.leftBarButtonItems) {
                block(self, barButtonItem);
            }
        }
        if(target.navigationItem.rightBarButtonItems){
            for (UIBarButtonItem * barButtonItem in target.navigationItem.rightBarButtonItems) {
                block(self, barButtonItem);
            }
        }
    }
}

-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{

    if ([target shouldAutorotate]){
        if (target.navigationController) {
            target.navigationController.interactivePopGestureRecognizer.enabled =  [PYUtileManager isSameOrientationInParentForTargetController:target];
        }
    }
    [target setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle) afterExcutePreferredStatusBarStyleWithTarget:(nonnull UIViewController *) target{
    
    if([target isKindOfClass:[UINavigationController class]]){
        return [((UINavigationController*)(target)).viewControllers.lastObject preferredStatusBarStyle];
    }
    
    if(target.childViewControllers.count ){
        return [target.childViewControllers.lastObject preferredStatusBarStyle];
    }
    
    UIStatusBarStyle statusBarStyle = self.managerNavigationbarDatas.count ? self.managerNavigationbarDatas.firstObject.statusBarStyle : UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:YES];
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

@end
@implementation UIViewcontrollerHookOrientationDelegateImp

//重写父类方法判断是否可以旋转
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController*)target).viewControllers.lastObject shouldAutorotate];
    }else{
        return self.managerOrientationData.shouldAutorotate;
    }
}
//重写父类方法判断支持的旋转方向
-(NSUInteger) afterExcuteSupportedInterfaceOrientationsWithTarget:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController*)target).viewControllers.lastObject supportedInterfaceOrientations];
    }else{
        return self.managerOrientationData.supportedInterfaceOrientations;
    }
}

//重写父类方法返回当前方向
-(UIInterfaceOrientation) afterExcutePreferredInterfaceOrientationForPresentationWithTarget:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController*)target).viewControllers.lastObject  preferredInterfaceOrientationForPresentation];
    }else{
        return self.managerOrientationData.preferredInterfaceOrientationForPresentation;
    }
}
//⇒ 重写父类方法旋转开始和结束
-(void) afterExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration target:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)target).viewControllers.lastObject  willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    target.currentInterfaceOrientation = toInterfaceOrientation;
}
-(void) afterExcuteDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation target:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
         [((UINavigationController*)target).viewControllers.lastObject  didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }else if (target.navigationController) {
        target.navigationController.interactivePopGestureRecognizer.enabled =  [PYUtileManager isSameOrientationInParentForTargetController:target];
    }
}

@end

@implementation PYUtileManagerOrientationData
@end

@implementation PYUtileManagerNavigationbarData

-(instancetype) init{
    if (self = [super init]) {
        self.shadowOffset = CGSizeZero;
        self.shadowBlurRadius = CGFLOAT_MIN;
        self.barPosition = UIBarPositionTop;
        self.barMetrics =  UIBarMetricsDefault;
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}
+(instancetype) defaut{
    PYUtileManagerNavigationbarData  * data = [PYUtileManagerNavigationbarData new];
    data.shadowOffset = CGSizeMake(1, 1);
    data.shadowBlurRadius = .5;
    data.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    data.nameColor = [UIColor whiteColor];
    data.nameFont = [UIFont systemFontOfSize:20];
    data.tintColor = [UIColor whiteColor];
    data.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    return data;
}

@end
@implementation PYUtileManagerBarButtonItemData

-(instancetype) init{
    if (self = [super init]) {
        self.shadowOffset = CGSizeZero;
        self.shadowBlurRadius = CGFLOAT_MIN;
        self.currentState = UIControlStateNormal;
    }
    return self;
}
+(instancetype) defaut{
    PYUtileManagerBarButtonItemData  * data = [PYUtileManagerBarButtonItemData new];
    data.shadowOffset = CGSizeMake(1, 1);
    data.shadowBlurRadius = .5;
    data.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    data.nameColor = [UIColor whiteColor];
    data.nameFont = [UIFont systemFontOfSize:12];
    return data;
}


@end