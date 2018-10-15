//
//  PYFrameworkParamNavigationBar.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkParamNavigationBar.h"


@implementation PYFrameworkParamNavigationBar

-(instancetype) init{
    if (self = [super init]) {
        self.shadowOffset = CGSizeZero;
        self.shadowBlurRadius = CGFLOAT_MIN;
        self.barMetrics =  UIBarMetricsDefault;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.lineButtomImage = nil;
    }
    return self;
}
+(instancetype) defaut{
    PYFrameworkParamNavigationBar  * data = [PYFrameworkParamNavigationBar new];
    data.shadowOffset = CGSizeMake(0, 0);
    data.shadowBlurRadius = 0;
    data.shadowColor = [UIColor clearColor];
    data.nameColor = [UIColor whiteColor];
    data.nameFont = [UIFont systemFontOfSize:20];
    data.tintColor = [UIColor whiteColor];
    data.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    return data;
}

@end
