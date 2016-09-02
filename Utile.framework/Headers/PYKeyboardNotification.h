//
//  PYKeyboardNotification.h
//  UtileScourceCode


//
//  Created by wlpiaoyi on 15/10/23.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockKeyboardAnimatedDoing)(UIResponder * _Nonnull responder, CGRect keyBoardFrame);
typedef void (^BlockKeyboardAnimatedCompletion)(UIResponder * _Nonnull responder);
/**
 键盘监听
 目标对象被回收时自动隐藏键盘
 */
@interface PYKeyboardNotification : NSObject
/**
 键盘监听事件添加
 @responder 输入源
 @blockStart 键盘显示回调
 @blockEnd 键盘隐藏回调
 */
+(BOOL)setKeyboardNotificationWithResponder:(nonnull UIResponder*) responder start:(nonnull BlockKeyboardAnimatedDoing) blockStart end:(nonnull BlockKeyboardAnimatedDoing) blockEnd;
/**
 键盘监听事件添加
 @responder 输入源
 @blockCompletionStart 键盘显示完成回调
 @blockCompletionEnd 键盘隐藏完成回调
 */
+(BOOL)setKeyboardNotificationWithResponder:(nonnull UIResponder*) responder completionStart:(nonnull BlockKeyboardAnimatedCompletion) blockCompletionStart completionEnd:(nonnull BlockKeyboardAnimatedCompletion) blockCompletionEnd;
/**
 移除键盘监听事件
 */
+(BOOL) removeKeyboardNotificationWithResponder:(nonnull UIResponder*) responder;
/**
 隐藏键盘
 */
+(BOOL) hiddenKeyboard;

@end
