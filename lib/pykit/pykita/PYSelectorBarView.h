//
//  PYSelectorBarView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/8/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

@class PYSelectorBarView;
@protocol PYSelectorBarViewDelegate<NSObject>
@required
-(BOOL) selectorBarView:(nonnull PYSelectorBarView *) selectorBarView selecteItemIndex:(NSUInteger) selecteItemIndex;
@end

@interface PYSelectorBarView : UIView
kPNRNN UIView * contentView;
/**
 按钮集合
 1.可以在xib里面在初始化是将自动加入到buttons对象里面
 2.自定义
 */
kPNSNN NSArray * buttons;
/**
 当前button选择后的一个标识图
 */
kPNSNA UIImageView * selectorTag;
/**
 标示图的高度
 如果高度为负数则表示等于当前bar的高度并且作为背景
 */
kPNA CGFloat selectorTagHeight;
/**
 当前选择第几个
 */
kPNA NSUInteger selectIndex;
/**
 仅用户选择变化回调
 适合用于功能开发
 delegate优先级大于blockSelecteItem
 */
kPNANA id<PYSelectorBarViewDelegate> delegate;
kPNCNA BOOL (^blockSelecteItem)(NSUInteger index);
/**
 强制选择，delegate,blockSelecteItem不会回调
 @param selectIndex 第几个
 @param animation 是否有动画
 */
-(void) setSelectIndex:(NSUInteger)selectIndex animation:(BOOL) animation;

#pragma mark 用于二次开发,所有选择变化回调
kPNCNA void (^blockSelectedOpt)(NSUInteger index);
#pragma mark 用于二次开发,重写此类将contentView添加到指定的地方, 由于使用了自动布局不建议直接加在scorllview中
-(void) addContentView:(nonnull UIView *) contentView;
@end