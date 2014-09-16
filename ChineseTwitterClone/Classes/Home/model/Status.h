//
//  Status.h
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//  Tweet/Weibo

#import "BaseText.h"

@interface Status : BaseText

@property (nonatomic, strong) NSArray *picUrls; // picture urls
@property (nonatomic, strong) Status *retweetedStatus; // retweeted status
@property (nonatomic, assign) int repostsCount; // retweet count
@property (nonatomic, assign) int commentsCount; // comment count
@property (nonatomic, assign) int attitudesCount; // attitude(praise) count;
@property (nonatomic, copy) NSString *source; // tweet source

@end
