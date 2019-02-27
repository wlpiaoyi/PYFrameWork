//
//  PYNetwork.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/14.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"


typedef enum _PYNetworkState {
    PYNetworkStateUnkwon = 0,
    PYNetworkStateResume,
    PYNetworkStateSuspend,
    PYNetworkStateCancel,
    PYNetworkStateInterrupt
} PYNetworkState;


extern NSTimeInterval PYNET_OUTTIME;

extern NSString * _Nonnull  PYNET_DATE_PATTERN;

extern CFStringRef PYNET_PERCENT_PARAM;
extern CFStringRef PYNET_PERCENT_FIELD;

//==>传输方法
extern NSString * _Nonnull PYNET_HTTP_GET;
extern NSString * _Nonnull PYNET_HTTP_POST;
extern NSString * _Nonnull PYNET_HTTP_PUT ;
extern NSString * _Nonnull PYNET_HTTP_DELETE;
///<==

@class PYNetwork;
@interface PYNetworkDelegate:NSObject<NSURLSessionDelegate>
kPNA PYNetwork * network;
@end

@interface PYNetwork : NSObject

kPNA NSTimeInterval outTime;
kPNAR PYNetworkState state;
kPNSNA id userInfo;

kPNRNN NSURLSession * session;
kPNSNA NSURLSessionTask * sessionTask;

//=========================================>
kPNSNN NSString * url;//请求地址
kPNSNN NSString * method;//请求类型，GET、POST、PUT、DELETE
/**
 支持的结构
 NSDictionary<NSString *, id> method参数key必须是String类型 value全类型支持
 NSData
 NSString
 */
kPNSNA id params;//请求数据
kPNSNA NSArray<NSString *> * keySorts;//参数排序 如果为空则不排序, 否则当前key-value在最前排序
kPNSNA NSDictionary<NSString *, NSString *> * heads;//头文件
///<=========================================

kPNCNA void (^blockSendProgress) (PYNetwork * _Nonnull target, int64_t currentBytes, int64_t totalBytes);
kPNCNA BOOL (^blockReceiveChallenge)(id _Nullable data, PYNetwork * _Nonnull target) ;
kPNCNA void (^blockComplete)(id _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target);

/**
 ssl证书账号密码
 */
//=========================================>
kPNSNA NSString * certificationName;
kPNSNA NSString * certificationPassword;
///<=========================================)

//=========================================>
/**
 开始、恢复请求
 */
-(BOOL) resume;
/**
 暂停请求
 */
-(BOOL) suspend;
/**
 取消请求
 */
-(BOOL) cancel;
/**
 强制中断请求
 不可短点恢复
 */
-(void) interrupt;
///<=========================================

-(nullable NSURLSession*) createSession;
-(nullable NSURLSessionTask *) createSessionTask;

/**
 创建网络请求
 @param urlString 请求地址
 @param httpMethod 请求类型
 @param heads 请求头信息
 @param outTime 超时时间
 */
+(nonnull NSURLRequest *) createRequestWithUrlString:(nonnull NSString*) urlString
                                            httpMethod:(nullable NSString*) httpMethod
                                            heads:(nullable NSDictionary<NSString *, NSString *> *) heads
                                            params:(nullable NSData *) params
                                            outTime:(CGFloat) outTime;
/**
 将键值对转换成对应的数据结构
 @param params 支持 NSString , NSDictionary, NSData
 @param contentType 支持
 application/x-www-form-urlencoded
 application/json
 application/xml
 @param keySorts 参数排序,仅当参数类型是form表单时有用
 */
+(nonnull NSData *) parseParamsToHttpBody:(nullable id) params
                                            contentType:(NSString *) contentType
                                            keySorts:(nullable NSArray<NSString *> *) keySorts;
@end
