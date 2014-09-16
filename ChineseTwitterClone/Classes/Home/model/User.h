//
//  User.h
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//  User

#import "BaseModel.h"

@interface User : BaseModel

// verified type
typedef enum {
    kVerifiedTypeNone = -1, // not verified
    kVerifiedTypePerson = 0,
    kVerifiedTypeOrgEnterprise = 2,
    kVerifiedTypeOrgMedia = 3,
    kVerifiedTypeOrgWebsite = 0,
    kVerifiedTypeDaren = 220
} VerifiedType;

// membership type
typedef enum {
    kMBTypeNone = 0,
    kMBTypeNormal,
    kMBTypeYear
} MBType;

@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, assign) BOOL verified; // verified user flag
@property (nonatomic, assign) VerifiedType verifiedType; // verified type
@property (nonatomic, assign) int mbrank; // member rank
@property (nonatomic, assign) MBType mbtype; // member type

@end
