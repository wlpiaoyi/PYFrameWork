//
//  PYFwMenuSlipController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/11/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFwMenuSlipController.h"

@interface UIViewControllerPyfwrsController: NSObject<PYFrameworkDelegate>
kPNA BOOL isLeft;
@end

@interface PYFwMenuSlipController ()
kPNSNN UIViewControllerPyfwrsController * superDelegate;
kPNSNN UIButton * buttonShowRoot;
@end

@implementation PYFwMenuSlipController

+(void) initialize{
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.delayTime = 0.25;
    return self;
}
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.delayTime = 0.25;
    return self;
}
-(void) setIsLeft:(BOOL)isLeft{
    _isLeft = isLeft;
    _superDelegate.isLeft = _isLeft;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.superDelegate = [UIViewControllerPyfwrsController new];
    self.pyfwDelegate = _superDelegate;
    _superDelegate.isLeft = self.isLeft;
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [b addTarget:self action:@selector(onclickShowRoot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    [self.view sendSubviewToBack:b];
    self.buttonShowRoot = b;
    [self refreshChildControllerWithShow:PYFrameworkRootFillShow delayTime:0];
#ifdef DEBUG
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * rv  = [storyboard instantiateViewControllerWithIdentifier:@"rv"];
    self.rootController = rv;
    UIViewController * vcm = [UIViewController new];
    [vcm.view setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor blueColor]];
    UIView * view = [UIView new];
    [view setCornerRadiusAndBorder:4 borderWidth:4 borderColor:[UIColor yellowColor]];
    view.backgroundColor = [UIColor whiteColor];
    [vcm.view addSubview:view];
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    eii.topActive = true;
    eii.bottomActive = true;
    vcm.view.backgroundColor = [UIColor grayColor];
    vcm.title = @"目录";
    [PYViewAutolayoutCenter persistConstraint:view relationmargins:UIEdgeInsetsZero relationToItems:eii];
    self.menuController = [[UINavigationController alloc] initWithRootViewController:vcm];
#endif
}
-(void) onclickShowRoot{
    [self refreshChildControllerWithShow:PYFrameworkRootFillShow delayTime:self.delayTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@implementation UIViewControllerPyfwrsController
-(void) pyfwDelegateLayoutAnimate:(PYFrameworkController *) pyfwVc pyfwShow:(PYFrameworkShow) pyfwShow rootParams:(nonnull PYFwlayoutParams *) rootParams menusParams:(nonnull PYFwlayoutParams *) menuParams{
    (*rootParams).frame = CGRectMake(0, 0, boundsWidth(), boundsHeight());
    if(self.isLeft){
        (*menuParams).frame = CGRectMake(0, 0, boundsWidth() * 3.0 / 4.0, boundsHeight());
        ((PYFwMenuSlipController *)pyfwVc).buttonShowRoot.frame = CGRectMake(boundsWidth() * 3.0 / 4.0, 0, boundsWidth()/4, boundsHeight());
    }else{
        (*menuParams).frame = CGRectMake(boundsWidth() / 4.0, 0, boundsWidth() * 3.0 / 4.0, boundsHeight());
        ((PYFwMenuSlipController *)pyfwVc).buttonShowRoot.frame = CGRectMake(0, 0, boundsWidth()/4, boundsHeight());
    }
    CGAffineTransform transform2D = CGAffineTransformIdentity;
    if(pyfwShow & PYFrameworkMenuShow){
        CGFloat tValue = 0.5;
        CGAffineTransform transform2DTemp =CGAffineTransformScale(transform2D, tValue, tValue);
        if(self.isLeft){
            transform2DTemp = CGAffineTransformTranslate(transform2DTemp, boundsWidth(), 0);
        }else{
            transform2DTemp = CGAffineTransformTranslate(transform2DTemp, -boundsWidth(), 0);
        }
        (*rootParams).transform2D = transform2DTemp;
        (*rootParams).alpha = .5;
        (*menuParams).transform2D = transform2D;
        (*menuParams).alpha = 1;
        [((PYFwMenuSlipController *)pyfwVc).view bringSubviewToFront:((PYFwMenuSlipController *)pyfwVc).buttonShowRoot];
    }else{
        CGAffineTransform transform2DTemp =CGAffineTransformScale(transform2D, 2, 2);
        (*menuParams).transform2D = transform2DTemp;
        (*menuParams).alpha = .5;
        (*rootParams).transform2D = transform2D;
        (*rootParams).alpha = 1;
        [((PYFwMenuSlipController *)pyfwVc).view sendSubviewToBack:((PYFwMenuSlipController *)pyfwVc).buttonShowRoot];
    }
}
@end
