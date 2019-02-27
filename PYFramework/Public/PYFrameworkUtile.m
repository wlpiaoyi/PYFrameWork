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
#import "PYGestureRecognizerDelegate.h"
#import "UIResponderHookBaseDelegateFWK.h"
#import "UIViewcontrollerHookViewDelegateImp.h"
#import "UIViewcontrollerHookOrientationDelegateImp.h"
#import "UIViewController+CurrentInterfaceOrientation.h"

static UIViewcontrollerHookOrientationDelegateImp * xUIViewcontrollerHookOrientationDelegateImp;
static UIViewcontrollerHookViewDelegateImp * xUIViewcontrollerHookViewDelegateImp;
static UIResponderHookBaseDelegateFWK * xUIResponderHookBaseDelegateFWK;

@implementation PYFrameworkUtile

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        xUIViewcontrollerHookOrientationDelegateImp = [UIViewcontrollerHookOrientationDelegateImp new];
        xUIViewcontrollerHookViewDelegateImp = [UIViewcontrollerHookViewDelegateImp new];
        xUIResponderHookBaseDelegateFWK = [UIResponderHookBaseDelegateFWK new];
        [UIResponder hookWithMethodNames:nil];
        [[UIResponder delegateBase] addObject:xUIResponderHookBaseDelegateFWK];
        [UINavigationController hookMethodWithName:@"preferredStatusBarStyle"];
    });
}

/**
 返回按钮图片
 */
+(void) setBackItemForPopvc:(nullable UIImage *) popvc dismissvc:(nullable UIImage *) dismissvc{
    xImageFrameworkPopvc = popvc;
    xImageFrameworkdismissvc = dismissvc;
}
/**
 旋转默认设置
 */
+(void) setViewControllerOrientationData:(nullable PYFrameworkParamOrientation *) frameworkOrientation{
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
+(void) setViewControllerNavigationbarData:(nullable NSArray<PYFrameworkParamNavigationBar*> *) managerNavigationbarDatas{
    
    [UIViewController hookMethodView];
    xUIViewcontrollerHookViewDelegateImp.managerNavigationbarDatas = managerNavigationbarDatas;
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
}
/**
 导航栏默认设置
 */
+(void) setViewControllertBarButtonItemData:(nullable NSArray<PYFrameworkParamNavigationItem*> *) managerBarButtonItemDatas{
    [UIViewController hookMethodView];
    xUIViewcontrollerHookViewDelegateImp.managerBarButtonItemDatas = managerBarButtonItemDatas;
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateImp]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateImp];
    }
    
}

/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem managerBarButtonItemData:(nonnull PYFrameworkParamNavigationItem *) managerBarButtonItemData{
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
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar managerNavigationbarData:(nonnull PYFrameworkParamNavigationBar *) managerNavigationbarData{

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

/**
 将button的image和title纵向显示
 #param offH:间距
 #param maxHeight:imageSize.height的最大高度，主要用于多个button的image 和 title 的协调
 #param direction:0 title在上 1 title在下
 */
+(void) parseImagetitleForButton:(nonnull UIButton *) button offH:(CGFloat) offH maxHeight:(CGFloat) maxHeight direction:(short) direction{
    UIImage * imageNormal;
    UIImage * imageSelected;
    UIImage * imageHigthlight;
    UIImage * imageDisabled;
    
    UIControlState state = UIControlStateNormal;
    imageNormal = [self pyfmu_getImageForButton:button state:state offH:offH maxHeight:maxHeight direction:direction];
    
    state = UIControlStateSelected;
    imageSelected = [self pyfmu_getImageForButton:button state:state offH:offH maxHeight:maxHeight direction:direction];
    
    state = UIControlStateHighlighted;
    imageHigthlight = [self pyfmu_getImageForButton:button state:state offH:offH maxHeight:maxHeight direction:direction];
    
    state = UIControlStateDisabled;
    imageDisabled = [self pyfmu_getImageForButton:button state:state offH:offH maxHeight:maxHeight direction:direction];
    
    
    state = UIControlStateNormal;
    if(imageNormal){
        [button setTitle:@"" forState:state];
        [button setImage:imageNormal forState:state];
    }
    
    state = UIControlStateSelected;
    if(imageSelected){
        [button setTitle:@"" forState:state];
        [button setImage:imageSelected forState:state];
    }
    
    state = UIControlStateHighlighted;
    if(imageHigthlight){
        [button setTitle:@"" forState:state];
        [button setImage:imageHigthlight forState:state];
    }
    
    state = UIControlStateDisabled;
    if(imageDisabled){
        [button setTitle:@"" forState:state];
        [button setImage:imageDisabled forState:state];
    }

}

/**
 创建上下结构的文字图片结构
 */
+(UIImage *) createImageWithTitle:(NSString *) title font:(UIFont *) font color:(UIColor *) color image:(UIImage *) image offH:(CGFloat) offH imageOffH:(CGFloat) imageOffH direction:(short) direction{
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:title attributes:@{(NSString *)kCTForegroundColorAttributeName:color,(NSString *)kCTFontAttributeName:font}];
    CGSize tSize = [PYUtile getBoundSizeWithAttributeTxt:attribute size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
    UIImage * tImage = [UIImage imageWithSize:tSize blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:CGRectMake(0, 0, 400, 400) y:rect.size.height scaleFlag:YES];
    }];
    
    tSize = CGSizeMake(tImage.size.width, tImage.size.height);
    tImage = [tImage setImageSize:tSize];
    
    tSize = tImage.size;
    CGSize tS = CGSizeMake(MAX(tSize.width, image.size.width), tSize.height + offH + image.size.height + imageOffH);
    CGRect tFrame, iFrame;
    switch (direction) {
        case 0:{
            tFrame = CGRectMake((tS.width - tSize.width)/2, 0, tImage.size.width, tImage.size.height);
            iFrame = CGRectMake((tS.width - image.size.width)/2, tFrame.size.height + tFrame.origin.y + offH + imageOffH, image.size.width, image.size.height);
        }
            break;
        default:{
            iFrame = CGRectMake((tS.width - image.size.width)/2, imageOffH, image.size.width, image.size.height);
            tFrame = CGRectMake((tS.width - tSize.width)/2, iFrame.size.height + iFrame.origin.y + offH, tImage.size.width, tImage.size.height);
        }
            break;
    }
    UIGraphicsBeginImageContextWithOptions(tS, NO, [UIScreen mainScreen].scale);
    [tImage drawInRect:tFrame];
    [image drawInRect:iFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(nullable UIImage *) pyfmu_getImageForButton:(nonnull UIButton *) button state:(UIControlState) state offH:(CGFloat) offH maxHeight:(CGFloat) maxHeight direction:(short) direction{
    UIImage * image = [button imageForState:state];
    NSString * title = [button titleForState:state];
    if(!image || ![NSString isEnabled:title]){
        return nil;
    }
    if(state != UIControlStateNormal){
        UIImage * imagen = [button imageForState:UIControlStateNormal];
        NSString * titlen = [button titleForState:UIControlStateNormal];
        if(imagen == image && title == titlen) return nil;
    }
    image = [PYFrameworkUtile createImageWithTitle:title font:button.titleLabel.font color:[button titleColorForState:state] image:image offH:offH imageOffH:maxHeight - image.size.height direction:direction];
    return image;
};
@end





