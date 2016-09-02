//
//  PYManagerData.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/23.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYManagerData.h"

#import <Utile/PYViewAutolayoutCenter.h>
#import <Utile/UIView+Expand.h>
#import <Utile/UIImage+Expand.h>
#import <Utile/PYOrientationListener.h>
CGRect PYMangerControllerForIOS7WindowsBounds(){
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (!IOS8_OR_LATER) {
        if ([PYOrientationListener instanceSingle].interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || [PYOrientationListener instanceSingle].interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
        }
    }
    return bounds;
}

@interface UIViewController(PYManagerController)
@property (nonatomic, readonly, nonnull) PYManagerData * managerData;
-(void) showRootController:(NSTimeInterval) delayTime;
-(void) hiddenRootController:(NSTimeInterval) delayTime;
-(void) showHeadController:(NSTimeInterval) delayTime;
-(void) hiddenHeadController:(NSTimeInterval) delayTime;
@end


CGFloat PYManagerControllerHeadOffavg = .75f;
CGFloat PYManagerControllerHeadNorHeight = 60;

@implementation PYManagerData
-(instancetype) init{
    if (self = [super init]) {
        
        _rootView = [PYManagerView new];
        _headView = [PYManagerView new];
        
        _rootView.userInteractionEnabled = true;
        _headView.userInteractionEnabled = true;
        
        self.rootController = [UIViewController new];
        self.headController = [UIViewController new];
        
        self.enumStyle = PYManagerNormalConrollerStyle;
        
    }
    return self;
}
-(void) setIsRootAnimated:(bool)isRootAnimated{
    _isRootAnimated = isRootAnimated;
}
-(void) setIsHeadAnimated:(bool)isHeadAnimated{
    _isHeadAnimated = isHeadAnimated;
}
-(void) setRootConstraintDict:(NSDictionary<NSString *,NSLayoutConstraint *> *)rootConstraintDict{
    if (_rootConstraintDict) {
        for (NSLayoutConstraint * constraint in _rootConstraintDict.allValues) {
            UIView * secondItem = constraint.secondItem;
            [secondItem removeConstraint:constraint];
        }
    }
    _rootConstraintDict = rootConstraintDict;
}
-(void) setHeadConstraintDict:(NSDictionary<NSString *,NSLayoutConstraint *> *)headConstraintDict{
    if (_headConstraintDict) {
        for (NSLayoutConstraint * constraint in _headConstraintDict.allValues) {
            UIView * secondItem = constraint.secondItem;
            [secondItem removeConstraint:constraint];
        }
    }
    _headConstraintDict = headConstraintDict;
}

-(void) setEnumShow:(PYManagerControllerShow)enumShow{
    _enumShow = enumShow;
}

-(void) setEnumStyle:(PYManagerControllerStyle)enumStyle{
    switch (enumStyle) {
        case PYManagerNormalConrollerStyle:{
            [self.class managerControlerNormalStyle:self];
        }
            break;
        case PYManagerSpecialConrollerStyle:{
            [self.class managerControlerSpecialStyle:self];
        }
            break;
        default:
            break;
    }
    _enumStyle = enumStyle;
}


-(void) setBlockHeadAnimate:(void (^)(UIViewController * _Nonnull manager, CGFloat value))blockHeadAnimate{
    _blockHeadAnimate = blockHeadAnimate;
    _enumStyle = PYManagerUnkownConrollerStyle;
}
-(void) setBlockRootAnimate:(void (^)(UIViewController * _Nonnull, CGFloat))blockRootAnimate{
    _blockRootAnimate = blockRootAnimate;
    _enumStyle = PYManagerUnkownConrollerStyle;
}
-(void) setBlockLayoutAnimate:(void (^)(UIViewController * _Nonnull))blockLayoutAnimate{
    _blockLayoutAnimate = blockLayoutAnimate;
}


+(void) managerControlerNormalStyle:(PYManagerData *) managerData{
    managerData.isImageHead= false;
    managerData.isImageRoot = false;
    [managerData  setBlockHeadAnimate:^void(UIViewController * _Nonnull managerController, CGFloat value) {
        managerController.managerData.headView.frame = CGRectMake(0, CGRectGetHeight(PYMangerControllerForIOS7WindowsBounds()) - PYManagerControllerHeadNorHeight * value, CGRectGetWidth(PYMangerControllerForIOS7WindowsBounds()),  PYManagerControllerHeadNorHeight);
    }];
    [managerData setBlockRootAnimate:^void(UIViewController * _Nonnull managerController, CGFloat value) {
        managerController.managerData.rootView.frame = CGRectMake(0, 0, PYMangerControllerForIOS7WindowsBounds().size.width, PYMangerControllerForIOS7WindowsBounds().size.height - ((managerData.enumShow & PYManagerHeadConrollerShow) ? (PYManagerControllerHeadNorHeight * value) : 0));
    }];
}
+(void) managerControlerSpecialStyle:(PYManagerData *) managerData{
    managerData.isImageHead = true;
    managerData.isImageRoot = true;
    [managerData setBlockHeadAnimate:^void(UIViewController * _Nonnull managerController, CGFloat value) {
        CATransform3D transformx = CATransform3DIdentity;
        transformx = CATransform3DScale(transformx, 1, 1, 1);
        managerController.managerData.headView.layer.transform = transformx;
        
        CGRect r = CGRectMake(CGRectGetWidth(PYMangerControllerForIOS7WindowsBounds()) * (1 - PYManagerControllerHeadOffavg), 0, CGRectGetWidth(PYMangerControllerForIOS7WindowsBounds()) * PYManagerControllerHeadOffavg, CGRectGetHeight(PYMangerControllerForIOS7WindowsBounds()));
        managerController.managerData.headView.frame = r;
        
        transformx = CATransform3DScale(transformx, 2 - value, 2 - value, 1);
        managerController.managerData.headView.layer.transform = transformx;
    }];
    [managerData setBlockRootAnimate:^void(UIViewController * _Nonnull managerController, CGFloat value) {
        
        CATransform3D transformx = CATransform3DIdentity;
        transformx = CATransform3DScale(transformx, 1, 1, 1);
        managerController.managerData.rootView.layer.transform = transformx;
        
        CGRect r = CGRectNull;
        r.size = PYMangerControllerForIOS7WindowsBounds().size;
        CGFloat x = r.size.width * -PYManagerControllerHeadOffavg * (1 - value) ;
        CGFloat offv = (r.size.width * (1-PYManagerControllerHeadOffavg) - r.size.width  * .01) * (1-value);
        x = x + offv/2 ;
        r.origin.x = x;
        r.origin.y = 0;
        managerController.managerData.rootView.frame = r;
        
        transformx = CATransform3DIdentity;
        transformx = CATransform3DScale(transformx, PYManagerControllerHeadOffavg + (1 - PYManagerControllerHeadOffavg) * value, PYManagerControllerHeadOffavg + (1 - PYManagerControllerHeadOffavg) * value, 1);
        managerController.managerData.rootView.layer.transform = transformx;
    }];
}
@end

@implementation PYManagerView{
@private
    UIImageView * imageView;
    NSMutableDictionary<NSNumber *, UIImage *> * dictionaryViewImge;
}
-(instancetype) init{
    if (self = [super init]) {
        dictionaryViewImge = [NSMutableDictionary new];
        self.backgroundColor = [UIColor blackColor];
        imageView = [UIImageView new];
        imageView.alpha = .6;
        [super addSubview:imageView];
        [PYViewAutolayoutCenter persistConstraint:imageView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        imageView.hidden = YES;
        _viewContain = [UIView new];
        self.viewContain.backgroundColor = [UIColor clearColor];
        [super addSubview:self.viewContain];
        [PYViewAutolayoutCenter persistConstraint:self.viewContain relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        self.viewContain.hidden = NO;
        [self setShadowColor:[UIColor lightGrayColor].CGColor shadowRadius:5];
    }
    return self;
}

-(BOOL) hasDisplayImageData{
    return imageView.image != nil;
}
-(void) addSubview:(UIView *)view{
    [self.viewContain addSubview:view];
}

-(BOOL) hasAddDisplayImage{
    return imageView.hidden == NO;
}
-(void) addDisplayImage:(nullable UIImage*) image{
    [self bringSubviewToFront:imageView];
    [self sendSubviewToBack:self.viewContain];
    imageView.hidden = NO;
    self.viewContain.hidden = YES;
    [self reFreshDisplayImage:image];
}
-(void) reFreshDisplayImage:(nullable UIImage*) image{
    if(image)imageView.image = image;
}
-(void) removeDisplayImage{
    imageView.hidden = YES;
    self.viewContain.hidden = NO;
    [self sendSubviewToBack:imageView];
    [self bringSubviewToFront:self.viewContain];
}
-(void) setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    CGFloat alpha = 0;
    if (userInteractionEnabled) {
        alpha = 1;
    }else{
        self.backgroundColor = [UIColor blackColor];
        alpha = .5;
    }
    self.viewContain.alpha = alpha;
}
-(void) layoutSubviews{
    [super layoutSubviews];
    //    [self exerciseAmbiguityInLayout];
}

@end
