//
//  UIView+Popup.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYPopupParams.h"

extern CGFloat PYPopupAnimationTime;
/**
 弹出框
 */
@interface UIView(Popup)
//是否正在进行动画
@property (nonatomic, readonly) BOOL isAnimationing;
//是否显示了
@property (nonatomic, readonly) BOOL isShow;
//显示靠近中心的偏移量
@property (nonatomic) CGPoint centerPoint;
//显示框的大小
@property (nonatomic) CGSize offsetSize;

//=====================显示和隐藏时候的回调=========================>
@property (nonatomic,copy, nullable) BlockPopupAnimation blockShowAnimation;
@property (nonatomic,copy, nullable) BlockPopupAnimation blockHiddenAnimation;
//<=====================显示和隐藏时候的回调=========================

//遮罩层
@property (nonatomic, retain, nonnull) UIView * mantleView;
//显示的视图默认是自己
@property (nonatomic, retain, nonnull) UIView * showView;

-(void) popupShow;
-(void) popupHidden;

-(void) reSetCenter;

@end
