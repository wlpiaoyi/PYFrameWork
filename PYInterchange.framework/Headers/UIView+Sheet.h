//
//  UIView+Sheet.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/5/18.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Sheet)
@property (nonatomic, strong, nullable) UIView * sheetTitleView;
@property (nonatomic, strong, nullable) NSString * sheetTitle;
@property (nonatomic, copy, nullable) void (^blockSheetShow) (UIView * _Nullable view);
@property (nonatomic, copy, nullable) void (^blockSheetHidden) (UIView * _Nullable view);
-(void) sheetShow:(nullable UIView *) superView;
-(void) sheetHidden;
@end
