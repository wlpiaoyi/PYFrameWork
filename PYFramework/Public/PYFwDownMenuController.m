//
//  PYFwDownMenuController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFwDownMenuController.h"
#import <objc/runtime.h>
#import "pyutilea.h"
#import "PYFrameworkParam.h"
#import "PYFwMenuController.h"

@interface UIResponderHookBaseDelegateFWC : NSObject<UIResponderHookBaseDelegate>
kPNANN NSMutableDictionary * mdict;
-(void) beforeExcuteDeallocWithTarget:(nonnull NSObject *) target;
@end

@implementation UIResponderHookBaseDelegateFWC

-(void) beforeExcuteDeallocWithTarget:(nonnull NSObject *) target;{
    if(![target conformsToProtocol:@protocol(PYFrameworkNormalTag)]) return;
    [self.mdict removeObjectForKey:@(target.hash)];
}

@end
UIResponderHookBaseDelegateFWC * xUIResponderHookBaseDelegateFWC;
@interface UIViewcontrollerHookViewDelegateFWC : NSObject<UIViewcontrollerHookViewDelegate>
kPNSNN NSMutableDictionary * mdict;
@end
@implementation UIViewcontrollerHookViewDelegateFWC
+(void) initialize{
    [UIResponder hookWithMethodNames:nil];
    xUIResponderHookBaseDelegateFWC = [UIResponderHookBaseDelegateFWC new];
    [[UIViewController delegateBase] addObject:xUIResponderHookBaseDelegateFWC];
}
-(instancetype) init{
    self = [super init];
    self.mdict = [NSMutableDictionary new];
    return self;
}
+(void) REFRESHMENU{
    if(![[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[PYFrameworkController class]]) return;
    
    PYFrameworkController * wrv = (PYFrameworkController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if(![wrv.rootController isKindOfClass:[UINavigationController class]]) return;
    
    UINavigationController * nvc = (UINavigationController *)wrv.rootController;
    NSUInteger vcc = nvc.viewControllers.count;
    
    switch (vcc) {
        case 0:
            break;
        case 1:{
            if(!(wrv.frameworkShow & PYFrameworkRootFitShow) || !(wrv.frameworkShow & PYFrameworkMenuShow)){
                [wrv refreshChildControllerWithShow:PYFrameworkRootFillShow | PYFrameworkMenuHidden delayTime:0];
                [wrv refreshChildControllerWithShow:PYFrameworkRootFitShow | PYFrameworkMenuShow delayTime:0.25];
            }
        }
            break;
        default:{
            if((wrv.frameworkShow & PYFrameworkRootFitShow) && (wrv.frameworkShow & PYFrameworkMenuShow)){
                [wrv refreshChildControllerWithShow:PYFrameworkRootFillShow | PYFrameworkMenuShow delayTime:0];
                [wrv refreshChildControllerWithShow:PYFrameworkRootFitShow | PYFrameworkMenuHidden delayTime:0.25];
            }
        }
            break;
    }
}
-(void) afterExcuteViewWillAppearWithTarget:(nonnull UIViewController *) target{
    if(![target conformsToProtocol:@protocol(PYFrameworkNormalTag)]) return;
    if(!target.navigationController) return;
    if(!self.mdict[@(target.hash)]
       || (self.mdict[@(target.hash)]
           && ((NSNumber *)self.mdict[@(target.hash)]).boolValue
           )
       ){
        [UIViewcontrollerHookViewDelegateFWC REFRESHMENU];
        self.mdict[@(target.hash)] = @(NO);
    }
}
-(void) afterExcuteViewDidDisappearWithTarget:(nonnull UIViewController *) target{
    if(![target conformsToProtocol:@protocol(PYFrameworkNormalTag)]) return;
    if(!target.navigationController){
#pragma mark 如果没有导航控制器则表示当前控制器已经移除
        [self.mdict removeObjectForKey:@(target.hash)];
    }else{
#pragma mark 如果有导航控制器则表示当前控制器是上级控制器当前已经没有显示了
        self.mdict[@(target.navigationController.viewControllers.lastObject.hash)] = @(YES);
    }
    [UIViewcontrollerHookViewDelegateFWC REFRESHMENU];
}

@end

static UIViewcontrollerHookViewDelegateFWC * xUIViewcontrollerHookViewDelegateFWC;
@interface PYFwDownMenuController ()
kPNSNN UIView * viewOutSafe;
@end

@implementation PYFwDownMenuController
+(void) initialize{
    xUIViewcontrollerHookViewDelegateFWC = [UIViewcontrollerHookViewDelegateFWC new];
    [UIViewController hookMethodView];
    if (![[UIViewController delegateViews] containsObject:xUIViewcontrollerHookViewDelegateFWC]) {
        [UIViewController addDelegateView:xUIViewcontrollerHookViewDelegateFWC];
    }
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.menuHeight = 50;
    self.colorSeletedHeight = 3;
    return self;
}
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.menuHeight = 50;
    self.colorSeletedHeight = 3;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewOutSafe = [UIView new];
    self.viewOutSafe.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewOutSafe];
    [PYViewAutolayoutCenter persistConstraint:self.viewOutSafe size:CGSizeMake(DisableConstrainsValueMAX, 0.5)];
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    eii.bottomActive = true;
    [PYViewAutolayoutCenter persistConstraint:self.viewOutSafe relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, 0) relationToItems:eii];
    @unsafeify(self);
    [super setBlockLayoutAnimate:^(PYFrameworkShow frameworkShow, PYFwlayoutParams * rootParams, PYFwlayoutParams * menuParams){
        @strongify(self);
        CGRect menuBounds = CGRectMake(0, boundsHeight(), boundsWidth(), self.menuHeight);
        CGRect rootBounds = CGRectMake(0, 0, boundsWidth(), boundsHeight());
        if(frameworkShow & PYFrameworkMenuShow){
            menuBounds.size = CGSizeMake(boundsWidth(), self.menuHeight + (boundsHeight() - self.viewOutSafe.frameY));
            menuBounds.origin = CGPointMake(0, boundsHeight() - menuBounds.size.height);
        }else{
            menuBounds = CGRectMake(0, boundsHeight(), boundsWidth(), 0);
        }
        if(frameworkShow & PYFrameworkRootFillShow){
            rootBounds = CGRectMake(0, 0, boundsWidth(), boundsHeight());
        }else{
            rootBounds = CGRectMake(0, 0, boundsWidth(),  boundsHeight() - menuBounds.size.height);
        }
        (*rootParams).frame = rootBounds;
        (*menuParams).frame = menuBounds;
    }];
    PYFwMenuController * mv = [PYFwMenuController new];
    self.menuController = mv;
#ifdef DEBUG
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * rv  = [storyboard instantiateViewControllerWithIdentifier:@"rv"];
    self.rootController = rv;
    [self refreshChildControllerWithShow:PYFrameworkRootFitShow | PYFrameworkMenuShow delayTime:0];
    NSDictionary * style1 = @{
                              PYFwMenuIdentify:@"medenuId1",
                              PYFwMenuTitle:@"目录名称1",
                              PYFwMenuTitleFontNormal:[UIFont systemFontOfSize:24],
                              PYFwMenuTitleColorNormal:[UIColor yellowColor],
                              PYFwMenuTitleColorHigthlight:[UIColor redColor],
                              PYFwMenuTitleColorSelected:[UIColor greenColor],
                              PYFwMenuImageNormal:[UIImage imageNamed:@"bill.png"],
                              PYFwMenuImageHigthlight:[UIImage imageNamed:@"bill_pre.png"],
                              PYFwMenuImageSelected:[UIImage imageNamed:@"bill_pre.png"]
                             };
    NSDictionary * style2 = @{
                              PYFwMenuIdentify:@"medenuId2",
                              PYFwMenuTitle:@"目录名称2",
                              PYFwMenuTitleFontNormal:[UIFont systemFontOfSize:24],
                              PYFwMenuTitleColorNormal:[UIColor yellowColor],
                              PYFwMenuTitleColorHigthlight:[UIColor redColor],
                              PYFwMenuTitleColorSelected:[UIColor greenColor],
                              PYFwMenuImageNormal:[UIImage imageNamed:@"me.png"],
                              PYFwMenuImageHigthlight:[UIImage imageNamed:@"me_pre.png"],
                              PYFwMenuImageSelected:[UIImage imageNamed:@"me_pre.png"],
                              PYFwMenuIsDownImgDirection: @(NO)
                             };
    [self setMenuStyle:@[style1, style2]];
    [self setColorSeletedBg:[UIColor orangeColor]];
    [self setBlockOnclickMenu:^BOOL (id _Nullable menuIdentify){
        @strongify(self);
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController * rv  = [storyboard instantiateViewControllerWithIdentifier:@"rv"];
        self.rootController = rv;
        [self refreshChildControllerWithShow:PYFrameworkRootFitShow | PYFrameworkMenuShow delayTime:0];
        return YES;
    }];
#endif
}
-(void) showMenu:(nonnull id)menuIdentify{
    if(self.blockOnclickMenu){
        self.blockOnclickMenu(menuIdentify);
        [((PYFwMenuController *)self.menuController) setSelectedMenuWithIdentify:menuIdentify];
    }
}
-(void) setColorSeletedBg:(UIColor *)colorSeletedBg{
    _colorSeletedBg = colorSeletedBg;
    ((PYFwMenuController*)self.menuController).colorSeletedHeight = self.colorSeletedHeight;
    ((PYFwMenuController*)self.menuController).colorSeletedBg = _colorSeletedBg;
}
-(void) setMenuStyle:(NSArray<NSDictionary *> *)menuStyle{
    _menuStyle = menuStyle;
    ((PYFwMenuController*)self.menuController).menuStyle = _menuStyle;
}
-(void) setBlockOnclickMenu:(BOOL (^)(id _Nullable))blockOnclickMenu{
    _blockOnclickMenu = blockOnclickMenu;
    PYFwMenuController * mv = (PYFwMenuController*)self.menuController;
    mv.blockOnclickMenu = _blockOnclickMenu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
