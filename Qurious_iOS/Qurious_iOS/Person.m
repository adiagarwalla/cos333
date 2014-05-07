//
//  Person.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize userID = _userID;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize bio = _bio;
@synthesize skills = _skills;
@synthesize profPic = _profPic;
@synthesize username = _username;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.skills = [[NSMutableArray alloc] init];
        self.profPic = [NSURL URLWithString:@"http://qurious.info:8080/files/dogesmall.jpg"];
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    if ( self.userID != [other userID])
        return NO;
    return YES;
}

@end


