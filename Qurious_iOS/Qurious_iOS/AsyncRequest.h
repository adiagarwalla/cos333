//
//  AsyncRequest.h
//  Qurious_iOS
//
//  Created by Abhinav  Khanna on 4/6/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncRequest : NSObject

- (void) startAsync:(void(*)(id))func andUrl:(NSString*)url;
- (void) startAsyncPost:(void(*)(id))func andUrl:(NSString*)url andDict:(NSDictionary*)dict;

@end
