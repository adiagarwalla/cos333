//
//  SidebarViewController.h
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/15/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UITableViewController
@property (nonatomic, strong) IBOutlet UILabel *notificationCountLabel;
@property (nonatomic, strong) NSString *count;

@end
