//
//  OauthController.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/29/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "OauthController.h"
#import "Weibocfg.h"
#import "AccountTool.h"
#import "MainController.h"
#import "MBProgressHUD.h"
#import "HttpTool.h"
#import "Weibocfg.h"

@interface OauthController () <UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation OauthController

- (void)loadView
{
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = _webView;
}

- (void)viewDidLoad
{
    [kBaseURL stringByAppendingPathComponent:@""];
    [super viewDidLoad];

    // 1. load login page(get unauthorised request token)
    NSString *urlStr = [kAuthorizeURL stringByAppendingFormat:@"?display=mobile&client_id=%@&redirect_uri=%@&language=%@", kAppKey, kRedirectURI, kLanguage];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    // 2. set delegate
    _webView.delegate = self;
}

#pragma mark - webview delegate
#pragma mark webview start load
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.dimBackground = YES;
}

#pragma mark webview finish load
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark intercept all requests from webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //MyLog(@"%@", request.URL);
    
    NSString *urlStr = request.URL.absoluteString;
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length != 0) {
        // Oauth succeed
        int index = range.location + range.length;
        NSString *requestToken = [urlStr substringFromIndex:index];
        MyLog(@"%@", requestToken);
        
        // get access token
        [self fetchAccessToken:requestToken];
        
        return NO;
    }
    
    return YES;
}

#pragma mark fetch access token
- (void)fetchAccessToken:(NSString *)requestToken
{
    [HttpTool postWithPath:@"oauth2/access_token"
        params: @{
            @"client_id" : kAppKey,
            @"client_secret" : kAppSecret,
            @"grant_type" : @"authorization_code",
            @"code" : requestToken,
            @"redirect_uri" : kRedirectURI
        } success:^(id JSON) {
            MyLog(@"Request succeeded!-%@", JSON);
            
            // save account
            Account *account = [[Account alloc] init];
            account.accessToken = JSON[@"access_token"];
            account.uid = JSON[@"uid"];
            [[AccountTool sharedAccountTool] saveAccount:account];
            
            self.view.window.rootViewController = [[MainController alloc] init];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSError *error) {
            //MyLog(@"Request failed!-%@", [error localizedDescription]);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
}

@end
















