//
//  PYManagerController.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYManagerController.h"
#import "PYUtileManager.h"
#import <objc/runtime.h>
#import "pyutilea.h"


@protocol PYViewGestureRecognizerDelegate <NSObject>

- (BOOL)touchesBegan:(CGPoint) point;
- (BOOL)touchesMoved:(CGPoint) point;
- (BOOL)touchesEnded:(CGPoint) point;
- (BOOL)touchesCancelled:(CGPoint) point;

@end

@interface PYViewGestureRecognizer : UIView
@property (nonatomic, assign, nullable) id<PYViewGestureRecognizerDelegate> delegate;
@end

@interface PYManagerData()
-(void) setIsRootAnimated:(bool)isRootAnimated;
-(void) setIsHeadAnimated:(bool)isHeadAnimated;
-(void) setEnumShow:(PYManagerControllerShow)enumShow;
@end

@interface PYManagerController ()<PYViewGestureRecognizerDelegate>{
    CGSize sizePre;
    CGPoint touchePoint;
    bool flagHasGrMove;
    BOOL isTouchMoveEnabled;
}
@property (nonatomic, strong) PYViewGestureRecognizer * viewGestureRecognizer;
@end

@implementation PYManagerController
@synthesize isPopGestureRecognizerEnabled;
+(void) initialize{
    [PYUtile class];
    [PYOrientationNotification instanceSingle];
}
-(instancetype) init{
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder: aDecoder]) {
        [self initParams];
    }
    return self;
}
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initParams];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isTouchMoveEnabled = true;
    isPopGestureRecognizerEnabled = true;
    self.viewGestureRecognizer = [PYViewGestureRecognizer new];
    self.viewGestureRecognizer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.viewGestureRecognizer];
    self.viewGestureRecognizer.delegate = self;
    [PYViewAutolayoutCenter persistConstraint:self.viewGestureRecognizer relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    
    [self.viewGestureRecognizer addSubview:self.managerData.headView];
    [self.viewGestureRecognizer addSubview:self.managerData.rootView];
    sizePre = CGSizeZero;
}
-(void) initParams{
    
    
    PYManagerData * managerData = [PYManagerData new];
    
    managerData.enumShow = PYManagerUnkownConrollerShow;
    
    [managerData setBlockLayoutAnimate:^(UIViewController * _Nonnull  _managerController_) {
        PYManagerController * managerController = (PYManagerController *) _managerController_;
        switch (managerController.managerData.enumShow) {
            case PYManagerHeadConrollerShow:{
                if(!managerController.managerData.isHeadAnimated)managerController.managerData.blockHeadAnimate(managerController, 1);
                if(!managerController.managerData.isRootAnimated)managerController.managerData.blockRootAnimate(managerController, 0);
            }
                break;
            case PYManagerRootConrollerShow:{
                if(!managerController.managerData.isRootAnimated)managerController.managerData.blockRootAnimate(managerController, 1);
                if(!managerController.managerData.isHeadAnimated)managerController.managerData.blockHeadAnimate(managerController, 0);
            }
                break;
            case PYManagerAllControllerShow:{
                if(!managerController.managerData.isHeadAnimated)managerController.managerData.blockHeadAnimate(managerController, 1);
                if(!managerController.managerData.isRootAnimated)managerController.managerData.blockRootAnimate(managerController, 1);
            }
                break;
            default:
                break;
        }
    }];
    _managerData = managerData;
}
-(void) showRootController:(NSTimeInterval) delayTime{
    sizePre = CGSizeZero;
    self.managerData.isRootAnimated = delayTime > 0;
    if (self.managerData.enumShow & PYManagerRootConrollerShow) {
        self.managerData.isRootAnimated = false;
    }else{
        self.managerData.enumShow = PYManagerRootConrollerShow | self.managerData.enumShow;
    }
    
    [self.managerData.rootView removeDisplayImage];
    
    [self addChildViewController:self.managerData.rootController];
    [self.managerData.rootView addSubview:self.managerData.rootController.view];
    self.managerData.rootConstraintDict = [PYViewAutolayoutCenter persistConstraint:self.managerData.rootController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    
    switch (self.managerData.enumStyle) {
        case PYManagerNormalConrollerStyle:{
            [self.view bringSubviewToFront:self.managerData.headView];
        }
        break;
        case PYManagerSpecialConrollerStyle:{
            [self.view bringSubviewToFront:self.managerData.rootView];
        }
        break;
        default:
        break;
    }

    if(self.managerData.isRootAnimated){
        __unsafe_unretained typeof(self) uuself = self;
        [UIView animateWithDuration:delayTime animations:^{
            uuself.managerData.blockRootAnimate(uuself, 1);
        } completion:^(BOOL finished) {
            uuself.managerData.rootView.userInteractionEnabled = true;
            uuself.managerData.isRootAnimated = false;
        }];
    }else{
        self.managerData.blockRootAnimate(self, 1);
        self.managerData.rootView.userInteractionEnabled = true;
        self.managerData.isRootAnimated = false;
    }
    
}
-(void) hiddenRootController:(NSTimeInterval) delayTime{
    
    self.managerData.isRootAnimated = delayTime > 0;
    if (!(self.managerData.enumShow & PYManagerRootConrollerShow)) {
        self.managerData.isRootAnimated = false;
    }else{
        self.managerData.enumShow = PYManagerHeadConrollerShow & self.managerData.enumShow;
    }
    if (self.managerData.isImageRoot) {
        [PYManagerController setDispalyImageForBaseView:self.managerData.rootView targetView:self.managerData.rootController.view];
    }
    [self.managerData.rootController.view removeFromSuperview];
    self.managerData.rootConstraintDict = nil;
    [self.managerData.rootController removeFromParentViewController];
    [PYManagerController setDispalyImageForBaseView:self.managerData.rootView targetView:self.managerData.rootController.view];
    if(self.managerData.isRootAnimated){
        __unsafe_unretained typeof(self) uuself = self;
        [UIView animateWithDuration:delayTime animations:^{
            uuself.managerData.blockRootAnimate(uuself, 0);
        } completion:^(BOOL finished) {
            uuself.managerData.isRootAnimated = false;
            uuself.managerData.rootView.userInteractionEnabled = false;
            [uuself.managerData.rootController removeFromParentViewController];
        }];
    }else{
        self.managerData.blockRootAnimate(self, 0);
        self.managerData.isRootAnimated = false;
        self.managerData.rootView.userInteractionEnabled = false;
    }
}

-(void) showHeadController:(NSTimeInterval) delayTime{
    self.managerData.isHeadAnimated = delayTime > 0;
    if (self.managerData.enumShow & PYManagerHeadConrollerShow) {
        self.managerData.isHeadAnimated = false;
    }else{
        self.managerData.enumShow = self.managerData.enumShow | PYManagerHeadConrollerShow;
    }
    
    [self.managerData.headView removeDisplayImage];
    
    [self addChildViewController:self.managerData.headController];
    [self.managerData.headView addSubview:self.managerData.headController.view];
    self.managerData.headConstraintDict = [PYViewAutolayoutCenter persistConstraint:self.managerData.headController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    
    if (self.managerData.rootView.superview == self.view) {
        switch (self.managerData.enumStyle) {
            case PYManagerNormalConrollerStyle:{
                [self.view bringSubviewToFront:self.managerData.headView];
            }
            break;
            case PYManagerSpecialConrollerStyle:{
                [self.view bringSubviewToFront:self.managerData.rootView];
            }
            break;
            default:
            break;
        }
    }

    if(self.managerData.isHeadAnimated){
        self.managerData.blockHeadAnimate(self, 0);
        __unsafe_unretained typeof(self) uuself = self;
        [UIView animateWithDuration:delayTime animations:^{
            uuself.managerData.blockHeadAnimate(uuself, 1);
        }completion:^(BOOL finished) {
            uuself.managerData.headView.userInteractionEnabled = true;
            uuself.managerData.isHeadAnimated = false;
        }];
    }else{
        self.managerData.blockHeadAnimate(self,1);
        self.managerData.headView.userInteractionEnabled = true;
        self.managerData.isHeadAnimated = false;
    }
}
-(void) hiddenHeadController:(NSTimeInterval) delayTime{
    self.managerData.isHeadAnimated = delayTime > 0;
    if (!(self.managerData.enumShow & PYManagerHeadConrollerShow)) {
        self.managerData.isHeadAnimated = false;
    }else{
        self.managerData.enumShow = self.managerData.enumShow & PYManagerRootConrollerShow;
    }
    if (self.managerData.isImageHead) {
        [PYManagerController setDispalyImageForBaseView:self.managerData.headView targetView:self.managerData.headController.view];
    }
    [self.managerData.headController.view removeFromSuperview];
    self.managerData.headConstraintDict = nil;
    [self.managerData.headController removeFromParentViewController];
    self.managerData.headView.userInteractionEnabled = false;
    if(self.managerData.isHeadAnimated){
        self.managerData.blockHeadAnimate(self, 1);
        __block bool flagRemoveControllerView = true;
        __unsafe_unretained typeof(self) uuself = self;
        [UIView animateWithDuration:delayTime animations:^{
            uuself.managerData.blockHeadAnimate(uuself, 0);
        } completion:^(BOOL finished) {
            if(!flagRemoveControllerView){
                [PYManagerController setDispalyImageForBaseView:uuself.managerData.headView targetView:uuself.managerData.headController.view];
            }
            uuself.managerData.isHeadAnimated = false;
        }];
    }else{
        self.managerData.blockHeadAnimate(self, 0);
        self.managerData.isHeadAnimated = false;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    switch (self.managerData.enumShow) {
        case PYManagerHeadConrollerShow:{
            return [self.managerData.headController preferredStatusBarStyle];
        }
            break;
        case PYManagerRootConrollerShow:{
            return [self.managerData.rootController preferredStatusBarStyle];
        }
            break;
        case PYManagerAllControllerShow:{
            return [self.managerData.rootController preferredStatusBarStyle];
        }
            break;
            
        default:
            break;
    }
    return [super preferredStatusBarStyle];
}
#pragma Orientations ==>
- (BOOL)shouldAutorotate{
    if (self.managerData.enumShow & PYManagerRootConrollerShow) {
        return [self.managerData.rootController shouldAutorotate];
    }else if (self.managerData.enumShow & PYManagerHeadConrollerShow) {
        return [self.managerData.headController shouldAutorotate];
    }
    return  [super shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.managerData.enumShow & PYManagerRootConrollerShow) {
        return [self.managerData.rootController supportedInterfaceOrientations];
    }else if (self.managerData.enumShow & PYManagerHeadConrollerShow) {
        return [self.managerData.headController supportedInterfaceOrientations];
    }
    return  [super supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (self.managerData.enumShow & PYManagerRootConrollerShow) {
        return [self.managerData.rootController preferredInterfaceOrientationForPresentation];
    }else if (self.managerData.enumShow & PYManagerHeadConrollerShow) {
        return [self.managerData.headController preferredInterfaceOrientationForPresentation];
    }
    return  [super preferredInterfaceOrientationForPresentation];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (self.managerData.enumShow & PYManagerRootConrollerShow) {
        [self.managerData.rootController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }else if (self.managerData.enumShow & PYManagerHeadConrollerShow) {
        [self.managerData.headController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }else{
        [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    self.managerData.blockLayoutAnimate(self);
    if (self.managerData.enumShow & PYManagerRootConrollerShow) {
        [self.managerData.rootController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }else if (self.managerData.enumShow & PYManagerHeadConrollerShow) {
        [self.managerData.headController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }else{
        [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}
#pragma Orientations <==
-(void) setIsPopGestureRecognizerEnabled:(BOOL) value{
    isPopGestureRecognizerEnabled = value;
}
-(BOOL) isPopGestureRecognizerEnabled{
    return isPopGestureRecognizerEnabled && isTouchMoveEnabled;
}
#pragma PYViewGestureRecognizerDelegate ==>
- (BOOL)touchesBegan:(CGPoint) point{
    
    isTouchMoveEnabled = flagHasGrMove = false;
    
    if (self.managerData.isHeadAnimated || self.managerData.isRootAnimated) {
        return false;
    }
    
    if (self.managerData.enumStyle == PYManagerUnkownConrollerStyle) {
        return false;
    }
    if (self.managerData.enumStyle != PYManagerSpecialConrollerStyle){
        return true;
    }
    
    switch (self.managerData.enumShow) {
        case PYManagerHeadConrollerShow:{
            isTouchMoveEnabled = (1 << self.managerData.headController.currentInterfaceOrientation) & self.managerData.rootController.supportedInterfaceOrientations;
            if (self.isPopGestureRecognizerEnabled) {
                bool flag = false;
                if(![self.managerData.rootView hasDisplayImageData]){
                    [self addChildViewController:self.managerData.rootController];
                    [self.managerData.rootView addSubview:self.managerData.rootController.view];
                    self.managerData.rootConstraintDict = [PYViewAutolayoutCenter persistConstraint:self.managerData.rootController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
                    flag = true;
                }
                if (![self.managerData.rootView hasAddDisplayImage]) {
                    [PYManagerController setDispalyImageForBaseView:self.managerData.rootView targetView:self.managerData.rootController.view];
                }
                if (!flag) {
                    self.managerData.rootConstraintDict = nil;
                    [self.managerData.rootController.view removeFromSuperview];
                    [self.managerData.rootController removeFromParentViewController];
                }
            }
        }
        break;
        case PYManagerRootConrollerShow:{
            isTouchMoveEnabled = self.managerData.headController.supportedInterfaceOrientations == (1 << self.managerData.rootController.currentInterfaceOrientation);
            if (self.isPopGestureRecognizerEnabled){
                
                
                bool flag = false;
                if(![self.managerData.headView hasDisplayImageData]){
                    [self addChildViewController:self.managerData.headController];
                    [self.managerData.headView addSubview:self.managerData.headController.view];
                    self.managerData.headConstraintDict = [PYViewAutolayoutCenter persistConstraint:self.managerData.headController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
                    flag = true;
                }
                [self addChildViewController:self.managerData.headController];
                [self.managerData.headView addSubview:self.managerData.headController.view];
                self.managerData.headConstraintDict = [PYViewAutolayoutCenter persistConstraint:self.managerData.headController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
                if (![self.managerData.headView hasAddDisplayImage]) {
                    [PYManagerController setDispalyImageForBaseView:self.managerData.headView targetView:self.managerData.headController.view];
                }
                if (!flag) {
                    self.managerData.headConstraintDict = nil;
                    [self.managerData.headController.view removeFromSuperview];
                    [self.managerData.headController removeFromParentViewController];
                }
            }
        }
        default:
        break;
    }
    if (!self.isPopGestureRecognizerEnabled) {
        return true;
    }
    touchePoint = point;
    return false;
}

//+(BOOL) isSupportOrientation:(UIDeviceOrientation) orientation targetController:(nonnull UIViewController *) targetController{
//    
//    UIInterfaceOrientationMask supportedInterfaceOrientations = [[UIApplication sharedApplication].keyWindow.rootViewController supportedInterfaceOrientations];
//    UIInterfaceOrientationMask interfaceOrientationMack = 1 << orientation;
//    if (!(supportedInterfaceOrientations & interfaceOrientationMack)) {
//        return false;
//    }
//    
//    supportedInterfaceOrientations = [targetController supportedInterfaceOrientations];
//    if (!(supportedInterfaceOrientations & interfaceOrientationMack)) {
//        return false;
//    }
//    
//    return true;
//}
- (BOOL)touchesMoved:(CGPoint) point{
    
    if (!self.isPopGestureRecognizerEnabled) {
        return true;
    }
    if (self.managerData.enumStyle == PYManagerUnkownConrollerStyle) {
        return false;
    }
    if (self.managerData.enumStyle != PYManagerSpecialConrollerStyle){
        return true;
    }
    flagHasGrMove = true;
    
    CGFloat value = (touchePoint.x - point.x) / self.viewGestureRecognizer.frameWidth;
    
    CGFloat rootValue =  1;
    CGFloat headValue =  0;
    
    if (self.managerData.enumShow & PYManagerRootConrollerShow){
        rootValue =  1 - MAX(0, MIN(1, value));
        headValue =  1 - rootValue;
    }else{
        headValue = 1 - MAX(0, MIN(1, -value));
        rootValue = 1 - headValue;
    }
    self.managerData.blockRootAnimate(self, rootValue);
    self.managerData.blockHeadAnimate(self, headValue);
    
    return false;
}
- (BOOL)touchesEnded:(CGPoint) point{
    
    if (!self.isPopGestureRecognizerEnabled) {
        return true;
    }
    
    if (!flagHasGrMove) {
        return true;
    }
    if (self.managerData.enumStyle == PYManagerUnkownConrollerStyle) {
        return true;
    }
    if (self.managerData.enumStyle != PYManagerSpecialConrollerStyle){
        return true;
    }
    
    CGFloat value = touchePoint.x - point.x ;
    if (value > 40) {
        [self showHeadController:.25];
        [self hiddenRootController:.25];
    }else if(value < -40){
        [self showRootController:.25];
        [self hiddenHeadController:.25];
    }else{
        [self touchesCancelled:point];
    }
    return false;
}
- (BOOL)touchesCancelled:(CGPoint) point{
    
    if (!self.isPopGestureRecognizerEnabled) {
        return true;
    }
    
    if (!flagHasGrMove) {
        return true;
    }
    
    if (self.managerData.enumShow & PYManagerRootConrollerShow){
        [self showRootController:.25];
    }else{
        [self hiddenRootController:.25];
    }
    if (self.managerData.enumShow & PYManagerHeadConrollerShow){
        [self showHeadController:.25];
    }else{
        [self hiddenHeadController:.25];
    }
    
    return false;
}
#pragma PYViewGestureRecognizerDelegate <==

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.view.frame.size.width == sizePre.width && self.view.frame.size.height == sizePre.height) {
        return;
    }
    sizePre = self.view.frame.size;
    self.managerData.blockLayoutAnimate(self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+(void) setDispalyImageForBaseView:(PYManagerView *) baseView targetView:(UIView *) view {
    
    [baseView addDisplayImage:nil];
    
    @unsafeify(view);
    @unsafeify(baseView);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @strongify(view);
        @strongify(baseView);
        __block UIImage *  image = [[view drawView] applyEffect:1 tintColor:nil];
        @unsafeify(baseView);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(baseView);
            [baseView reFreshDisplayImage:image];
            image = nil;
        });
    });
}

@end


@implementation PYViewGestureRecognizer{
    
}
-(instancetype) init{
    if (self = [super init]) {
//        swipeLeft= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeForLeft)];
//        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//        [self addGestureRecognizer:swipeLeft];
//        
//        swipeRight= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeForRight)];
//        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer:swipeRight];
//        gestureRecognizerEnum = PYViewGestureRecognizerUnknow;
    }
    return self;
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BOOL flag = true;
    if (self.delegate) {

        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        flag = [self.delegate touchesBegan:point];
        
    }
    if (flag) {
        [super touchesBegan:touches withEvent:event];
    }
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BOOL flag = true;
    if (self.delegate) {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        flag = [self.delegate touchesMoved:point];
        
    }
    if (flag) {
        [super touchesMoved:touches withEvent:event];
    }
}
-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BOOL flag = true;
    if (self.delegate) {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        flag = [self.delegate touchesEnded:point];
        
    }
    if (flag) {
        [super touchesEnded:touches withEvent:event];
    }
}
-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BOOL flag = true;
    if (self.delegate) {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        flag = [self.delegate touchesCancelled:point];
        
    }
    if (flag) {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end

