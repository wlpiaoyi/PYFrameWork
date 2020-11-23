//
//  View2Controller.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/13.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "View2Controller.h"
#import "PYFrameworkUtile.h"
#import "pyinterflowa.h"

@interface View2Controller ()<PYFrameworkAllTag>

@end

@implementation View2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    [textView dialogShowWithTitle:nil block:^(UIView * _Nonnull view, NSUInteger index) {
        [view dialogHidden];
    } buttonNames:@[@"确定"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//-(BOOL) isMoveForKeyboradShow;{
//    return NO;
//}

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
