//
//  PYSliderView.h
//  PYKit
//
//  Created by wlpiaoyi on 2018/5/8.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

extern CGFloat PY_SLIDER_POINTER_WITDH;

@interface PYSliderView : UIView
kPNA CGFloat minValue;
kPNA CGFloat maxValue;
kPNA CGFloat startValue;
kPNA CGFloat endValue;
kPNCNA BOOL (^blockTouchSlider) (PYSliderView * _Nonnull sliderView);
@end
