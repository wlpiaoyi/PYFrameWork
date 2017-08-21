//
//  UITextField+Check.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/6/27.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYUtile.h"

@interface UITextField(Check)
PYPNCNA void (^blockInputEndMatch) (NSString * _Nonnull identify, BOOL * _Nonnull checkResult);
-(void) clearTextFieldCheck;
-(void) checkInteger;
-(void) checkIntegerForMax:(PYInt64) max min:(PYInt64) min;
-(void) checkFloat;
-(void) checkFloatForMax:(CGFloat) max min:(CGFloat) min precision:(int) precision;
-(void) checkMobliePhone;
-(void) checkEmail;
-(void) checkIDCard;
-(void) checkMatchWithIdentify:(nonnull NSString *) identify inputing:(nonnull id) inputing inputEnd:(nonnull NSString *) inputEnd;
@end
