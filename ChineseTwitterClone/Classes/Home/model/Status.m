//
//  Status.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "Status.h"
#import "User.h"

@implementation Status

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.picUrls = dict[@"pic_urls"];
        
        NSDictionary *retweet = dict[@"retweeted_status"];
        if(retweet) {
            self.retweetedStatus = [[Status alloc] initWithDict:retweet];
        }
        
        self.source = dict[@"source"];
        self.repostsCount = [dict[@"reposts_count"] intValue];
        self.commentsCount = [dict[@"comments_count"] intValue];
        self.attitudesCount = [dict[@"attitudes_count"] intValue];
    }
    
    return self;
}

// change the display text of source.
// unlike time(createdAt), source is calculated only once, therefore override setter
- (void)setSource:(NSString *)source
{
    // <a href="http://app.weibo.com/t/feed/9ksdit" rel="nofollow">iPhone客户端</a>

    int start = [source rangeOfString:@">"].location + 1;
    int end = [source rangeOfString:@"</"].location;
    _source = [@"From " stringByAppendingString
                           :[source substringWithRange:NSMakeRange(start, end - start)]];
    
}

@end









