//
//  PYFrameworkController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkController.h"
#import "PYViewAutolayoutCenter.h"
#import "PYFwnmMenuController.h"
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
    if(self.blockLayoutAnimate){
        _blockLayoutAnimate(self.frameworkShow, self.rootView, self.menuView);
    }
}

-(void) refreshChildControllerWithShow:(PYFrameworkShow) show delayTime:(NSTimeInterval) delayTime{
    _frameworkShow = show;
    if(delayTime > 0){
        _isRootAnimated = true;
        __unsafe_unretained typeof(self) uself = self;
        [UIView animateWithDuration:delayTime animations:^{
            [uself excuteBlockLayout];
            [_rootView layoutIfNeeded];
            [_menuView layoutIfNeeded];
        } completion:^(BOOL finished) {
            _isRootAnimated = false;
            [_rootView layoutIfNeeded];
            [_menuView layoutIfNeeded];
        }];
    }else{
        _isRootAnimated = false;
        [self excuteBlockLayout];
        [_rootView layoutIfNeeded];
        [_menuView layoutIfNeeded];
    }
}

-(BOOL) removeRootController{
    if(_isRootAnimated) return NO;
    _frameworkShow = _frameworkShow ^ PYFrameworkRootShow;
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
    _frameworkShow = _frameworkShow ^ PYFrameworkMenuShow;
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
    switch (_frameworkShow) {
        case PYFrameworkRootShow:{
            return self.rootController;
        }
            break;
        case PYFrameworkAllShow:{
            return self.rootController;
        }
            break;
        case PYFrameworkMenuShow:{
            return self.menuController;
        }
            break;
        default:
            break;
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
