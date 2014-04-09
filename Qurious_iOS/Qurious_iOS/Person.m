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
@synthesize username = _username;
@synthesize email = _email;
@synthesize bio = _bio;
@synthesize skills = _skills;
@synthesize profPic = _profPic;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.skills = [[NSMutableArray alloc] init];
        self.profPic = [UIImage imageNamed:@"dogesmall.jpg"];
    }
    return self;
}

@end


