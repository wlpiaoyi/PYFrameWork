//
//  PYEventManager.h
//  PYIpa
//
//  Created by wlpiaoyi on 2018/9/25.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

typedef void(^PYEventStoreRequestAccessCompletionHandler)(id _Nullable data);

@interface PYEventManager : NSObject
+(nonnull instancetype) singleInstance;
-(void) presisitEvent:(nonnull NSString *) title
                            startDate:(nonnull NSDate *) startDate
                            endDate:(nonnull NSDate *) endDate
                            alarmDate:(nonnull NSDate *) alarmDate
                            completion:(nullable PYEventStoreRequestAccessCompletionHandler)completion;
-(nullable NSError *) removeEvent:(nonnull NSString *) identify;
-(nullable EKEvent *) findEvent:(nonnull NSString *) identify;

//-(void) presisitReminder:(nonnull NSString *) title
//                            startDate:(nonnull NSDate *) startDate
//                            endDate:(nonnull NSDate *) endDate
//                            completion:(nullable EKEventStoreRequestAccessCompletionHandler)completion;
//-(nullable NSError *) removeReminder:(nonnull EKReminder *) reminder;

@end
