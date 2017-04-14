//
//  MangerViewController.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/15.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "MangerViewController.h"
#import "RootViewController.h"
#import "HeadViewController.h"

@interface MangerViewController ()

@end

@implementation MangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RootViewController * vc1  = [storyboard instantiateViewControllerWithIdentifier:@"nav01"];
    HeadViewController * vc2  = [storyboard instantiateViewControllerWithIdentifier:@"HeadViewController"];
    self.managerData.rootController = vc1;
    self.managerData.headController = vc2;
    self.managerData.enumStyle = PYManagerNormalConrollerStyle;
    [self showHeadController:0];
    [self showRootController:0];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
