//
//  PYPopupParams.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockTouchView)(CGPoint point, UIView  * _Nonnull touchView);
typedef void (^BlockPopupEndAnmation) (UIView * _Nonnull view);
typedef void (^BlockPopupAnimation) (UIView * _Nonnull view, BlockPopupEndAnmation _Nullable block);
//标题栏的背景颜色
extern UIColor * _Nullable STATIC_TITLEVIEW_BACKGROUNDCLOLOR;
//标题栏的边框颜色
extern UIColor * _Nullable STATIC_TITLEVIEW_BORDERCLOLOR;
//对话框的宽度，仅当在调用了 setMessage 方法后有效，其他情况以targetView的大小为准
extern CGFloat DialogFrameWith;
typedef void(^BlockDialogOpt)(UIView * _Nonnull view, NSUInteger index);


