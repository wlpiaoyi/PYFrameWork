//
//  PYFrameworkUtile.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/24.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkUtile.h"
#import "pyutilea.h"
#import <objc/runtime.h>

@interface UIViewcontrollerHookViewDelegateImp : NSObject<UIViewcontrollerHookViewDelegate>
@property (nonatomic, strong, nullable) NSArray<PYFrameworkUtileNavigationbar*> * managerNavigationbarDatas;
@property (nonatomic, strong, nullable) NSArray<PYFrameworkUtileBarButtonItem*> * managerBarButtonItemDatas;
-(void) afterExcuteViewWillAppearWithTarget:(UIViewController *)target;
-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target;
@end

@interface UIViewcontrollerHookOrientationDelegateImp : NSObject<UIViewcontrollerHookOrientationDelegate>
@property (nonatomic, strong, nullable) PYFrameworkUtileOrientation * frameworkOrientation;
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

static UIViewcontrollerHookOrientationDelegateImp * xUIViewcontrollerHookOrientationDelegateImp;
static UIViewcontrollerHookViewDelegateImp * xUIViewcontrollerHookViewDelegateImp;
@implementation PYFrameworkUtile

+(void) initialize{
    xUIViewcontrollerHookOrientationDelegateImp = [UIViewcontrollerHookOrientationDelegateImp new];
    xUIViewcontrollerHookViewDelegateImp = [UIViewcontrollerHookViewDelegateImp new];
    [UINavigationController hookMethodWithName:@"preferredStatusBarStyle"];
}
/**
 创建上下结构的文字图片结构
 */
+(UIImage *) createImageWithTitle:(NSString *) title font:(UIFont *) font color:(UIColor *) color image:(UIImage *) image offH:(CGFloat) offH{
    
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:title attributes:@{(NSString *)kCTForegroundColorAttributeName:color,(NSString *)kCTFontAttributeName:font}];
    CGSize tSize = [PYUtile getBoundSizeWithAttributeTxt:attribute size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
    UIImage * tImage = [UIImage imageWithSize:tSize blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:CGRectMake(0, 0, 400, 400) y:rect.size.height scaleFlag:YES];
    }];
    
    tSize = CGSizeMake(tImage.size.width/2, tImage.size.height/2);
    tImage = [tImage setImageSize:tSize];
    
    tSize = tImage.size;
    CGSize tS = CGSizeMake(MAX(tSize.width, image.size.width), tSize.height + offH + image.size.height);
    UIGraphicsBeginImageContextWithOptions(tS, NO, 2);
    [tImage drawInRect:CGRectMake((tS.width - tSize.width)/2, 0, tImage.size.width, tImage.size.height)];
    [image drawInRect:CGRectMake((tS.width - image.size.width)/2, tSize.height + offH, image.size.width, image.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYFrameworkUtileOrientation *) frameworkOrientation{
    xUIViewcontrollerHookOrientationDelegateImp.frameworkOrientation = frameworkOrientation;
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
+(void) setViewControllerNavigationbarData:(nullable NSArray<PYFrameworkUtileNavigationbar*> *) managerNavigationbarDatas{
    
    [UIViewController hookMethodView];
    xUIViewcontrollerHookViewDelegateImp.managerNavigationbarDatas = managerNavigationbarDatas;
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
}
/**
 导航栏默认设置
 */
+(void) setViewControllertBarButtonItemData:(nullable NSArray<PYFrameworkUtileBarButtonItem*> *) managerBarButtonItemDatas{
    [UIViewController hookMethodView];
    xUIViewcontrollerHookViewDelegateImp.managerBarButtonItemDatas = managerBarButtonItemDatas;
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
    
}

/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem managerBarButtonItemData:(nonnull PYFrameworkUtileBarButtonItem *) managerBarButtonItemData{
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
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar managerNavigationbarData:(nonnull PYFrameworkUtileNavigationbar *) managerNavigationbarData{

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
        [navigationBar setBackgroundImage:managerNavigationbarData.backgroundImage forBarMetrics:managerNavigationbarData.barMetrics];
    }
    if(managerNavigationbarData.lineButtomImage)navigationBar.shadowImage = managerNavigationbarData.lineButtomImage;
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

@implementation UIViewcontrollerHookViewDelegateImp

-(void) afterExcuteViewWillAppearWithTarget:(UIViewController *)target{
    
    if([target conformsToProtocol:@protocol(PYFrameworkOrientationTag)]){
        UIInterfaceOrientation interfaceOrientation = [PYOrientationNotification instanceSingle].interfaceOrientation;
        if (![PYOrientationNotification isSupportInterfaceOrientation:interfaceOrientation targetController:target]) {
            interfaceOrientation = [target preferredInterfaceOrientationForPresentation];
        }
        UIDeviceOrientation deviceOrientation = parseInterfaceOrientationToDeviceOrientation(interfaceOrientation);
        if ([self.class isSupportDeviceOrientation:deviceOrientation targetController:target]){
            target.currentInterfaceOrientation = interfaceOrientation;
            [[PYOrientationNotification instanceSingle] attemptRotationToDeviceOrientation:deviceOrientation completion:nil];
        }
    }
    
    if([target isKindOfClass:[UINavigationController class]]){
        UINavigationBar *navigationBar = ((UINavigationController *) target).navigationBar;
        if(navigationBar)
            for (PYFrameworkUtileNavigationbar * data in self.managerNavigationbarDatas) {
                [PYFrameworkUtile setNavigationBarStyle:navigationBar managerNavigationbarData:data];
            }
    }else{
        UINavigationBar *navigationBar = nil;
        if([target respondsToSelector:@selector(navigationBar)]){
            navigationBar = [target performSelector:@selector(navigationBar)];
        }
        if(navigationBar)
            for (PYFrameworkUtileNavigationbar * data in self.managerNavigationbarDatas) {
                [PYFrameworkUtile setNavigationBarStyle:navigationBar managerNavigationbarData:data];
            }
        
        UINavigationItem *navigationItem = target.navigationItem;
        if(navigationItem){
            void (^block) (UIViewcontrollerHookViewDelegateImp * imp, UIBarButtonItem * barButtonItem) = ^ (UIViewcontrollerHookViewDelegateImp * imp, UIBarButtonItem * barButtonItem){
                for (PYFrameworkUtileBarButtonItem * data in imp.managerBarButtonItemDatas) {
                    [PYFrameworkUtile setBarButtonItemStyle:barButtonItem managerBarButtonItemData:data];
                }
            };
            if(navigationItem.backBarButtonItem){
                block(self, navigationItem.backBarButtonItem);
            }
            if(navigationItem.leftBarButtonItems){
                for (UIBarButtonItem * barButtonItem in navigationItem.leftBarButtonItems) {
                    block(self, barButtonItem);
                }
            }
            if(navigationItem.rightBarButtonItems){
                for (UIBarButtonItem * barButtonItem in navigationItem.rightBarButtonItems) {
                    block(self, barButtonItem);
                }
            }
        }
    }
    
}

-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
    if([target conformsToProtocol:@protocol(PYFrameworkAttemptRotationTag)]){
        if (target.navigationController) {
            target.navigationController.interactivePopGestureRecognizer.enabled =  [PYFrameworkUtile isSameOrientationInParentForTargetController:target];
        }
        [target setNeedsStatusBarAppearanceUpdate];
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

@end
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
-(NSUInteger) afterExcuteSupportedInterfaceOrientationsWithTarget:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
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
-(void) afterExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration target:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)target).viewControllers.lastObject willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    target.currentInterfaceOrientation = toInterfaceOrientation;
}
-(void) afterExcuteDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation target:(nonnull UIViewController *) target{
    if ([target isKindOfClass:[UINavigationController class]]) {
         [((UINavigationController*)target).viewControllers.lastObject didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }else if (target.navigationController) {
        target.navigationController.interactivePopGestureRecognizer.enabled =  [PYFrameworkUtile isSameOrientationInParentForTargetController:target];
    }
}

@end

@implementation PYFrameworkUtileOrientation
@end

@implementation PYFrameworkUtileNavigationbar

-(instancetype) init{
    if (self = [super init]) {
        self.shadowOffset = CGSizeZero;
        self.shadowBlurRadius = CGFLOAT_MIN;
        self.barMetrics =  UIBarMetricsDefault;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.lineButtomImage = nil;
    }
    return self;
}
+(instancetype) defaut{
    PYFrameworkUtileNavigationbar  * data = [PYFrameworkUtileNavigationbar new];
    data.shadowOffset = CGSizeMake(0, 0);
    data.shadowBlurRadius = 0;
    data.shadowColor = [UIColor clearColor];
    data.nameColor = [UIColor whiteColor];
    data.nameFont = [UIFont systemFontOfSize:20];
    data.tintColor = [UIColor whiteColor];
    data.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    return data;
}

@end
@implementation PYFrameworkUtileBarButtonItem

-(instancetype) init{
    if (self = [super init]) {
        self.shadowOffset = CGSizeZero;
        self.shadowBlurRadius = CGFLOAT_MIN;
        self.currentState = UIControlStateNormal;
    }
    return self;
}
+(instancetype) defaut{
    PYFrameworkUtileBarButtonItem  * data = [PYFrameworkUtileBarButtonItem new];
    data.shadowOffset = CGSizeMake(0, 0);
    data.shadowBlurRadius = 0;
    data.shadowColor = [UIColor clearColor];
    data.nameColor = [UIColor whiteColor];
    data.nameFont = [UIFont systemFontOfSize:12];
    return data;
}


@end
