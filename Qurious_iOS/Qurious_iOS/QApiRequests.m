//
//  QApiRequests.m
//  Qurious_iOS
//
//  Created by Abhinav  Khanna on 4/6/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//  This is the file that will contain all the api endpoints to reach the server. Please
//  utilize these endpoint functions rather than directly calling the server endpoints.

#import "QApiRequests.h"
#import "AsyncRequest.h"
#import "AFNetworking.h"


@implementation QApiRequests

char* baseURL = "http://qurious.info:8080";

+ (void) getProfiles:(int)user_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/profile/?id=%d", baseURL, user_id];
    [request startAsync:callback andUrl:url];
}

+ (void) getSkillDetails:(int)skill_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/skills/?id=%d", baseURL, skill_id];
    [request startAsync:callback andUrl:url];
}

+ (void) editProfile:(NSString*)first andLastName:(NSString*)last andBio:(NSString*)bio andEmail:(NSString*)email andProfile:(NSString*)profile_name  andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/profile/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:first,@"profile_first", last, @"profile_last", bio, @"user_bio", email, @"user_email", profile_name, @"profile_name", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) editSkill:(int)skill_id andPrice:(NSString*)price andDesc:(NSString*)desc andForSale:(BOOL)isMarketable andCallback:(void(*)(id))callback {
    
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/skills/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:price,@"price", desc, @"name",[NSString stringWithFormat:@"%i", isMarketable], @"marketable", [NSString stringWithFormat:@"%i", skill_id], @"skill_id", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) getAllProfiles:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/allprofiles/", baseURL];
    [request startAsync:callback andUrl:url];
}

+ (void) getAllSkills:(int)user_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/allskills/?id=%i", baseURL, user_id];
    [request startAsync:callback andUrl:url];
}

+ (void) login:(NSString*)username andPassword:(NSString*)password andCallback:(void(*)(id))callback {
    // calls the login endpoint
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://qurious.info:8080/"]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    // once all the cookies are deleted, you need to actually fire off the request to the server to initiate the login.
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-auth/login/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username", password, @"password", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) logout:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-auth/logout/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) signUp:(NSString*)username andPassword:(NSString*)password andEmail:(NSString*)userEmail andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-auth/signup/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", password, @"password", userEmail, @"user_email", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

@end
