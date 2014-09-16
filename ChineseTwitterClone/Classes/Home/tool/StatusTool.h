//
//  StatusTool.h
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Status;

typedef void (^StatusSuccessBlock)(NSArray *statuses);
typedef void (^StatusFailureBlock)(NSError *error);

typedef void (^CommentSuccessBlock)(NSArray *comments, int totalNum, long long nextCursor);
typedef void (^CommentFailureBlock)(NSError *error);

typedef void (^RepostSuccessBlock)(NSArray *reposts, int totalNum, long long nextCursor);
typedef void (^RepostFailureBlock)(NSError *error);

typedef void (^SingleStatusSuccessBlock)(Status *status);
typedef void (^SingleStatusFailureBlock)(NSError *error);

@interface StatusTool : NSObject

// get tweet data
+ (void)statusesWithSinceId:(long long)sinceId maxId:(long long)maxId success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;

// get comment data
+ (void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentSuccessBlock)success failure:(CommentFailureBlock)failure;

// get repost data
+ (void)repostsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostSuccessBlock)success failure:(RepostFailureBlock)failure;

// get single tweet
+ (void)statusWithId:(long long)ID success:(SingleStatusSuccessBlock)success failure:(SingleStatusFailureBlock)failure;
@end
