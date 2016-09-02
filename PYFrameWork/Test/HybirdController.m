//
//  HybirdController.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/7/29.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "HybirdController.h"
#import "PYHybirdView.h"
#import <Utile/PYViewAutolayoutCenter.h>

@interface HybirdController ()
@property (nonatomic, strong) PYHybirdView * hybirdView;
@end

@implementation HybirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hybirdView = [PYHybirdView new];
    [self.view addSubview:self.hybirdView];
    [PYViewAutolayoutCenter persistConstraint:self.hybirdView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
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
