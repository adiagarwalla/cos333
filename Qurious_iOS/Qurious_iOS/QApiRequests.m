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

+ (void) sendToken:(NSString*)token andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/settoken/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:token,@"token", nil];
    [request startAsyncPost: callback andUrl:url andDict:dict];
}

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

+ (void) uploadImage:(UIImage*) image andId:(NSString*)user_id andCallback:(void(*)(id))callback {
    NSString* url = [NSString stringWithFormat:@"/api-profile/uploadimage/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s",baseURL]]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSDictionary *parameters = @{@"id": user_id};
    AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"profile_pic_%@", user_id] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
}

+ (void) editSkill:(int)skill_id andName:(NSString*)name andPrice:(NSString*)price andDesc:(NSString*)desc andForSale:(BOOL)isMarketable andCallback:(void(*)(id))callback {
    
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/skills/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:price,@"price", name, @"name", desc, @"desc", [NSString stringWithFormat:@"%i", isMarketable], @"marketable", [NSString stringWithFormat:@"%i", skill_id], @"skill_id", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) deleteSkill:(int)skill_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/delete/?id=%d", baseURL, skill_id];
    [request startAsync:callback andUrl:url];
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

+ (void) createSession:(NSString*)tutor_id andMinutes:(NSString*)minutes andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-session/create/", baseURL];
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:tutor_id, @"teacher", minutes, @"time", nil];
    [request startAsyncPost:callback andUrl:url andDict:dict];
}

+ (void) getToken:(NSString*)session_token andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-session/gettoken/?session_token=%@", baseURL, session_token];
    [request startAsync:callback andUrl:url];
}

+ (void) getNotification:(int)user_id andCallback:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-session/notifications/?user_id=%i", baseURL, user_id];
    [request startAsync:callback andUrl:url];
}


+ (void) whoAmI:(void(*)(id))callback {
    AsyncRequest* request = [AsyncRequest new];
    NSString* url = [NSString stringWithFormat:@"%s/api-profile/whoami/", baseURL];
    [request startAsync:callback andUrl:url];
}
@end
