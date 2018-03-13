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

@interface PYFrameworkController ()
kPNSNN UIView * rootView;
kPNSNN UIView * menuView;
kPNSNN NSArray<NSLayoutConstraint *> * lcRoots;
kPNSNN NSArray<NSLayoutConstraint *> * lcMenus;
kSOULDLAYOUTP
@end

@implementation PYFrameworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootView = [UIView new];
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.menuView = [UIView new];
    self.menuView.backgroundColor = [UIColor whiteColor];
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
    CATransform3D rootRransform = self.rootView.layer.transform;
    CATransform3D menuRransform = self.menuView.layer.transform;
    PYFwlayoutParams rootParams = PYFwlayoutParamsMake(rootFrame, 0, rootRransform);
    PYFwlayoutParams menuParams = PYFwlayoutParamsMake(menuFrame, 0, menuRransform);
    if(self.pyfwDelegate){
        [self.pyfwDelegate pyfwDelegateLayoutAnimate:self pyfwShow:self.pyfwShow rootParams:&rootParams menusParams:&menuParams];
    }else if(self.blockLayoutAnimate){
        _blockLayoutAnimate(self.pyfwShow, &rootParams, &menuParams);
    }
    self.rootView.frame = rootParams.frame;
    self.rootView.layer.transform = rootParams.transform;
    self.menuView.frame = menuParams.frame;
    self.menuView.layer.transform = menuParams.transform;
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
            [self.view layoutIfNeeded];
            [self.rootView layoutIfNeeded];
            [self.menuView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->_isRootAnimated = false;
            [self.view layoutIfNeeded];
            [self.rootView layoutIfNeeded];
            [self.menuView layoutIfNeeded];
            self.view.userInteractionEnabled = YES;
        }];
    }else{
        _pyfwShow = show;
        _isRootAnimated = false;
        [self excuteBlockLayout];
        [self.rootView layoutIfNeeded];
        [self.menuView layoutIfNeeded];
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
