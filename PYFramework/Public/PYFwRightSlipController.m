//
//  PYFwRightSlipController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/11/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFwRightSlipController.h"

@interface _PYFwrscView:UIView
kPNANA PYFwRightSlipController * rsController;
kPNA PYFwlayoutParams rootParams;
kPNA PYFwlayoutParams menuParams;
@end
@implementation _PYFwrscView
-(void) setRsController:(PYFwRightSlipController *)rsController{
    _rsController = rsController;
    kAssign(self);
    [_rsController setBlockLayoutAnimate:^(PYFrameworkShow pyfwShow, PYFwlayoutParams * _Nullable rootParams, PYFwlayoutParams * _Nullable menuParams) {
        (*rootParams).frame = CGRectMake(0, 0, boundsWidth(), boundsHeight());
        (*menuParams).frame = CGRectMake(boundsWidth() / 4.0, 0, boundsWidth() * 3.0 / 4.0, boundsHeight());
        CATransform3D trans = CATransform3DIdentity;
        kStrong(self);
        if(pyfwShow == PYFrameworkShowUnkownShow){
            
        }else if(pyfwShow & PYFrameworkRootFillShow){
            CATransform3D transTemp = CATransform3DScale(trans, 2, 2, 0);
            (*menuParams).transform = transTemp;
            (*menuParams).alpha = .5;
            (*rootParams).transform = trans;
        }else if(pyfwShow & PYFrameworkRootFitShow){
            CATransform3D transTemp = CATransform3DTranslate(trans, boundsWidth()/2, 0, 0);
            transTemp = CATransform3DScale(transTemp, 0.5, 0.5, 0);
            (*rootParams).transform = transTemp;
            (*menuParams).transform = trans;
            (*menuParams).alpha = 1;
        }
    }];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end

@interface PYFwRightSlipController ()

@end

@implementation PYFwRightSlipController

+(void) initialize{
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.view = [_PYFwrscView new];
    return self;
}
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.view = [_PYFwrscView new];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ((_PYFwrscView*)self.view).rsController = self;
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
