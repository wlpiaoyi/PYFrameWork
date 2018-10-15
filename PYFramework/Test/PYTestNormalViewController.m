//
//  PYTestNormalViewController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/3/13.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestNormalViewController.h"
#import "PYFrameworkParam.h"

@interface PYTestNormalViewController ()<PYFrameworkAllTag>

@end

@implementation PYTestNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)onclickNext:(id)sender {
    NSMutableString * str = [NSMutableString stringWithUTF8String:"vc"];
    [str appendString:@(self.navigationController.viewControllers.count).stringValue];
    [self performSegueWithIdentifier:str sender:nil];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[PYOrientationNotification instanceSingle] attemptRotationToDeviceOrientation:UIDeviceOrientationLandscapeLeft completion:^(NSTimer * _Nonnull timer) {
//        kNOTIF_POST(@"PYFWRefreshLayout", nil);
//    }];
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeLeft;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) dealloc{
    
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
