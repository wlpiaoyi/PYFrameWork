//
//  PYFrameworkController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkController.h"
#import "PYViewAutolayoutCenter.h"
#import "PYFwMenuController.h"
#import "UIView+PYExpand.h"

@interface PYFWView:UIView
kPNA PYFwlayoutParams layoutParams;
@end
@implementation PYFWView{
@private
    UIView * _viewTransform3D;
    UIView * _viewTransform2D;
}
@synthesize layoutParams;
kINITPARAMSForType(PYFWView){
    _viewTransform2D = [UIView new];
    _viewTransform2D.backgroundColor = [UIColor clearColor];
    [super addSubview:_viewTransform2D];
    [PYViewAutolayoutCenter persistConstraint:_viewTransform2D relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
    _viewTransform3D = [UIView new];
    _viewTransform3D.backgroundColor = [UIColor clearColor];
    [_viewTransform2D addSubview:_viewTransform3D];
    [PYViewAutolayoutCenter persistConstraint:_viewTransform3D relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
}
-(void) setLayoutParams:(PYFwlayoutParams ) lp{
    layoutParams = lp;
    self.frame = layoutParams.frame;
    self.alpha = layoutParams.alpha;
    _viewTransform2D.transform = layoutParams.transform2D;
    _viewTransform3D.layer.transform = layoutParams.transform3D;
}
-(PYFwlayoutParams) layoutParams{
    layoutParams.frame = self.frame;
    layoutParams.alpha = self.alpha;
    layoutParams.transform2D = _viewTransform2D.transform;
    layoutParams.transform3D = _viewTransform3D.layer.transform;
    return layoutParams;
}
-(void) addSubview:(UIView *)view{
    [_viewTransform3D addSubview:view];
}
@end

@interface PYFrameworkController ()<PYFrameworkAllTag>
kPNSNN PYFWView * rootView;
kPNSNN PYFWView * menuView;
kPNSNN NSArray<NSLayoutConstraint *> * lcRoots;
kPNSNN NSArray<NSLayoutConstraint *> * lcMenus;
kSOULDLAYOUTP
@end

@implementation PYFrameworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootAnimationTransition = UIViewAnimationTransitionNone;
    self.rootView = [PYFWView new];
    self.rootView.backgroundColor = [UIColor clearColor];
    self.menuView = [PYFWView new];
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.menuView setShadowColor:[UIColor grayColor].CGColor shadowRadius:4];
    [self.view addSubview:self.rootView];
    [self.view addSubview:self.menuView];
    kNOTIF_ADD(self, @"PYFWRefreshLayout", refreshLayout);
}
-(BOOL) refreshChildControllerWithShow:(PYFrameworkShow) show delayTime:(NSTimeInterval) delayTime{
    if(delayTime > 0){
        if(_isRootAnimated) return NO;
        _isRootAnimated = true;
        _pyfwShow = show;
        self.view.userInteractionEnabled = NO;
        kAssign(self);
        [UIView animateWithDuration:delayTime animations:^{
            kStrong(self)
            [self excuteBlockLayout];
            [self refreshLayout];
        } completion:^(BOOL finished) {
            kStrong(self)
            self->_isRootAnimated = false;
            [self refreshLayout];
            self.view.userInteractionEnabled = YES;
        }];
    }else{
        _pyfwShow = show;
        _isRootAnimated = false;
        [self excuteBlockLayout];
        [self refreshLayout];
    }
    return YES;
}
-(void) setShow:(PYFrameworkShow) show rootsParams:(PYFwlayoutParams) rootsParams menusParams:(PYFwlayoutParams ) menusParams{
    _pyfwShow = show;
    self.rootView.layoutParams = rootsParams;
    self.menuView.layoutParams = menusParams;
}
-(void) refreshLayout{
    UIView * toBringView = self.rootView;
    if(_pyfwShow & PYFrameworkMenuShow){
        toBringView = self.menuView;
    }
    [self.view bringSubviewToFront:toBringView];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(BOOL) removeRootController{
    if(_isRootAnimated) return NO;
    _pyfwShow = _pyfwShow ^ (PYFrameworkRootFillShow | PYFrameworkRootFitShow | PYFrameworkRootHidden);
    [self.rootController removeFromParentViewController];
    [self.rootController.view removeFromSuperview];
    if(self.lcRoots){
        [self.rootView removeConstraints:self.lcRoots];
        [self.rootController.view removeConstraints:self.lcRoots];
    }
    _lcRoots = nil;
    _rootController = nil;
    return YES;
}

-(BOOL) removeMenuController{
    if(_isMenuAnimated) return NO;
    _pyfwShow = _pyfwShow ^ (PYFrameworkMenuShow | PYFrameworkMenuHidden);
    [self.menuController removeFromParentViewController];
    [self.menuController.view removeFromSuperview];
    if(self.lcMenus){
        [self.menuView removeConstraints:self.lcMenus];
        [self.menuController.view removeConstraints:self.lcMenus];
    }
    _lcMenus = nil;
    _menuController = nil;
    return YES;
}

-(void) setRootController:(UIViewController *)rootController{
    @synchronized (self) {
        if(_rootController) [self removeRootController];
        _rootController = rootController;
        if(!_rootController) return;
        [self addChildViewController:_rootController];
        [self.rootView addSubview:_rootController.view];
        self.lcRoots = [PYViewAutolayoutCenter persistConstraint:_rootController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()].allValues;
        self.rootView.frame = _rootController.view.bounds;
    }
}
-(void) setMenuController:(UIViewController *)menuController{
    @synchronized (self) {
        if(_menuController) [self removeMenuController];
        _menuController = menuController;
        if(!_menuController) return;
        self.menuView.frame = _menuController.view.frame;
        [self addChildViewController:_menuController];
        [self.menuView addSubview:_menuController.view];
        self.lcMenus = [PYViewAutolayoutCenter persistConstraint:_menuController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()].allValues;
    }
}

-(void) excuteBlockLayout{
    PYFwlayoutParams rootlp = self.rootView.layoutParams;
    PYFwlayoutParams menulp = self.menuView.layoutParams;
    if(self.pyfwDelegate){
        [self.pyfwDelegate pyfwDelegateLayoutAnimate:self pyfwShow:self.pyfwShow rootParams:&rootlp menusParams:&menulp];
    }else if(self.blockLayoutAnimate){
        _blockLayoutAnimate(self.pyfwShow, &rootlp, &menulp);
    }
    if(self.rootAnimationTransition != UIViewAnimationTransitionNone){
        [UIView beginAnimations:@"py_framwork_root" context:nil];
        [UIView setAnimationTransition:self.rootAnimationTransition forView:self.rootView cache:YES];
        [UIView setAnimationDuration:.5]; //动画时长
        [self setShow:self.pyfwShow rootsParams:rootlp menusParams:menulp];
        [UIView commitAnimations];
    }else{
        [self setShow:self.pyfwShow rootsParams:rootlp menusParams:menulp];
    }
}
-(UIViewController *) getEnableController{
    if(_pyfwShow & PYFrameworkRootFillShow || _pyfwShow & PYFrameworkRootFitShow){
        return self.rootController;
    }
    if(_pyfwShow & PYFrameworkMenuShow){
        return self.menuController;
    }
    return nil;
}
#pragma Orientations ==>
- (BOOL)shouldAutorotate{
    UIViewController * vc = [self getEnableController];
    if(vc) return [vc shouldAutorotate];
    return  [super shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController * vc = [self getEnableController];
    if(vc) return [vc supportedInterfaceOrientations];
    return  [super supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIViewController * vc = [self getEnableController];
    if(vc) return [vc preferredInterfaceOrientationForPresentation];
    return  [super preferredInterfaceOrientationForPresentation];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    UIViewController * vc = [self getEnableController];
    if(vc) return [vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    UIViewController * vc = [self getEnableController];
    if(vc) return [vc  didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
- (void)preferredContentSizeDidChangeForChildContentContainer:(id <UIContentContainer>)container{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
}
- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(id <UIContentContainer>)containe{
    [super systemLayoutFittingSizeDidChangeForChildContentContainer:containe];
}
#pragma Orientations <==

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self excuteBlockLayout];
}
kSOULDLAYOUTVMSTART
    [self excuteBlockLayout];
kSOULDLAYOUTMEND

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
