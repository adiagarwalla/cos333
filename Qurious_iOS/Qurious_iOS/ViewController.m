//
//  ViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/9/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
}

// Take care of this later
static NSString* const kApiKey = @"";    // Replace with your OpenTok API key
static NSString* const kSessionId = @""; // Replace with your generated session ID
static NSString* const kToken = @"";     // Replace with your generated token (use the Dashboard or an OpenTok server-side library)
static bool subscribeToSelf = YES; // Change to NO to subscribe to streams other than your own.

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _session = [[OTSession alloc] initWithSessionId:kSessionId
                                           delegate:self];
    [self doConnect];
}

#pragma mark - OpenTok methods

- (void)doConnect
{
    [_session connectWithApiKey:kApiKey token:kToken];
}

@end
