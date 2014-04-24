//
//  Notification.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/24/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "Notification.h"

@implementation Notification

@synthesize session_token = _session_token;
@synthesize from = _from;
@synthesize message = _message;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.session_token = @"";
        self.from = @"";
        self.message = @"0";
    }
    return self;
}

@end
