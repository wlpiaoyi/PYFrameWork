//
//  PYManagerController.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/6/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYManagerData.h"


/**
 底层指挥控制器
 */
@interface PYManagerController : UIViewController

@property (nonatomic, readonly, nonnull) PYManagerData * managerData;

@property (nonatomic) BOOL isPopGestureRecognizerEnabled;

-(void) showRootController:(NSTimeInterval) delayTime;
-(void) hiddenRootController:(NSTimeInterval) delayTime;

-(void) showHeadController:(NSTimeInterval) delayTime;
-(void) hiddenHeadController:(NSTimeInterval) delayTime;
@end

