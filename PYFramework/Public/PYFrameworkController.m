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
#import "UIView+Expand.h"

@interface PYFWView:UIView
kPNA CATransform3D transform3D;
kPNA CGAffineTransform transform2D;
@end

@implementation PYFWView{
@private
    UIView * _viewTransform3D;
    UIView * _viewTransform2D;
}
kINITPARAMSForType(PYFWView){
    _viewTransform2D = [UIView new];
    _viewTransform2D.backgroundColor = [UIColor clearColor];
    [super addSubview:_viewTransform2D];
    [PYViewAutolayoutCenter persistConstraint:_viewTransform2D relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
    _viewTransform3D = [UIView new];
    _viewTransform3D.backgroundColor = [UIColor clearColor];
    [_viewTransform2D addSubview:_viewTransform3D];
    [PYViewAutolayoutCenter persistConstraint:_viewTransform3D relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
    _transform2D = _viewTransform2D.transform;
    _transform3D = _viewTransform3D.layer.transform;
}
-(void) addSubview:(UIView *)view{
    [_viewTransform3D addSubview:view];
}
-(void) setTransform3D:(CATransform3D)transform3D{
    _transform3D = transform3D;
    _viewTransform3D.layer.transform = _transform3D;
}
-(void) setTransform2D:(CGAffineTransform)transform2D{
    _transform2D = transform2D;
    _viewTransform2D.transform = _transform2D;
}

@end

@interface PYFrameworkController ()
kPNSNN PYFWView * rootView;
kPNSNN PYFWView * menuView;
kPNSNN NSArray<NSLayoutConstraint *> * lcRoots;
kPNSNN NSArray<NSLayoutConstraint *> * lcMenus;
kSOULDLAYOUTP
@end

@implementation PYFrameworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootView = [PYFWView new];
    self.rootView.backgroundColor = [UIColor clearColor];
    self.menuView = [PYFWView new];
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.menuView setShadowColor:[UIColor grayColor].CGColor shadowRadius:4];
    [self.view addSubview:self.rootView];
    [self.view addSubview:self.menuView];
}
-(void) setRootController:(UIViewController *)rootController{
    @synchronized (self) {
        if(_rootController) [self removeRootController];
        _rootController = rootController;
        if(!_rootController) return;
        [self addChildViewController:_rootController];
        [self.rootView addSubview:_rootController.view];
        [PYViewAutolayoutCenter persistConstraint:_rootController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
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
        [PYViewAutolayoutCenter persistConstraint:_menuController.view relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    }
    self.rootController = self.rootController;
}

-(void) excuteBlockLayout{
    CGRect rootFrame = self.rootView.frame;
    CGRect menuFrame = self.menuView.frame;
    CATransform3D rootRransform3D = self.rootView.transform3D;
    CATransform3D menuRransform3D = self.menuView.transform3D;
    PYFwlayoutParams rootParams = PYFwlayoutParamsMake(rootFrame, self.rootView.alpha, rootRransform3D, self.rootView.transform2D);
    PYFwlayoutParams menuParams = PYFwlayoutParamsMake(menuFrame, self.menuView.alpha, menuRransform3D, self.menuView.transform2D);
    if(self.pyfwDelegate){
        [self.pyfwDelegate pyfwDelegateLayoutAnimate:self pyfwShow:self.pyfwShow rootParams:&rootParams menusParams:&menuParams];
    }else if(self.blockLayoutAnimate){
        _blockLayoutAnimate(self.pyfwShow, &rootParams, &menuParams);
    }
    self.rootView.frame = rootParams.frame;
    self.rootView.transform2D = rootParams.transform2D;
    self.rootView.alpha = rootParams.alpha;
    self.menuView.frame = menuParams.frame;
    self.menuView.transform2D = menuParams.transform2D;
    self.menuView.alpha = menuParams.alpha;
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
-(UIViewController *) getEnableController{
    if(_pyfwShow & PYFrameworkRootFillShow || _pyfwShow & PYFrameworkRootFitShow){
        return self.rootController;
    }
    if(_pyfwShow & PYFrameworkMenuShow){
        return self.menuController;
    }
    return nil;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController * vc = [self getEnableController];
    if(vc) return [vc preferredStatusBarStyle];
    return [super preferredStatusBarStyle];
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

-(void) refreshLayout{
    UIView * toBringView = self.rootView;
    if(_pyfwShow & PYFrameworkMenuShow){
        toBringView = self.menuView;
    }
    [self.view bringSubviewToFront:toBringView];
    [self.view layoutIfNeeded];
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
