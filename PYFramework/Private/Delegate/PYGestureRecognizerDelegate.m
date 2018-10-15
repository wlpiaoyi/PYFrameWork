//
//  PYGestureRecognizerDelegate.m
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYGestureRecognizerDelegate.h"

@implementation PYGestureRecognizerDelegate
+(nullable instancetype) shareDelegate{
    static PYGestureRecognizerDelegate * xGrd;
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        xGrd = [PYGestureRecognizerDelegate new];
    });
    return xGrd;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

@end
