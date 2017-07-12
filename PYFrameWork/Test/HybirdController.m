//
//  HybirdController.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/7/29.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "HybirdController.h"
#import "PYWebView.h"
#import "pyutilea.h"
#import "pyinterflowa.h"

@interface HybirdController ()
@property (weak, nonatomic) IBOutlet PYWebView *webView;
@end

@implementation HybirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0]];
    [((PYWebView *)self.webView) addJavascriptInterface:self name:@"vc"];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(char *) getchars:(char *) b{
    return "adfasdfasdfads";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
