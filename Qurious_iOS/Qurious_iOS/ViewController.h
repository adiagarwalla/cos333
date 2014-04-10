//
//  ViewController.h
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/9/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Opentok/Opentok.h>

@interface ViewController : UIViewController <OTSessionDelegate, OTSubscriberDelegate, OTPublisherDelegate>
- (void)doConnect;
- (void)doPublish;
- (void)showAlert:(NSString*)string;
@end
