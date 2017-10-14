//
//  PYFwnmController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFwnmController.h"
#import "EXTScope.h"
#import <objc/runtime.h>
#import "pyutilea.h"
#import "PYFwnmParam.h"
#import "PYFwnmMenuController.h"

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
            if(wrv.frameworkShow != PYFrameworkAllShow)
                [wrv refreshChildControllerWithShow:PYFrameworkAllShow delayTime:0.25];
        }
            break;
        default:{
            if(wrv.frameworkShow != PYFrameworkRootShow)
                [wrv refreshChildControllerWithShow:PYFrameworkRootShow delayTime:0.25];
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
        [self.mdict removeObjectForKey:@(target.hash)];
    }else{
        self.mdict[@(target.navigationController.viewControllers.lastObject.hash)] = @(YES);
    }
    [UIViewcontrollerHookViewDelegateFWC REFRESHMENU];
}

@end

static UIViewcontrollerHookViewDelegateFWC * xUIViewcontrollerHookViewDelegateFWC;
@interface PYFwnmController ()

@end

@implementation PYFwnmController
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
    return self;
}
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.menuHeight = 50;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    @unsafeify(self);
    [super setBlockLayoutAnimate:^(PYFrameworkShow frameworkShow, UIView * _Nullable rootView, UIView * _Nonnull menuView){
        @strongify(self);
        CGRect menuBounds = CGRectMake(0, boundsHeight(), boundsWidth(), self.menuHeight);
        CGRect rootBounds = CGRectMake(0, 0, boundsWidth(), boundsHeight());
        if(frameworkShow & PYFrameworkMenuShow){
            menuBounds.origin.y = boundsHeight() - menuBounds.size.height;
            rootBounds.size.height = boundsHeight() - menuBounds.size.height;
        }
        rootView.frame = rootBounds;
        menuView.frame = menuBounds;
    }];
    PYFwnmMenuController * mv = [PYFwnmMenuController new];
    self.menuController = mv;
#ifdef DEBUG
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * rv  = [storyboard instantiateViewControllerWithIdentifier:@"rv"];
    self.rootController = rv;
    [self refreshChildControllerWithShow:PYFrameworkAllShow delayTime:0];
    NSDictionary * style1 = @{
                              PYFwnmMenuIdentify:@"err",
                              PYFwnmMenuTitle:@"menu1",
                              PYFwnmMenuTitleFontNormal:[UIFont systemFontOfSize:24],
                              PYFwnmMenuTitleColorNormal:[UIColor yellowColor],
                              PYFwnmMenuTitleColorHigthlight:[UIColor redColor],
                              PYFwnmMenuTitleColorSelected:[UIColor greenColor],
                              PYFwnmMenuImageNormal:[UIImage imageNamed:@"bill.png"],
                              PYFwnmMenuImageHigthlight:[UIImage imageNamed:@"bill_pre.png"],
                              PYFwnmMenuImageSelected:[UIImage imageNamed:@"bill_pre.png"]
                             };
    NSDictionary * style2 = @{
                              PYFwnmMenuIdentify:@"adsfa",
                              PYFwnmMenuTitle:@"menu2",
                              PYFwnmMenuTitleFontNormal:[UIFont systemFontOfSize:24],
                              PYFwnmMenuTitleColorNormal:[UIColor yellowColor],
                              PYFwnmMenuTitleColorHigthlight:[UIColor redColor],
                              PYFwnmMenuTitleColorSelected:[UIColor greenColor],
                              PYFwnmMenuImageNormal:[UIImage imageNamed:@"me.png"],
                              PYFwnmMenuImageHigthlight:[UIImage imageNamed:@"me_pre.png"],
                              PYFwnmMenuImageSelected:[UIImage imageNamed:@"me_pre.png"]
                             };
    [self setMenuStyle:@[style1, style2]];
    [self setColorSeletedBg:[UIColor orangeColor]];
    [self setBlockOnclickMenu:^BOOL (id _Nullable menuIdentify){
        @strongify(self);
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController * rv  = [storyboard instantiateViewControllerWithIdentifier:@"rv"];
        self.rootController = rv;
        [self refreshChildControllerWithShow:PYFrameworkAllShow delayTime:0];
        return YES;
    }];
#endif
}
-(void) setMenuIdentify:(id)menuIdentify{
    if(self.blockOnclickMenu){
        self.blockOnclickMenu(menuIdentify);
        _menuIdentify = menuIdentify;
        [((PYFwnmMenuController *)self.menuController) setSelectedMenuWithIdentify:menuIdentify];
    }
}
-(void) setColorSeletedBg:(UIColor *)colorSeletedBg{
    _colorSeletedBg = colorSeletedBg;
    ((PYFwnmMenuController*)self.menuController).colorSeletedBg = _colorSeletedBg;
}
-(void) setMenuStyle:(NSArray<NSDictionary *> *)menuStyle{
    _menuStyle = menuStyle;
    ((PYFwnmMenuController*)self.menuController).menuStyle = _menuStyle;
}
-(void) setBlockOnclickMenu:(BOOL (^)(id _Nullable))blockOnclickMenu{
    _blockOnclickMenu = blockOnclickMenu;
    PYFwnmMenuController * mv = (PYFwnmMenuController*)self.menuController;
    mv.blockOnclickMenu = _blockOnclickMenu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
