//
//  UIView+layerSwitch.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/4/18.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(LayerSwitch)
/**
 在最上层
 */
@property (nonatomic) BOOL layerSwitchToFront;
/**
 在最下层
 */
@property (nonatomic) BOOL layerSwitchToBack;
/**
 参与layer调整的view集合
 */
@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> * hashTableUIViewLayerSwitch;

@end
