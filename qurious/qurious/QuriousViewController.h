//
//  QuriousViewController.h
//  qurious 333
//
//  Created by Qurious iOS on 3/29/14.
//  Copyright (c) 2014 Qurious iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuriousViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
