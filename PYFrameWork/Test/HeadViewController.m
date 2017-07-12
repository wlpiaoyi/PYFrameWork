//
//  HeadViewController.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/15.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "HeadViewController.h"
#import "PYManagerController.h"

@interface HeadViewController ()

@end

@implementation HeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onClick:(id)sender {
    [((PYManagerController*)[UIApplication sharedApplication].keyWindow.rootViewController) hiddenHeadController:.25];
    [((PYManagerController*)[UIApplication sharedApplication].keyWindow.rootViewController) showRootController:.25];
}
- (IBAction)onClick2:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclick1:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * vc1  = [storyboard instantiateViewControllerWithIdentifier:@"HeadViewController"];
    [self presentViewController:vc1 animated:YES completion:^{}];
//    [self.navigationController pushViewController:vc1 animated:YES];

}
//-(void) viewWillAppear:(BOOL)animated{
//}
//-(void) viewDidAppear:(BOOL)animated{
//}
//-(void)viewWillDisappear:(BOOL)animated{
//}
//-(void) viewDidDisappear:(BOOL)animated{
//}
//-(void) viewWillLayoutSubviews{
//}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGRect r = self.view.frame;
    NSLog(@"");
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
