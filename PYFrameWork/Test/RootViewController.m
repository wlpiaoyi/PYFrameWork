//
//  RootViewController.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/15.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "RootViewController.h"
#import "PYManagerController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout;
@property (nonatomic) BOOL flag;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试";
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:UIBarButtonItemStyleDone target:self action:@selector(onClicked)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    // Do any additional setup after loading the view.
}
- (void)onClicked {
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    RootViewController * vc1  = [storyboard instantiateViewControllerWithIdentifier:@"hybird"];
//    vc1.flag = self.navigationController.viewControllers.count > 2;
//    [self.navigationController pushViewController:vc1 animated:YES];
    [self performSegueWithIdentifier:@"wo cao" sender:nil];;
}
- (IBAction)onClick:(id)sender {
    [((PYManagerController*)[UIApplication sharedApplication].keyWindow.rootViewController) hiddenRootController:.25];
    [((PYManagerController*)[UIApplication sharedApplication].keyWindow.rootViewController) showHeadController:.25];
}
- (IBAction)onClickNext:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RootViewController * vc1  = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    vc1.flag = self.navigationController.viewControllers.count > 2;
    PYManagerController * rv = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(vc1.flag){
        [rv hiddenHeadController:0];
    }else{
        [rv showHeadController:0];
        [rv showRootController:0];
    }
    [self.navigationController pushViewController:vc1 animated:YES];
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.flag ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft;
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations{
    return self.flag ? (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight) : (UIInterfaceOrientationMaskLandscapeLeft);
}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//-(void) viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//}
//-(void)viewWillDisappear:(BOOL)animated{
//}
//-(void) viewDidDisappear:(BOOL)animated{
//}
//-(void) viewWillLayoutSubviews{
//}
//-(void) viewDidLayoutSubviews{
//}

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
