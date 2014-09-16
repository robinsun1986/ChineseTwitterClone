//
//  StatusTool.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "StatusTool.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "Status.h"
#import "Comment.h"

@implementation StatusTool

+ (void)statusesWithSinceId:(long long)sinceId maxId:(long long)maxId success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/home_timeline.json" params:@{
     @"count": @20,
     @"since_id": @(sinceId),
     @"max_id": @(maxId)
     } success:^(id JSON) {
        if (success == nil) {
            return;
        }
        
        NSMutableArray *statuses = [NSMutableArray array];
        
        NSArray *array = JSON[@"statuses"];
        for (NSDictionary *dict in array) {
            Status *s = [[Status alloc] initWithDict:dict];
            [statuses addObject:s];
        }
        
        // callback block
        success(statuses);
        
    } failure:^(NSError *error) {
        if (failure == nil) {
            return;
        }
        failure(error);
    }];
}

+ (void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentSuccessBlock)success failure:(CommentFailureBlock)failure
{
    [HttpTool getWithPath:@"2/comments/show.json" params:@{
     @"id": @(statusId),
     @"since_id": @(sinceId),
     @"max_id": @(maxId)
     } success:^(id JSON) {
         if (success == nil) {
             return;
         }
         
         NSArray *array = JSON[@"comments"];
         NSMutableArray *comments = [NSMutableArray array];
         for (NSDictionary *dict in array) {
             Comment *c = [[Comment alloc] initWithDict:dict];
             [comments addObject:c];
         }
     
         success(comments, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] intValue]);
     
     } failure:^(NSError *error) {
         if (failure == nil) {
             return;
         }
         failure(error);
     }];
}

+ (void)repostsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostSuccessBlock)success failure:(RepostFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/repost_timeline.json" params:@{
     @"id": @(statusId),
     @"since_id": @(sinceId),
     @"max_id": @(maxId)
     } success:^(id JSON) {
         if (success == nil) {
             return;
         }
         
         NSArray *array = JSON[@"reposts"];
         NSMutableArray *reposts = [NSMutableArray array];
         for (NSDictionary *dict in array) {
             Status *s = [[Status alloc] initWithDict:dict];
             [reposts addObject:s];
         }
         success(reposts, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] intValue]);
         
     } failure:^(NSError *error) {
         if (failure == nil) {
             return;
         }
         failure(error);
     }];
}

+ (void)statusWithId:(long long)ID success:(SingleStatusSuccessBlock)success failure:(SingleStatusFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/show.json" params:@{
     @"id": @(ID)
     } success:^(id JSON) {
         if (success == nil) {
             return;
         }
         
         Status *s = [[Status alloc] initWithDict:JSON];
         success(s);
     } failure:^(NSError *error) {
         if (failure == nil) {
             return;
         }
         failure(error);
     }];
}





@end
