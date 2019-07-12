//
//  PYKeybordHeadView.h
//  forex
//
//  Created by wlpiaoyi on 2018/8/9.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"


@protocol PYKeybordHeadDelegate<NSObject>
@required
-(void) keybordHidden;
@optional
-(void) next;
-(void) previous;

@end

@interface PYKeybordHeadView : UIView
kPNA BOOL isMoveForKeyboard;
kPNSNA id tapGestureRecognizer;
kPNANA id<PYKeybordHeadDelegate> delegate;
kPNSNA NSArray<UIView *> * responders;
kPNSNA UIView * responder;

kPNA BOOL hasAppeared;
kPNA BOOL hasShowKeyboard;
kPNA CGRect keyBoardFrame;
kPNSNA NSString * placeholder;

-(void) addKeyBoardNotifyForTargetView:(nonnull UIView *) targetView;
-(void) removeKeybordNotify;

+(nullable UIView *) getCurFirstResponder:(nonnull UIView *) superView inputs:(nonnull NSMutableArray<id<UITextInput>> *) inputs;
@end
