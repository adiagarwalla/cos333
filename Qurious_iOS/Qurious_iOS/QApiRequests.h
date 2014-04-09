//
//  QApiRequests.h
//  Qurious_iOS
//
//  Created by Abhinav  Khanna on 4/6/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QApiRequests : NSObject

+ (void) getProfiles:(int)user_id andCallback:(void(*)(id))callback;
+ (void) getAllSkills:(int)user_id andCallback:(void(*)(id))callback;
+ (void) getSkillDetails:(int)skill_id andCallback:(void(*)(id))callback;
+ (void) editProfile: (NSString*)first andLastName:(NSString*)last andBio:(NSString*)bio andEmail:(NSString*)email  andCallback:(void(*)(id))callback;
+ (void) editSkill:(int)skill_id andPrice:(NSString*)price andDesc:(NSString*)desc andForSale:(BOOL)isMarketable andCallback:(void(*)(id))callback;
+ (void) getAllProfiles:(void(*)(id))callback;


@end
