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

@implementation QApiRequests

char* baseURL = "http://localhost:8000";

+ (void) getProfiles:(int)user_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/profile?id=%d", baseURL, user_id];
    [request startAsync:callback andUrl:url];
}

+ (void) getSkillDetails:(int)skill_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/skills?id=%d", baseURL, skill_id];
    [request startAsync:callback andUrl:url];
}

+ (void) editProfile: (NSString*)first andLastName:(NSString*)last andBio:(NSString*)bio andEmail:(NSString*)email  andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/profile/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:first,@"profile_first", last, @"profile_last", bio, @"user_bio", email, @"user_email", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) editSkill:(int)skill_id andPrice:(NSString*)price andDesc:(NSString*)desc andForSale:(BOOL)isMarketable andCallback:(void(*)(id))callback {
    
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/skills?id=%d/", baseURL, skill_id];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:price,@"price", desc, @"desc", isMarketable, @"marketable", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) getAllProfiles:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/allprofiles", baseURL];
    [request startAsync:callback andUrl:url];
}

+ (void) getAllSkills:(int)user_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/allskills?id=%i/", baseURL, user_id];
    [request startAsync:callback andUrl:url];
}



@end
