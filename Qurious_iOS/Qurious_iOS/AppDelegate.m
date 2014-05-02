//
//  AppDelegate.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "QApiRequests.h"
#import "NotificationViewController.h"
#import "Crittercism.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window.rootViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    self.window.rootViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//    [self.window makeKeyAndVisible];
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    if(apsInfo) {
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        NotificationViewController* pvc = [mainstoryboard instantiateViewControllerWithIdentifier:@"notification"];
        [self.window.rootViewController presentViewController:pvc animated:YES completion:NULL];
    }

    [Crittercism enableWithAppID: @"5362f12fb573f1182b000003"];
    return YES;
}

void appDelegateCallback(id arg) {

}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	// make the network call here...
    if (deviceToken != NULL) {
        NSLog(@"Token: %@", deviceToken);
        [QApiRequests sendToken:[NSString stringWithFormat:@"%@", deviceToken] andCallback:&appDelegateCallback];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

//Your app receives push notification.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"linen3.jpg"] forBarMetrics:UIBarMetricsDefault];
    UIApplicationState state = [application applicationState];
    
    // If your app is running
    if (state == UIApplicationStateActive)
    {
        
        //You need to customize your alert by yourself for this situation. For ex,
        NSString *cancelTitle = @"Close";
        NSString *showTitle = @"Ok";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
        
    }
    // If your app was in in active state
    else if (state == UIApplicationStateInactive)
    {
//        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
//        NotificationViewController *notificationViewController = [[NotificationViewController alloc] init];
//        [navController.visibleViewController.navigationController pushViewController:notificationViewController animated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
