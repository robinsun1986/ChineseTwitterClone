//
//  DetailHeader.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//  Header of secion 1

#import <UIKit/UIKit.h>

typedef enum {
    kDetailHeaderBtnTypeRepost, // repost button
    kDetailHeaderBtnTypeComment // comment button
} DetailHeaderBtnType;

@class Status, DetailHeader;
@protocol DetailHeaderDelegate <NSObject>
@optional
-  (void)detailHeader:(DetailHeader *)header btnClick:(int)index;
@end


@interface DetailHeader : UIView

@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *repost;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIImageView *hint;

- (IBAction)btnClick:(UIButton *)sender;

+ (id)header;

@property (nonatomic, strong) Status *status;
@property (nonatomic, weak) id<DetailHeaderDelegate> delegate;
@property (nonatomic, assign, readonly) DetailHeaderBtnType currentBtnType;

@end
