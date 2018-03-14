//
//  PYTestNormalViewController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/3/13.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestNormalViewController.h"

@interface PYTestNormalViewController ()

@end

@implementation PYTestNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onclickNext:(id)sender {
    NSMutableString * str = [NSMutableString stringWithUTF8String:"vc"];
    [str appendString:@(self.navigationController.viewControllers.count).stringValue];
    [self performSegueWithIdentifier:str sender:nil];
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
