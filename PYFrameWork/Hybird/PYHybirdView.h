//
//  PYHybirdView.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/7/20.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYHybirdView : UIView
@property (nonatomic, strong, nullable) NSURLRequest * request;
@property (nonatomic, strong, nullable) NSString * HTMLString;
-(void) addJavascriptInterfaces:(nonnull NSObject *) interface name:(nullable NSString *) name;
@end
