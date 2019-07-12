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
PYKeybordHeadView * __X_PY_KEYBORD_HEADVIEW;

@interface UITextField(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder;
@end
@interface UITextView(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder;
@end

@implementation PYKeybordHeadView{
@private
    UIView * viewShadown;
    UIView * viewContentLeft;
    UIView * viewContentRight;
    UIButton * buttonHidden;
    UIButton * buttonNext;
    UIButton * buttonPre;
    NSTimer * timerKeyboardShow;
    UILabel * labelPlacetext;
    __weak UIView * forKeyboardView;
}
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        PY_FW_KBHV_FONT = [UIFont systemFontOfSize:14];
        [UITextField hookInstanceMethodName:@"becomeFirstResponder"];
        [UITextView hookInstanceMethodName:@"becomeFirstResponder"];
    });
}

kINITPARAMSForType(PYKeybordHeadView){
    self.isMoveForKeyboard = YES;
    self.backgroundColor = [UIColor clearColor];
    self.frameSize = CGSizeMake(boundsWidth(), 30);
    
    UIView * tempView = [UIView new];
    tempView.backgroundColor = [UIColor colorWithRGBHex:0xefeff4ff];
    [self addSubview:tempView];
    [tempView setShadowColor:[UIColor grayColor].CGColor shadowRadius:1];
    [tempView setAutotLayotDict:@{@"top":@(0),@"left":@(66),@"bottom":@(0),@"right":@(44)}];
    
    labelPlacetext = [UILabel new];
    labelPlacetext.textColor = [UIColor lightGrayColor];
    labelPlacetext.backgroundColor = [UIColor clearColor];
    labelPlacetext.textAlignment = NSTextAlignmentCenter;
    labelPlacetext.font = [UIFont systemFontOfSize:12];
    labelPlacetext.numberOfLines = 2;
    [tempView addSubview:labelPlacetext];
    [labelPlacetext setAutotLayotDict:@{@"top":@(0),@"left":@(self.frameHeight/2),@"bottom":@(0),@"right":@(self.frameHeight/2)}];
    
    viewShadown = [UIView new];
    viewShadown.backgroundColor = [UIColor clearColor];
    [viewShadown setShadowColor:[UIColor grayColor].CGColor shadowRadius:4];
    [self addSubview:viewShadown];
    [viewShadown setAutotLayotDict:@{@"top":@(0),@"left":@(0),@"bottom":@(0),@"right":@(0)}];
    
    viewContentLeft = [UIView new];
    viewContentLeft.backgroundColor = [UIColor whiteColor];
    [viewShadown addSubview:viewContentLeft];
    [viewContentLeft setAutotLayotDict:@{@"top":@(0),@"w":@(44 + self.frameHeight),@"bottom":@(0),@"right":@(-self.frameHeight/2)}];
    [viewContentLeft setCornerRadiusAndBorder:self.frameHeight/2 borderWidth:0 borderColor:[UIColor clearColor]];
    
    UIButton * b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@"• • • " forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickHidden:) forControlEvents:UIControlEventTouchUpInside];
    [viewContentLeft addSubview:b];
    [b setAutotLayotDict:@{@"top":@(0),@"left":@(self.frameHeight/2),@"bottom":@(0),@"right":@(self.frameHeight/2)}];
    buttonHidden = b;
    
    viewContentRight = [UIView new];
    viewContentRight.backgroundColor = [UIColor whiteColor];
    [viewShadown addSubview:viewContentRight];
    [viewContentRight setAutotLayotDict:@{@"top":@(0),@"w":@(66 + self.frameHeight),@"bottom":@(0),@"left":@(-self.frameHeight/2)}];
    [viewContentRight setCornerRadiusAndBorder:self.frameHeight/2 borderWidth:0 borderColor:[UIColor clearColor]];
    b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@" ▲" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickPre:) forControlEvents:UIControlEventTouchUpInside];
    [viewContentRight addSubview:b];
    buttonPre = b;
    
    b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@"▼ " forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickNext:) forControlEvents:UIControlEventTouchUpInside];
    [viewContentRight addSubview:b];
    buttonNext = b;
    [PYViewAutolayoutCenter persistConstraintHorizontal:@[buttonPre, buttonNext] relationmargins:UIEdgeInsetsMake(0, self.frameHeight/2, 0, self.frameHeight/2) relationToItems:PYEdgeInsetsItemNull() offset:0];
    self.placeholder = nil;
    
    kNOTIF_ADD(self, @"PY_KEYBORD_SET_PLACEHLODER", notifySetPlaceholder:);
    
}
-(void) notifySetPlaceholder:(NSNotification *) notify{
    NSString * obj = notify.object;
    self.placeholder = obj;
}
-(void) setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    labelPlacetext.text = placeholder ?  : @"";
}
+(UIButton *) __PY_CREATE_BUTTON{
    UIButton * b =  [UIButton buttonWithType:UIButtonTypeCustom];
    [b.titleLabel setFont:PY_FW_KBHV_FONT];
    [b setTitleColor:[UIColor colorWithRGBHex:0x167ffbff] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [b setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
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
    kNOTIF_REMV(self, @"PY_KEYBORD_SET_PLACEHLODER");
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


@implementation UITextField(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder{
    BOOL flag = [self exchangeBecomeFirstResponder];
    if(flag){
        kNOTIF_POST(@"PY_KEYBORD_SET_PLACEHLODER", self.placeholder);
    }
    return flag;
}
@end

@implementation UITextView(__PY_KEYBORD)
- (BOOL)exchangeBecomeFirstResponder{
    BOOL flag = [self exchangeBecomeFirstResponder];
    if(flag){
        kNOTIF_POST(@"PY_KEYBORD_SET_PLACEHLODER", nil);
    }
    return flag;
}
@end
