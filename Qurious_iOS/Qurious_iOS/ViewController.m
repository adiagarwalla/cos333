//
//  ViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/9/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "ViewController.h"
#import "QApiRequests.h"

@implementation ViewController {
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
}
static double widgetHeight = 240;
static double widgetWidth = 320;

static NSString* const kApiKey = @"44722692";    // Replace with your OpenTok API key
static NSString* const kSessionId = @"2_MX40NDcyMjY5Mn5-U2F0IEFwciAxMiAxOTo0MjowOSBQRFQgMjAxNH4wLjMxMjIyMjU0fn4"; // Replace with your generated session ID
static NSString* const kToken = @"T1==cGFydG5lcl9pZD00NDcyMjY5MiZzZGtfdmVyc2lvbj10YnJ1YnktdGJyYi12MC45MS4yMDExLTAyLTE3JnNpZz0yMTNhNGM4NmJkNzNiYTZlZmY4MDRjYjdkMmFjNGRmMzgzMjk2MTVmOnJvbGU9c3Vic2NyaWJlciZzZXNzaW9uX2lkPTJfTVg0ME5EY3lNalk1TW41LVUyRjBJRUZ3Y2lBeE1pQXhPVG8wTWpvd09TQlFSRlFnTWpBeE5INHdMak14TWpJeU1qVTBmbjQmY3JlYXRlX3RpbWU9MTM5NzM1Njk1NiZub25jZT0wLjE0MzEzOTYxMTc2Nzk1NjEmZXhwaXJlX3RpbWU9MTM5NzM2MDUyMSZjb25uZWN0aW9uX2RhdGE9";     // Replace with your generated token (use the Dashboard or an OpenTok server-side library)

//void callback(id arg) {
//    
//    // do nothing valuable
//    NSLog(@"JSON: %@", arg);
//    printf("%s", "Hi");
//    
//    NSDictionary * results = arg;
//    for (NSDictionary *jsonobject in results) {
//        NSDictionary *fields = jsonobject[@"fields"];
//        kApiKey = fields[@"api"];
//        kSessionId = fields[@"session"];
//        kToken = fields[@"token"];
//    }
//}

static bool subscribeToSelf = YES; // Change to NO to subscribe to streams other than your own.

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _session = [[OTSession alloc] initWithSessionId:kSessionId
                                           delegate:self];
    //[QApiRequests getVideo:&callback];

    [self doConnect];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    } else {
        return YES;
    }
}

- (void)updateSubscriber {
    for (NSString* streamId in _session.streams) {
        OTStream* stream = [_session.streams valueForKey:streamId];
        if (![stream.connection.connectionId isEqualToString: _session.connection.connectionId]) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            break;
        }
    }
}

#pragma mark - OpenTok methods

- (void)doConnect
{
    [_session connectWithApiKey:kApiKey token:kToken];
}

- (void)doPublish
{
    _publisher = [[OTPublisher alloc] initWithDelegate:self];
    [_publisher setName:[[UIDevice currentDevice] name]];
    [_session publish:_publisher];
    [self.view addSubview:_publisher.view];
    [_publisher.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
}

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage = [NSString stringWithFormat:@"Session disconnected: (%@)", session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
    [self showAlert:alertMessage];
}


- (void)session:(OTSession*)mySession didReceiveStream:(OTStream*)stream
{
    NSLog(@"session didReceiveStream (%@)", stream.streamId);
    
    // See the declaration of subscribeToSelf above.
    if ( (subscribeToSelf && [stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ||
        (!subscribeToSelf && ![stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ) {
        if (!_subscriber) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
        }
    }
}

- (void)session:(OTSession*)session didDropStream:(OTStream*)stream{
    NSLog(@"session didDropStream (%@)", stream.streamId);
    NSLog(@"_subscriber.stream.streamId (%@)", _subscriber.stream.streamId);
    if (!subscribeToSelf
        && _subscriber
        && [_subscriber.stream.streamId isEqualToString: stream.streamId])
    {
        _subscriber = nil;
        [self updateSubscriber];
    }
}

- (void)session:(OTSession *)session didCreateConnection:(OTConnection *)connection {
    NSLog(@"session didCreateConnection (%@)", connection.connectionId);
}

- (void) session:(OTSession *)session didDropConnection:(OTConnection *)connection {
    NSLog(@"session didDropConnection (%@)", connection.connectionId);
}

- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
    [subscriber.view setFrame:CGRectMake(0, widgetHeight, widgetWidth, widgetHeight)];
    [self.view addSubview:subscriber.view];
}

- (void)publisher:(OTPublisher*)publisher didFailWithError:(OTError*) error {
    NSLog(@"publisher didFailWithError %@", error);
    [self showAlert:[NSString stringWithFormat:@"There was an error publishing."]];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
    [self showAlert:[NSString stringWithFormat:@"There was an error subscribing to stream %@", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"sessionDidFail");
    [self showAlert:[NSString stringWithFormat:@"There was an error connecting to session %@", session.sessionId]];
}


- (void)showAlert:(NSString*)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from video session"
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
