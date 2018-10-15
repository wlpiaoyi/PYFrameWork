//
//  PYGestureRecognizerDelegate.h
//  PYFramework
//
//  Created by wlpiaoyi on 2018/10/15.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>
+(nullable instancetype) shareDelegate;
@end
