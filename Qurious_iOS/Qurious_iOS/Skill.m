//
//  Skill.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/7/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "Skill.h"

@implementation Skill
@synthesize desc = _desc;
@synthesize name = _name;
@synthesize price = _price;
@synthesize isMarketable = _isMarketable;
@synthesize skillID = _skillID;


- (id)init
{
    self = [super init];
    if (self)
    {
        self.skillID = 0;
        self.desc = @"";
        self.name = @"";
        self.price = @"0";
        self.isMarketable = NO;
        // superclass successfully initialized, further
        // initialization happens here ...
    }
    return self;
}


@end
