//
//  PYFrameworkParamNavigationItem.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYFrameworkParamNavigationItem.h"

@implementation PYFrameworkParamNavigationItem

-(instancetype) init{
    if (self = [super init]) {
        self.shadowOffset = CGSizeZero;
        self.shadowBlurRadius = CGFLOAT_MIN;
        self.currentState = UIControlStateNormal;
    }
    return self;
}
+(instancetype) defaut{
    PYFrameworkParamNavigationItem  * data = [PYFrameworkParamNavigationItem new];
    data.shadowOffset = CGSizeMake(0, 0);
    data.shadowBlurRadius = 0;
    data.shadowColor = [UIColor clearColor];
    data.nameColor = [UIColor whiteColor];
    data.nameFont = [UIFont systemFontOfSize:12];
    return data;
}


@end
