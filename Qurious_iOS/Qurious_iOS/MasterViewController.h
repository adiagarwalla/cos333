//
//  MasterViewController.h
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (retain, nonatomic) NSMutableArray *searchObjects;

@end
