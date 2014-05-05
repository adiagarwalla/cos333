//
//  Notification.h
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/24/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (copy, nonatomic) NSString *session_token;
@property (copy, nonatomic) NSString *from;
@property (copy, nonatomic) NSString *message;
@property (nonatomic) int notificationID;
@property (nonatomic) BOOL isExpired;
@end
