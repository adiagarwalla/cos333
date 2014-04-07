//
//  Skill.h
//  Qurious_iOS
//
//  Created by Helen Yu on 4/7/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Skill : NSObject
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSNumber *price;
@property (nonatomic) BOOL isMarketable;

@end
