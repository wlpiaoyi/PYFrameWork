//
//  PYKeybordHeadView.m
//  forex
//
//  Created by wlpiaoyi on 2018/8/9.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYKeybordHeadView.h"
#import "pyutilea.h"

UIFont * PY_FW_KBHV_FONT;

@implementation PYKeybordHeadView{
@private
    UIView *viewBorder;
    UIView *viewContent;
    UIButton * buttonHidden;
    UIButton * buttonNext;
    UIButton * buttonPre;
    NSTimer * timerKeyboardShow;
    __weak UIView * forKeyboardView;
}
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        PY_FW_KBHV_FONT = [UIFont systemFontOfSize:12];
    });
}

kINITPARAMSForType(PYKeybordHeadView){
    self.isMoveForKeyboard = YES;
    self.backgroundColor = [UIColor clearColor];
    [self setShadowColor:[UIColor grayColor].CGColor shadowRadius:4];
    self.frameSize = CGSizeMake(190, 30);
    
    viewBorder = [UIView new];
    viewBorder.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBorder];
    [viewBorder setAutotLayotDict:@{@"top":@(0),@"left":@(0),@"bottom":@(0),@"right":@(0)}];
    [viewBorder setCornerRadiusAndBorder:self.frameHeight/2 borderWidth:0 borderColor:[UIColor clearColor]];
    
    viewContent = [UIView new];
    viewContent.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewContent];
    [viewContent setAutotLayotDict:@{@"top":@(0),@"left":@(self.frameHeight/2),@"bottom":@(0),@"right":@(0)}];
    UIButton * b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@"隐藏🔽" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickHidden:) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:b];
    buttonHidden = b;
    
    b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@" 下一个⬇️ " forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickNext:) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:b];
    buttonNext = b;
    
    b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@" 上一个⬆️ " forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickPre:) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:b];
    buttonPre = b;
    
    [PYViewAutolayoutCenter persistConstraintHorizontal:@[buttonPre, buttonNext, buttonHidden] relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull() offset:0];

}
+(UIButton *) __PY_CREATE_BUTTON{
    UIButton * b =  [UIButton buttonWithType:UIButtonTypeCustom];
    [b.titleLabel setFont:PY_FW_KBHV_FONT];
    [b setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [b setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
    return b;
}

- (void)onclickHidden:(id)sender {
    [PYKeyboardNotification hiddenKeyboard];
    if(self.delegate && [self.delegate respondsToSelector:@selector(keybordHidden)]){
        [self.delegate keybordHidden];
    }
}
- (void)onclickNext:(id)sender {
    if(!forKeyboardView) return;
    NSUInteger index = (self.responder && self.responders && [self.responders containsObject:self.responder]) ? [self.responders indexOfObject:self.responder] : -1;
    if(index != -1){
        if(index < self.responders.count - 1){
            index ++;
        }else{
            index = 0;
        }
        self.responder = [self.responders objectAtIndex:index];
        if(@available(iOS 12.0, *)){
            timerKeyboardShow = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [UIView animateWithDuration:.25 animations:^{
                    [self keyboradShowDoingWithInputView:self.responder keyboradFrame:self.keyBoardFrame];
                }];
            }];
        }
        [self.responder becomeFirstResponder];
    }
    if(self.delegate){
        [self.delegate next];
    }
}
- (void)onclickPre:(id)sender {
    if(!forKeyboardView) return;
    NSUInteger index = (self.responder && self.responders && [self.responders containsObject:self.responder]) ? [self.responders indexOfObject:self.responder] : -1;
    if(index != -1){
        if(index > 0){
            index --;
        }else{
            index = self.responders.count - 1;
        }
        self.responder = [self.responders objectAtIndex:index];
        if(@available(iOS 12.0, *)){
            timerKeyboardShow = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [UIView animateWithDuration:.25 animations:^{
                    [self keyboradShowDoingWithInputView:self.responder keyboradFrame:self.keyBoardFrame];
                }];
            }];
        }
        [self.responder becomeFirstResponder];
    }
    if(self.delegate){
        [self.delegate previous];
    }
}

+(UIView *) getCurFirstResponder:(UIView *) superView inputs:(NSMutableArray<id<UITextInput>> *) inputs{
    UIView * resultView = nil;
    for (UIView * subView in superView.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInput)]){
            if(subView.hidden || !subView.userInteractionEnabled || subView.frame.size.width <= 0 || subView.frame.size.height <= 0){
                continue;
            }
            if(inputs) [inputs addObject:((id<UITextInput>)subView)];
            if([subView isFirstResponder]){
                resultView = subView;
            }
        }else{
            UIView * temp = [self getCurFirstResponder:subView inputs:inputs];
            if(temp) resultView = temp;
        }
    }
    return resultView;
}
-(void) keyboradShowDoingWithInputView:(nullable UIView *) inputView keyboradFrame:(CGRect) keyboradFrame{
    if(!self.hasAppeared) return;
    [timerKeyboardShow invalidate];
    timerKeyboardShow = nil;
    self.hasShowKeyboard = true;
    self.keyBoardFrame = keyboradFrame;
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self];
    self.frameY = boundsHeight() - keyboradFrame.size.height - self.frameHeight;
    
    
    NSMutableArray<id<UITextInput>> * inputs = [NSMutableArray new];
    if(!inputView) inputView = [PYKeybordHeadView getCurFirstResponder:forKeyboardView inputs:inputs];
    else [PYKeybordHeadView getCurFirstResponder:forKeyboardView inputs:inputs];
    if(!inputView) return;
    if(inputs && inputs.count){
        [inputs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            UIView * view1 = obj1;
            UIView * view2 = obj2;
            CGPoint p1 = [view1 getAbsoluteOrigin:[UIApplication sharedApplication].delegate.window];
            CGPoint p2 = [view2 getAbsoluteOrigin:[UIApplication sharedApplication].delegate.window];
            if(p1.y < p2.y) return NSOrderedAscending;
            else return NSOrderedDescending;
        }];
    }
    self.responder = inputView;
    self.responders = (NSArray<UIView *> *)inputs;
    
    if(self.isMoveForKeyboard){
        CGPoint p = [inputView getAbsoluteOrigin:[UIApplication sharedApplication].delegate.window];
        CGFloat value = (boundsHeight() - p.y - inputView.frameHeight) - keyboradFrame.size.height - self.frameHeight;
        CGRect bounds = forKeyboardView.bounds;
        if(value > 0){
            if(bounds.origin.y != 0){
                bounds.origin.y = 0;
                forKeyboardView.bounds = bounds;
            }
            return;
        }
        bounds.origin.y = -value;
        forKeyboardView.bounds = bounds;
    }
}

-(void) addKeyBoardNotifyForTargetView:(nonnull UIView *) targetView{
    [self removeKeybordNotify];
    forKeyboardView = targetView;
    kAssign(self);
    [PYKeyboardNotification setKeyboardNotificationWithResponder:self showDoing:^(UIResponder * _Nonnull responder, CGRect keyBoardFrame) {
        kStrong(self);
        [self keyboradShowDoingWithInputView:nil keyboradFrame:keyBoardFrame];
    } hiddenDoing:^(UIResponder * _Nonnull responder, CGRect keyBoardFrame) {
        kStrong(self);
        [self->timerKeyboardShow invalidate];
        self->timerKeyboardShow = nil;
        PYKeybordHeadView * keybordHead = self;
        if(!keybordHead.hasAppeared) return;
        keybordHead.frameY = boundsHeight();
        if(!keybordHead.hasShowKeyboard) return;
        keybordHead.hasShowKeyboard = false;
        CGRect bounds = targetView.bounds;
        bounds.origin.y = 0;
        targetView.bounds = bounds;
    }];
}

-(void) removeKeybordNotify{
    forKeyboardView = nil;
    [PYKeyboardNotification removeKeyboardNotificationWithResponder:self];
}
-(void) dealloc {
    [self removeKeybordNotify];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
