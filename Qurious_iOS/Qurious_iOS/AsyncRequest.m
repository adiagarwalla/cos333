//
//  AsyncRequest.m
//  Qurious_iOS
//
//  Created by Abhinav  Khanna on 4/6/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "AsyncRequest.h"
#import "AFNetworking.h"

@implementation AsyncRequest
NSString* urlString;

void(*f)(NSString*);

- (void) startAsync:(void(*)(id))func andUrl:(NSString*)url {
    f = func;
    urlString = url;
    [self grabURLInBackground];
}

- (void) startAsyncPost:(void(*)(id))func andUrl:(NSString*)url andDict:(NSDictionary*)dict {
    f = func;
    urlString = url;
    [self postURLInBackground:dict];
}

- (void)grabURLInBackground
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        f(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        f(@"");
        NSLog(@"Error: %@", error);
    }];
}

- (void)postURLInBackground:(NSDictionary*)dict
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = dict;
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        f(responseObject);
        NSLog(@"ASYNCREQUEST JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        f(@"");
        NSLog(@"ASYNCREQUEST JSON Error: %@", error);
    }];
}
@end
