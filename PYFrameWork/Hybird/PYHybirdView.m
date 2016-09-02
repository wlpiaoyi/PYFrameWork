//
//  PYHybirdView.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/7/20.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYHybirdView.h"
#import <Utile/UIView+Expand.h>
#import <WebKit/WebKit.h>
#import <Utile/PYUtile.h>
#import <Utile/PYReflect.h>
#import <Utile/PYViewAutolayoutCenter.h>
#import <PYInterchange/UIView+Dialog.h>
#import <Utile/NSString+Expand.h>
#import <Utile/NSDictionary+Expand.h>
#import <Utile/NSData+Expand.h>
#import <objc/runtime.h>
#import <Utile/EXTScope.h>

@interface PYHybirdView()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView * contentView;
@property (nonatomic, strong) NSMutableDictionary * dictJavascriptInterfaces;
@property (nonatomic, strong) NSMutableDictionary * dictAlertCompletionHandler;
@end

@implementation PYHybirdView
-(instancetype) init{
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initParams];
    }
    return self;
}
-(NSString *) getAertName{
    return @"adfasdfalkajdkhjkadjsh";
}
-(void) initParams{
    self.dictJavascriptInterfaces = [NSMutableDictionary new];
    self.dictAlertCompletionHandler = [NSMutableDictionary new];
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
    // Webview的偏好设置
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.preferences.minimumFontSize = 10;
    configuration.preferences.javaScriptEnabled = true;
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // 通过js与webview内容交互配置
    configuration.userContentController = [[WKUserContentController alloc] init];
    NSString * javaScript = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/hybird.js",[[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
    WKUserScript * userScript = [[WKUserScript alloc] initWithSource:javaScript  injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
    [configuration.userContentController addUserScript:userScript];
    self.contentView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    [self addJavascriptInterfaces:self name:@"self"];
    
    [self addSubview:self.contentView];
    self.contentView.navigationDelegate = self;
    self.contentView.UIDelegate = self;
    [PYViewAutolayoutCenter persistConstraint:self.contentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    self.HTMLString = @"<HTML> sss</HTML>";
    
}
-(void) addJavascriptInterfaces:(nonnull NSObject *) interface name:(nullable NSString *) name{
    NSDictionary * dict = [PYHybirdView parsetJavascriptInterfacesToJavascriptInterfaces:interface name:name];
    name = (name && name.length) ? name : dict[@"className"];
//    // 添加一个名称，就可以在JS通过这个名称发送消息：
//    // window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
    for (NSString * methodName in ((NSDictionary *)dict[@"methodInfos"]).allKeys) {
        [self.contentView.configuration.userContentController addScriptMessageHandler:self name:[PYHybirdView getMessageHanderJS:name methodName:methodName]];
    }
    NSString * jsObjfun = [NSString stringWithFormat:@"var %@ = \n\t%@\n", name, [[dict[@"JSInfos"] toData] toString]];
    jsObjfun = [jsObjfun stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString * jsObjMethod = [NSString stringWithFormat:@"var  %@_method= \n\t%@\n", name,[[dict[@"methodInfos"] toData] toString]];
    WKUserScript * userScript = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"%@ \n %@",jsObjMethod, jsObjfun] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
    [self.contentView.configuration.userContentController addUserScript:userScript];
    [self.dictJavascriptInterfaces setObject:interface forKey:name];
}
-(void) setRequest:(NSURLRequest *)request{
    _request = request;
    [self.contentView loadRequest:self.request];
}
-(void) setHTMLString:(NSString *)HTMLString{
    _HTMLString = HTMLString;
    [self.contentView loadHTMLString:HTMLString baseURL:[NSURL URLWithString:[[NSBundle mainBundle] resourcePath]]];
}
#pragma WKScriptMessageHandler==>
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary * params = message.body;
    NSString * interfaceKey = [message.name componentsSeparatedByString:@"_"].firstObject;
    NSString * methodName = [message.name stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@_", interfaceKey] withString:@""];
    [self excuteHybirdWithInterfaceKey:interfaceKey methodName:methodName parmas:params[@"params"] callbackId:nil];
}
#pragma WKScriptMessageHandler<==
-(void) excuteHybirdWithInterfaceKey:(NSString *) interfaceKey methodName:(NSString *) methodName parmas:(NSArray *) params  callbackId:(NSString *) callbackId{
    id invocation = [PYReflect startInvoke:self.dictJavascriptInterfaces[interfaceKey] action:sel_getUid(methodName.UTF8String)];
    for (NSObject * param in params) {
        [PYReflect setInvoke:(__bridge void * _Nullable)(param) index:[params indexOfObject:param] + 2 invocation:invocation];
    }
    void * resultPoint;
    [PYReflect excuInvoke:&resultPoint returnType:nil invocation:invocation];
    id result;
    if(resultPoint){
        result = (__bridge id )(resultPoint);
    }
    if(resultPoint && callbackId){
        @unsafeify(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @strongify(self);
            @unsafeify(self);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.contentView evaluateJavaScript:[NSString stringWithFormat:@"setTimeout(function(){alert(\"sdfsdf\")}, 0); window.hybird.callbackResults['%@'] = '%@'",callbackId,result] completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    if (error != nil) {
//                        NSAssert(error == nil, @"error hybird");
                        return;
                    }
                }];
            });
        });
    }
}

#pragma WKUIDelegate==>
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    if (message.length > 18) {
        NSRange range = [message rangeOfString:@"{\"callbackId\":"];
        if (range.location == 0) {
            NSDictionary * infos = [[message dataUsingEncoding:NSUTF8StringEncoding] toDictionary];
            NSArray * params = infos[@"params"];
            NSString * callbackId = infos[@"callbackId"];
            NSString * interfaceKey = [((NSString *)infos[@"methodName"]) componentsSeparatedByString:@"_"].firstObject;
            NSString * methodName = [((NSString *)infos[@"methodName"]) substringFromIndex:interfaceKey.length + 1];
            [self excuteHybirdWithInterfaceKey:interfaceKey methodName:methodName parmas:params callbackId:callbackId];
            completionHandler();
            return;
        }
    }
    UIView * view = [UIView new];
    view.dialogTitle = webView.title.length ? webView.title : @"提示";
    view.dialogMessage = message;
    [view dialogShowWithBlock:^(UIView * _Nonnull view, NSUInteger index) {
        [view dialogHidden];
        completionHandler();
    } buttonNames:@[@"确定"]];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIView * view = [UIView new];
    view.dialogTitle = webView.title;
    view.dialogMessage = message;
    [view dialogShowWithBlock:^(UIView * _Nonnull view, NSUInteger index) {
        [view dialogHidden];
        completionHandler(index != 0);
    } buttonNames:@[@"确定",@"取消"]];
    completionHandler(true);
}
#pragma WKUIDelegate<==

#pragma WKNavigationDelegate==>
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.contentView evaluateJavaScript:@"var a = self.getAertName()" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"");
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}
#pragma WKNavigationDelegate <==

+(nonnull NSDictionary *) parsetJavascriptInterfacesToJavascriptInterfaces:(nonnull NSObject *) interface  name:(nullable NSString *) name{
    NSArray<NSDictionary*> * reflectDicts = [PYReflect getInstanceMethodInfosWithClass:interface.class];
    NSString * className = NSStringFromClass(interface.class);
    NSMutableDictionary * methodInfos = [NSMutableDictionary new];
    NSMutableDictionary * JSInfos = [NSMutableDictionary new];
    NSMutableDictionary * objDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"className":className,@"methodInfos":methodInfos,@"JSInfos":JSInfos}];
    for (NSDictionary * reflectDict in reflectDicts) {
        NSString * methodName = reflectDict[@"name"];
        if ([methodName containsString:@"."]) {
            continue;
        }
        NSString * returnType = reflectDict[@"returnType"];
        NSNumber * argumentNum = reflectDict[@"argumentNum"];
        NSArray * argumentTypes = reflectDict[@"argumentTypes"];
        NSDictionary * methodInfo = @{@"returnType":returnType, @"methodName":methodName,@"argumentNum":argumentNum,@"argumentTypes":argumentTypes ? argumentTypes : @""};
        
        NSMutableString * params = [NSMutableString new];
        if (argumentNum.integerValue > 0) {
            methodName = [PYHybirdView getMethodJS:methodName];
            for (int index = 0; index < argumentNum.integerValue; index ++) {
                [params appendFormat:@"v%d",index];
                if(index < argumentNum.integerValue - 1){
                    [params appendString:@","];
                }
            }
        }
        
        NSMutableString * functionJS = [NSMutableString new];
        [functionJS appendString:@"function("];
        [functionJS appendString:params];
        [functionJS appendFormat:@"){try{%@;}catch(err){alert('Error name: ' + err.name + '\nError message: ' + err.message);} }",[NSString stringWithFormat:@"window.hybird.call('%d','%@',[%@])",arc4random() ,[PYHybirdView getMessageHanderJS:name methodName:methodName],params]];
        
        JSInfos[methodName] = functionJS;
        methodInfos[[NSString stringWithFormat:@"%@",methodName]] = methodInfo;
    }
    return objDict;
}
+(nonnull NSString *) getMethodJS:(nonnull NSString *) methodName{
    if ([methodName containsString:@":"]) {
        return [[methodName stringByReplacingOccurrencesOfString:@":" withString:@"_"] substringToIndex:methodName.length - 1];
    }
    return methodName;
}
+(nonnull NSString *) getMessageHanderJS:(nonnull NSString *) objName methodName:(nonnull NSString *) methodName{
    return [NSString stringWithFormat:@"%@_%@",objName, [self getMethodJS:methodName]];
}
@end
