//
//  HttpTool.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Weibocfg.h"
#import "AccountTool.h"

@implementation HttpTool

+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    // 1. create post
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    // add access_token to param dictionary
    NSMutableDictionary *allParams;
    if (params) {
        allParams = [NSMutableDictionary dictionaryWithDictionary:params];
    } else {
        allParams = [NSMutableDictionary dictionary];
    }
     
    NSString *accessToken = [AccountTool sharedAccountTool].currentAccount.accessToken;
    if (accessToken) {
        allParams[@"access_token"] = accessToken;
    }

    NSURLRequest *req = [client requestWithMethod:method path:path parameters:allParams];
    
    // 2. create AFJSONRequestOperation
    NSOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success == nil) {
            return;
        }
        success(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure == nil) {
            return;
        }
        failure(error);
    }];
    
    // 3. post request
    [op start];
}

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"POST"];
}

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"GET"];
}

+ (void)downloadImage:(NSString *)url placeHolder:(UIImage *)placeHolder imageView:(UIImageView *)imageView
{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

@end
