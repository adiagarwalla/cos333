//
//  NotificationViewController.h
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/23/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (strong, nonatomic) id detailItem;

//- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
