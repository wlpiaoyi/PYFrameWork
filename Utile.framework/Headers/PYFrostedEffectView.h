//
//  PYFrostedEffectView.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/12/24.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYFrostedEffectView : UIView
@property (nonatomic, assign, nullable) UIView * viewTarget;
@property (nonatomic) CGFloat effectValue;
-(void) refreshImage;
@end
