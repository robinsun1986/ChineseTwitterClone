//
//  BaseText.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/7/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseModel.h"

@class User;
@interface BaseText : BaseModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) User *user;

@end
