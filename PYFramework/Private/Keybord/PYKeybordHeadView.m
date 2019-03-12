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
}
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        PY_FW_KBHV_FONT = [UIFont systemFontOfSize:12];
    });
}
kINITPARAMSForType(PYKeybordHeadView){
    
    self.backgroundColor = [UIColor clearColor];
    [self setShadowColor:[UIColor grayColor].CGColor shadowRadius:4];
    self.frameSize = CGSizeMake(180, 30);
    
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
    [b setTitle:@"下一个⬇️" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(onclickNext:) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:b];
    buttonNext = b;
    
    b = [self.class __PY_CREATE_BUTTON];
    [b setTitle:@"上一个⬆️" forState:UIControlStateNormal];
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
    NSUInteger index = (self.responder && self.responders && [self.responders containsObject:self.responder]) ? [self.responders indexOfObject:self.responder] : -1;
    if(index != -1){
        if(index < self.responders.count - 1){
            index ++;
        }else{
            index = 0;
        }
        self.responder = [self.responders objectAtIndex:index];
        [self.responder becomeFirstResponder];
    }
    if(self.delegate){
        [self.delegate next];
    }
}
- (void)onclickPre:(id)sender {
    NSUInteger index = (self.responder && self.responders && [self.responders containsObject:self.responder]) ? [self.responders indexOfObject:self.responder] : -1;
    if(index != -1){
        if(index > 0){
            index --;
        }else{
            index = self.responders.count - 1;
        }
        self.responder = [self.responders objectAtIndex:index];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
